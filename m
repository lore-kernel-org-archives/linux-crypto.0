Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0AC18C348
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729105055; cv=none; b=q+mDP7dtbzc84qIIdAO1J2jH5P2uPuWjnekOHH2FWkALyVIzqX1d7+xfSFoHdQxtyJUU6LhLrSr8jlhPwEPDxxK72F/XFoejwNf03GBMEwocsZhvE4aTLXrQVgk46GZv/6w68UpvV4jiAvr44ofZoTuijRw3dZ95kn5JNY1E7zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729105055; c=relaxed/simple;
	bh=IG+SRmTH4G08TNshqZJihJneVr6+/bPkCI2f/y52GcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RaKo1Eliw6giSA7xTeK4UtVnT5HAL23EXR+V4XAJw3K3JQIStcwKg2PaLPvlLXAO0AcW5Y0lv503rBN9lyM+1pcc2JbfyEwDQwRAqy2CSf/e6tTXQ4bIp7av4Fqy5jbVXvKnHFra+vG1QMPiYFiPnFIBJ5ZttkG/BXSVWhy2/DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qk9kjLHm; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qk9kjLHm"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2946a143efso214831276.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 11:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729105053; x=1729709853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gYtRV230Y1defH04O9/zFGKqHUP2iTynKVw1Uy+NKaQ=;
        b=qk9kjLHm+Z6B41NfwfMMvSRwJ6vD+fXSGiRLPsEJoPCF0WQkItHver2Nm1u6tKZ2sG
         VbwIUlSg/Oa6iRahkRyWx4xNpZ/2BlUEFu8Kut6Z49CKOAAoJ3lL5GN/rs0VbV26mLWq
         fWdznp6Byyi2gkJx+FZMipUJFVZmU4h3+rLWu2Z9aC8SBLw7mdqzWhvZhDlZuRvBCL7D
         IuYG3D++l9eCUAEnPY7ejIF4B/DMUMYJtuyYSv76vMmWwIs8L1LaebCJ5NYlg4uxAych
         WI4TBIBcAdOsVaq4taDlgNJqZba0ffySl4LHT5+X+EZ8SKM3Je7WdXo4Rjv13K1fiuRk
         WWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729105053; x=1729709853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gYtRV230Y1defH04O9/zFGKqHUP2iTynKVw1Uy+NKaQ=;
        b=LKucczhWU6XwEM2yFu2iB7LyCCkOf9z3thHts15lCVp0DPa8ky423rQsVnbxGenSLv
         OUbQpaADUjE0Flm8L0XiQMTF1caGqMQ0UZxMr3WgYf4xMS14nzb7NfAywx1eeuCn7S9r
         jDzRqRm2NK6lM5pfWIiBQmLSXlOlYpSB7GOzVHHepmcmaPHT0evu9B8PaoQFlkLiyGSH
         9LK0Wm9XTqo50svG+RoQlaJjw/6FfjTV6UQegDb0r0Yx/APnu4LGaWU/zvPUa1/6E6Uw
         ZPzckTbFzbvIDzcABrXHg9993Zskab4wx0RNwpBOo8o5aVdd5pwP3cIh5lgnlK6x6YyB
         ajrQ==
X-Gm-Message-State: AOJu0YxbqTe/Z83Ksps+l5y7uP28d17SJgZa45n+yA7bsSXEKHEAlSt7
	2RfKYMHy4JumqfW8efG3uRiLGK8fzHvZ+s1eCm1UoEbj6dHDhUT4bg8Ai9Qh3/JPiLCfm3rOQ7o
	yoN6BZb7Gg7Keqj91WLxpyzgsrNsPuP3JW7hyeKQGf/fCqJonciJ0ap636MPWx3jZlhdSnYFcOc
	CtPERchdfnFeG+nhfBZ6WQwGiGqGVhCw==
X-Google-Smtp-Source: AGHT+IFA0BqM7jxBGOut2JZFe4Lp/FiNFdXZmsjo3Ce3s6EQyp/0Gw61M84HdSCl2VvxXmOpppj9x17q
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a25:72c3:0:b0:e29:ad0:a326 with SMTP id
 3f1490d57ef6-e2b9ccc8449mr598276.0.1729105052676; Wed, 16 Oct 2024 11:57:32
 -0700 (PDT)
Date: Wed, 16 Oct 2024 20:57:24 +0200
In-Reply-To: <20241016185722.400643-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241016185722.400643-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6094; i=ardb@kernel.org;
 h=from:subject; bh=8Dbkch42Eeu11lfBnfNEmQ7+t8JvrDgiTEpZ05fPCXk=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV2AZ4rkwYj3D62/KhxyVfp/X/zDPX8pq7m3XKP3xOVVe
 cXtLVzaUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbSpcvI8Ozt5dVTTR7f6Kso
 nBY/T+wHX2Z553oDw0edq4NZHp+e7MjIcHwKA9tqDtnHDZdCOVJ/Ncnd8axzMcs77f64oena+Tv 8jAA=
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241016185722.400643-5-ardb+git@google.com>
Subject: [PATCH v2 1/2] crypto/crc32: Provide crc32-arch driver for
 accelerated library code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

crc32-generic is currently backed by the architecture's CRC-32 library
code, which may offer a variety of implementations depending on the
capabilities of the platform. These are not covered by the crypto
subsystem's fuzz testing capabilities because crc32-generic is the
reference driver that the fuzzing logic uses as a source of truth.

Fix this by providing a crc32-arch implementation which is based on the
arch library code if available, and modify crc32-generic so it is
always based on the generic C implementation. If the arch has no CRC-32
library code, this change does nothing.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Makefile        |  1 +
 crypto/crc32_generic.c | 94 +++++++++++++++-----
 lib/crc32.c            |  2 +
 3 files changed, 73 insertions(+), 24 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 4c99e5d376f6..2d4a3c0659fa 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -152,6 +152,7 @@ obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
