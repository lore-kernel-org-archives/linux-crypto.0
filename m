Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780893;
	b=sep/bJOx5ojdn54Km4hpqmLTriPQAOkUU2ma1h5M2VLoKoknHbvFteEJQydFfnMW8pza
	 3otUhni+a5VMIjsXdcSbD2zvvFkiKl561zJ6ZsY0EVmIA6qPFYSouebJl6qwTQX6AGRHg
	 AnzGwxHxBLTDvgx8m6mxYMqdsasBEvJSbCgKhqWxo6IUypAbjYvdWshoO/YU0QafUzgha
	 c3tPWDxRlCkK9kiz4vwyPSp0nyWnAl9U96YKCkVqBHNYDx1Dw2+UBMCljFp3YNKdtgd/6
	 dP1pJ1OohA6uDT0IwQVhJGtEwCe7Isz8GbFxQO2La25lqSt5voKoG9N/Nh46Zvde8Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IoF64jnw/OxIgULPI43O4WtliYquxuYl5hRwBwB9SZc=;
	b=QeP8jN60evPhh8P/GLQCbjfhGLw1g8gA1FPxU5DpMUkJPeBddGrcmSw4EXCHSEb2Fvun
	 JNKzTOHHZXFY0wtsTLtXsdBXXAivwoBGFXdvy6FYddyFpyrbIVNJ7e6fp8/qaM1um1xky
	 JrXSnl9rpjsLD4q4/LL4VauVYAdgTB9H1mtvMnX6NRl+ZU2tL27TKS69vPf6JvsT01rYi
	 iCaUKltxOSHbA0JveKLnbzghUoF8hCU7Vodc19jLo8J7Do8BAWMkrhgLmpdjjTg7BGiwt
	 PxT/hkPbav6nS8bZhpHhnrC5wsiicVo6hkO+OElv/TcfPDKuMBs6l4asdFmN1oZyJYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iyhEYbVb;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31003606A321
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31003606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iyhEYbVb
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4aa5833c263so7713769f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780891; x=1796385691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IoF64jnw/OxIgULPI43O4WtliYquxuYl5hRwBwB9SZc=;
        b=iyhEYbVbwVE+6wEHMPsuUaDKWnJv7hOKEAadAdBfDnvp1/q8P4jHAGzjVvPAEIlv12
         WZfGq/+p6XbpNB1L/ZpXofH51sjivZob16E7FqppasBRDmaGRcrKdNSUc1nNbFQncqcS
         r5bmPd14uqU0affY0gGyutopWKBqCnh1k3kWvl8ysZPktZy89rjv43LfeoMuo+y9RjTj
         zwiDMi97m0L6iLZr5XO96e2XzILVxP1eIhEODjmkHqxIHbqnExXoE/1QByoZUM+VCIvu
         YyzzFgIPgt6ImXuH0OqLIxTbwq5933ENoODR301CGI3p5fauwvvpLcX8ZXJK+nhq8ppv
         vLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780891; x=1796385691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IoF64jnw/OxIgULPI43O4WtliYquxuYl5hRwBwB9SZc=;
        b=Ob/MEikwWOWWkSVPxKSo6GP8oHmBgw8bP2F1sWBr5aFLgiwNE4bkD9FizcB5TO1oHl
         9p6LdadpW0Dn29PGVfyu4sLeSOB27PmtU1UH/mXg4ezexiRY3JTeSg/l+A5HcsyXJ4Us
         dOsuLl1mLrNRRJvLZcsb0s7Z6ydYrBVhCimdHn69Gmkg1dLZshNy9c3/4No0RIyPtbfg
         oaaSTkTPVWpK7LymUFU9FUofLIBuk9LvC4f7vBrzGzYNqHonVhfd5y/LmcdnLr+Z6Dub
         Vsregod656kdSmIh5ztV2QcoAKvTAvISCHBlK1oPeMKMMqFJwAigEtcEKPcbq6sOArBq
         d7zw==
