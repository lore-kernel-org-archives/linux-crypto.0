Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5AD34D922
	for <linux-crypto@vger.kernel.org>; Sat, 14 Mar 2026 19:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773517103; cv=none; b=F9aZ20zLClFlywt62iRi7HrkIYwCcrL0/UJmqBwLDcan8o9h9nOzwvOc6H9Su+x6hb82tprLL4hA3V9Cuoy1a9Q/vWbHh4cPvTV3+wE5AXMzs5CL+XjASH3aJSnCybzgPdhXYNYHVo1FQveToowFm7eTZDsJSr7/ThO3uUiQu2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773517103; c=relaxed/simple;
	bh=BHatjBYmMqWDoVSJLpd9wA/cae++1PKscmXrKmMopf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hustd23rIFLQ4pEcUJIkz2gnlPay/gpPIqDnB8e8abJ+XFMq3vwsWKBp0PltjY1ZvuwihHTVtxKgVt2DBPwXZFEy2FOQ8rHAsiIKeAIdWExRlMpJ7bR3C5Cgw2CTmy4QOs4sPmiu7nloSRHC5U8JJSHtXikSXZ+I0IGTL0zUV84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A3V02oBy; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A3V02oBy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773517089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1y6+a9hP8kEfCSdJXdEzyPlBatUJQdOrQGIEsbPLPCI=;
	b=A3V02oBykMZFjJkvFdBTU8UsKKvRxTIgCvPWDEvhTMMlcsLr6W+uFUVAy9doWxfVVoecpR
	3I433k6t7LirJaul8QEZuRQQZ4Wa4+bLobvVZnbE6mI1P+qbqJBcb+4UMrBR37ih/ccmpR
	ni8Qqj9hk9YB7SGvUBLR6Z4sWicitQg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Linus Walleij <linusw@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path
Date: Sat, 14 Mar 2026 20:36:29 +0100
Message-ID: <20260314193627.728469-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1492; i=thorsten.blum@linux.dev; h=from:subject; bh=BHatjBYmMqWDoVSJLpd9wA/cae++1PKscmXrKmMopf0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJlbd+xedn693PdS6WdfZ39YtTi9wcJ6nYnS65CH37tEm 7jf3XdM7yhlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJpAozMrw+ZHPk7bm2vVHL /lQVZSs9aatY9YTVYf0kfY2SP+tMN+gx/C/Iy6tm5F/vv/FEorbcxh02qbenfN+3y8Hu9VuvmwV imbwA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Unregister the hwrng to prevent new ->read() calls and flush the Atmel
I2C workqueue before teardown to prevent a potential UAF if a queued
callback runs while the device is being removed.

Drop the early return to ensure sysfs entries are removed and
->hwrng.priv is freed, preventing a memory leak.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Unregister hwrng to avoid new ->read() calls and then flush the queue
- Drop the ->tfm_count check and error logging after flushing (Herbert)
- Link to v1: https://lore.kernel.org/lkml/20260221190424.85984-2-thorsten.blum@linux.dev/
---
 drivers/crypto/atmel-sha204a.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 98d1023007e3..aeadbc9a2759 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -191,10 +191,8 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	if (atomic_read(&i2c_priv->tfm_count)) {
-		dev_emerg(&client->dev, "Device is busy, will remove it anyhow\n");
-		return;
-	}
+	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
+	atmel_i2c_flush_queue();
 
 	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 
