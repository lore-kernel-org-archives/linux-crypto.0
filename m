Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB3EC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Nov 2021 20:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhKXURr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:17:47 -0500
Received: from mga05.intel.com ([192.55.52.43]:13503 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351555AbhKXURe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Nov 2021 15:17:34 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="321601965"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="321601965"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 12:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="510015835"
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
Subject: [PATCH v3 13/15] crypto: x86/aes-kl - Support CBC mode
Date:   Wed, 24 Nov 2021 12:06:58 -0800
Message-Id: <20211124200700.15888-14-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211124200700.15888-1-chang.seok.bae@intel.com>
References: <20211124200700.15888-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement CBC using AES-KL. Export the methods with a lower priority than
AES-NI to avoid from selected by default.

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
 arch/x86/crypto/aeskl-intel_asm.S  | 188 +++++++++++++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c |  67 ++++++++++
 2 files changed, 255 insertions(+)

diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
index 833bb39ae903..5ee7b24ee3c8 100644
--- a/arch/x86/crypto/aeskl-intel_asm.S
+++ b/arch/x86/crypto/aeskl-intel_asm.S
@@ -375,3 +375,191 @@ SYM_FUNC_START(_aeskl_ecb_dec)
 	ret
 SYM_FUNC_END(_aeskl_ecb_dec)
 
+/*
+ * int _aeskl_cbc_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+SYM_FUNC_START(_aeskl_cbc_enc)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl IVP
+	pushl LEN
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+20)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+28)(%esp), INP	# src
+	movl (FRAME_OFFSET+32)(%esp), LEN	# len
+	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
+#endif
+
+	cmp $16, LEN
+	jb .Lcbc_enc_noerr
+	mov 480(HANDLEP), KLEN
+	movdqu (IVP), STATE
+
+.align 4
+.Lcbc_enc1:
+	movdqu (INP), IN
+	pxor IN, STATE
+
+	cmp $16, KLEN
+	je .Lcbc_enc1_128
+	aesenc256kl (HANDLEP), STATE
+	jz .Lcbc_enc_err
+	jmp .Lcbc_enc1_end
+.Lcbc_enc1_128:
+	aesenc128kl (HANDLEP), STATE
+	jz .Lcbc_enc_err
+
+.Lcbc_enc1_end:
+	movdqu STATE, (OUTP)
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lcbc_enc1
+	movdqu STATE, (IVP)
+
+.Lcbc_enc_noerr:
+	xor AREG, AREG
+	jmp .Lcbc_enc_end
+.Lcbc_enc_err:
+	mov $1, AREG
+.Lcbc_enc_end:
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+	popl LEN
+	popl IVP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(_aeskl_cbc_enc)
+
+/*
+ * int _aeskl_cbc_dec(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
+ *		      size_t len, u8 *iv)
+ */
+SYM_FUNC_START(_aeskl_cbc_dec)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl IVP
+	pushl LEN
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+20)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+24)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+28)(%esp), INP	# src
+	movl (FRAME_OFFSET+32)(%esp), LEN	# len
+	movl (FRAME_OFFSET+36)(%esp), IVP	# iv
+#endif
+
+	cmp $16, LEN
+	jb .Lcbc_dec_noerr
+	mov 480(HANDLEP), KLEN
+#ifdef __x86_64__
+	cmp $128, LEN
+	jb .Lcbc_dec1_pre
+
+.align 4
+.Lcbc_dec8:
+	movdqu 0x0(INP), STATE1
+	movdqu 0x10(INP), STATE2
+	movdqu 0x20(INP), STATE3
+	movdqu 0x30(INP), STATE4
+	movdqu 0x40(INP), STATE5
+	movdqu 0x50(INP), STATE6
+	movdqu 0x60(INP), STATE7
+	movdqu 0x70(INP), STATE8
+
+	movdqu (IVP), IN1
+	movdqa STATE1, IN2
+	movdqa STATE2, IN3
+	movdqa STATE3, IN4
+	movdqa STATE4, IN5
+	movdqa STATE5, IN6
+	movdqa STATE6, IN7
+	movdqa STATE7, IN8
+	movdqu STATE8, (IVP)
+
+	cmp $16, KLEN
+	je .Lcbc_dec8_128
+	aesdecwide256kl (HANDLEP)
+	jz .Lcbc_dec_err
+	jmp .Lcbc_dec8_end
+.Lcbc_dec8_128:
+	aesdecwide128kl (HANDLEP)
+	jz .Lcbc_dec_err
+
+.Lcbc_dec8_end:
+	pxor IN1, STATE1
+	pxor IN2, STATE2
+	pxor IN3, STATE3
+	pxor IN4, STATE4
+	pxor IN5, STATE5
+	pxor IN6, STATE6
+	pxor IN7, STATE7
+	pxor IN8, STATE8
+
+	movdqu STATE1, 0x0(OUTP)
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
+	jge .Lcbc_dec8
+	cmp $16, LEN
+	jb .Lcbc_dec_noerr
+#endif
+
+.align 4
+.Lcbc_dec1_pre:
+	movdqu (IVP), STATE3
+.Lcbc_dec1:
+	movdqu (INP), STATE2
+	movdqa STATE2, STATE1
+
+	cmp $16, KLEN
+	je .Lcbc_dec1_128
+	aesdec256kl (HANDLEP), STATE1
+	jz .Lcbc_dec_err
+	jmp .Lcbc_dec1_end
+.Lcbc_dec1_128:
+	aesdec128kl (HANDLEP), STATE1
+	jz .Lcbc_dec_err
+
+.Lcbc_dec1_end:
+	pxor STATE3, STATE1
+	movdqu STATE1, (OUTP)
+	movdqa STATE2, STATE3
+	sub $16, LEN
+	add $16, INP
+	add $16, OUTP
+	cmp $16, LEN
+	jge .Lcbc_dec1
+	movdqu STATE3, (IVP)
+
+.Lcbc_dec_noerr:
+	xor AREG, AREG
+	jmp .Lcbc_dec_end
+.Lcbc_dec_err:
+	mov $1, AREG
+.Lcbc_dec_end:
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+	popl LEN
+	popl IVP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(_aeskl_cbc_dec)
+
diff --git a/arch/x86/crypto/aeskl-intel_glue.c b/arch/x86/crypto/aeskl-intel_glue.c
index 7c9794a0969d..742576ae0481 100644
--- a/arch/x86/crypto/aeskl-intel_glue.c
+++ b/arch/x86/crypto/aeskl-intel_glue.c
@@ -30,6 +30,11 @@ asmlinkage int _aeskl_dec(const void *ctx, u8 *out, const u8 *in);
 asmlinkage int _aeskl_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
 asmlinkage int _aeskl_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
 
