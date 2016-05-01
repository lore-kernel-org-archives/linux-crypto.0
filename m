From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] crypto: constify ccp_actions structure
Date: Sun,  1 May 2016 13:52:55 +0200
Message-ID: <1462103575-21705-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gary Hook <gary.hook@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ccp_actions structure is never modified, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/crypto/ccp/ccp-dev-v3.c |    2 +-
 drivers/crypto/ccp/ccp-dev.h    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 597fc50..d7a7103 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -526,7 +526,7 @@ static irqreturn_t ccp_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static struct ccp_actions ccp3_actions = {
+static const struct ccp_actions ccp3_actions = {
 	.perform_aes = ccp_perform_aes,
 	.perform_xts_aes = ccp_perform_xts_aes,
 	.perform_sha = ccp_perform_sha,
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 5d986c9..bd41ffce 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -162,7 +162,7 @@ struct ccp_actions {
 /* Structure to hold CCP version-specific values */
 struct ccp_vdata {
 	unsigned int version;
-	struct ccp_actions *perform;
+	const struct ccp_actions *perform;
 };
 
 extern struct ccp_vdata ccpv3;
