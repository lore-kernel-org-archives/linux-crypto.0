Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61268C4332D
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3199220732
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbhAPRPK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbhAPRPH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37A58230FE;
        Sat, 16 Jan 2021 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610815697;
        bh=IH/nf9U6TbopCThaeu1W365wUsj3imYlgtOdNAoMAv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UA0wiqLcEyeT1tPd3cDG4S/OgHz7eCt17sZ9LCo32KuiM3VwzrlfBBK6onREbx0uG
         TngOc/oru1nsb4ATw/VxUBtfzJsVNK9+tqvEAW15EE9xvdvdWKOK7a2ldmOEWYPgkL
         BmlTGI1zvM/IXiHle8UKyR7VTZD73QYaKu4ZQxubSN2iQnsO2tWV055Fa4/b/e1GeO
         cnaqijRxIBaRWXk7QqbFxrRgaVHIMNdZTDhQtvaXe4wo5VeT1IjOZ/dBvPr/D6G4NT
         9F1oOqYzIPYHgh6Zvnf+gEHdPrl9Ax3dlVXDkdD3VnNOdyxbRqwNqHLCoaoVpLHUKf
         iyLa0OZYku9kQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: aesni - replace CTR function pointer with static call
Date:   Sat, 16 Jan 2021 17:48:09 +0100
Message-Id: <20210116164810.21192-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116164810.21192-1-ardb@kernel.org>
References: <20210116164810.21192-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Indirect calls are very expensive on x86, so use a static call to set
the system-wide AES-NI/CTR asm helper.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index a548fdbc3073..d96685457196 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -34,6 +34,7 @@
 #include <linux/jump_label.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/static_call.h>
 
 
 #define AESNI_ALIGN	16
@@ -107,10 +108,9 @@ asmlinkage void aesni_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *out,
 
 #ifdef CONFIG_X86_64
 
-static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
+DEFINE_STATIC_CALL(aesni_ctr_enc_tfm, aesni_ctr_enc);
 
 /* Scatter / Gather routines, with args similar to above */
 asmlinkage void aesni_gcm_init(void *ctx,
@@ -520,8 +520,10 @@ static int ctr_crypt(struct skcipher_request *req)
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
-		aesni_ctr_enc_tfm(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			              nbytes & AES_BLOCK_MASK, walk.iv);
+		static_call(aesni_ctr_enc_tfm)(ctx, walk.dst.virt.addr,
+					       walk.src.virt.addr,
+					       nbytes & AES_BLOCK_MASK,
+					       walk.iv);
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = skcipher_walk_done(&walk, nbytes);
 	}
@@ -1160,10 +1162,9 @@ static int __init aesni_init(void)
 	} else {
 		pr_info("SSE version of gcm_enc/dec engaged.\n");
 	}
-	aesni_ctr_enc_tfm = aesni_ctr_enc;
 	if (boot_cpu_has(X86_FEATURE_AVX)) {
 		/* optimize performance of ctr mode encryption transform */
-		aesni_ctr_enc_tfm = aesni_ctr_enc_avx_tfm;
+		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx_tfm);
 		pr_info("AES CTR mode by8 optimization enabled\n");
 	}
 #endif
-- 
2.17.1