+CFLAGS_crc32_generic.o += -DARCH=$(ARCH)
 obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
 obj-$(CONFIG_CRYPTO_CRC64_ROCKSOFT) += crc64_rocksoft_generic.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
diff --git a/crypto/crc32_generic.c b/crypto/crc32_generic.c
index d1251663ed66..6a55d206fab3 100644
--- a/crypto/crc32_generic.c
+++ b/crypto/crc32_generic.c
@@ -59,6 +59,15 @@ static int crc32_update(struct shash_desc *desc, const u8 *data,
 {
 	u32 *crcp = shash_desc_ctx(desc);
 
+	*crcp = crc32_le_base(*crcp, data, len);
+	return 0;
+}
+
+static int crc32_update_arch(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
+{
+	u32 *crcp = shash_desc_ctx(desc);
+
 	*crcp = crc32_le(*crcp, data, len);
 	return 0;
 }
@@ -66,6 +75,13 @@ static int crc32_update(struct shash_desc *desc, const u8 *data,
 /* No final XOR 0xFFFFFFFF, like crc32_le */
 static int __crc32_finup(u32 *crcp, const u8 *data, unsigned int len,
 			 u8 *out)
+{
+	put_unaligned_le32(crc32_le_base(*crcp, data, len), out);
+	return 0;
+}
+
+static int __crc32_finup_arch(u32 *crcp, const u8 *data, unsigned int len,
+			      u8 *out)
 {
 	put_unaligned_le32(crc32_le(*crcp, data, len), out);
 	return 0;
@@ -77,6 +93,12 @@ static int crc32_finup(struct shash_desc *desc, const u8 *data,
 	return __crc32_finup(shash_desc_ctx(desc), data, len, out);
 }
 
+static int crc32_finup_arch(struct shash_desc *desc, const u8 *data,
+		       unsigned int len, u8 *out)
+{
+	return __crc32_finup_arch(shash_desc_ctx(desc), data, len, out);
+}
+
 static int crc32_final(struct shash_desc *desc, u8 *out)
 {
 	u32 *crcp = shash_desc_ctx(desc);
@@ -88,38 +110,62 @@ static int crc32_final(struct shash_desc *desc, u8 *out)
 static int crc32_digest(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
-	return __crc32_finup(crypto_shash_ctx(desc->tfm), data, len,
-			     out);
+	return __crc32_finup(crypto_shash_ctx(desc->tfm), data, len, out);
 }
-static struct shash_alg alg = {
-	.setkey		= crc32_setkey,
-	.init		= crc32_init,
-	.update		= crc32_update,
-	.final		= crc32_final,
-	.finup		= crc32_finup,
-	.digest		= crc32_digest,
-	.descsize	= sizeof(u32),
-	.digestsize	= CHKSUM_DIGEST_SIZE,
-	.base		= {
-		.cra_name		= "crc32",
-		.cra_driver_name	= "crc32-generic",
-		.cra_priority		= 100,
-		.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.cra_blocksize		= CHKSUM_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(u32),
-		.cra_module		= THIS_MODULE,
-		.cra_init		= crc32_cra_init,
-	}
-};
+
+static int crc32_digest_arch(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *out)
+{
+	return __crc32_finup_arch(crypto_shash_ctx(desc->tfm), data, len, out);
+}
+
+static struct shash_alg algs[] = {{
+	.setkey			= crc32_setkey,
+	.init			= crc32_init,
+	.update			= crc32_update,
+	.final			= crc32_final,
+	.finup			= crc32_finup,
+	.digest			= crc32_digest,
+	.descsize		= sizeof(u32),
+	.digestsize		= CHKSUM_DIGEST_SIZE,
+
+	.base.cra_name		= "crc32",
+	.base.cra_driver_name	= "crc32-generic",
+	.base.cra_priority	= 100,
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(u32),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_init		= crc32_cra_init,
+}, {
+	.setkey			= crc32_setkey,
+	.init			= crc32_init,
+	.update			= crc32_update_arch,
+	.final			= crc32_final,
+	.finup			= crc32_finup_arch,
+	.digest			= crc32_digest_arch,
+	.descsize		= sizeof(u32),
+	.digestsize		= CHKSUM_DIGEST_SIZE,
+
+	.base.cra_name		= "crc32",
+	.base.cra_driver_name	= "crc32-" __stringify(ARCH),
+	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(u32),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_init		= crc32_cra_init,
+}};
 
 static int __init crc32_mod_init(void)
 {
-	return crypto_register_shash(&alg);
+	/* register the arch flavor only if it differs from the generic one */
+	return crypto_register_shashes(algs, 1 + (&crc32_le != &crc32_le_base));
 }
 
 static void __exit crc32_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crypto_unregister_shashes(algs, 1 + (&crc32_le != &crc32_le_base));
 }
 
 subsys_initcall(crc32_mod_init);
diff --git a/lib/crc32.c b/lib/crc32.c
index 5649847d0a8d..a54ba87b7073 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -205,6 +205,8 @@ EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(__crc32c_le);
 
 u32 __pure crc32_le_base(u32, unsigned char const *, size_t) __alias(crc32_le);
+EXPORT_SYMBOL(crc32_le_base);
+
 u32 __pure __crc32c_le_base(u32, unsigned char const *, size_t) __alias(__crc32c_le);
 u32 __pure crc32_be_base(u32, unsigned char const *, size_t) __alias(crc32_be);
 
-- 
2.47.0.rc1.288.g06298d1525-goog

