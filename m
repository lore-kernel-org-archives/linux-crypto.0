Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40661C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Nov 2021 20:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351676AbhKXUSC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:18:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:13501 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351687AbhKXURm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Nov 2021 15:17:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="321601966"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="321601966"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 12:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="510015839"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 24 Nov 2021 12:14:22 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, bp@suse.de, dave.hansen@linux.intel.com,
        mingo@kernel.org, luto@kernel.org, x86@kernel.org,
        herbert@gondor.apana.org.au
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dan.j.williams@intel.com, charishma1.gairuboyina@intel.com,
        kumar.n.dwarakanath@intel.com, lalithambika.krishnakumar@intel.com,
        ravi.v.shankar@intel.com, chang.seok.bae@intel.com
Subject: [PATCH v3 14/15] crypto: x86/aes-kl - Support CTR mode
Date:   Wed, 24 Nov 2021 12:06:59 -0800
Message-Id: <20211124200700.15888-15-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211124200700.15888-1-chang.seok.bae@intel.com>
References: <20211124200700.15888-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement CTR mode using AES-KL. Export the methods with a lower priority
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
 arch/x86/crypto/aeskl-intel_asm.S  | 174 +++++++++++++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c |  55 +++++++++
 2 files changed, 229 insertions(+)

diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
index 5ee7b24ee3c8..ffde0cd3dd42 100644
--- a/arch/x86/crypto/aeskl-intel_asm.S
+++ b/arch/x86/crypto/aeskl-intel_asm.S
@@ -563,3 +563,177 @@ SYM_FUNC_START(_aeskl_cbc_dec)
 	ret
 SYM_FUNC_END(_aeskl_cbc_dec)
 
