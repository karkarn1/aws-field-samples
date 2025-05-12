#!/bin/bash

AGENT_STATUS=$(aws bedrock-agent get-agent --agent-id "$AGENT_ID" --query 'agent.status' --output text)
echo "Initial agent status: $AGENT_STATUS"

if [ "$AGENT_STATUS" != "PREPARING" ] && [ "$AGENT_STATUS" != "PREPARED" ]; then
	echo "Preparing agent..."
	aws bedrock-agent prepare-agent --agent-id "$AGENT_ID"
else
	echo "Agent is already in PREPARING or PREPARED state. Skipping prepare command."
fi
while true; do
	STATUS=$(aws bedrock-agent get-agent --agent-id "$AGENT_ID" --query 'agent.agentStatus' --output text)
	if [ "$STATUS" = "PREPARED" ]; then
		echo "Agent is prepared"
		break
	elif [ "$STATUS" = "FAILED" ]; then
		echo "Agent preparation failed"
		exit 1
	fi
	echo "Waiting for agent to be prepared... Current status: $STATUS"
	sleep 5
done
