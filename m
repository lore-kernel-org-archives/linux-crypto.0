Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B577C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Nov 2021 20:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351731AbhKXURq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:17:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:24872 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244409AbhKXURe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Nov 2021 15:17:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222240647"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222240647"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 12:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="510015829"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 24 Nov 2021 12:14:21 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, bp@suse.de, dave.hansen@linux.intel.com,
        mingo@kernel.org, luto@kernel.org, x86@kernel.org,
        herbert@gondor.apana.org.au
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dan.j.williams@intel.com, charishma1.gairuboyina@intel.com,
        kumar.n.dwarakanath@intel.com, lalithambika.krishnakumar@intel.com,
        ravi.v.shankar@intel.com, chang.seok.bae@intel.com
Subject: [PATCH v3 12/15] crypto: x86/aes-kl - Support ECB mode
Date:   Wed, 24 Nov 2021 12:06:57 -0800
Message-Id: <20211124200700.15888-13-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211124200700.15888-1-chang.seok.bae@intel.com>
References: <20211124200700.15888-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement ECB mode using AES-KL. Export the methods with a lower priority
than AES-NI to avoid from selected by default.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: x86@kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from RFC v2:
* Separate out the code as a new patch.
---
 arch/x86/crypto/aeskl-intel_asm.S  | 193 +++++++++++++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c |  92 +++++++++++++-
 2 files changed, 284 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
index d56ec8dd6644..833bb39ae903 100644
--- a/arch/x86/crypto/aeskl-intel_asm.S
+++ b/arch/x86/crypto/aeskl-intel_asm.S
@@ -182,3 +182,196 @@ SYM_FUNC_START(_aeskl_dec)
 	ret
 SYM_FUNC_END(_aeskl_dec)
 
