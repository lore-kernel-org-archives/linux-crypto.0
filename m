From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 4/4] csrypto: ccp - Expand RSA support for a v5 ccp
Date: Mon, 17 Jul 2017 15:16:42 -0500
Message-ID: <150032260278.102878.17708144678881515908.stgit@sosxen.amd.com>
References: <150032218639.102878.17376499349231172712.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0059.outbound.protection.outlook.com ([104.47.41.59]:41572
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751346AbdGQUQu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 16:16:50 -0400
In-Reply-To: <150032218639.102878.17376499349231172712.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A version 5 CCP can handle an RSA modulus up to 16k bits.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-rsa.c |    5 ++++-
 drivers/crypto/ccp/ccp-crypto.h     |    1 +
 drivers/crypto/ccp/ccp-dev-v3.c     |    1 +
 drivers/crypto/ccp/ccp-dev-v5.c     |    2 ++
 drivers/crypto/ccp/ccp-dev.h        |    1 +
 drivers/crypto/ccp/ccp-ops.c        |    3 ++-
 drivers/crypto/ccp/sp-dev.h         |    1 +
 7 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
index d5544943f5f0..e6db8672d89c 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -60,7 +60,10 @@ static int ccp_rsa_complete(struct crypto_async_request *async_req, int ret)
 
 static unsigned int ccp_rsa_maxsize(struct crypto_akcipher *tfm)
 {
-	return CCP_RSA_MAXMOD;
+	if (ccp_version() > CCP_VERSION(3, 0))
+		return CCP5_RSA_MAXMOD;
+	else
+		return CCP_RSA_MAXMOD;
 }
 
 static int ccp_rsa_crypt(struct akcipher_request *req, bool encrypt)
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index aa53b97f6f00..67c7620029e3 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -255,6 +255,7 @@ struct ccp_rsa_req_ctx {
 };
 
 #define	CCP_RSA_MAXMOD	(4 * 1024 / 8)
+#define	CCP5_RSA_MAXMOD	(16 * 1024 / 8)
 
 /***** Common Context Structure *****/
 struct ccp_ctx {
diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index c2861749e2ad..240bebbcb8ac 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -597,4 +597,5 @@ const struct ccp_vdata ccpv3 = {
 	.setup = NULL,
 	.perform = &ccp3_actions,
 	.offset = 0x20000,
+	.rsamax = CCP_RSA_MAX_WIDTH,
 };
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index b77ac0a638d5..3f574d50c0f8 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -1114,6 +1114,7 @@ const struct ccp_vdata ccpv5a = {
 	.setup = ccp5_config,
 	.perform = &ccp5_actions,
 	.offset = 0x0,
+	.rsamax = CCP5_RSA_MAX_WIDTH,
 };
 
 const struct ccp_vdata ccpv5b = {
@@ -1122,4 +1123,5 @@ const struct ccp_vdata ccpv5b = {
 	.setup = ccp5other_config,
 	.perform = &ccp5_actions,
 	.offset = 0x0,
+	.rsamax = CCP5_RSA_MAX_WIDTH,
 };
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 3d51180199ac..6810b65c1939 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -203,6 +203,7 @@
 #define CCP_SHA_SB_COUNT		1
 
 #define CCP_RSA_MAX_WIDTH		4096
+#define CCP5_RSA_MAX_WIDTH		16384
 
 #define CCP_PASSTHRU_BLOCKSIZE		256
 #define CCP_PASSTHRU_MASKSIZE		32
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 72c0f938abd7..c269f41e0526 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1770,7 +1770,8 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	unsigned int sb_count, i_len, o_len;
 	int ret;
 
-	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
+	/* Check against the maximum allowable size, in bits */
+	if (rsa->key_size > cmd_q->ccp->vdata->rsamax)
 		return -EINVAL;
 
 	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 3520da4e20cf..5ab486ade1ad 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -40,6 +40,7 @@ struct ccp_vdata {
 	void (*setup)(struct ccp_device *);
 	const struct ccp_actions *perform;
 	const unsigned int offset;
+	const unsigned int rsamax;
 };
 /* Structure to hold SP device data */
 struct sp_dev_vdata {
