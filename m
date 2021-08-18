Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D8CC4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 03:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D0460462
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 03:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbhHRDb4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 23:31:56 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54225 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234860AbhHRDbz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 23:31:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0Ujc8IsJ_1629257477;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Ujc8IsJ_1629257477)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Aug 2021 11:31:18 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH 1/2] crypto: x86/sm4 - export reusable AESNI/AVX functions
Date:   Wed, 18 Aug 2021 11:31:16 +0800
Message-Id: <20210818033117.91717-2-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20210818033117.91717-1-tianjia.zhang@linux.alibaba.com>
References: <20210818033117.91717-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Export the reusable functions in the SM4 AESNI/AVX implementation,
mainly public functions, which are used to develop the SM4 AESNI/AVX2
implementation, and eliminate unnecessary duplication of code.

At the same time, in order to make the public function universal,
minor fixes was added.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/x86/crypto/sm4-avx.h            | 24 ++++++++
 arch/x86/crypto/sm4_aesni_avx_glue.c | 92 ++++++++++++++++++----------
 2 files changed, 84 insertions(+), 32 deletions(-)
 create mode 100644 arch/x86/crypto/sm4-avx.h

diff --git a/arch/x86/crypto/sm4-avx.h b/arch/x86/crypto/sm4-avx.h
new file mode 100644
index 000000000000..1bceab7516aa
--- /dev/null
+++ b/arch/x86/crypto/sm4-avx.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef ASM_X86_SM4_AVX_H
+#define ASM_X86_SM4_AVX_H
+
+#include <linux/types.h>
+#include <crypto/sm4.h>
+
+typedef void (*sm4_crypt_func)(const u32 *rk, u8 *dst, const u8 *src, u8 *iv);
+
+int sm4_avx_ecb_encrypt(struct skcipher_request *req);
+int sm4_avx_ecb_decrypt(struct skcipher_request *req);
+
+int sm4_cbc_encrypt(struct skcipher_request *req);
+int sm4_avx_cbc_decrypt(struct skcipher_request *req,
+			unsigned int bsize, sm4_crypt_func func);
+
+int sm4_cfb_encrypt(struct skcipher_request *req);
+int sm4_avx_cfb_decrypt(struct skcipher_request *req,
+			unsigned int bsize, sm4_crypt_func func);
+
+int sm4_avx_ctr_crypt(struct skcipher_request *req,
+			unsigned int bsize, sm4_crypt_func func);
+
+#endif
diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
index c1f5728efd1d..7800f77d68ad 100644
--- a/arch/x86/crypto/sm4_aesni_avx_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -15,6 +15,7 @@
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/sm4.h>
+#include "sm4-avx.h"
 
 #define SM4_CRYPT8_BLOCK_SIZE	(SM4_BLOCK_SIZE * 8)
 
@@ -71,23 +72,25 @@ static int ecb_do_crypt(struct skcipher_request *req, const u32 *rkey)
 	return err;
 }
 
-static int ecb_encrypt(struct skcipher_request *req)
+int sm4_avx_ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return ecb_do_crypt(req, ctx->rkey_enc);
 }
+EXPORT_SYMBOL_GPL(sm4_avx_ecb_encrypt);
 
-static int ecb_decrypt(struct skcipher_request *req)
+int sm4_avx_ecb_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return ecb_do_crypt(req, ctx->rkey_dec);
 }
+EXPORT_SYMBOL_GPL(sm4_avx_ecb_decrypt);
 
-static int cbc_encrypt(struct skcipher_request *req)
+int sm4_cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -118,8 +121,10 @@ static int cbc_encrypt(struct skcipher_request *req)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(sm4_cbc_encrypt);
 
-static int cbc_decrypt(struct skcipher_request *req)
+int sm4_avx_cbc_decrypt(struct skcipher_request *req,
+			unsigned int bsize, sm4_crypt_func func)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -135,15 +140,14 @@ static int cbc_decrypt(struct skcipher_request *req)
 
 		kernel_fpu_begin();
 
