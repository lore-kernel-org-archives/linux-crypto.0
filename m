From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - coccicheck fixes
Date: Fri, 24 Aug 2012 18:21:35 -0500
Message-ID: <20120824182135.dbf3bd61662ae8f542a4eb3e@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45596 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625Ab2HXXXp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Aug 2012 19:23:45 -0400
Received: from mail155-tx2 (localhost [127.0.0.1])	by
 mail155-tx2-R.bigfish.com (Postfix) with ESMTP id 850CE2E0545	for
 <linux-crypto@vger.kernel.org>; Fri, 24 Aug 2012 23:23:44 +0000 (UTC)
Received: from TX2EHSMHS025.bigfish.com (unknown [10.9.14.235])	by
 mail155-tx2.bigfish.com (Postfix) with ESMTP id 795A21202DC	for
 <linux-crypto@vger.kernel.org>; Fri, 24 Aug 2012 23:23:42 +0000 (UTC)
Received: from x9.am.freescale.net (x9.am.freescale.net [10.82.120.9])	by
 tx30smr01.am.freescale.net (8.14.3/8.14.0) with SMTP id q7ONNemt007805	for
 <linux-crypto@vger.kernel.org>; Fri, 24 Aug 2012 16:23:41 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

use true/false for bool, fix code alignment, and fix two allocs with
no test.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 16 ++++++++--------
 drivers/crypto/caam/caamhash.c |  4 ++++
 drivers/crypto/caam/key_gen.c  |  4 ++++
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 6b48295..cf268b1 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -224,7 +224,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	struct aead_tfm *tfm = &aead->base.crt_aead;
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	bool keys_fit_inline = 0;
+	bool keys_fit_inline = false;
 	u32 *key_jump_cmd, *jump_cmd;
 	u32 geniv, moveiv;
 	u32 *desc;
@@ -239,7 +239,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (DESC_AEAD_ENC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen <=
 	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = 1;
+		keys_fit_inline = true;
 
 	/* aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
@@ -297,7 +297,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (DESC_AEAD_DEC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen <=
 	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = 1;
+		keys_fit_inline = true;
 
 	desc = ctx->sh_desc_dec;
 
@@ -365,7 +365,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (DESC_AEAD_GIVENC_LEN + DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen <=
 	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = 1;
+		keys_fit_inline = true;
 
 	/* aead_givencrypt shared descriptor */
 	desc = ctx->sh_desc_givenc;
@@ -1354,10 +1354,10 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 		contig &= ~GIV_SRC_CONTIG;
 	if (dst_nents || iv_dma + ivsize != sg_dma_address(req->dst))
 		contig &= ~GIV_DST_CONTIG;
-		if (unlikely(req->src != req->dst)) {
-			dst_nents = dst_nents ? : 1;
-			sec4_sg_len += 1;
-		}
+	if (unlikely(req->src != req->dst)) {
+		dst_nents = dst_nents ? : 1;
+		sec4_sg_len += 1;
+	}
 	if (!(contig & GIV_SRC_CONTIG)) {
 		assoc_nents = assoc_nents ? : 1;
 		src_nents = src_nents ? : 1;
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index fbf3fe8..32aba7a 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -430,6 +430,10 @@ static u32 hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 	int ret = 0;
 
 	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
+	if (!desc) {
+		dev_err(jrdev, "unable to allocate key input memory\n");
+		return -ENOMEM;
+	}
 
 	init_job_desc(desc, 0);
 
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 0028881..f5c0d56 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -54,6 +54,10 @@ u32 gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 	int ret = 0;
 
 	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
+	if (!desc) {
+		dev_err(jrdev, "unable to allocate key input memory\n");
+		return -ENOMEM;
+	}
 
 	init_job_desc(desc, 0);
 
-- 
1.7.12
