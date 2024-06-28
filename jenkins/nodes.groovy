import jenkins.model.*
import hudson.model.*
import hudson.slaves.*
import hudson.EnvVars
import hudson.plugins.sshslaves.verifiers.*

hostKeyVerificationStrategy = new NonVerifyingKeyVerificationStrategy()

environment = new EnvVars(Jenkins.instance.toComputer().getEnvironment())

jenkinsNodes = environment.get("JENKINS_SSH_NODES", "")
if (jenkinsNodes) {
	for (nodeAddress in jenkinsNodes.split(" ")){
		launcher = new hudson.plugins.sshslaves.SSHLauncher(
				nodeAddress,
				22,
				vagrantInsecureKey,
				"",
				"",
				"",
				10,
				60,
				1,
				hostKeyVerificationStrategy
			)
		agent = new DumbSlave(
				nodeAddress,
				"/home/vagrant/",
				launcher
			)
		agent.nodeDescription = "Vagrant BOX node"
		agent.numExecutors = 1
		agent.labelString = "vagrant ${nodeAddress}"
		agent.mode = Node.Mode.Normal
		agent.retentionStrategy = new RetentionStrategy.Always()

		env = new ArrayList<Entry>()
		env.add(new Entry("key1", "value1"))
		envPro = new EnvironmentVariablesNodeProperty(env)
		agent.getNodeProperties().add(envPro)
		Jenkins.instance.addNode(agent)

		)
	}

}
