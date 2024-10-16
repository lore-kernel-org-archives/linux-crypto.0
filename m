Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4F413B584
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729105059; cv=none; b=deERFkwLVkK/zQukD1of85ajlI8W7z7lEBvDv1v+Hie90bdH598yEvOZppdztjBKLyL+N1+eDzaj84QtLzOsRNlai5jlUVoXOJV3CFTxHrbYLheuqdRYEzEPXrzgwuf/ULb5HOv4Shjg9qltzxEIGjaEJHQhCFDjEaWnetEwrcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729105059; c=relaxed/simple;
	bh=oiYqhyCfNECla3wo9T4rZ8hxjeau48ECJntlFO1/ndM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BBQC+k9V99D5KWth6WRDtagl95arohds210ZqsI7U5mR5C91eeMW3Mb1U9aThzCnbqZkhaQETdK3tW86xc3qP+EkGi5VXN8ydC3ljF65UOrB+xFMdSaroomztHn2j4H95CkPT1rmuaKBkCSwvCC25v4HuEpfBywc8VMzE0HnGOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bZOZ4M0F; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bZOZ4M0F"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43052e05c8fso883065e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 11:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729105056; x=1729709856; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sW0yUROZlsJZ4dADY7tJnMCIVMxWZRtZU3IyrdoI2OE=;
        b=bZOZ4M0FXtQd7npqAlVJL/M9dgzQGmsAxB7NNmn3p2amlY74Flp/kNdOP+gXqyO28O
         423ufuJPh7CJJ2cKqw5fFb8XwRg9AAuIW9UoRbQNOrAy7h2uYOb2fOhS8Mbwfzze1UxA
         ikRbYuSDBNbQilnHimgpwWsoskWfLk42jUxMlcApJtzaeE22y6CfX2cAsyGgp1lEvNx4
         Kh+jHuMoTdl/Ur8mTKypSWOQtGwbBh6TLLgTvhCIcgvwvavFwmq9REBU/WUN3u6FlTA6
         OynwIUdWTpLLsDNEPFe6XEnC9ztkPlTpdcFYCm+RSYTGOGtobxPnuRlPh0STiHJ7hfUV
         6zzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729105056; x=1729709856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sW0yUROZlsJZ4dADY7tJnMCIVMxWZRtZU3IyrdoI2OE=;
        b=PCy3XovP3IHs7defN1nAjBc2wM+LcsatvMRd/M3twCvP6ln3mdtHRH7vsUkiupvZ8T
         wSULVdT3owc8Vxn2kluENl+qTqhrfjT8tEwBJ+fblUrTCqqHaDPI8bhqvbnK8RIAIP9U
         blpSFrCn0bAMywLS7iRohVtUvx2NLrlofUUIykDV4JVnnFvV6zS3mub0HrjzOtZ8VrnR
         yu6VC87zxFlqvwYY1cL5ep68o9b+TgBhYdMWhCL4GvrSo2FWnigiEf1lw5BsSj+OkJcp
         DJEOL4OuSiWM822o6YbSd72k6rsN30+SOgCoes/I4QrelmPSIvqHJ4JM9ZKrPd4CsUv4
         yKug==
X-Gm-Message-State: AOJu0YxMZy3egBopl3Ke4gwvSkm2Tmjda3z5s9ZHzoHchtMSn1EzzKFw
	ix5SVcwCRtbCC36ZN7alCnNDghNkADkWdrJqzyDwg62FtbE4gfSvEYfVWj4rfaVnzZoNg53iXfk
	9xhjSI/3DY0X2twbBQEIYeyjGtXdxJavCDZZtss4pqj5f0kAj+5et2BYQHrhNJbBIDtki92w8f+
	yTThFwCFiKfz2YZowZGJM8P//gpzc97Q==
X-Google-Smtp-Source: AGHT+IHbPH9ZhxNB41hYvP/zgSkn4DEq/Za2fAtq7wzoFAiYRlPY9DYh6RhBOCa3jtH+AK5MgCM9uMzk
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:600c:58c2:b0:431:47fc:92ab with SMTP id
 5b1f17b1804b1-4314a28b3b5mr157565e9.1.1729105055189; Wed, 16 Oct 2024
 11:57:35 -0700 (PDT)
Date: Wed, 16 Oct 2024 20:57:25 +0200
In-Reply-To: <20241016185722.400643-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241016185722.400643-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6363; i=ardb@kernel.org;
 h=from:subject; bh=iBkYwANksR6w5fMRKLkgmxoRXPxogHfDye8V4SpkJng=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV2AZ2rffD+Z+/f7InwDyu4XV61ab1OvwRP9b8ekucsbp
 TKVX93rKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABO5o8LIsNY4We0R22PX2RtP
 MXP9yFlqLad++KGNmWO21HTmo8oaHAz/lN++Xyj9vGf1JoX79VO+MepkXKp7LT3n+Ob6+40xef1 yLAA=
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241016185722.400643-6-ardb+git@google.com>
Subject: [PATCH v2 2/2] crypto/crc32c: Provide crc32c-arch driver for
 accelerated library code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

crc32c-generic is currently backed by the architecture's CRC-32c library
code, which may offer a variety of implementations depending on the
capabilities of the platform. These are not covered by the crypto
subsystem's fuzz testing capabilities because crc32c-generic is the
reference driver that the fuzzing logic uses as a source of truth.

Fix this by providing a crc32c-arch implementation which is based on the
arch library code if available, and modify crc32c-generic so it is
always based on the generic C implementation. If the arch has no CRC-32c
library code, this change does nothing.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Makefile         |  1 +
 crypto/crc32c_generic.c | 94 +++++++++++++++-----
 lib/crc32.c             |  2 +
 3 files changed, 75 insertions(+), 22 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 2d4a3c0659fa..a1ce3fa5298d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -152,6 +152,7 @@ obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
