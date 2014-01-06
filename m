From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 1/6] crypto: ccp - Apply appropriate gfp_t type to memory
 allocations
Date: Mon, 6 Jan 2014 13:33:59 -0600
Message-ID: <20140106193359.26918.68911.stgit@tlendack-t1.amdoffice.net>
References: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix some memory allocations to use the appropriate gfp_t type based
on the CRYPTO_TFM_REQ_MAY_SLEEP flag.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    5 ++++-
 drivers/crypto/ccp/ccp-crypto-sha.c      |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 64dd35e..398832c 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -61,6 +61,7 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	unsigned int block_size =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	unsigned int len, need_pad, sg_count;
+	gfp_t gfp;
 	int ret;
 
 	if (!ctx->u.aes.key_len)
@@ -99,7 +100,9 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	 * possible data pieces (buffer, input data, padding)
 	 */
 	sg_count = (nbytes) ? sg_nents(req->src) + 2 : 2;
-	ret = sg_alloc_table(&rctx->data_sg, sg_count, GFP_KERNEL);
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		GFP_KERNEL : GFP_ATOMIC;
+	ret = sg_alloc_table(&rctx->data_sg, sg_count, gfp);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index b0881df..0571940 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -128,6 +128,7 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	unsigned int block_size =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	unsigned int len, sg_count;
+	gfp_t gfp;
 	int ret;
 
 	if (!final && ((nbytes + rctx->buf_count) <= block_size)) {
@@ -156,7 +157,9 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	 * possible data pieces (hmac ipad, buffer, input data)
 	 */
 	sg_count = (nbytes) ? sg_nents(req->src) + 2 : 2;
-	ret = sg_alloc_table(&rctx->data_sg, sg_count, GFP_KERNEL);
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		GFP_KERNEL : GFP_ATOMIC;
+	ret = sg_alloc_table(&rctx->data_sg, sg_count, gfp);
 	if (ret)
 		return ret;
 
