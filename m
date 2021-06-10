Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9381C48BD1
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 13:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B5BD61404
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 13:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFJNrF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 09:47:05 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:50336 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhFJNrF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 09:47:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UbzGBj3_1623332701;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UbzGBj3_1623332701)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 21:45:01 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH 2/3] crypto: arm64/sm4-ce - Make dependent on sm4 library instead of sm4-generic
Date:   Thu, 10 Jun 2021 21:44:58 +0800
Message-Id: <20210610134459.28541-3-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
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
 arch/arm64/crypto/sm4-ce-glue.c | 14 +++++++++++---
 crypto/sm4_generic.c            | 15 ++++++---------
 include/crypto/sm4.h            |  5 -----
 4 files changed, 18 insertions(+), 18 deletions(-)

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
index 2754c875d39c..ba2261ec54d5 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -17,12 +17,20 @@ MODULE_LICENSE("GPL v2");
 
 asmlinkage void sm4_ce_do_crypt(const u32 *rk, void *out, const void *in);
 
+int sm4_ce_setkey(struct crypto_tfm *tfm, const u8 *in_key,
+		       unsigned int key_len)
+{
+	struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return crypto_sm4_expand_key(ctx, in_key, key_len);
+}
+
 static void sm4_ce_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (!crypto_simd_usable()) {
-		crypto_sm4_encrypt(tfm, out, in);
+		crypto_sm4_do_crypt(ctx->rkey_enc, out, in);
 	} else {
 		kernel_neon_begin();
 		sm4_ce_do_crypt(ctx->rkey_enc, out, in);
@@ -35,7 +43,7 @@ static void sm4_ce_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (!crypto_simd_usable()) {
-		crypto_sm4_decrypt(tfm, out, in);
+		crypto_sm4_do_crypt(ctx->rkey_dec, out, in);
 	} else {
 		kernel_neon_begin();
 		sm4_ce_do_crypt(ctx->rkey_dec, out, in);
@@ -54,7 +62,7 @@ static struct crypto_alg sm4_ce_alg = {
 	.cra_u.cipher = {
 		.cia_min_keysize	= SM4_KEY_SIZE,
 		.cia_max_keysize	= SM4_KEY_SIZE,
-		.cia_setkey		= crypto_sm4_set_key,
+		.cia_setkey		= sm4_ce_setkey,
 		.cia_encrypt		= sm4_ce_encrypt,
 		.cia_decrypt		= sm4_ce_decrypt
 	}
diff --git a/crypto/sm4_generic.c b/crypto/sm4_generic.c
index 7d1c25244268..c06856110126 100644
--- a/crypto/sm4_generic.c
+++ b/crypto/sm4_generic.c
@@ -28,34 +28,31 @@
  *
  * Return: 0 on success; -EINVAL on failure (only happens for bad key lengths)
  */
-int crypto_sm4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+static int sm4_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 		       unsigned int key_len)
 {
 	struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	return crypto_sm4_expand_key(ctx, in_key, key_len);
 }
-EXPORT_SYMBOL_GPL(crypto_sm4_set_key);
 
 /* encrypt a block of text */
 
-void crypto_sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	crypto_sm4_do_crypt(ctx->rkey_enc, out, in);
 }
-EXPORT_SYMBOL_GPL(crypto_sm4_encrypt);
 
 /* decrypt a block of text */
 
-void crypto_sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	crypto_sm4_do_crypt(ctx->rkey_dec, out, in);
 }
-EXPORT_SYMBOL_GPL(crypto_sm4_decrypt);
 
 static struct crypto_alg sm4_alg = {
 	.cra_name		=	"sm4",
@@ -69,9 +66,9 @@ static struct crypto_alg sm4_alg = {
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
index 39273121c145..73c15179e4c6 100644
--- a/include/crypto/sm4.h
+++ b/include/crypto/sm4.h
@@ -45,9 +45,4 @@ int crypto_sm4_expand_key(struct crypto_sm4_ctx *ctx, const u8 *in_key,
  */
 void crypto_sm4_do_crypt(const u32 *rk, u8 *out, const u8 *in);
 
-int crypto_sm4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		       unsigned int key_len);
-void crypto_sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in);
-void crypto_sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in);
-
 #endif
-- 
2.19.1.3.ge56e4f7

