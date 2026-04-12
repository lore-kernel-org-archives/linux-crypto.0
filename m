Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B498C42AA9
	for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2026 09:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775987840; cv=none; b=uFQ17iXFtxDt6ePfaR9V+RlJ/g9px26XKomWLOfB4vXxLerBjJ6c/4NyzXghspPmSBrYBTxTR33CLCRlmihoefSywfWxlw9k9t08NkzcZ6jfEnpp0A9XXLlN5t5ZZ1zde5lvQh4FXBdAGH30CJ5ctbekylf+lYsk2l0iX295YxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775987840; c=relaxed/simple;
	bh=HB3s4feq30/s1R2bwwVv+aAdLnzAoOYlnjVAKPryZjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jFt3hMlAk8OrK3bqs4fhM63/gvKUyLGEoqXpHUCGAwO6WuBEK25YAG3yxiZS3sJVUe64LB2G2ZcEphLrkrxhxq3WQcGpBQSmSCHG0XIZOM4VKClDtaLhboKrIr8G3E3DcMxIZb8+ktGgaFZ5HnpekTFUpwT0qbcAxf5nATZMSDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZNUZT6Yg; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZNUZT6Yg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775987826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PB2wIVal0knNRH3IHxGDNzU1l0k9OBTjBH/yfZTe3bo=;
	b=ZNUZT6Yg9k3SkxNbn+yFQEiQmMPJckZuGM87mew6So1NGo30Uvb4FylHI/bkM3aRBvEeEo
	FldqUO6R45huHuVT6cYgNtJvLqChDbFOo+dwwVqyYH2Yl/B64yFa1fK1eOtnp/Os0OzdBn
	1EBR49YOOh29G+Re5SX9PB32GB4NBsU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/2] crypto: atmel-ecc - add support for atecc608b
Date: Sun, 12 Apr 2026 11:56:43 +0200
Message-ID: <20260412095642.120815-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1168; i=thorsten.blum@linux.dev; h=from:subject; bh=HB3s4feq30/s1R2bwwVv+aAdLnzAoOYlnjVAKPryZjw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJm3c6Jzl+TqXJo85+TDPJaevacOp25pKhRM9Obb+7Ry7 8Iy/jChjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIki/D/4qCHa/8lrbM4j/U OUts5v+kRH9/XUXvNa8sFkXLsr68ncbIcOsU+1KWM/YyL932Rb96zXV72yf7O4ciV++U8Yj9xL5 rAyMA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Tested on hardware with an ATECC608B at 0x60. The device binds
successfully, passes the driver's sanity check, and registers the
ecdh-nist-p256 KPP algorithm.

The hardware ECDH path was also exercised using a minimal KPP test
module, covering private key generation, public key derivation, and
shared secret computation.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Resending to include linux-crypto in patch 2/2.
---
 drivers/crypto/atmel-ecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index b6a77c8d439c..5793e0c44113 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -371,6 +371,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
 static const struct of_device_id atmel_ecc_dt_ids[] = {
 	{
 		.compatible = "atmel,atecc508a",
+	}, {
+		.compatible = "atmel,atecc608b",
 	}, {
 		/* sentinel */
 	}
@@ -380,6 +382,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 
 static const struct i2c_device_id atmel_ecc_id[] = {
 	{ "atecc508a" },
+	{ "atecc608b" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
