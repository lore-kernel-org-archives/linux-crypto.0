Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8363A1682
	for <linux-crypto@vger.kernel.org>; Sat,  9 May 2026 10:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778321551; cv=none; b=ntcgEQp6Wnpz1MwS9hTtiwM+Jp3TExd0ms7h56Z3zxtOEGfFd9OOy6reSpnI+jp6sZ0w6gHa+qnCs0STSN/KcjWrugtb35a6tePMpMeDctE59DqILr9HrkeJIZyDux1gVjc+PH8M2yPL7H3X7DoW2MFsrfBFqiwHU9qUzkh7ycQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778321551; c=relaxed/simple;
	bh=LIGm6IfeAOjLe+aNZQ+2T5UbI0Y/Q+X6zrfFX8yPCsg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bA6Drd9zHev25WcRV0BX6mVNZSNG+jDnJDevNYhEGL91NnYalkt3LXq9ZSLH6aX60yDmWlz2OHn5wuxFIQREr6aIUJmxLVDLfrxBSt+b4IQKSpeIiFu1ZWfdV3Gn7ubAiPSNjMC09vI8Lmjy6YxWCg3PbmmUaKUFtHEDL3jAcNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LsvMYuDX; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LsvMYuDX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778321538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=61oGxBAoiQU9iEBw4v4XAgABJgwFZGOsQf7ibrEj0qk=;
	b=LsvMYuDXbkPd11NP/xoDQaeJComKTLV7p7QVmj8mFazNwOvW3E5aUwWGHt9r8Kg7s9MVlS
	GD0RBs1u94UJ2Yq8IXWfjfeRpxD+Zrg5/xwiEc3BvF9lqVAAdf+XgsMXbo2ZhZo5K62IA2
	zFhLs3ZM2f5nro+v+WrgDhoWb+zUB4U=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: atmel-sha204a - drop __maybe_unused and of_match_ptr
Date: Sat,  9 May 2026 12:11:55 +0200
Message-ID: <20260509101155.2095-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1645; i=thorsten.blum@linux.dev; h=from:subject; bh=LIGm6IfeAOjLe+aNZQ+2T5UbI0Y/Q+X6zrfFX8yPCsg=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJn/ObL7OxceiO3doJt77Eff27tlIbs3cL2e9illZfir4 2J+25yaOkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAixYcZ/ieei6+f+sWtf/Lh 0Fuvur5FTVp7KCO+XV5K+4bKqeebZasZ/goLGD41CMw+saZ/uprn+p0ZIkJN1bqSxxay+3YFSDx p4wUA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since MODULE_DEVICE_TABLE() keeps atmel_sha204a_dt_ids referenced, drop
the unnecessary __maybe_unused annotation. Also remove of_match_ptr()
because OF matching is stubbed out when CONFIG_OF=n.

Reformat atmel_sha204a_dt_ids to silence a checkpatch error and
atmel_sha204a_id for consistency.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha204a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index ed7d69bf6890..6e6ac4770416 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -207,17 +207,17 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
-static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
+static const struct of_device_id atmel_sha204a_dt_ids[] = {
 	{ .compatible = "atmel,atsha204", .data = &atsha204_quality },
 	{ .compatible = "atmel,atsha204a", },
-	{ /* sentinel */ }
+	{ }
 };
 MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
 
 static const struct i2c_device_id atmel_sha204a_id[] = {
 	{ "atsha204", (kernel_ulong_t)&atsha204_quality },
 	{ "atsha204a" },
-	{ /* sentinel */ }
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);
 
@@ -227,7 +227,7 @@ static struct i2c_driver atmel_sha204a_driver = {
 	.id_table		= atmel_sha204a_id,
 
 	.driver.name		= "atmel-sha204a",
-	.driver.of_match_table	= of_match_ptr(atmel_sha204a_dt_ids),
+	.driver.of_match_table	= atmel_sha204a_dt_ids,
 };
 
 static int __init atmel_sha204a_init(void)
