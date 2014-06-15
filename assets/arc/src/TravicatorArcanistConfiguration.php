<?php

class TravicatorArcanistConfiguration extends ArcanistConfiguration {
  // Push changes to git if we've put up a diff.
  public function didRunWorkflow(
    $command,
    ArcanistBaseWorkflow $workflow,
    $return_code
  ) {
    if ($workflow instanceof ArcanistDiffWorkflow && // it's a diff
      !$workflow->getArgument('only') &&  // user wants a build
      $workflow->getDiffID() // sometimes this is called without a diffid? 
      )
    {
      $diff_id = $workflow->getDiffID();
      $branch = "refs/heads/ci/{$diff_id}";
      $cmd = "git push origin HEAD:{$branch}";

      echo "Pushing to {$branch} for remote build.\n";
      $git_future = new ExecFuture($cmd);
      $git_future->resolvex();
    }
  }
}

?>
