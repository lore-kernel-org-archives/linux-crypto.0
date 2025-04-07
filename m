Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A075231CAE
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021268; cv=none; b=fK7yLPq5XxRrBN7AVx0Nsg9wRFXZ45DwHGLvRf2CsIhKn02EfiMh2MPiQekvxCqhb2RxWYXKwnIf77WVtvPoapm5vAqIf2UNmmIzrGwkmdpLp/Y70u1zVvqS/c/QNe3pxHUm29GutZqX7KwU+sExGWQGKXcWV0qI7f2JIsKPNd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021268; c=relaxed/simple;
	bh=DnYw7IC8xWuMG+UL/gQ5prUj9HOQyrvroe8K4Ecs5ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l9vWGfYZL9AKbXj4WBTKzutXVcb71iFslliwYbFrfCxUEssFwXSAs1ruddurotxe94JxoWFHiuvOD2hVXMl8nDPKaHeiFqbukR5RU4XSojXPX/Ffd9GdlaIjYI/Y2MTwfSaBfLxIn86VyHAO/L1KfZL0z4ZxJ+F6I6jbouoa5hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hifiphile.com; spf=none smtp.mailfrom=hifiphile.com; dkim=pass (2048-bit key) header.d=hifiphile-com.20230601.gappssmtp.com header.i=@hifiphile-com.20230601.gappssmtp.com header.b=xsgOGhhZ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hifiphile.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=hifiphile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hifiphile-com.20230601.gappssmtp.com header.i=@hifiphile-com.20230601.gappssmtp.com header.b="xsgOGhhZ"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so2308829f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Apr 2025 03:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hifiphile-com.20230601.gappssmtp.com; s=20230601; t=1744021264; x=1744626064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L5jGr+pI3zOZTWXmjHZAncBL8qM4rtZILEfUKQGcw3Q=;
        b=xsgOGhhZ6JgjDw+UVon4kCJDL0z2E7tbvcdnLQwKXhhw/SqwATEsZidArfJeGsYHpw
         yUMNDBGoUJbhw0hufEoRJb8fRASlzLhY4Jn5fpLuhjUey8Mxnv0fBQtneBf8GOnDI6Tg
         jSHo8i6Mr8mzR7Uqq8PiiDFG0rz3QMrMsu9laAZZFWWmdiM7qNz44r4IbrUO6Su+6o69
         miw2w4JrNldvXBspT5qqy5rbGiOz5WUgUIBRXjjlAjqgOq5KGHUVMMZf5NkCT9+3O+Nc
         Mlzf+YQuUIp/+Lv5KwV2SZgS/dqt8TDWzsjr/KSXbC1CvdENaZIiCCuMUYDSGq2pCrkA
         IzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744021264; x=1744626064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L5jGr+pI3zOZTWXmjHZAncBL8qM4rtZILEfUKQGcw3Q=;
        b=cDUaayZdDDmRIOp2k1YFQp3kl8rB4t76AwyzjTwWHrCvKdpzUz8p0mt20KLT7XwBsl
         tQfuWDl5Rbi0ufuiMhU7ODdXVr77N/2pWUaxZBe7PIJwvhv2LFn05bneqApeQSh8kXaT
         7okPeXNGhf6H6kY73a1OlrSGfOad35odnOZ7FjM+4q7faztcie0umrC/wQ2s/2QE3xd5
         /MuAerhNv3lrhSZBAEgQSCkXfR9dbr/ztkm8YhAc+gMF+3SZiapZ/GjpnobDFtkqUFj/
         xFy9uNo9uEvmALjxLBW9dgAtnrFGRvGcw+ThHB7wVWvTnnBwEa4rwcbgHjCZKqHtzLqt
         m1AA==
X-Forwarded-Encrypted: i=1; AJvYcCXfYawLIk8aHFb90Ih+8Bp8ZqJK2OxBREajkUTCzUUxvKHcqkyLGd1Kri7HMCb5aQjDpLSxuTq20Lw2rBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIAMUlVhvW461ALpne8DCJgY8IvUm6QtX3AynK0DLFRhSZ2GTS
	OGDvYcVgCg2pjuFdCuOuQe2nGQwJvwg6gedbiFm6wjXmFbB4sAxsKPyUHqzbU3U=
