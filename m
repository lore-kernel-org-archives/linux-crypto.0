Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEE53A16B6
	for <linux-crypto@vger.kernel.org>; Sat,  9 May 2026 10:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778321547; cv=none; b=sfrUD0meZbCN4b3Ry2WnaToil4sGU+9LNXTWBO84rxT6b/A4Tb/geZ1onWfA3f5NLm+btl6sescyYgd1QFx3MFN3dsA0+BZX/83CIyjRtsjWhKkZOY8eqy+s9g17QDnzIoEfOjRrdtOTy7ReIUVnRUM70PBWubpSaI4P6rA8VAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778321547; c=relaxed/simple;
	bh=QgJ75jFnjL7d1sl4OoWG5P0JzmlOcIc6pkH89CkMwNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcuVnIb94dwDTQ7jSfKjv0pJBO76Zia2FVKwB4/3PeSx/GBIwsbjKsWziknVvWo+fNP/vcvCX+erOflX3+8VsiiTjNY+Nowr9AiQzJZbmHDg8vSnYeVAYtZD27h0ubI0Bhv8qz9TZsGGKiO2Z6g2skOVt7InaXgUk9/mLVR6zeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pp8/aych; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pp8/aych"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778321543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b5fZ0Pbkodc7PSHQ6BqzpKM2cdMLGYSys0q5hgxO3YM=;
	b=pp8/aychRiUvzmEmRbLPvRbPH/399vrW17t7CkmSDUVjkXvEgKJdfq0Cf3/bhXX/D2ypA8
	Y+mKA93XxkaRBo2AxXJRmblA0nwnjeRPnqOa2gIjRu7pVgsQgqLAzRUiOMUuMDBAO0fZGR
	LXf5rDgWrMpfbp3Ot81yUqVgm+xStPY=
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
Subject: [PATCH 2/2] crypto: atmel-ecc - drop CONFIG_OF guard and of_match_ptr
Date: Sat,  9 May 2026 12:11:56 +0200
Message-ID: <20260509101155.2095-4-thorsten.blum@linux.dev>
In-Reply-To: <20260509101155.2095-3-thorsten.blum@linux.dev>
References: <20260509101155.2095-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1372; i=thorsten.blum@linux.dev; h=from:subject; bh=QgJ75jFnjL7d1sl4OoWG5P0JzmlOcIc6pkH89CkMwNk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJn/OQoP/LjUcEaOkXntm20ulZ+mViu8vsZ8UEn716fJy w2/r3h7vKOUhUGMi0FWTJHlwawfM3xLayo3mUTshJnDygQyhIGLUwAm4niE4Q+34LrXcfxHPc0b LvzXff2F/5CukaaM2h2D3XMWb1x8T3AnI8PlY/diF76f0q24eyfz9DrDGUtUQrmCrn4WUCiIPt+ 5Yy8PAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Drop the CONFIG_OF preprocessor guard and remove of_match_ptr() because
OF matching is stubbed out when CONFIG_OF=n.

Reformat atmel_ecc_dt_ids for consistency.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 3738a4eb8701..c15096676ac5 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -368,18 +368,12 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	spin_unlock(&driver_data.i2c_list_lock);
 }
 
-#ifdef CONFIG_OF
 static const struct of_device_id atmel_ecc_dt_ids[] = {
-	{
-		.compatible = "atmel,atecc508a",
-	}, {
-		.compatible = "atmel,atecc608b",
-	}, {
-		/* sentinel */
-	}
+	{ .compatible = "atmel,atecc508a", },
+	{ .compatible = "atmel,atecc608b", },
+	{ }
 };
 MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
-#endif
 
 static const struct i2c_device_id atmel_ecc_id[] = {
 	{ "atecc508a" },
@@ -391,7 +385,7 @@ MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
 static struct i2c_driver atmel_ecc_driver = {
 	.driver = {
 		.name	= "atmel-ecc",
-		.of_match_table = of_match_ptr(atmel_ecc_dt_ids),
+		.of_match_table = atmel_ecc_dt_ids,
 	},
 	.probe		= atmel_ecc_probe,
 	.remove		= atmel_ecc_remove,
