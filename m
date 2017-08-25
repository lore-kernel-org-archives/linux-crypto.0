From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 06/12] crypto: crypto4xx: fix dynamic_sa_ctl's sa_contents declaration
Date: Fri, 25 Aug 2017 15:47:19 +0200
Message-ID: <575e998ebe72ea59e785263e11b2a44fb1c6d910.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35024 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932813AbdHYNrg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:36 -0400
Received: by mail-wr0-f194.google.com with SMTP id a47so1528228wra.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:35 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <c623cda688571bc483f0c9a9fb4c17cda0514cdd.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com> <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com> <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com> <c623cda688571bc483f0c9a9fb4c17cda0514cdd.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver had a union dynamic_sa_contents in place that
described the meaning of the bits in the sa_contents
variable.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c |  4 ++--
 drivers/crypto/amcc/crypto4xx_sa.c  | 12 ++++++------
 drivers/crypto/amcc/crypto4xx_sa.h  |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 6da92321173b..867a9230cd3f 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -149,7 +149,7 @@ static int crypto4xx_setkey_aes(struct crypto_ablkcipher *cipher,
 				 SA_NOT_COPY_HDR);
 	crypto4xx_memcpy_le(ctx->sa_in + get_dynamic_sa_offset_key_field(ctx),
 			    key, keylen);
-	sa->sa_contents = SA_AES_CONTENTS | (keylen << 2);
+	sa->sa_contents.w = SA_AES_CONTENTS | (keylen << 2);
 	sa->sa_command_1.bf.key_len = keylen >> 3;
 	ctx->is_hash = 0;
 	ctx->direction = DIR_INBOUND;
@@ -219,7 +219,7 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 				 SA_NOT_COPY_PAD, SA_NOT_COPY_PAYLOAD,
 				 SA_NOT_COPY_HDR);
 	ctx->direction = DIR_INBOUND;
-	sa->sa_contents = SA_HASH160_CONTENTS;
+	sa->sa_contents.w = SA_HASH160_CONTENTS;
 	sa_in = (struct dynamic_sa_hash160 *) ctx->sa_in;
 	/* Need to zero hash digest in SA */
 	memset(sa_in->inner_digest, 0, sizeof(sa_in->inner_digest));
diff --git a/drivers/crypto/amcc/crypto4xx_sa.c b/drivers/crypto/amcc/crypto4xx_sa.c
index 69182e2cc3ea..78a8ca192d0d 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.c
+++ b/drivers/crypto/amcc/crypto4xx_sa.c
@@ -40,9 +40,9 @@ u32 get_dynamic_sa_offset_state_ptr_field(struct crypto4xx_ctx *ctx)
 	union dynamic_sa_contents cts;
 
 	if (ctx->direction == DIR_INBOUND)
-		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_in)->sa_contents;
+		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_in)->sa_contents.w;
 	else
-		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_out)->sa_contents;
+		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_out)->sa_contents.w;
 	offset = cts.bf.key_size
 		+ cts.bf.inner_size
 		+ cts.bf.outer_size
@@ -66,9 +66,9 @@ u32 get_dynamic_sa_iv_size(struct crypto4xx_ctx *ctx)
 	union dynamic_sa_contents cts;
 
 	if (ctx->direction == DIR_INBOUND)
-		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_in)->sa_contents;
+		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_in)->sa_contents.w;
 	else
-		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_out)->sa_contents;
+		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_out)->sa_contents.w;
 	return (cts.bf.iv0 + cts.bf.iv1 + cts.bf.iv2 + cts.bf.iv3) * 4;
 }
 
@@ -77,9 +77,9 @@ u32 get_dynamic_sa_offset_key_field(struct crypto4xx_ctx *ctx)
 	union dynamic_sa_contents cts;
 
 	if (ctx->direction == DIR_INBOUND)
-		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_in)->sa_contents;
+		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_in)->sa_contents.w;
 	else
-		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_out)->sa_contents;
+		cts.w = ((struct dynamic_sa_ctl *) ctx->sa_out)->sa_contents.w;
 
 	return sizeof(struct dynamic_sa_ctl);
 }
diff --git a/drivers/crypto/amcc/crypto4xx_sa.h b/drivers/crypto/amcc/crypto4xx_sa.h
index 1352d58d4e34..537d548a20b7 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.h
+++ b/drivers/crypto/amcc/crypto4xx_sa.h
@@ -169,7 +169,7 @@ union sa_command_1 {
 } __attribute__((packed));
 
 struct dynamic_sa_ctl {
-	u32 sa_contents;
+	union dynamic_sa_contents sa_contents;
 	union sa_command_0 sa_command_0;
 	union sa_command_1 sa_command_1;
 } __attribute__((packed));
-- 
2.14.1
