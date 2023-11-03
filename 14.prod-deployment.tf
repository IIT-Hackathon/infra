# Create an sns topic for codedeploy
resource "aws_sns_topic" "textwizard-codedeploy-topic" {
  name = "textwizard-codedeploy-topic"
}

# Create codedeploy application
resource "aws_codedeploy_app" "textwizard-codedeploy-app" {
  name     = "textwizard-codedeploy-app"
  compute_platform = "Server"
}

# Create codedeploy deployment group - in-place deployment - no triggers
resource "aws_codedeploy_deployment_group" "textwizard-codedeploy-deployment-group" {
  app_name = aws_codedeploy_app.textwizard-codedeploy-app.name
  deployment_group_name = "textwizard-codedeploy-deployment-group"
  service_role_arn = var.code_deploy_role_arn
  deployment_config_name = "CodeDeployDefault.HalfAtATime"
  
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type = "IN_PLACE"
  }

  autoscaling_groups = [
    aws_autoscaling_group.textwizard-autoscaling-group.id
  ]
  
    
  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.textwizard-target-group.name
    }
  }

  trigger_configuration {
    trigger_name = "textwizard-codedeploy-trigger"
    trigger_target_arn = aws_sns_topic.textwizard-codedeploy-topic.arn
    trigger_events = [
      "DeploymentStart",
      "DeploymentSuccess",
      "DeploymentFailure",
      "DeploymentStop",
      "DeploymentReady"
    ]
  }

  depends_on = [ aws_codedeploy_app.textwizard-codedeploy-app, aws_sns_topic.textwizard-codedeploy-topic ]
}