+asmlinkage int _aeskl_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			      u8 *iv);
+asmlinkage int _aeskl_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			      u8 *iv);
+
 static int aeskl_setkey_common(struct crypto_tfm *tfm, void *raw_ctx, const u8 *in_key,
 			       unsigned int key_len)
 {
@@ -113,6 +118,32 @@ static int aeskl_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsi
 		return 0;
 }
 
+static int aeskl_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			 u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_cbc_enc(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int aeskl_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in, unsigned int len,
+			 u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_cbc_dec(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
 static int aeskl_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				 unsigned int len)
 {
@@ -142,6 +173,26 @@ static int ecb_decrypt(struct skcipher_request *req)
 		return ecb_crypt_common(req, aesni_ecb_dec);
 }
 
+static int cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return cbc_crypt_common(req, aeskl_cbc_enc);
+	else
+		return cbc_crypt_common(req, aesni_cbc_enc);
+}
+
+static int cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return cbc_crypt_common(req, aeskl_cbc_dec);
+	else
+		return cbc_crypt_common(req, aesni_cbc_dec);
+}
+
 static struct skcipher_alg aeskl_skciphers[] = {
 	{
 		.base = {
@@ -158,6 +209,22 @@ static struct skcipher_alg aeskl_skciphers[] = {
 		.setkey		= aeskl_skcipher_setkey,
 		.encrypt	= ecb_encrypt,
 		.decrypt	= ecb_decrypt,
+	}, {
+		.base = {
+			.cra_name		= "__cbc(aes)",
+			.cra_driver_name	= "__cbc-aes-aeskl",
+			.cra_priority		= 200,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= AES_MIN_KEY_SIZE,
+		.max_keysize	= AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= aeskl_skcipher_setkey,
+		.encrypt	= cbc_encrypt,
+		.decrypt	= cbc_decrypt,
 	}
 };
 
-- 
2.17.1

