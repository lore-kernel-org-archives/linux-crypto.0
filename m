Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2D0381AE6;
	Wed,  4 Mar 2026 08:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772612666; cv=none; b=Nrc713Yx67DW4/R+0CCm+PltTT2hl8BKNYbPVt4AQDtr51PiFQKVy4cbbP5DQj6oY/exgxGjVtUPwkiu82OoiijQYilimQrLnncV/oEaosSPe4hEoJiqA248QTAuSYJ8NBGRAqK68hdIyxLBoRIMJm9+Bk1D+an18oySZHDGX6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772612666; c=relaxed/simple;
	bh=kom2xcr6Cjn2gbx/GXrP4GnvYuWcWipTx1C1J5pOmdo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U84u6S8Du7NCF6ptIa/y0g7/Brs6ebkEbKZyGPabNYzWWsKc57OeZWDkW8SsZYR4DPEZEBE+Oq+kuj+xUeCe5MCENi7GzdbLHnW1QLonSXJZXn7d0E4+X5k4RwcE21RLGB0KN4XFzpiFgVRKUqnpT0LkFz616M14sFAHLbSc5MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FXfpAiTo; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FXfpAiTo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772612658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W8iP5iIpjfhqtiGCtP0Z9gtiRw2K8cNyOMqPJ6maOv4=;
	b=FXfpAiTo06Rg/ywv0JoRSpy1E3nECXs5Q3ceIXa4YuIiCWroJEinxpkYSNTQyWeIC5lj45
	s1XxinJAjZP8zh9KiYdMO+MlATCFtrP2bb7O8LqVHCCMUMMI1IVm1+3BbkvenMwF7rVm4w
	iDtqwgdmk8D0NW4o83bmKb+ioFASBYo=
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
Subject: [PATCH] crypto: atmel-sha204a - Drop redundant I2C_FUNC_I2C check
Date: Wed,  4 Mar 2026 09:24:02 +0100
Message-ID: <20260304082402.89237-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

atmel_i2c_probe() already verifies I2C_FUNC_I2C - remove the redundant
check in atmel_sha204a_probe().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha204a.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 6a065779b0db..2081a4d538d0 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -180,10 +180,6 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 	if (ret)
 		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
 
-	/* otp read out */
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		return -ENODEV;
-
 	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
 		dev_err(&client->dev, "failed to register sysfs entry\n");
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

