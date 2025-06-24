Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1980B2D5404;
	Tue, 24 Jun 2025 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773198; cv=none; b=mMxTaNTO5aOi1vSjVsAs+FKuBDrU/WPfBvFEY4edP+lmgt76hKRmrgfs8ES+VysTGxuZUm4qRkZKTxHnJDeZDCUZP6yY8hu9RXbhEfCQOuPRbPppz3B2f1Vo/bLtQDN+0Nk4CyZpfFNBrBGw6xx48mw2s22b3hbcXFA3DMMLzYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773198; c=relaxed/simple;
	bh=lkSC4Aoe2RYHdhHJgZ3RU4f+5rFQm8ra1dHdbYgsUWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nqJvIorFZ7FMwoNn8pUQF6aePH+V0KxXj6kRI3DmIagXpkoaIgfFNfB2P7xmEOpYxHAMNhLlWOcJuTWhZNZuRHSZqPdp/Dqbr71s+qUvlTdQEFOWh0j8Xl18HKDwByFZi3ABeWA2VBs7QndU2ZcuFWNZzgPJ2zaBSdez3vFTag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dQAPRTDj; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dQAPRTDj"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-553dceb342fso414208e87.0;
        Tue, 24 Jun 2025 06:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773195; x=1751377995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RO69daI5W04OIOGnZa1tJIfwSEk4z8uvJzpownmww5k=;
        b=dQAPRTDjMauDdblwLMjycps5/7PrA6JGXT0zH7lx8ru1ZkIdNJ7XA5JkeMDOIHnWJn
         p8BwcKf6D0NKPNFd+eiHGVRTo/9C0j7gV9pwTiv8yGSP9PGowlSBJPGnnaeGc5ztSfrg
         UkcojRko85No4LS6z6Bnuw2TFjOFo2zZ3rxSIAkIYlEc1gikRo7Bp3bxx4noT2b2lFj8
         13OblRnvDBHnTQypUNxTmWbnzjhUCWgmufSyiCOGJUA0MQjeTe/bHpq9Bkffvz5AESaB
         vHR56xNYulpQetOxlMnK3ecGWnR6L1fd1QxK9xcApSCjPNVxPmIKZHDCCsy40oD1lPoI
         DHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773195; x=1751377995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RO69daI5W04OIOGnZa1tJIfwSEk4z8uvJzpownmww5k=;
        b=vUUoe3Xc6irNwjD5tuEPiaa6oznz0MTJG/Bv4IwuEJDofZVjddT02gC7HtimkBksyT
         gxP79lc4D5k4il2G+qAhMHOgeVLw4i/cIxjrBltUMdC2Wnx/cFehuzeDZYG1zveptm60
         OSKIbxy6qzGhbfq1j703qKDMSHE2X8tW3+HVa5jJBDEQZRryoIhTEfesx6wrXICt+1X2
         Kp3AwTD8mVOW7xSScjjVJIPqS8kHbrvdUt6YYV/HRmFyD1M1+tME1mJm3kEIhjYe6VVj
         lS+KDuxTkC0bBtvJc33hXBy4L7ol5+B/5XFCZFAg3H4y0GO0/Hqq0Ay1YsdWHB9vjd+F
         klHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUx9Cai9DbSqGvEKulWzLHsmoGlbXYUs+2n5itzy/TLsF+TohzAefwpUq+HXOW1nC9jPNrbVPw+/yJ/XgdU@vger.kernel.org, AJvYcCW2j1KoB710dlhVgajYa3QzWEUpZd2DZEMuU0vGvMKqOf24kfoqgTkuLC+9MbEK77+ubHFzYmNEFZMh@vger.kernel.org
X-Gm-Message-State: AOJu0YzeAA1WBDEFNA/k6gKE77c2ZQMUHCLJ7NWepcdgy+yW9vMmot45
	TB9qRbxwJgorLfLKHXMUtA0XdsxxWOTsN9MNKpm/SV1sJAtvV+QHS283
X-Gm-Gg: ASbGncuPwYMKPojoHqQvb2dsWlydPQY8vOvvE7AMa8H0niRgtiPyZDSx2AyR2q75HUC
	S60PhhyCqVFZ6WK5L74B2K9NA+pNSLOXI5piOiFSyHyTQQOGd8iZYiZ4iTtSqpiCiR5AziO3U+Y
	dZsXRCj4pZz9Yp1As1BDeo6CTPF+jbqRU4Mqs0/ApH5bbHaFgcOEJpdP8vCCO9Mv+nmNAh1Sert
	CwqghKA4aP+0P0IC+QwRE1lQjJefhIwuydcpS3pIR+dfLC62luLbYThPPyAQZreYmkwcnijGI5E
	9qGzuMScoNhx49dY6mqtDYov/qCCSpXw1Fp3c4oRlWhaiEPvGdVzCZd/u977mvCJ8izjgPiwRPa
	1b0eSHjgcPH+5Zr0MGnYOrLMlljETbIGw5ePMODHlv5t0cjb63Sll8V7d9lSBmg==
