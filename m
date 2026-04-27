Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DB93B9D93
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 12:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777293704; cv=none; b=REDjpDdJnMoRvyTFZnpmlxRW3TRLZHsRdk4GwzxFrV2AvJKHNZeuAkmfaPQvU6vwXvB9vb5KvGdy6mPJoHowR3FWZbBgH96mvK+s6ayhDNJgtVx/GhCVEwM0C/WWJ92AnmZQZ44x4nwWmEI8fRsDM3X0BlV+QWrUuU+GGep0H8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777293704; c=relaxed/simple;
	bh=rPsElOTnBU2IAaqPJKzszB9VzGW4gBafqHa3s/4eJvE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pg6GOTe8kPftsaYIKAloGN7LdtBaUaYQYLKIoyBagNaMZsU5RQun/gJhNgmz99YHVn0xf0WBNLeP0Drt8sw0QCiRPDTV4IEzEdsrQcdBiBR//iFhuxGDbxHhl2rACsEz9bAZagVxjLRo1ypeojzCdN3w6KzJG4Ma9wlMaiZKuAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SwVYql80; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SwVYql80"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777293690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1hHanKhgSNPNyW7BtonFlH3iX6W/a+wogWqZOKIosO4=;
	b=SwVYql808T4i1NosCr+5XCBhbYxszy3j4bdvpSaN7hyrUVPJnDS4kjM7GTFV70EEhnhQ64
	j5xjEVw9xCl1EK7bCx0xNVB8b93VYELLiIv91pgtpuFtKoWtOChxkAr777c65OBkvcvmoi
	cDLcCsPZiWVaUi8UxSi7++5yOh2tiEE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Cc: stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-sha204a - drop hwrng quality reduction for ATSHA204A
Date: Mon, 27 Apr 2026 14:40:32 +0200
Message-ID: <20260427124030.315590-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3771; i=thorsten.blum@linux.dev; h=from:subject; bh=rPsElOTnBU2IAaqPJKzszB9VzGW4gBafqHa3s/4eJvE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvI+02/HdQN7hmPueCfHr9w5tdL9aeNPmQs8Yga+78N IGLjaXMHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRDGmG/2ETlnxR8p9cppF5 Vl3/07rAaxx/brz2KuF9/7Q/tukskwAjw28np8U5s2a5rLsqqqPIVPV/F8+JU24qlqmrv4WrP3q 1kQEA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit 8006aff15516 ("crypto: atmel-sha204a - Set hwrng quality to
lowest possible") reduced the hwrng quality to 1 based on a review by
Bill Cox [1]. However, despite its title, the review only tested the
ATSHA204, not the ATSHA204A.

In the same thread, Atmel engineer Landon Cox wrote "this behavior has
been eliminated entirely"[2] in the ATSHA204A and "this problem does not
affect the ATECC108 or the ATECC108A (or the ATSHA204A)"[3].

According to the official ATSHA204A datasheet [4], the device contains a
high-quality hardware RNG that combines its output with an internal seed
value stored in EEPROM or SRAM to generate random numbers. The device
also implements all security functions using SHA-256, and the driver
uses the chip's Random command in seed-update mode.

Keep 'quality = 1' for ATSHA204, but drop the explicit hwrng quality
reduction for ATSHA204A and fall back to the hwrng core default.

[1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
[2] https://www.metzdowd.com/pipermail/cryptography/2014-December/023852.html
[3] https://www.metzdowd.com/pipermail/cryptography/2014-December/023886.html
[4] https://ww1.microchip.com/downloads/en/DeviceDoc/ATSHA204A-Data-Sheet-40002025A.pdf

Fixes: 8006aff15516 ("crypto: atmel-sha204a - Set hwrng quality to lowest possible")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha204a.c | 40 ++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index dbb39ed0cea1..df69fb190e52 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -19,6 +19,25 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
+enum atmel_sha204a_variant {
+	ATSHA204 = 1,
+	ATSHA204A,
+};
+
+static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
+	{ .compatible = "atmel,atsha204",  .data = (void *)ATSHA204 },
+	{ .compatible = "atmel,atsha204a", .data = (void *)ATSHA204A },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
+
+static const struct i2c_device_id atmel_sha204a_id[] = {
+	{ .name = "atsha204",  .driver_data = ATSHA204 },
+	{ .name = "atsha204a", .driver_data = ATSHA204A },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);
+
 static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 				   void *areq, int status)
 {
@@ -171,11 +190,8 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 	i2c_priv->hwrng.name = dev_name(&client->dev);
 	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
 
-	/*
-	 * According to review by Bill Cox [1], this HWRNG has very low entropy.
-	 * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
-	 */
-	i2c_priv->hwrng.quality = 1;
+	if ((uintptr_t)i2c_get_match_data(client) == ATSHA204)
+		i2c_priv->hwrng.quality = 1;
 
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
 	if (ret)
@@ -202,20 +218,6 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
-static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
-	{ .compatible = "atmel,atsha204", },
-	{ .compatible = "atmel,atsha204a", },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
-
-static const struct i2c_device_id atmel_sha204a_id[] = {
-	{ "atsha204" },
-	{ "atsha204a" },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);
-
 static struct i2c_driver atmel_sha204a_driver = {
 	.probe			= atmel_sha204a_probe,
 	.remove			= atmel_sha204a_remove,