X-Gm-Gg: ASbGncvB7tvQS6s83hj5uloTWeSnzoagQ/HEV2zjLrQ1PaA/eJLxbQ0V5B2KHbJSP4D
	wlYWGk/M5M6YswAXoLDpF9FT67uCwOwPDNs86qzbNoUfdM0MRVUHv3jUu284Bavy2oA6zwnKN7M
	4B5tbTYDiFXyGdRSbI/dNSs7IsPYlK58TriYYe5Kw4y7Go1saO97VXarV61EZMxUW05U7qfXEN4
	Ixmt8D808axgacHAOFpGMIX0JY1dvXGqEmkyYZH+EEkmxIT9bbxoMUt2Ptc2kEtTo8j6xOrD+zO
	JUEpsjab6JkXk1uXfs+sOE01B8EEP6ALC9u6CpyZBTBdtiuibD0ZQbcd
X-Google-Smtp-Source: AGHT+IHIVQFFxQYUM9c9p5jCB+KaT/H7u/LzBHBry2a7T1ZwTP6sqndz9DYPvtVDPTHqnOcrzzxy+w==
X-Received: by 2002:a05:6000:2907:b0:39c:1258:2dc8 with SMTP id ffacd0b85a97d-39d6fd0756emr5600592f8f.57.1744021264047;
        Mon, 07 Apr 2025 03:21:04 -0700 (PDT)
Received: from localhost.localdomain ([78.199.60.143])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-39c30096896sm11740533f8f.19.2025.04.07.03.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 03:21:03 -0700 (PDT)
From: Zixun LI <admin@hifiphile.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Zixun LI <admin@hifiphile.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: atmel - add CRYPTO_ALG_KERN_DRIVER_ONLY flag to atmel-aes, atmel-sha, atmel-tdes drivers
Date: Mon,  7 Apr 2025 12:20:49 +0200
Message-ID: <20250407102050.1747860-1-admin@hifiphile.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces the CRYPTO_ALG_KERN_DRIVER_ONLY flag to the
atmel-aes, atmel-sha, and atmel-tdes drivers. This flag is set for
hardware accelerated ciphers accessible through a kernel driver only,
which is the case of these drivers.

Signed-off-by: Zixun LI <admin@hifiphile.com>
---

v2: fix indentaion
---
 drivers/crypto/atmel-aes.c  | 5 +++--
 drivers/crypto/atmel-sha.c  | 6 ++++--
 drivers/crypto/atmel-tdes.c | 2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index f3cb73df941e..266e1d0aca3c 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1948,7 +1948,8 @@ static struct skcipher_alg aes_xts_alg = {
 	.base.cra_driver_name	= "atmel-xts-aes",
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct atmel_aes_xts_ctx),
-	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY,

 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
@@ -2471,7 +2472,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)

 static void atmel_aes_crypto_alg_init(struct crypto_alg *alg)
 {
-	alg->cra_flags |= CRYPTO_ALG_ASYNC;
+	alg->cra_flags |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->cra_alignmask = 0xf;
 	alg->cra_priority = ATMEL_AES_PRIORITY;
 	alg->cra_module = THIS_MODULE;
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 095ba254a25c..b4e917a8465e 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1254,7 +1254,8 @@ static int atmel_sha_cra_init(struct crypto_tfm *tfm)
 static void atmel_sha_alg_init(struct ahash_alg *alg)
 {
 	alg->halg.base.cra_priority = ATMEL_SHA_PRIORITY;
-	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC |
+				   CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->halg.base.cra_ctxsize = sizeof(struct atmel_sha_ctx);
 	alg->halg.base.cra_module = THIS_MODULE;
 	alg->halg.base.cra_init = atmel_sha_cra_init;
@@ -2043,7 +2044,8 @@ static void atmel_sha_hmac_cra_exit(struct crypto_tfm *tfm)
 static void atmel_sha_hmac_alg_init(struct ahash_alg *alg)
 {
 	alg->halg.base.cra_priority = ATMEL_SHA_PRIORITY;
-	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC |
+				   CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->halg.base.cra_ctxsize = sizeof(struct atmel_sha_hmac_ctx);
 	alg->halg.base.cra_module = THIS_MODULE;
 	alg->halg.base.cra_init	= atmel_sha_hmac_cra_init;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 099b32a10dd7..96fc19cd62a2 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -898,7 +898,7 @@ static int atmel_tdes_init_tfm(struct crypto_skcipher *tfm)
 static void atmel_tdes_skcipher_alg_init(struct skcipher_alg *alg)
 {
 	alg->base.cra_priority = ATMEL_TDES_PRIORITY;
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->base.cra_ctxsize = sizeof(struct atmel_tdes_ctx);
 	alg->base.cra_module = THIS_MODULE;

--
2.49.0

