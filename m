Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE1CC07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 03:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5CAE610A0
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 03:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347782AbhGTDGz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 23:06:55 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:44428 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348040AbhGTDGJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 23:06:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UgNuUUj_1626752803;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UgNuUUj_1626752803)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 11:46:44 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v3 2/4] crypto: arm64/sm4-ce - Make dependent on sm4 library instead of sm4-generic
Date:   Tue, 20 Jul 2021 11:46:40 +0800
Message-Id: <20210720034642.19230-3-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20210720034642.19230-1-tianjia.zhang@linux.alibaba.com>
References: <20210720034642.19230-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SM4 library is abstracted from sm4-generic algorithm, sm4-ce can depend on
the SM4 library instead of sm4-generic, and some functions in sm4-generic
do not need to be exported.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/arm64/crypto/Kconfig       |  2 +-
 arch/arm64/crypto/sm4-ce-glue.c | 20 ++++++++++++++------
 crypto/sm4_generic.c            | 27 ++++++++++++---------------
 include/crypto/sm4.h            |  9 ++-------
 lib/crypto/sm4.c                |  2 +-
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index b8eb0453123d..55f19450091b 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -51,7 +51,7 @@ config CRYPTO_SM4_ARM64_CE
 	tristate "SM4 symmetric cipher (ARMv8.2 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
-	select CRYPTO_SM4
+	select CRYPTO_LIB_SM4
 
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH/AES-GCM using ARMv8 Crypto Extensions"
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index 2754c875d39c..9c93cfc4841b 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -17,12 +17,20 @@ MODULE_LICENSE("GPL v2");
 
 asmlinkage void sm4_ce_do_crypt(const u32 *rk, void *out, const void *in);
 
+static int sm4_ce_setkey(struct crypto_tfm *tfm, const u8 *key,
+		       unsigned int key_len)
+{
+	struct sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return sm4_expandkey(ctx, key, key_len);
+}
+
 static void sm4_ce_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (!crypto_simd_usable()) {
-		crypto_sm4_encrypt(tfm, out, in);
+		sm4_crypt_block(ctx->rkey_enc, out, in);
 	} else {
 		kernel_neon_begin();
 		sm4_ce_do_crypt(ctx->rkey_enc, out, in);
@@ -32,10 +40,10 @@ static void sm4_ce_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 
 static void sm4_ce_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (!crypto_simd_usable()) {
-		crypto_sm4_decrypt(tfm, out, in);
+		sm4_crypt_block(ctx->rkey_dec, out, in);
 	} else {
 		kernel_neon_begin();
 		sm4_ce_do_crypt(ctx->rkey_dec, out, in);
@@ -49,12 +57,12 @@ static struct crypto_alg sm4_ce_alg = {
 	.cra_priority			= 200,
 	.cra_flags			= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize			= SM4_BLOCK_SIZE,
-	.cra_ctxsize			= sizeof(struct crypto_sm4_ctx),
+	.cra_ctxsize			= sizeof(struct sm4_ctx),
 	.cra_module			= THIS_MODULE,
 	.cra_u.cipher = {
 		.cia_min_keysize	= SM4_KEY_SIZE,
 		.cia_max_keysize	= SM4_KEY_SIZE,
-		.cia_setkey		= crypto_sm4_set_key,
+		.cia_setkey		= sm4_ce_setkey,
 		.cia_encrypt		= sm4_ce_encrypt,
 		.cia_decrypt		= sm4_ce_decrypt
 	}
diff --git a/crypto/sm4_generic.c b/crypto/sm4_generic.c
index d19d01f852a9..4a6480a27fee 100644
--- a/crypto/sm4_generic.c
+++ b/crypto/sm4_generic.c
@@ -17,45 +17,42 @@
 #include <asm/unaligned.h>
 
 /**
- * crypto_sm4_set_key - Set the SM4 key.
+ * sm4_setkey - Set the SM4 key.
  * @tfm:	The %crypto_tfm that is used in the context.
  * @in_key:	The input key.
  * @key_len:	The size of the key.
  *
  * This function uses sm4_expandkey() to expand the key.
- * &crypto_sm4_ctx _must_ be the private data embedded in @tfm which is
+ * &sm4_ctx _must_ be the private data embedded in @tfm which is
  * retrieved with crypto_tfm_ctx().
  *
  * Return: 0 on success; -EINVAL on failure (only happens for bad key lengths)
  */
-int crypto_sm4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+static int sm4_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 		       unsigned int key_len)
 {
-	struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	return sm4_expandkey(ctx, in_key, key_len);
 }
-EXPORT_SYMBOL_GPL(crypto_sm4_set_key);
 
 /* encrypt a block of text */
 
-void crypto_sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	sm4_crypt_block(ctx->rkey_enc, out, in);
 }
-EXPORT_SYMBOL_GPL(crypto_sm4_encrypt);
 
 /* decrypt a block of text */
 
-void crypto_sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	sm4_crypt_block(ctx->rkey_dec, out, in);
 }