+#ifdef __x86_64__
+
+/*
+ * _aeskl_ctr_inc_init:	internal ABI
+ *	setup registers used by _aesni_inc
+ * input:
+ *	IV
+ * output:
+ *	CTR:	== IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ *	INC:	== 1, in little endian
+ *	BSWAP_MASK == endian swapping mask
+ */
+SYM_FUNC_START_LOCAL(_aeskl_ctr_inc_init)
+	movaps .Lbswap_mask, BSWAP_MASK
+	movaps IV, CTR
+	pshufb BSWAP_MASK, CTR
+	mov $1, TCTR_LOW
+	movq TCTR_LOW, INC
+	movq CTR, TCTR_LOW
+	ret
+SYM_FUNC_END(_aeskl_ctr_inc_init)
+
+/*
+ * _aeskl_ctr_inc:		internal ABI
+ *	Increase IV by 1, IV is in big endian
+ * input:
+ *	IV
+ *	CTR:	== IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ *	INC:	== 1, in little endian
+ *	BSWAP_MASK == endian swapping mask
+ * output:
+ *	IV:	Increase by 1
+ * changed:
+ *	CTR:	== output IV, in little endian
+ *	TCTR_LOW: == lower qword of CTR
+ */
+SYM_FUNC_START_LOCAL(_aeskl_ctr_inc)
+	paddq INC, CTR
+	add $1, TCTR_LOW
+	jnc .Linc_low
+	pslldq $8, INC
+	paddq INC, CTR
+	psrldq $8, INC
+.Linc_low:
+	movaps CTR, IV
+	pshufb BSWAP_MASK, IV
+	ret
+SYM_FUNC_END(_aeskl_ctr_inc)
+
+/*
+ * CTR implementations
+ */
+
+/*
+ * int _aeskl_ctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+SYM_FUNC_START(_aeskl_ctr_enc)
+	FRAME_BEGIN
+	cmp $16, LEN
+	jb .Lctr_enc_noerr
+	mov 480(HANDLEP), KLEN
+	movdqu (IVP), IV
+	call _aeskl_ctr_inc_init
+	cmp $128, LEN
+	jb .Lctr_enc1
+
+.align 4
+.Lctr_enc8:
+	movaps IV, STATE1
+	call _aeskl_ctr_inc
+	movaps IV, STATE2
+	call _aeskl_ctr_inc
+	movaps IV, STATE3
+	call _aeskl_ctr_inc
+	movaps IV, STATE4
+	call _aeskl_ctr_inc
+	movaps IV, STATE5
+	call _aeskl_ctr_inc
+	movaps IV, STATE6
+	call _aeskl_ctr_inc
+	movaps IV, STATE7
+	call _aeskl_ctr_inc
+	movaps IV, STATE8
+	call _aeskl_ctr_inc
+
+	cmp $16, KLEN
+	je .Lctr_enc8_128
+	aesencwide256kl (%rdi)
+	jz .Lctr_enc_err
+	jmp .Lctr_enc8_end
+.Lctr_enc8_128:
+	aesencwide128kl (%rdi)
+	jz .Lctr_enc_err
+.Lctr_enc8_end:
+
+	movups (INP), IN1
+	pxor IN1, STATE1
+	movups STATE1, (OUTP)
+
+	movups 0x10(INP), IN1
+	pxor IN1, STATE2
+	movups STATE2, 0x10(OUTP)
+
+	movups 0x20(INP), IN1
+	pxor IN1, STATE3
+	movups STATE3, 0x20(OUTP)
+
+	movups 0x30(INP), IN1
+	pxor IN1, STATE4
+	movups STATE4, 0x30(OUTP)
+
+	movups 0x40(INP), IN1
+	pxor IN1, STATE5
+	movups STATE5, 0x40(OUTP)
+
+	movups 0x50(INP), IN1
+	pxor IN1, STATE6
+	movups STATE6, 0x50(OUTP)
+
+	movups 0x60(INP), IN1
+	pxor IN1, STATE7
+	movups STATE7, 0x60(OUTP)
+
+	movups 0x70(INP), IN1
+	pxor IN1, STATE8
+	movups STATE8, 0x70(OUTP)
+
+	sub $128, LEN
+	add $128, INP
+	add $128, OUTP
+	cmp $128, LEN
+	jge .Lctr_enc8
+	cmp $16, LEN
+	jb .Lctr_enc_end
+
+.align 4
+.Lctr_enc1:
+	movaps IV, STATE1
+	call _aeskl_ctr_inc
+
+	cmp $16, KLEN
+	je .Lctr_enc1_128
+	aesenc256kl (HANDLEP), STATE1
+	jz .Lctr_enc_err
+	jmp .Lctr_enc1_end
+.Lctr_enc1_128:
+	aesenc128kl (HANDLEP), STATE1
+	jz .Lctr_enc_err
+
+.Lctr_enc1_end:
+	movups (INP), IN1
+	pxor IN1, STATE1
+	movups STATE1, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lctr_enc1
+
+.Lctr_enc_end:
+	movdqu IV, (IVP)
+.Lctr_enc_noerr:
+	xor AREG, AREG
+	jmp .Lctr_enc_ret
+.Lctr_enc_err:
+	mov $1, AREG
+.Lctr_enc_ret:
+	FRAME_END
+	ret
+SYM_FUNC_END(_aeskl_ctr_enc)
+
diff --git a/arch/x86/crypto/aeskl-intel_glue.c b/arch/x86/crypto/aeskl-intel_glue.c
index 742576ae0481..f99dfa4a052f 100644
--- a/arch/x86/crypto/aeskl-intel_glue.c
+++ b/arch/x86/crypto/aeskl-intel_glue.c
@@ -35,6 +35,11 @@ asmlinkage int _aeskl_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
 asmlinkage int _aeskl_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
 			      u8 *iv);
 
+#ifdef CONFIG_X86_64
+asmlinkage int _aeskl_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			      u8 *iv);
+#endif
+
 static int aeskl_setkey_common(struct crypto_tfm *tfm, void *raw_ctx, const u8 *in_key,
 			       unsigned int key_len)
 {
@@ -144,6 +149,23 @@ static int aeskl_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsi
 		return 0;
 }
 
+#ifdef CONFIG_X86_64
+
+static int aeskl_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			 u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_ctr_enc(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+#endif /* CONFIG_X86_64 */
+
 static int aeskl_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				 unsigned int len)
 {
@@ -193,6 +215,20 @@ static int cbc_decrypt(struct skcipher_request *req)
 		return cbc_crypt_common(req, aesni_cbc_dec);
 }
 
+#ifdef CONFIG_X86_64
+
+static int ctr_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return ctr_crypt_common(req, aeskl_ctr_enc, aeskl_enc);
+	else
+		return ctr_crypt_common(req, aesni_ctr_enc, aesni_enc);
+}
+
+#endif /* CONFIG_X86_64 */
+
 static struct skcipher_alg aeskl_skciphers[] = {
 	{
 		.base = {
@@ -225,6 +261,25 @@ static struct skcipher_alg aeskl_skciphers[] = {
 		.setkey		= aeskl_skcipher_setkey,
 		.encrypt	= cbc_encrypt,
 		.decrypt	= cbc_decrypt,
+#ifdef CONFIG_X86_64
+	}, {
+		.base = {
+			.cra_name		= "__ctr(aes)",
+			.cra_driver_name	= "__ctr-aes-aeskl",
+			.cra_priority		= 200,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
+		.setkey		= aeskl_skcipher_setkey,
+		.encrypt	= ctr_crypt,
+		.decrypt	= ctr_crypt,
+#endif
 	}
 };
 
-- 
2.17.1

