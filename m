From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 3/3] crypto: ccp - Remove user triggerable pr_err calls
Date: Tue, 10 Dec 2013 10:38:44 -0600
Message-ID: <20131210163844.24304.39872.stgit@tlendack-t1.amdoffice.net>
References: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the pr_err calls that are issued during parameter
checking in some AES operations. This will eliminate the
possibility of filling up syslog through these paths.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    4 +---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c  |   12 +++---------
 drivers/crypto/ccp/ccp-crypto-aes.c      |   12 +++---------
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 5b9cd98..64dd35e 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -63,10 +63,8 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	unsigned int len, need_pad, sg_count;
 	int ret;
 
-	if (!ctx->u.aes.key_len) {
-		pr_err("AES key not set\n");
+	if (!ctx->u.aes.key_len)
 		return -EINVAL;
-	}
 
 	if (nbytes)
 		rctx->null_msg = 0;
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index d100b48..0237ab5 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -125,20 +125,14 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	unsigned int unit;
 	int ret;
 
-	if (!ctx->u.aes.key_len) {
-		pr_err("AES key not set\n");
+	if (!ctx->u.aes.key_len)
 		return -EINVAL;
-	}
 
-	if (req->nbytes & (AES_BLOCK_SIZE - 1)) {
-		pr_err("AES request size is not a multiple of the block size\n");
+	if (req->nbytes & (AES_BLOCK_SIZE - 1))
 		return -EINVAL;
-	}
 
-	if (!req->info) {
-		pr_err("AES IV not supplied");
+	if (!req->info)
 		return -EINVAL;
-	}
 
 	for (unit = 0; unit < ARRAY_SIZE(unit_size_map); unit++)
 		if (!(req->nbytes & (unit_size_map[unit].size - 1)))
diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index c0befdb..e46490d 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -76,24 +76,18 @@ static int ccp_aes_crypt(struct ablkcipher_request *req, bool encrypt)
 	unsigned int iv_len = 0;
 	int ret;
 
-	if (!ctx->u.aes.key_len) {
-		pr_err("AES key not set\n");
+	if (!ctx->u.aes.key_len)
 		return -EINVAL;
-	}
 
 	if (((ctx->u.aes.mode == CCP_AES_MODE_ECB) ||
 	     (ctx->u.aes.mode == CCP_AES_MODE_CBC) ||
 	     (ctx->u.aes.mode == CCP_AES_MODE_CFB)) &&
-	    (req->nbytes & (AES_BLOCK_SIZE - 1))) {
-		pr_err("AES request size is not a multiple of the block size\n");
+	    (req->nbytes & (AES_BLOCK_SIZE - 1)))
 		return -EINVAL;
-	}
 
 	if (ctx->u.aes.mode != CCP_AES_MODE_ECB) {
-		if (!req->info) {
-			pr_err("AES IV not supplied");
+		if (!req->info)
 			return -EINVAL;
-		}
 
 		memcpy(rctx->iv, req->info, AES_BLOCK_SIZE);
 		iv_sg = &rctx->iv_sg;
