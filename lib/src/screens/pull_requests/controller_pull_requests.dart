part of pull_requests;

class _PullRequestsController with FilterMixin {
  factory _PullRequestsController({
    required AzureApiService apiService,
    required StorageService storageService,
    Project? project,
  }) {
    return instance ??= _PullRequestsController._(apiService, storageService, project);
  }

  _PullRequestsController._(this.apiService, this.storageService, this.project) {
    projectFilter = project ?? projectAll;
  }

  static _PullRequestsController? instance;

  final AzureApiService apiService;
  final StorageService storageService;
  final Project? project;

  final pullRequests = ValueNotifier<ApiResponse<List<PullRequest>?>?>(null);

  PullRequestState statusFilter = PullRequestState.all;

  void dispose() {
    instance = null;
  }

  Future<void> init() async {
    await _getData();
  }

  void goToPullRequestDetail(PullRequest pr) {
    AppRouter.goToPullRequestDetail(pr);
  }

  void filterByStatus(PullRequestState state) {
    pullRequests.value = null;
    statusFilter = state;
    _getData();
  }

  void filterByUser(GraphUser u) {
    pullRequests.value = null;
    userFilter = u;
    _getData();
  }

  void filterByProject(Project proj) {
    pullRequests.value = null;
    projectFilter = proj.name! == projectAll.name ? projectAll : proj;
    _getData();
  }

  Future<void> _getData() async {
    final res = await apiService.getPullRequests(
      filter: statusFilter,
      creator: userFilter.displayName == userAll.displayName ? null : userFilter,
      project: projectFilter.name == projectAll.name ? null : projectFilter,
    );
    pullRequests.value = res..data?.sort((a, b) => (b.creationDate).compareTo(a.creationDate));
  }

  void resetFilters() {
    pullRequests.value = null;
    projectFilter = projectAll;
    statusFilter = PullRequestState.all;
    userFilter = userAll;

    init();
  }
}