X-Google-Smtp-Source: AGHT+IHqC0I7lY85uruxM8FbkichBl5lVOZaUMavYs1QcspMaDSIZ5c23RtGIRSTLmBN3qMhhWwupw==
X-Received: by 2002:a05:6512:3e0f:b0:553:2869:3a5 with SMTP id 2adb3069b0e04-553e3c07c9amr4738378e87.48.1750773195001;
        Tue, 24 Jun 2025 06:53:15 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:14 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 08/22] crypto: amlogic - Cleanup defines
Date: Tue, 24 Jun 2025 16:52:00 +0300
Message-Id: <20250624135214.1355051-9-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is bad to use hardcoded values directly in the code.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 24 ++++++++++-----------
 drivers/crypto/amlogic/amlogic-gxl.h        | 16 ++++++++------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index bc3092a8a2c2..c662c4b86e97 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -141,8 +141,8 @@ static int meson_cipher(struct skcipher_request *areq)
 						 ivsize, 0);
 		}
 	}
-	if (keyivlen == 24)
-		keyivlen = 32;
+	if (keyivlen == AES_KEYSIZE_192)
+		keyivlen = AES_MAX_KEY_SIZE;
 
 	phykeyiv = dma_map_single(mc->dev, bkeyiv, keyivlen,
 				  DMA_TO_DEVICE);
@@ -161,7 +161,7 @@ static int meson_cipher(struct skcipher_request *areq)
 		todo = min(keyivlen - eat, 16u);
 		desc->t_src = cpu_to_le32(phykeyiv + i * 16);
 		desc->t_dst = cpu_to_le32(i * 16);
-		v = (MODE_KEY << 20) | DESC_OWN | 16;
+		v = DESC_MODE_KEY | DESC_OWN | 16;
 		desc->t_status = cpu_to_le32(v);
 
 		eat += todo;
@@ -205,7 +205,7 @@ static int meson_cipher(struct skcipher_request *areq)
 		desc->t_src = cpu_to_le32(sg_dma_address(src_sg));
 		desc->t_dst = cpu_to_le32(sg_dma_address(dst_sg));
 		todo = min(len, sg_dma_len(src_sg));
-		v = (op->keymode << 20) | DESC_OWN | todo | (algt->blockmode << 26);
+		v = op->keymode | DESC_OWN | todo | algt->blockmode;
 		if (rctx->op_dir)
 			v |= DESC_ENCRYPTION;
 		len -= todo;
@@ -348,14 +348,14 @@ static int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct meson_dev *mc = op->mc;
 
 	switch (keylen) {
-	case 128 / 8:
-		op->keymode = MODE_AES_128;
+	case AES_KEYSIZE_128:
+		op->keymode = DESC_MODE_AES_128;
 		break;
-	case 192 / 8:
-		op->keymode = MODE_AES_192;
+	case AES_KEYSIZE_192:
+		op->keymode = DESC_MODE_AES_192;
 		break;
-	case 256 / 8:
-		op->keymode = MODE_AES_256;
+	case AES_KEYSIZE_256:
+		op->keymode = DESC_MODE_AES_256;
 		break;
 	default:
 		dev_dbg(mc->dev, "ERROR: Invalid keylen %u\n", keylen);
@@ -373,7 +373,7 @@ static int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 static struct meson_alg_template algs[] = {
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.blockmode = MESON_OPMODE_CBC,
+	.blockmode = DESC_OPMODE_CBC,
 	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "cbc(aes)",
@@ -402,7 +402,7 @@ static struct meson_alg_template algs[] = {
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.blockmode = MESON_OPMODE_ECB,
+	.blockmode = DESC_OPMODE_ECB,
 	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "ecb(aes)",
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index f0ccd28545aa..8f20903842ec 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -11,19 +11,21 @@
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 
-#define MODE_KEY 1
-#define MODE_AES_128 0x8
-#define MODE_AES_192 0x9
-#define MODE_AES_256 0xa
-
 #define MESON_DECRYPT 0
 #define MESON_ENCRYPT 1
 
-#define MESON_OPMODE_ECB 0
-#define MESON_OPMODE_CBC 1
+#define DESC_MODE_KEY (0x1 << 20)
+#define DESC_MODE_AES_128 (0x8 << 20)
+#define DESC_MODE_AES_192 (0x9 << 20)
+#define DESC_MODE_AES_256 (0xa << 20)
 
 #define MAXDESC 64
 
+#define DESC_OPMODE_ECB (0 << 26)
+#define DESC_OPMODE_CBC (1 << 26)
+
+#define DESC_MAXLEN GENMASK(16, 0)
+
 #define DESC_LAST BIT(18)
 #define DESC_ENCRYPTION BIT(28)
 #define DESC_OWN BIT(31)
-- 
2.34.1

