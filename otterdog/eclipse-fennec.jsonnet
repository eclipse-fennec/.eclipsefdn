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

orgs.newOrg('modeling.fennec', 'eclipse-fennec') {
  settings+: {
    description: "",
    name: "Eclipse Fennec project",
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  secrets+: [
    orgs.newOrgSecret('DOCKER_USERNAME') {
      value: "pass:bots/modeling.fennec/docker.com/username",
    },
    orgs.newOrgSecret('DOCKER_API_TOKEN') {
      value: "pass:bots/modeling.fennec/docker.com/api-token",
    },
    orgs.newOrgSecret('GITLAB_API_TOKEN') {
      value: "pass:bots/modeling.fennec/gitlab.eclipse.org/api-token",
    },
    orgs.newOrgSecret('GPG_KEY_ID') {
      value: "pass:bots/modeling.fennec/gpg/key_id",
    },
    orgs.newOrgSecret('GPG_PASSPHRASE') {
      value: "pass:bots/modeling.fennec/gpg/passphrase",
    },
    orgs.newOrgSecret('GPG_PRIVATE_KEY') {
      value: "pass:bots/modeling.fennec/gpg/secret-subkeys.asc",
    },
    orgs.newOrgSecret('CENTRAL_SONATYPE_TOKEN_PASSWORD') {
      value: "pass:bots/modeling.fennec/central.sonatype.org/token-password",
    },
    orgs.newOrgSecret('CENTRAL_SONATYPE_TOKEN_USERNAME') {
      value: "pass:bots/modeling.fennec/central.sonatype.org/token-username",
    },
    orgs.newOrgSecret('SCP_KEY') {
      value: "pass:bots/modeling.fennec/projects-storage.eclipse.org/id_ed25519",
    },
    orgs.newOrgSecret('SCP_PASSPHRASE') {
      value: "pass:bots/modeling.fennec/projects-storage.eclipse.org/id_ed25519.passphrase",
    },
    orgs.newOrgSecret('SCP_USERNAME') {
      value: "pass:bots/modeling.fennec/projects-storage.eclipse.org/username",
    },
  ],
  _repositories+:: [
    newFennecRepo('.github') {
      description: "github organisation repository, defaults for all other Repositories",
    },    
    newFennecRepo('eclipse-fennec.github.io') {
      description: "Fennec Documentation",
      gh_pages_build_type: "legacy",
      gh_pages_source_branch: "gh-pages",
      gh_pages_source_path: "/",
      environments: [
        orgs.newEnvironment('github-pages'),
      ],
    },
    newFennecRepo('emf.osgi') {
      description: "OSGi extension for EMF",
    },
    newFennecRepo('emf.util') {
      description: "Utilities and commons for Fennec EMF OSGi",
    },
    newFennecRepo('common.models') {
      description: "Common EMF models (ecore models)",
    },
    newFennecRepo('emf.editors') {
      description: "Custom EMF Eclipse Editors",
    },
    newFennecRepo('emf.ts') {
      description: "TypeScript based EMF",
    },
    newFennecRepo('fennec.bnd.libraries') {
      description: "Fennec Workspace and Project Libraries",
      allow_merge_commit: true,
      allow_rebase_merge: false,
      allow_squash_merge: true,
    },
    newFennecRepo('model.atlas') {
      description: "Fennec Model Atlas",
      allow_merge_commit: true,
      allow_rebase_merge: false,
      allow_squash_merge: true,
    }
  ],
}