X-Gm-Message-State: APuU4Z+ZDOcVVMjYePGFhf6lE8rKviKFAJMzFMKegc6S3xfA2YClC4vo
	BcYfeWqda+XHTIPqcEcEbr6gSiNLPbCjYZbgBjUh64lMuDQ37wf93xD5
X-Gm-Gg: AZFdTZe+269jUerLIEwmg5MkrI7yO5WNbYCXKwupnFZqvQ7m+w58ZjOzxpMFaGS5VmW
	JNhYRGXL1cWjzMp27o7++R1YidTNe1WsUZ13OR0S3RO+JuS31iy/G03r5xov6av3z+Lz/Nxz/Sd
	nGOVxbsv24GJfcWLhYZBjCoH/2HeGGkz+v+19Ptb6yluBqSiPRM46S/0E0BjQb4rVPYwhFzHrWl
	YhpzB8wB8RbJGrFBukvOeIGAo/e3MCv3ptAq4zjesIPUCSXqtuQP8HuKsdtDUUAJTAZ1TYNwECb
	BXW4TnsFtziCuzTtGbL7WYWc7zrKGxAaC/N0p0gt4fsd54CF/6iVPZRuP6li+rIUmuKqK5q6dfZ
	B6/3RdOvmC2qSvPdroj4O+yossuCucWGYskT3xmQKlr1XkPWITdLcC53fR20usLYQ3AE1rm3dYS
	XSjElZHQSmV3Kpc8Npz519oAaI8X9rQYH/UQuvCkjWTMJtaXJ1OcO8lI9RQCx/7iL2Ra56Fqv+b
	eMLFS8BJfwOPa2TUjexseSDIVrFqL+/NfHGBiYyqjoqRlNEVHJGcRoPqPNlwZYkmoCyVdWfjg9C
	e851eWNudxeFhHd0TgYJ4Ad0YEbwWiUGo6Hm6wetWdmujzg=
X-Received: by 2002:a05:600c:1911:b0:4a2:150f:1607 with SMTP id 5b1f17b1804b1-4bb8880a584mr492741765e9.13.1795780891427;
        Fri, 27 Nov 2026 04:01:31 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:29 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v14 10/30] crypto: amlogic - Cleanup defines
Date: Fri, 27 Nov 2026 13:00:43 +0100
Message-ID: <20261127120103.1532882-11-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Romanov <romanov.alexey2000@gmail.com>

It is bad to use hardcoded values directly in the code.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 24 ++++++++++-----------
 drivers/crypto/amlogic/amlogic-gxl.h        | 16 ++++++++------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 00d3247ebea1..c17ce5cc70a8 100644
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
@@ -214,7 +214,7 @@ static int meson_cipher(struct skcipher_request *areq)
 		desc->t_src = cpu_to_le32(sg_dma_address(src_sg));
 		desc->t_dst = cpu_to_le32(sg_dma_address(dst_sg));
 		todo = min(len, sg_dma_len(src_sg));
-		v = (op->keymode << 20) | DESC_OWN | todo | (algt->blockmode << 26);
+		v = op->keymode | DESC_OWN | todo | algt->blockmode;
 		if (rctx->op_dir)
 			v |= DESC_ENCRYPTION;
 		len -= todo;
@@ -363,14 +363,14 @@ static int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
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
@@ -388,7 +388,7 @@ static int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 static struct meson_alg_template algs[] = {
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.blockmode = MESON_OPMODE_CBC,
+	.blockmode = DESC_OPMODE_CBC,
 	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "cbc(aes)",
@@ -417,7 +417,7 @@ static struct meson_alg_template algs[] = {
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.blockmode = MESON_OPMODE_ECB,
+	.blockmode = DESC_OPMODE_ECB,
 	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "ecb(aes)",
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 608ce75f027a..15b4335942d5 100644
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
2.47.3

