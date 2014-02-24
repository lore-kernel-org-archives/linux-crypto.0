From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 1/3] crypto: ccp - Prevent a possible lost CCP command request
Date: Mon, 24 Feb 2014 08:42:02 -0600
Message-ID: <20140224144202.16181.68619.stgit@tlendack-t1.amdoffice.net>
References: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If a CCP command has been queued for processing at the
crypto layer then, when dequeueing it for processing, the
"can backlog" flag must be set so that the request isn't
lost if the CCP backlog queue limit is reached.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 010fded..9d30d6f 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -174,6 +174,10 @@ static void ccp_crypto_complete(void *data, int err)
 
 	/* Submit the next cmd */
 	while (held) {
+		/* Since we have already queued the cmd, we must indicate that
+		 * we can backlog so as not to "lose" this request.
+		 */
+		held->cmd->flags |= CCP_CMD_MAY_BACKLOG;
 		ret = ccp_enqueue_cmd(held->cmd);
 		if (ccp_crypto_success(ret))
 			break;
