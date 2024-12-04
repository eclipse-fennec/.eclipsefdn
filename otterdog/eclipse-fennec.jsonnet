local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

local branchProtectionRule(branchName) = orgs.newBranchProtectionRule(branchName) {
  required_approving_review_count: 0,
  requires_linear_history: false,
  requires_strict_status_checks: true,
};

local newFennecRepo(repoName, default_branch = 'main') = orgs.newRepo(repoName) {
  allow_squash_merge: false,
  allow_update_branch: false,
  default_branch: default_branch,
  delete_branch_on_merge: false,
  dependabot_security_updates_enabled: true,
  has_wiki: false,
  homepage: "https://projects.eclipse.org/projects/modeling.fennec",
  branch_protection_rules: [
    branchProtectionRule($.default_branch) {},
  ],
};

orgs.newOrg('eclipse-fennec') {
  settings+: {
    description: "",
    name: "Eclipse Fennec project",
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },

  _repositories+:: [
    newFennecRepo('.github') {
      description: "github organisation repository, defaults for all other Repositories",
    },
    newFennecRepo('emf.osgi') {
      description: "OSGi extension for EMF",
    },
    newFennecRepo('common.models') {
      description: "Common EMF models (ecore models)",
    },
  ],
}