-		while (nbytes >= SM4_CRYPT8_BLOCK_SIZE) {
-			sm4_aesni_avx_cbc_dec_blk8(ctx->rkey_dec, dst,
-						src, walk.iv);
-			dst += SM4_CRYPT8_BLOCK_SIZE;
-			src += SM4_CRYPT8_BLOCK_SIZE;
-			nbytes -= SM4_CRYPT8_BLOCK_SIZE;
+		while (nbytes >= bsize) {
+			func(ctx->rkey_dec, dst, src, walk.iv);
+			dst += bsize;
+			src += bsize;
+			nbytes -= bsize;
 		}
 
-		if (nbytes >= SM4_BLOCK_SIZE) {
+		while (nbytes >= SM4_BLOCK_SIZE) {
 			u8 keystream[SM4_BLOCK_SIZE * 8];
 			u8 iv[SM4_BLOCK_SIZE];
 			unsigned int nblocks = min(nbytes >> 4, 8u);
@@ -165,6 +169,8 @@ static int cbc_decrypt(struct skcipher_request *req)
 			}
 			crypto_xor_cpy(dst, walk.iv, keystream, SM4_BLOCK_SIZE);
 			memcpy(walk.iv, iv, SM4_BLOCK_SIZE);
+			dst += nblocks * SM4_BLOCK_SIZE;
+			src += (nblocks + 1) * SM4_BLOCK_SIZE;
 			nbytes -= nblocks * SM4_BLOCK_SIZE;
 		}
 
@@ -174,8 +180,15 @@ static int cbc_decrypt(struct skcipher_request *req)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(sm4_avx_cbc_decrypt);
+
+static int cbc_decrypt(struct skcipher_request *req)
+{
+	return sm4_avx_cbc_decrypt(req, SM4_CRYPT8_BLOCK_SIZE,
+				sm4_aesni_avx_cbc_dec_blk8);
+}
 
-static int cfb_encrypt(struct skcipher_request *req)
+int sm4_cfb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -214,8 +227,10 @@ static int cfb_encrypt(struct skcipher_request *req)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(sm4_cfb_encrypt);
 
-static int cfb_decrypt(struct skcipher_request *req)
+int sm4_avx_cfb_decrypt(struct skcipher_request *req,
+			unsigned int bsize, sm4_crypt_func func)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -231,15 +246,14 @@ static int cfb_decrypt(struct skcipher_request *req)
 
 		kernel_fpu_begin();
 
-		while (nbytes >= SM4_CRYPT8_BLOCK_SIZE) {
-			sm4_aesni_avx_cfb_dec_blk8(ctx->rkey_enc, dst,
-						src, walk.iv);
-			dst += SM4_CRYPT8_BLOCK_SIZE;
-			src += SM4_CRYPT8_BLOCK_SIZE;
-			nbytes -= SM4_CRYPT8_BLOCK_SIZE;
+		while (nbytes >= bsize) {
+			func(ctx->rkey_enc, dst, src, walk.iv);
+			dst += bsize;
+			src += bsize;
+			nbytes -= bsize;
 		}
 
-		if (nbytes >= SM4_BLOCK_SIZE) {
+		while (nbytes >= SM4_BLOCK_SIZE) {
 			u8 keystream[SM4_BLOCK_SIZE * 8];
 			unsigned int nblocks = min(nbytes >> 4, 8u);
 
@@ -276,8 +290,16 @@ static int cfb_decrypt(struct skcipher_request *req)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(sm4_avx_cfb_decrypt);
 
-static int ctr_crypt(struct skcipher_request *req)
+static int cfb_decrypt(struct skcipher_request *req)
+{
+	return sm4_avx_cfb_decrypt(req, SM4_CRYPT8_BLOCK_SIZE,
+				sm4_aesni_avx_cfb_dec_blk8);
+}
+
+int sm4_avx_ctr_crypt(struct skcipher_request *req,
+			unsigned int bsize, sm4_crypt_func func)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -293,15 +315,14 @@ static int ctr_crypt(struct skcipher_request *req)
 
 		kernel_fpu_begin();
 
-		while (nbytes >= SM4_CRYPT8_BLOCK_SIZE) {
-			sm4_aesni_avx_ctr_enc_blk8(ctx->rkey_enc, dst,
-						src, walk.iv);
-			dst += SM4_CRYPT8_BLOCK_SIZE;
-			src += SM4_CRYPT8_BLOCK_SIZE;
-			nbytes -= SM4_CRYPT8_BLOCK_SIZE;
+		while (nbytes >= bsize) {
+			func(ctx->rkey_enc, dst, src, walk.iv);
+			dst += bsize;
+			src += bsize;
+			nbytes -= bsize;
 		}
 
-		if (nbytes >= SM4_BLOCK_SIZE) {
+		while (nbytes >= SM4_BLOCK_SIZE) {
 			u8 keystream[SM4_BLOCK_SIZE * 8];
 			unsigned int nblocks = min(nbytes >> 4, 8u);
 			int i;
@@ -343,6 +364,13 @@ static int ctr_crypt(struct skcipher_request *req)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(sm4_avx_ctr_crypt);
+
+static int ctr_crypt(struct skcipher_request *req)
+{
+	return sm4_avx_ctr_crypt(req, SM4_CRYPT8_BLOCK_SIZE,
+				sm4_aesni_avx_ctr_enc_blk8);
+}
 
 static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 	{
@@ -359,8 +387,8 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 		.max_keysize	= SM4_KEY_SIZE,
 		.walksize	= 8 * SM4_BLOCK_SIZE,
 		.setkey		= sm4_skcipher_setkey,
-		.encrypt	= ecb_encrypt,
-		.decrypt	= ecb_decrypt,
+		.encrypt	= sm4_avx_ecb_encrypt,
+		.decrypt	= sm4_avx_ecb_decrypt,
 	}, {
 		.base = {
 			.cra_name		= "__cbc(sm4)",
@@ -376,7 +404,7 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 		.ivsize		= SM4_BLOCK_SIZE,
 		.walksize	= 8 * SM4_BLOCK_SIZE,
 		.setkey		= sm4_skcipher_setkey,
-		.encrypt	= cbc_encrypt,
+		.encrypt	= sm4_cbc_encrypt,
 		.decrypt	= cbc_decrypt,
 	}, {
 		.base = {
@@ -394,7 +422,7 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 		.chunksize	= SM4_BLOCK_SIZE,
 		.walksize	= 8 * SM4_BLOCK_SIZE,
 		.setkey		= sm4_skcipher_setkey,
-		.encrypt	= cfb_encrypt,
+		.encrypt	= sm4_cfb_encrypt,
 		.decrypt	= cfb_decrypt,
 	}, {
 		.base = {
-- 
2.19.1.3.ge56e4f7