+/*
+ * int _aeskl_ecb_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len)
+ */
+SYM_FUNC_START(_aeskl_ecb_enc)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl LEN
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+16)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+20)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+24)(%esp), INP	# src
+	movl (FRAME_OFFSET+28)(%esp), LEN	# len
+#endif
+	test LEN, LEN
+	jz .Lecb_enc_noerr
+	mov 480(HANDLEP), KLEN
+	cmp $16, LEN
+	jb .Lecb_enc_noerr
+	cmp $128, LEN
+	jb .Lecb_enc1
+
+.align 4
+.Lecb_enc8:
+	movdqu (INP), STATE1
+	movdqu 0x10(INP), STATE2
+	movdqu 0x20(INP), STATE3
+	movdqu 0x30(INP), STATE4
+	movdqu 0x40(INP), STATE5
+	movdqu 0x50(INP), STATE6
+	movdqu 0x60(INP), STATE7
+	movdqu 0x70(INP), STATE8
+
+	cmp $16, KLEN
+	je .Lecb_enc8_128
+	aesencwide256kl (HANDLEP)
+	jz .Lecb_enc_err
+	jmp .Lecb_enc8_end
+.Lecb_enc8_128:
+	aesencwide128kl (HANDLEP)
+	jz .Lecb_enc_err
+
+.Lecb_enc8_end:
+	movdqu STATE1, (OUTP)
+	movdqu STATE2, 0x10(OUTP)
+	movdqu STATE3, 0x20(OUTP)
+	movdqu STATE4, 0x30(OUTP)
+	movdqu STATE5, 0x40(OUTP)
+	movdqu STATE6, 0x50(OUTP)
+	movdqu STATE7, 0x60(OUTP)
+	movdqu STATE8, 0x70(OUTP)
+
+	sub $128, LEN
+	add $128, INP
+	add $128, OUTP
+	cmp $128, LEN
+	jge .Lecb_enc8
+	cmp $16, LEN
+	jb .Lecb_enc_noerr
+
+.align 4
+.Lecb_enc1:
+	movdqu (INP), STATE1
+	cmp $16, KLEN
+	je .Lecb_enc1_128
+	aesenc256kl (HANDLEP), STATE
+	jz .Lecb_enc_err
+	jmp .Lecb_enc1_end
+.Lecb_enc1_128:
+	aesenc128kl (HANDLEP), STATE
+	jz .Lecb_enc_err
+
+.Lecb_enc1_end:
+	movdqu STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lecb_enc1
+
+.Lecb_enc_noerr:
+	xor AREG, AREG
+	jmp .Lecb_enc_end
+.Lecb_enc_err:
+	mov $1, AREG
+.Lecb_enc_end:
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+	popl LEN
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(_aeskl_ecb_enc)
+
+/*
+ * int _aeskl_ecb_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len)
+ */
+SYM_FUNC_START(_aeskl_ecb_dec)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl LEN
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+16)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+20)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+24)(%esp), INP	# src
+	movl (FRAME_OFFSET+28)(%esp), LEN	# len
+#endif
+
+	test LEN, LEN
+	jz .Lecb_dec_noerr
+	mov 480(HANDLEP), KLEN
+	cmp $16, LEN
+	jb .Lecb_dec_noerr
+	cmp $128, LEN
+	jb .Lecb_dec1
+
+.align 4
+.Lecb_dec8:
+	movdqu (INP), STATE1
+	movdqu 0x10(INP), STATE2
+	movdqu 0x20(INP), STATE3
+	movdqu 0x30(INP), STATE4
+	movdqu 0x40(INP), STATE5
+	movdqu 0x50(INP), STATE6
+	movdqu 0x60(INP), STATE7
+	movdqu 0x70(INP), STATE8
+
+	cmp $16, KLEN
+	je .Lecb_dec8_128
+	aesdecwide256kl (HANDLEP)
+	jz .Lecb_dec_err
+	jmp .Lecb_dec8_end
+.Lecb_dec8_128:
+	aesdecwide128kl (HANDLEP)
+	jz .Lecb_dec_err
+
+.Lecb_dec8_end:
+	movdqu STATE1, (OUTP)
+	movdqu STATE2, 0x10(OUTP)
+	movdqu STATE3, 0x20(OUTP)
+	movdqu STATE4, 0x30(OUTP)
+	movdqu STATE5, 0x40(OUTP)
+	movdqu STATE6, 0x50(OUTP)
+	movdqu STATE7, 0x60(OUTP)
+	movdqu STATE8, 0x70(OUTP)
+
+	sub $128, LEN
+	add $128, INP
+	add $128, OUTP
+	cmp $128, LEN
+	jge .Lecb_dec8
+	cmp $16, LEN
+	jb .Lecb_dec_noerr
+
+.align 4
+.Lecb_dec1:
+	movdqu (INP), STATE1
+	cmp $16, KLEN
+	je .Lecb_dec1_128
+	aesdec256kl (HANDLEP), STATE
+	jz .Lecb_dec_err
+	jmp .Lecb_dec1_end
+.Lecb_dec1_128:
+	aesdec128kl (HANDLEP), STATE
+	jz .Lecb_dec_err
+
+.Lecb_dec1_end:
+	movdqu STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lecb_dec1
+
+.Lecb_dec_noerr:
+	xor AREG, AREG
+	jmp .Lecb_dec_end
+.Lecb_dec_err:
+	mov $1, AREG
+.Lecb_dec_end:
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+	popl LEN
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(_aeskl_ecb_dec)
+
diff --git a/arch/x86/crypto/aeskl-intel_glue.c b/arch/x86/crypto/aeskl-intel_glue.c
index 3e3a8b6eccb4..7c9794a0969d 100644
--- a/arch/x86/crypto/aeskl-intel_glue.c
+++ b/arch/x86/crypto/aeskl-intel_glue.c
@@ -27,6 +27,9 @@ asmlinkage int aeskl_setkey(struct crypto_aes_ctx *ctx, const u8 *in_key, unsign
 asmlinkage int _aeskl_enc(const void *ctx, u8 *out, const u8 *in);
 asmlinkage int _aeskl_dec(const void *ctx, u8 *out, const u8 *in);
 
+asmlinkage int _aeskl_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+asmlinkage int _aeskl_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+
 static int aeskl_setkey_common(struct crypto_tfm *tfm, void *raw_ctx, const u8 *in_key,
 			       unsigned int key_len)
 {
@@ -86,11 +89,92 @@ static inline int aeskl_dec(const void *ctx, u8 *out, const u8 *in)
 		return 0;
 }
 
+static int aeskl_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_ecb_enc(ctx, out, in, len))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int aeskl_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_ecb_dec(ctx, out, in, len))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int aeskl_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				 unsigned int len)
+{
+	struct crypto_tfm *crypto_tfm = crypto_skcipher_tfm(tfm);
+	void *raw_ctx = crypto_skcipher_ctx(tfm);
+
+	return aeskl_setkey_common(crypto_tfm, raw_ctx, key, len);
+}
+
+static int ecb_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return ecb_crypt_common(req, aeskl_ecb_enc);
+	else
+		return ecb_crypt_common(req, aesni_ecb_enc);
+}
+
+static int ecb_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return ecb_crypt_common(req, aeskl_ecb_dec);
+	else
+		return ecb_crypt_common(req, aesni_ecb_dec);
+}
+
+static struct skcipher_alg aeskl_skciphers[] = {
+	{
+		.base = {
+			.cra_name		= "__ecb(aes)",
+			.cra_driver_name	= "__ecb-aes-aeskl",
+			.cra_priority		= 200,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.setkey		= aeskl_skcipher_setkey,
+		.encrypt	= ecb_encrypt,
+		.decrypt	= ecb_decrypt,
+	}
+};
+
+static struct simd_skcipher_alg *aeskl_simd_skciphers[ARRAY_SIZE(aeskl_skciphers)];
+
 static int __init aeskl_init(void)
 {
+	u32 eax, ebx, ecx, edx;
+	int err;
+
 	if (!valid_keylocker())
 		return -ENODEV;
 
+	cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
+	if (!(ebx & KEYLOCKER_CPUID_EBX_WIDE))
+		return -ENODEV;
+
 	/*
 	 * AES-KL itself does not depend on AES-NI. But AES-KL does not
 	 * support 192-bit keys. To make itself AES-compliant, it falls
@@ -99,12 +183,18 @@ static int __init aeskl_init(void)
 	if (!boot_cpu_has(X86_FEATURE_AES))
 		return -ENODEV;
 
+	err = simd_register_skciphers_compat(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+					     aeskl_simd_skciphers);
+	if (err)
+		return err;
+
 	return 0;
 }
 
 static void __exit aeskl_exit(void)
 {
-	return;
+	simd_unregister_skciphers(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+				  aeskl_simd_skciphers);
 }
 
 late_initcall(aeskl_init);
-- 
2.17.1

