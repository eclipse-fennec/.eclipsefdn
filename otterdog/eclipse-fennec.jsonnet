local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('eclipse-fennec') {
  settings+: {
    description: "",
    name: "Eclipse Fennec project",
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
}
