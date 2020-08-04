Return-Path: <SRS0=wb3S=BO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C9EC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 13:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54AED2075D
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596546271;
	bh=9UExFAQWoqYJsRDTZfZ2Z85Tu/slCNX+un0+fA3jr+k=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=qfvBVfyXni8qixMxgc792YFZyp/gCEVGVRLm3qRwX4MTjYppQdV+JBxFtf9z7RapH
	 M6bZdxFuewq7Eew75q9/hmkpAlkyRN84pPbknT6gR0HaMRjJe/B62UZjm5jry+6FEY
	 E1eqt6FyiOk3a0lHQzcxTHzKOcTFBvnSdtlmDNNc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgHDNEa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 09:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbgHDNEX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 09:04:23 -0400
Received: from e123331-lin.nice.arm.com (46-144-95-194.biz.kpn.net [46.144.95.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6212075D;
        Tue,  4 Aug 2020 13:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596546262;
        bh=9UExFAQWoqYJsRDTZfZ2Z85Tu/slCNX+un0+fA3jr+k=;
        h=From:To:Cc:Subject:Date:From;
        b=eIPkxYEeK9gUNjxhNsVaUzXGb6nOSFeZssNvwB7FqEU8CGiHrAB7j3fl9QYHX33nE
         rzQRUWR5q5NcUzgkb2+k6y8JgUceydrIj7rSAOO1KaMC4xiaU9RZVfKxETfm6+csFP
         hdJS518wg23tKIixINH/ybr7NCO+2D0tZ53ZKKDs=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] crypto: x86/aesni - implement accelerated CBCMAC ahash
Date:   Tue,  4 Aug 2020 15:03:40 +0200
Message-Id: <20200804130340.30733-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ben reports that CCM using AES-NI instructions performs pathologically
poorly, which is due to the overhead of preserving/restoring the SIMD
state, which is repeated after every 16 bytes of input when executing
the CBCMAC portion of the algorithm.

So let's adopt the arm64 implementation of cbcmac(aes), which takes
care to only preserve/restore the SIMD state after processing the
whole input, and convert it into an ahash implementation, which gives
us more control over the way FPU preserve/restore can be amortized over
the entire request.

Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: 
- use a ahash not shash, so we can process most of the cbcmac input in one go
- drop cmac and xcbc, which are only used in shash form by other parts of the
  kernel

 arch/x86/crypto/Makefile           |   2 +-
 arch/x86/crypto/aesni-intel.h      |  21 ++
 arch/x86/crypto/aesni-intel_asm.S  |  38 ++++
 arch/x86/crypto/aesni-intel_glue.c |  24 +--
 arch/x86/crypto/aesni-intel_mac.c  | 206 ++++++++++++++++++++
 5 files changed, 275 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index a31de0c6ccde..f83e162f87ad 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -51,7 +51,7 @@ chacha-x86_64-y := chacha-avx2-x86_64.o chacha-ssse3-x86_64.o chacha_glue.o
 chacha-x86_64-$(CONFIG_AS_AVX512) += chacha-avx512vl-x86_64.o
 
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
-aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
+aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o aesni-intel_mac.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
diff --git a/arch/x86/crypto/aesni-intel.h b/arch/x86/crypto/aesni-intel.h
new file mode 100644
index 000000000000..d9dc072a6038
--- /dev/null
+++ b/arch/x86/crypto/aesni-intel.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/internal/hash.h>
+
+#define AESNI_ALIGN	16
+#define AESNI_ALIGN_EXTRA ((AESNI_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
+#define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
+
+extern struct ahash_alg aesni_cbcmac_alg;
+
+static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
+{
+	unsigned long addr = (unsigned long)raw_ctx;
+	unsigned long align = AESNI_ALIGN;
+
+	if (align <= crypto_tfm_ctx_alignment())
+		align = 1;
+	return (struct crypto_aes_ctx *)ALIGN(addr, align);
+}
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 54e7d15dbd0d..fa5730e78520 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2578,6 +2578,44 @@ SYM_FUNC_START(aesni_cbc_dec)
 	ret
 SYM_FUNC_END(aesni_cbc_dec)
 
+/*
+ * void aesni_cbc_mac(struct crypto_aes_ctx *ctx, u8 *dgst, const u8 *src,
+ *		      size_t len)
+ */
+SYM_FUNC_START(aesni_cbc_mac)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl LEN
+	pushl KEYP
+	pushl KLEN
+	movl (FRAME_OFFSET+16)(%esp), KEYP	# ctx
+	movl (FRAME_OFFSET+20)(%esp), OUTP	# dgst
+	movl (FRAME_OFFSET+24)(%esp), INP	# src
+	movl (FRAME_OFFSET+28)(%esp), LEN	# len
+#endif
+	sub $1, LEN
+	jb .Lcbc_mac_ret
+	mov 480(KEYP), KLEN
+	movups (OUTP), STATE	# load digest as initial state
+.align 4
+.Lcbc_mac_loop:
+	movups (INP), IN	# load input
+	pxor IN, STATE
+	call _aesni_enc1
+	add $16, INP
+	sub $1, LEN
+	jge .Lcbc_mac_loop
+	movups STATE, (OUTP)	# store output digest
+.Lcbc_mac_ret:
+#ifndef __x86_64__
+	popl KLEN
+	popl KEYP
+	popl LEN
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(aesni_cbc_mac)
+
 #ifdef __x86_64__
 .pushsection .rodata
 .align 16
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ad8a7188a2bf..a67e115fe250 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -19,8 +19,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <crypto/algapi.h>
-#include <crypto/aes.h>
 #include <crypto/ctr.h>
 #include <crypto/b128ops.h>
 #include <crypto/gcm.h>
@@ -37,13 +35,11 @@
 #include <asm/crypto/glue_helper.h>
 #endif
 
+#include "aesni-intel.h"
 
-#define AESNI_ALIGN	16
 #define AESNI_ALIGN_ATTR __attribute__ ((__aligned__(AESNI_ALIGN)))
 #define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE - 1))
 #define RFC4106_HASH_SUBKEY_SIZE 16
-#define AESNI_ALIGN_EXTRA ((AESNI_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
-#define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
 #define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
 
 /* This data is stored at the end of the crypto_tfm struct.
@@ -296,16 +292,6 @@ generic_gcmaes_ctx *generic_gcmaes_ctx_get(struct crypto_aead *tfm)
 }
 #endif
 
-static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
-{
-	unsigned long addr = (unsigned long)raw_ctx;
-	unsigned long align = AESNI_ALIGN;
-
-	if (align <= crypto_tfm_ctx_alignment())
-		align = 1;
-	return (struct crypto_aes_ctx *)ALIGN(addr, align);
-}
-
 static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
 			      const u8 *in_key, unsigned int key_len)
 {
@@ -1098,8 +1084,15 @@ static int __init aesni_init(void)
 	if (err)
 		goto unregister_skciphers;
 
+	err = crypto_register_ahash(&aesni_cbcmac_alg);
+	if (err)
+		goto unregister_aeads;
+
 	return 0;
 
+unregister_aeads:
+	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
+			      aesni_simd_aeads);
 unregister_skciphers:
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
 				  aesni_simd_skciphers);
@@ -1110,6 +1103,7 @@ static int __init aesni_init(void)
 
 static void __exit aesni_exit(void)
 {
+	crypto_unregister_ahash(&aesni_cbcmac_alg);
 	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
 			      aesni_simd_aeads);
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
diff --git a/arch/x86/crypto/aesni-intel_mac.c b/arch/x86/crypto/aesni-intel_mac.c
new file mode 100644
index 000000000000..693897360c35
--- /dev/null
+++ b/arch/x86/crypto/aesni-intel_mac.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2013 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2020 Arm Ltd <ard.biesheuvel@arm.com>
+ */
+
+#include <asm/simd.h>
+#include <crypto/b128ops.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
+#include <linux/module.h>
+
+#include "aesni-intel.h"
+
+MODULE_ALIAS_CRYPTO("cbcmac(aes)");
+
+struct mac_tfm_ctx {
+	u8 key[CRYPTO_AES_CTX_SIZE];
+	u8 __aligned(8) consts[];
+};
+
+struct mac_req_ctx {
+	u8 dg[AES_BLOCK_SIZE];
+	unsigned int len;
+};
+
+asmlinkage void aesni_enc(const void *ctx, u8 *out, const u8 *in);
+asmlinkage void aesni_cbc_mac(struct crypto_aes_ctx *ctx, u8 *digest,
+			      const u8 *src, size_t blocks);
+
+static int cbcmac_setkey(struct crypto_ahash *tfm, const u8 *in_key,
+			 unsigned int key_len)
+{
+	struct mac_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	return aes_expandkey(aes_ctx(&ctx->key), in_key, key_len);
+}
+
+static int cbcmac_init(struct ahash_request *req)
+{
+	struct mac_req_ctx *ctx = ahash_request_ctx(req);
+
+	memset(ctx->dg, 0, AES_BLOCK_SIZE);
+	ctx->len = 0;
+
+	return 0;
+}
+
+static void mac_process_blocks(struct crypto_aes_ctx *ctx, u8 const in[],
+			       int blocks, u8 dg[], int enc_before,
+			       bool do_simd)
+{
+	if (likely(do_simd)) {
+		if (enc_before)
+			aesni_enc(ctx, dg, dg);
+		if (blocks > 0)
+			aesni_cbc_mac(ctx, dg, in, blocks);
+	} else {
+		if (enc_before)
+			aes_encrypt(ctx, dg, dg);
+
+		while (blocks--) {
+			crypto_xor(dg, in, AES_BLOCK_SIZE);
+			aes_encrypt(ctx, dg, dg);
+			in += AES_BLOCK_SIZE;
+		}
+	}
+}
+
+static int mac_do_update(struct ahash_request *req, bool do_simd)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct mac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct mac_req_ctx *ctx = ahash_request_ctx(req);
+	struct crypto_hash_walk walk;
+	unsigned int len;
+
+	for (len = crypto_hash_walk_first(req, &walk); len > 0;
+	     len = crypto_hash_walk_done(&walk, 0)) {
+		void *p = walk.data;
+		unsigned int l;
+
+		while (len > 0) {
+			if ((ctx->len % AES_BLOCK_SIZE) == 0 &&
+			    (ctx->len + len) > AES_BLOCK_SIZE) {
+
+				int blocks = len / AES_BLOCK_SIZE;
+
+				len %= AES_BLOCK_SIZE;
+
+				mac_process_blocks(aes_ctx(&tctx->key),
+						   p, blocks, ctx->dg,
+						   (ctx->len != 0), do_simd);
+
+				p += blocks * AES_BLOCK_SIZE;
+				ctx->len = 0;
+			}
+
+			l = min(len, AES_BLOCK_SIZE - ctx->len);
+
+			if (l <= AES_BLOCK_SIZE) {
+				crypto_xor(ctx->dg + ctx->len, p, l);
+				ctx->len += l;
+				len -= l;
+				p += l;
+			}
+		}
+	}
+	return 0;
+}
+
+static int cbcmac_update(struct ahash_request *req)
+{
+	bool do_simd = crypto_simd_usable();
+
+	if (likely(do_simd))
+		kernel_fpu_begin();
+
+	mac_do_update(req, do_simd);
+
+	if (likely(do_simd))
+		kernel_fpu_end();
+
+	return 0;
+}
+
+static int cbcmac_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct mac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct mac_req_ctx *ctx = ahash_request_ctx(req);
+
+	if (ctx->len != 0) {
+		if (likely(crypto_simd_usable())) {
+			kernel_fpu_begin();
+			aesni_enc(aes_ctx(&tctx->key), ctx->dg, ctx->dg);
+			kernel_fpu_end();
+		} else {
+			aes_encrypt(aes_ctx(&tctx->key), ctx->dg, ctx->dg);
+		}
+	}
+
+	memcpy(req->result, ctx->dg, AES_BLOCK_SIZE);
+	return 0;
+}
+
+static int cbcmac_finup(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct mac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct mac_req_ctx *ctx = ahash_request_ctx(req);
+	bool do_simd = crypto_simd_usable();
+
+	if (likely(do_simd))
+		kernel_fpu_begin();
+
+	mac_do_update(req, do_simd);
+
+	if (likely(do_simd)) {
+		if (ctx->len != 0)
+			aesni_enc(aes_ctx(&tctx->key), ctx->dg, ctx->dg);
+		kernel_fpu_end();
+	} else if (ctx->len != 0) {
+		aes_encrypt(aes_ctx(&tctx->key), ctx->dg, ctx->dg);
+	}
+
+	memcpy(req->result, ctx->dg, AES_BLOCK_SIZE);
+	return 0;
+}
+
+static int cbcmac_digest(struct ahash_request *req)
+{
+	return cbcmac_init(req) ?: cbcmac_finup(req);
+}
+
+static int cbcmac_export(struct ahash_request *req, void *out)
+{
+	memcpy(out, ahash_request_ctx(req), sizeof(struct mac_req_ctx));
+	return 0;
+}
+
+static int cbcmac_import(struct ahash_request *req, const void *in)
+{
+	memcpy(ahash_request_ctx(req), in, sizeof(struct mac_req_ctx));
+	return 0;
+}
+
+struct ahash_alg aesni_cbcmac_alg = {
+	.halg.base.cra_name		= "cbcmac(aes)",
+	.halg.base.cra_driver_name	= "cbcmac-aes-aesni",
+	.halg.base.cra_priority		= 400,
+	.halg.base.cra_blocksize	= 1,
+	.halg.base.cra_ctxsize		= sizeof(struct mac_tfm_ctx),
+	.halg.base.cra_module		= THIS_MODULE,
+	.halg.digestsize		= AES_BLOCK_SIZE,
+	.halg.statesize			= sizeof(struct mac_req_ctx),
+
+	.init				= cbcmac_init,
+	.update				= cbcmac_update,
+	.final				= cbcmac_final,
+	.finup				= cbcmac_finup,
+	.digest				= cbcmac_digest,
+	.setkey				= cbcmac_setkey,
+	.export				= cbcmac_export,
+	.import				= cbcmac_import,
+};
-- 
2.17.1