+CFLAGS_crc32c_generic.o += -DARCH=$(ARCH)
 CFLAGS_crc32_generic.o += -DARCH=$(ARCH)
 obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
 obj-$(CONFIG_CRYPTO_CRC64_ROCKSOFT) += crc64_rocksoft_generic.o
diff --git a/crypto/crc32c_generic.c b/crypto/crc32c_generic.c
index a8c90b3f4c6c..7c2357c30fdf 100644
--- a/crypto/crc32c_generic.c
+++ b/crypto/crc32c_generic.c
@@ -85,6 +85,15 @@ static int chksum_update(struct shash_desc *desc, const u8 *data,
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
+	ctx->crc = __crc32c_le_base(ctx->crc, data, length);
+	return 0;
+}
+
+static int chksum_update_arch(struct shash_desc *desc, const u8 *data,
+			      unsigned int length)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
 	ctx->crc = __crc32c_le(ctx->crc, data, length);
 	return 0;
 }
@@ -98,6 +107,13 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
 }
 
 static int __chksum_finup(u32 *crcp, const u8 *data, unsigned int len, u8 *out)
+{
+	put_unaligned_le32(~__crc32c_le_base(*crcp, data, len), out);
+	return 0;
+}
+
+static int __chksum_finup_arch(u32 *crcp, const u8 *data, unsigned int len,
+			       u8 *out)
 {
 	put_unaligned_le32(~__crc32c_le(*crcp, data, len), out);
 	return 0;
@@ -111,6 +127,14 @@ static int chksum_finup(struct shash_desc *desc, const u8 *data,
 	return __chksum_finup(&ctx->crc, data, len, out);
 }
 
+static int chksum_finup_arch(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	return __chksum_finup_arch(&ctx->crc, data, len, out);
+}
+
 static int chksum_digest(struct shash_desc *desc, const u8 *data,
 			 unsigned int length, u8 *out)
 {
@@ -119,6 +143,14 @@ static int chksum_digest(struct shash_desc *desc, const u8 *data,
 	return __chksum_finup(&mctx->key, data, length, out);
 }
 
+static int chksum_digest_arch(struct shash_desc *desc, const u8 *data,
+			      unsigned int length, u8 *out)
+{
+	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
+
+	return __chksum_finup_arch(&mctx->key, data, length, out);
+}
+
 static int crc32c_cra_init(struct crypto_tfm *tfm)
 {
 	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
@@ -127,35 +159,53 @@ static int crc32c_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static struct shash_alg alg = {
-	.digestsize		=	CHKSUM_DIGEST_SIZE,
-	.setkey			=	chksum_setkey,
-	.init		=	chksum_init,
-	.update		=	chksum_update,
-	.final		=	chksum_final,
-	.finup		=	chksum_finup,
-	.digest		=	chksum_digest,
-	.descsize		=	sizeof(struct chksum_desc_ctx),
-	.base			=	{
-		.cra_name		=	"crc32c",
-		.cra_driver_name	=	"crc32c-generic",
-		.cra_priority		=	100,
-		.cra_flags		=	CRYPTO_ALG_OPTIONAL_KEY,
-		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
-		.cra_ctxsize		=	sizeof(struct chksum_ctx),
-		.cra_module		=	THIS_MODULE,
-		.cra_init		=	crc32c_cra_init,
-	}
-};
+static struct shash_alg algs[] = {{
+	.digestsize		= CHKSUM_DIGEST_SIZE,
+	.setkey			= chksum_setkey,
+	.init			= chksum_init,
+	.update			= chksum_update,
+	.final			= chksum_final,
+	.finup			= chksum_finup,
+	.digest			= chksum_digest,
+	.descsize		= sizeof(struct chksum_desc_ctx),
+
+	.base.cra_name		= "crc32c",
+	.base.cra_driver_name	= "crc32c-generic",
+	.base.cra_priority	= 100,
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct chksum_ctx),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_init		= crc32c_cra_init,
+}, {
+	.digestsize		= CHKSUM_DIGEST_SIZE,
+	.setkey			= chksum_setkey,
+	.init			= chksum_init,
+	.update			= chksum_update_arch,
+	.final			= chksum_final,
+	.finup			= chksum_finup_arch,
+	.digest			= chksum_digest_arch,
+	.descsize		= sizeof(struct chksum_desc_ctx),
+
+	.base.cra_name		= "crc32c",
+	.base.cra_driver_name	= "crc32c-" __stringify(ARCH),
+	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct chksum_ctx),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_init		= crc32c_cra_init,
+}};
 
 static int __init crc32c_mod_init(void)
 {
-	return crypto_register_shash(&alg);
+	/* register the arch flavor only if it differs from the generic one */
+	return crypto_register_shashes(algs, 1 + (&__crc32c_le != &__crc32c_le_base));
 }
 
 static void __exit crc32c_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crypto_unregister_shashes(algs, 1 + (&__crc32c_le != &__crc32c_le_base));
 }
 
 subsys_initcall(crc32c_mod_init);
diff --git a/lib/crc32.c b/lib/crc32.c
index a54ba87b7073..ff587fee3893 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -208,6 +208,8 @@ u32 __pure crc32_le_base(u32, unsigned char const *, size_t) __alias(crc32_le);
 EXPORT_SYMBOL(crc32_le_base);
 
 u32 __pure __crc32c_le_base(u32, unsigned char const *, size_t) __alias(__crc32c_le);
+EXPORT_SYMBOL(__crc32c_le_base);
+
 u32 __pure crc32_be_base(u32, unsigned char const *, size_t) __alias(crc32_be);
 
 /*
-- 
2.47.0.rc1.288.g06298d1525-goog

