Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55189142E77
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 14:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729001732; cv=none; b=KHws9RfSVRzWAYnXkis9mvNnQfCs0LZCjlesPKeBfpX90rwZTZVbJTtQkWm4oxh2ZUCqWCKkTyaxik7xmBa1URd6ta0TcRVk2jKiXs869vi3msYYwY7nO3Yftv/S6Fe+aBlmJ/dGC4cD2glfhUrpIGCHgVAob9ykp/S++QjVv2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729001732; c=relaxed/simple;
	bh=Z1aPPooDls2taVn+gi0sXyVQV8kJ8ey67lZ9fVQtJxE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aU0JW7uXDRGkjl3SV9yrDfOfmtW1jx00CEhto6oqrcQOrD4XP/0zVhadN5kqJj55kImEQ3f4Hf47YTe1flAoa8klkV3HjSHco6LxHGn2SbN/yq4XXi+dO3II9U9N2+xu6VUjy3Dkuo41t/PBh4tAKKw7+fJGiyR9uMFsszcoz0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=klf2AMrW; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="klf2AMrW"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-37d609ef9f7so1354065f8f.3
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 07:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729001729; x=1729606529; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8CxPmpBAP8eCjtMdTvIIYVSJhCFUv2sFvYcbHhPChyY=;
        b=klf2AMrWzvNeZBZ7cC2iClnutLAIkDAoJ/uudqI76/Nx0/N7gbbHtmQAmmsRbW61gF
         vGEAFQrpjyDosW1nqBRMFNCg97PwtwDgXeA7+tFDYloPYjdkIybRGL6a6AXu9LEzlDUY
         /mLJglngTYiW3SshTd37GvBQLQD0iAsvTa8/lKS7Wsoy9pNV8LoZJ5hkMC8MJnEUBhqV
         2sw6N6SxIx6SHEApVGAgH73auPwBCVSCsjE3ge0nu+STq8r0EWo1QoiIgJXiwQUnjtC6
         B0vwzIBdzPwm3xveQ6yTTY9NkHWxAUBFrHMuyFDUy5yaXVyJNn8alxvlhPclD1k7/Csf
         ZZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729001729; x=1729606529;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8CxPmpBAP8eCjtMdTvIIYVSJhCFUv2sFvYcbHhPChyY=;
        b=EaiIvbI6eADoguxV8456KH/RePSd4q5mChZdLWSe44R5AVuNRXXVPJOI1uWRO1JTpG
         Zs6hVyzCp1QzEEXrFEoSfKg7V4MsVYilKvni4yV9BLsTjzJDYy70vKBl4CvzrRkabIzn
         5GZdhMhEJU3nmxIb+zSbpGGkm53aXb27z9OUxkDZipM/uF9twlICDNAyYPVDl6D24Uf/
         4dzrrqwGfq3KdLJp8exKphYjxlcvrA6yCjjfEOFKfPmnhokONah5aYCbwBM2ax5d+9pC
         KZE4Nr9wHUL2ZtDI9vHq4HQQNQTcCCanV1+W8WeeUe79UU3frs+uTqNvQPEHgrPWDu6x
         WJFw==
X-Gm-Message-State: AOJu0Yw1APhrqeib/bi6iqUfDX1+oj6gKZmMD4ycYQ/yJpL6zUqk1cEk
	U5wCWADmEjfEzVqQsCGw+gAkJwJBraCVj/RNA7gIkqhpWUaJvnB38KK1lSdC3QKpXAxicFE+tZi
	Pq2jEBiDixiDtmS2caFXa2kRqDWy05aO271BD4Q/xhZ2N0OZWBgtJql+yw/ZAYS4IrwvJnq98Xg
	8+5X14q/QFdHWzo5G2HJnRG7XoHULepg==
X-Google-Smtp-Source: AGHT+IHLLxVIYbMv3FLoPzUWQvuVMjRWgHzzi75eychuiPSYTRrqwBaSf1ewYX77XMNsLQT/1p+6qqnd
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a5d:4d88:0:b0:37d:4722:57 with SMTP id
 ffacd0b85a97d-37d86d9ceb0mr157f8f.8.1729001728542; Tue, 15 Oct 2024 07:15:28
 -0700 (PDT)
Date: Tue, 15 Oct 2024 16:15:17 +0200
In-Reply-To: <20241015141514.3000757-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241015141514.3000757-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4002; i=ardb@kernel.org;
 h=from:subject; bh=XEFH/aVkBNoR48BTtlFJeWHZfRlCtF6XDXXhHKYRsHM=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIZ2v4ss0noL+aY0uItNPfTh4tYP/SouYr/KeCyHH9k+8a
 puxqzq8o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExEsZiRYTGf+tLH/lWb5I/u
 efTx405vyd3xUspzV39Mkmicccru+AJGhuW1XJqiu8WDTooKH536VuWjWriZg1qvsSVfreMq87O b2QE=
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241015141514.3000757-6-ardb+git@google.com>
Subject: [PATCH 2/2] crypto/crc32c: Provide crc32c-base alias to enable fuzz testing
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

crc32-generic is backed by the architecture's CRC-32c library, which may
offer a variety of implementations depending on the capabilities of the
platform. These are not covered by the crypto subsystem's fuzz testing
capabilities because crc32c-generic is the reference driver that the
fuzzing logic uses as a source of truth.

Fix this by proving a crc32c-base implementation which is always based
on the generic C implementation, and wire it up as the reference
implementation for the fuzz tester.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/crc32c_generic.c | 72 ++++++++++++++------
 crypto/testmgr.c        |  1 +
 2 files changed, 51 insertions(+), 22 deletions(-)

diff --git a/crypto/crc32c_generic.c b/crypto/crc32c_generic.c
index a8c90b3f4c6c..0a7543dbc515 100644
--- a/crypto/crc32c_generic.c
+++ b/crypto/crc32c_generic.c
@@ -80,6 +80,17 @@ static int chksum_setkey(struct crypto_shash *tfm, const u8 *key,
 	return 0;
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+static int chksum_update_base(struct shash_desc *desc, const u8 *data,
+			      unsigned int length)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->crc = __crc32c_le_base(ctx->crc, data, length);
+	return 0;
+}
+#endif
+
 static int chksum_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int length)
 {
@@ -127,35 +138,52 @@ static int crc32c_cra_init(struct crypto_tfm *tfm)
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
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+}, {
+	.digestsize		= CHKSUM_DIGEST_SIZE,
+	.setkey			= chksum_setkey,
+	.init			= chksum_init,
+	.update			= chksum_update_base,
+	.final			= chksum_final,
+	.digest			= chksum_digest,
+	.descsize		= sizeof(struct chksum_desc_ctx),
+
+	.base.cra_name		= "crc32c",
+	.base.cra_driver_name	= "crc32c-base",
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct chksum_ctx),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_init		= crc32c_cra_init,
+#endif
+}};
 
 static int __init crc32c_mod_init(void)
 {
-	return crypto_register_shash(&alg);
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit crc32c_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
 subsys_initcall(crc32c_mod_init);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e0d6bfcc13e6..c3f1cfe9e17e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4700,6 +4700,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "crc32c",
+		.generic_driver = "crc32c-base",
 		.test = alg_test_crc32c,
 		.fips_allowed = 1,
 		.suite = {
-- 
2.47.0.rc1.288.g06298d1525-goog

