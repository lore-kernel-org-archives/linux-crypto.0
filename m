From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 04/27] staging: ccree: remove GFP_DMA flag from mem allocs
Date: Wed,  3 Jan 2018 13:35:11 +0000
Message-ID: <1514986544-5888-5-git-send-email-gilad@benyossef.com>
References: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove bogus GFP_DMA flag from memory allocations. ccree driver
does not operate over an ISA or similar limited bus.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c |  2 +-
 drivers/staging/ccree/ssi_hash.c   | 15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 71d3e79..479186f 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -166,7 +166,7 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 	ctx_p->drvdata = cc_alg->drvdata;
 
 	/* Allocate key buffer, cache line aligned */
-	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL | GFP_DMA);
+	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL);
 	if (!ctx_p->user.key)
 		return -ENOMEM;
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index c409dcd..a6702cf 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -132,29 +132,27 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
 
-	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
+	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL);
 	if (!state->buff0)
 		goto fail0;
 
-	state->buff1 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
+	state->buff1 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL);
 	if (!state->buff1)
 		goto fail_buff0;
 
 	state->digest_result_buff = kzalloc(CC_MAX_HASH_DIGEST_SIZE,
-					    GFP_KERNEL | GFP_DMA);
+					    GFP_KERNEL);
 	if (!state->digest_result_buff)
 		goto fail_buff1;
 
-	state->digest_buff = kzalloc(ctx->inter_digestsize,
-				     GFP_KERNEL | GFP_DMA);
+	state->digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL);
 	if (!state->digest_buff)
 		goto fail_digest_result_buff;
 
 	dev_dbg(dev, "Allocated digest-buffer in context ctx->digest_buff=@%p\n",
 		state->digest_buff);
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE,
-						  GFP_KERNEL | GFP_DMA);
+		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL);
 		if (!state->digest_bytes_len)
 			goto fail1;
 
@@ -164,8 +162,7 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 		state->digest_bytes_len = NULL;
 	}
 
-	state->opad_digest_buff = kzalloc(ctx->inter_digestsize,
-					  GFP_KERNEL | GFP_DMA);
+	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL);
 	if (!state->opad_digest_buff)
 		goto fail2;
 
-- 
2.7.4
