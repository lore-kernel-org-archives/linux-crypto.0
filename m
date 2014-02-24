From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 2/3] crypto: ccp - Invoke context callback when there is a
 backlog error
Date: Mon, 24 Feb 2014 08:42:08 -0600
Message-ID: <20140224144208.16181.98860.stgit@tlendack-t1.amdoffice.net>
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

Invoke the callback routine associated with the crypto context
if an error is encountered sending the command to the CCP during
backlog processing.  This is needed to free any resources used
by the command.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 9d30d6f..7d98635 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -183,6 +183,9 @@ static void ccp_crypto_complete(void *data, int err)
 			break;
 
 		/* Error occurred, report it and get the next entry */
+		ctx = crypto_tfm_ctx(held->req->tfm);
+		if (ctx->complete)
+			ret = ctx->complete(held->req, ret);
 		held->req->complete(held->req, ret);
 
 		next = ccp_crypto_cmd_complete(held, &backlog);
