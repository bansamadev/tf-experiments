import jenkins.model.*
import hudson.model.*
import jenkins.*
import hudson.*
import hudson.slaves.*
import hudson.plugins.sshslaves.verifiers.*
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry

jenkinsNodes = System.getenv("PATH")
hostKeyVerificationStrategy = new NonVerifyingKeyVerificationStrategy()

if (jenkinsNodes) {
	for (nodeAddress in jenkinsNodes.split(" ")){
		launcher = new hudson.plugins.sshslaves.SSHLauncher(
			nodeAddress,
			22,
			"vagrantInsecureKey",
			"",
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
			$//home/vagrant/$,
			launcher
		)
		agent.nodeDescription = "Vagrant BOX node"
		agent.numExecutors = 1
		agent.labelString = "vagrant ${nodeAddress}"
		agent.mode = Node.Mode.NORMAL
		agent.retentionStrategy = new RetentionStrategy.Always()

		env = new ArrayList<Entry>()
		env.add(new Entry("key1", "value1"))
		envPro = new EnvironmentVariablesNodeProperty(env)
		agent.getNodeProperties().add(envPro)
		Jenkins.instance.addNode(agent)

	}

}
