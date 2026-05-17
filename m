Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B64133AD9C
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779021441; cv=none; b=AalDqWrDjHDNqi/KxHl9zWBeh7abo/tZBfuXwRRMvLqL/uusGW9EXkg0ODtEarIOKv78kXqlYLVQiKL5cVqlXHgrnIzdNyhXVF1gnKlZg6GR89cOhJFRHaZUtHtDGa2Fsz0Qw1To0Oj56YcOO6XOIRq33xBaaD9o6M2DhguVp+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779021441; c=relaxed/simple;
	bh=yIr3ddKu0XfiqPI1PUw8cCy/5rppI05Skg71kfhHso8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NvX16rKureKVWeojMx+VeXV9yOszFgb/WPI5IviXyGMH3CZUqU0zuUuV21FdO9ypMuf/FmFOYcI+zScw2XsvSJQn4nXy0geVMgW3X2fXldOxeayxnRqh+suDQydRRMlIML5p9p0xbXLUdannS4HfAyijv6PMxTHdNjsqmPr3i3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gT+fU88q; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gT+fU88q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779021437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=B+3cXlV3mYWAhcoAJ4yQz6I0dSdgiSUgD9AaORo5moI=;
	b=gT+fU88q/T7/ZPVmcUuWgxbjrl4XsDdYjnH00DpMS5APwxp+W0N/a7hdi6pmSxC8WG8mH9
	G02hOAROG/6trkWgDv4TnH5S3GkupW318Y2O3XZLPMY5jAF+4++uHaEpso81LNu9ECB8/3
	gahPuVeaHmBGwzhXYehxJbWwr+wDIBA=
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
Subject: [PATCH] crypto: atmel-sha204a - remove sysfs group before hwrng
Date: Sun, 17 May 2026 14:37:07 +0200
Message-ID: <20260517123706.1182427-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=963; i=thorsten.blum@linux.dev; h=from:subject; bh=yIr3ddKu0XfiqPI1PUw8cCy/5rppI05Skg71kfhHso8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmc24o2iuvESVgenGi1f+fp/HtTdFnrb25nzk88f+DHl KbH5izbOkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAivSwM/93PqEyvPDf39r0J a3TuKPbkMWhZaT4R8ws6qpbvk1nst4fhf+C/FdYT+bTqUq6qdvvarf177h9XhegT2+0bdVb+eLQ niB0A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

atmel_sha204a_probe() registers the hwrng before creating the sysfs
group. Mirror this order in atmel_sha204a_remove() by removing the sysfs
group before unregistering the hwrng.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha204a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 6e6ac4770416..37538b0fd7c2 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -199,11 +199,10 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	atmel_i2c_flush_queue();
 
-	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
-
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