-EXPORT_SYMBOL_GPL(crypto_sm4_decrypt);
 
 static struct crypto_alg sm4_alg = {
 	.cra_name		=	"sm4",
@@ -63,15 +60,15 @@ static struct crypto_alg sm4_alg = {
 	.cra_priority		=	100,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	SM4_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypto_sm4_ctx),
+	.cra_ctxsize		=	sizeof(struct sm4_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	SM4_KEY_SIZE,
 			.cia_max_keysize	=	SM4_KEY_SIZE,
-			.cia_setkey		=	crypto_sm4_set_key,
-			.cia_encrypt		=	crypto_sm4_encrypt,
-			.cia_decrypt		=	crypto_sm4_decrypt
+			.cia_setkey		=	sm4_setkey,
+			.cia_encrypt		=	sm4_encrypt,
+			.cia_decrypt		=	sm4_decrypt
 		}
 	}
 };
diff --git a/include/crypto/sm4.h b/include/crypto/sm4.h
index 06322325f862..709f286e7b25 100644
--- a/include/crypto/sm4.h
+++ b/include/crypto/sm4.h
@@ -16,7 +16,7 @@
 #define SM4_BLOCK_SIZE	16
 #define SM4_RKEY_WORDS	32
 
-struct crypto_sm4_ctx {
+struct sm4_ctx {
 	u32 rkey_enc[SM4_RKEY_WORDS];
 	u32 rkey_dec[SM4_RKEY_WORDS];
 };
@@ -30,7 +30,7 @@ struct crypto_sm4_ctx {
  * Returns 0 on success. The function fails only if an invalid key size (or
  * pointer) is supplied.
  */
-int sm4_expandkey(struct crypto_sm4_ctx *ctx, const u8 *in_key,
+int sm4_expandkey(struct sm4_ctx *ctx, const u8 *in_key,
 			  unsigned int key_len);
 
 /**
@@ -41,9 +41,4 @@ int sm4_expandkey(struct crypto_sm4_ctx *ctx, const u8 *in_key,
  */
 void sm4_crypt_block(const u32 *rk, u8 *out, const u8 *in);
 
-int crypto_sm4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		       unsigned int key_len);
-void crypto_sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in);
-void crypto_sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in);
-
 #endif
diff --git a/lib/crypto/sm4.c b/lib/crypto/sm4.c
index 5fbf8c741a2f..633b59fed9db 100644
--- a/lib/crypto/sm4.c
+++ b/lib/crypto/sm4.c
@@ -108,7 +108,7 @@ static inline u32 sm4_round(u32 x0, u32 x1, u32 x2, u32 x3, u32 rk)
  * Returns 0 on success. The function fails only if an invalid key size (or
  * pointer) is supplied.
  */
-int sm4_expandkey(struct crypto_sm4_ctx *ctx, const u8 *in_key,
+int sm4_expandkey(struct sm4_ctx *ctx, const u8 *in_key,
 			  unsigned int key_len)
 {
 	u32 rk[4];
-- 
2.19.1.3.ge56e4f7

