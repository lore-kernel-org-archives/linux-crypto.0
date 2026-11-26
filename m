Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721596;
	b=K5dUzH7trPl7VNbGTIGBn1vwKTlawBGSU2xIl8FKB+LxoWDiKYNKit6KrQhcDmukbu73
	 Fta6xLSL5DZYDmjNFGHUDG4TWFD99A+llXY2zEvmqC+9UsUMHcKM7dlGX/pYvetnqTBgp
	 NLBqKPv3EF7/1OtoE8bRa0ViWpsOBT15ZbL2upWO5O0xq0Bs8ntwQnixMfPz7+Qx+646Z
	 cFpotjHsM8pgo3RfrBByOqCleqRSCM50BW6NlmiPaDd05tp+WnF4fRHL3jVLz/EW6mi4D
	 Vwb3NH1mhdCuW1IC9ts7k+AqS0jMD5A78gdomPFk/uxr9YAHgWJmtisr7lpzLDexOBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721596;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IoF64jnw/OxIgULPI43O4WtliYquxuYl5hRwBwB9SZc=;
	b=ybhleJ5gOKarH7PpYK37t5h7QDOHA5NnQl136Gm0N8AXtdnFTWn1bM2JcfooL+x+cYRK
	 Zv4TxH8KaQpgcugzo6YJjmtHcKKvA89BBpyUkG93DEhvxV2Sz1OJp5Pl47qhlcpgOvcjC
	 8c/dH097gopvEXzwdKlAZgHkcmN/1wCwwEXlG+juFoftezj3Ri4myzdxRak3+vyAxuteq
	 dzdDJ+2dqJf2yhh0dzXmVXv3graTtBiTZ2kcyC8TejCQjzpoyZLlTW+MuR5VNSdseXLkV
	 b/+4dsIthtN7BSJSVzchbvwyxcifTd1NBLBA4GTPn3O8X3T4OD5HG2qkcKxPg6YDd+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cnqP3S8h;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6CD606A330
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A6CD606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cnqP3S8h
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso74457805e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721595; x=1796326395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IoF64jnw/OxIgULPI43O4WtliYquxuYl5hRwBwB9SZc=;
        b=cnqP3S8hNwYCVxe6qhH3SCYe9yECLOv/Zw+1SUqsATHV+noeg4z0Ihz8drVNv3T+DO
         mV9Qpo27f4qjbb2y3IsMehStvSkg4MCJ/WmHI6b6ayMZfKHSBXR2JVUr0WIwyPSZY1iI
         kYyTCFKK9l7oLHyGw/IQWIqNyz9ZMLyDwSUQECVtxFkJ+ouXbT0saWR5zU388N1OEk8X
         bH93Vy9+f9od5SeM7SgZSLRf4OzSBOKHHNseX19N+bxJ75UxtpKS1d99c6gqAlmwGV1R
         kf4A6X5OUmM9jjq2G3fHXkSIUl2U6OuH2udUwaydc4oEPcVIZ4IpG9lefpqh+sSsAqzv
         5tjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721595; x=1796326395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IoF64jnw/OxIgULPI43O4WtliYquxuYl5hRwBwB9SZc=;
        b=rzpqxx8i8WmmicsEDuUqHzRME3wVJ4Jzah5zM0ZKqUu9CGKcITtUOBqHgdJO8nkgmE
         esvAiZG86KNTxpSklzlkLysVVPp7gkmghCbllPm3TY9NggPA2ch7AzkSgExd307hC5De
         oTlbHE53NmqPaJODlq5urmF/5UTgojiYBJ/WfvvF4FsrPg1fQ5rHQM4K/sIXck9ejjzC
         HPkF+UeOS1OCvrmvBkKi50KX5ya7oAkg8Ak0R3xgX701DLoz3RjDoLlgMQdONd4qgQea
         VdAXphKXHyEPhZQSu53SjCPX3n4valAefG20qXgBk4YRBvQ9+ytn+xN1l5tgmtBVKvr9
         /f8w==
X-Gm-Message-State: APuU4Z83k9tRGLdPo7jxKb6U3mdMHxg+0j54qBHJtBJB1Y6eZhaBNZeK
	bWGBNCg7NiGnjkYTK/I23OpJDleItODmFKuL5koQ3A4gHEyxGfYH6dqv
X-Gm-Gg: AZFdTZdFsOin/KN7Z77ZOdoabEldgKd+uPvceWBY3D6QwJ+Evu3AAZRKlyIDMeUKIg5
	bMCOyF2pdDkxPWJKF4nklH0Ta8XEmqJ7vnFQCY7d2BWJNptW8MJlj8kJweUArJfugfcOVokgCeY
	YOTKeV3uEy4VQkDMjnyElemFjpt2R4Dq1wgB48n8h9l2P5my149GEEwYo9P/0JNJEupwni/kcyv
	Z1zXuETL0RIkFzN0msUl7nCXaYskI+Raq7Mu8LPaS+a3yqQKKKBK2iGkH3g8amU1VIHD2WwTtud
	kTdp/+5UwKkcEj+KFBaiS6HirtLHyyHLIl+mGmuSVTuwYsv/wqKHyOAMQ54mRjx8itEMTZdAlfk
	UStBndTS4m8S0w1MMrofk42eEyi4pAML9cd4ir63wCPe+R2ptIYzdy2rWeVV+7Lbxi7a8/2iJ3c
	FKJnG1gK3p23hSfmeRkqx6aLln967oCkSvlYmmub+9AEint6cP872G6VXGTgRZmAuif0RXXa5Rh
	ANee62WZB4V0CbrP/zSYaRop0tMvH6A66rtPhG2MMnyt7WXaDdGTjA3l4MWQqn6yFe+mbiG0ENE
	qdY1am91Fdt/YJwubruWnCHXdAMam5mKKf2RrIUotmL0umzsqF6yQLoCnZBZD+bYZcw=
X-Received: by 2002:a05:600d:6504:10b0:4bb:b378:a003 with SMTP id 5b1f17b1804b1-4bbb378a00bmr865745e9.2.1795721594660;
        Thu, 26 Nov 2026 11:33:14 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:14 -0800 (PST)
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
Subject: [PATCH v13 10/25] crypto: amlogic - Cleanup defines
Date: Thu, 26 Nov 2026 20:32:26 +0100
Message-ID: <20261126193241.1471372-11-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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

