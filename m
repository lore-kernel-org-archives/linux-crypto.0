Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F1630AD0A
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779035298; cv=none; b=VFRLxUUh431nDHxWzL/SWdAUzXPLOCzAHOU5fpOL4ktwbSF7PTbKL1PITsAqLT7bmS14IT/H9kPkZoOlKIkm2Zt/oN4PqOlgZal3CR9IaNAOnixxP+0OF+ErK8OaeK/G3iSXCAO3R+/N/yTP42ilF20GCiNICDot8FuIeCDx6Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779035298; c=relaxed/simple;
	bh=edBBxxv1poLSjMB8ohIHerWYeMF+vu/6TSkucKR5d08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mpRvi/xvr1DT1mjZtSWr2mDgrr6KRxgJrkydKYzaC0mtu4MJ/WYY5JkgE6RLjfbdH8Cywvy9EY6B69vyJ2Iglaz77O2GpXuCXsgwE24B1cvtOmtiu0H/gfdveCtoGsl7dXNg6FwOuKpClPZhbWyNGykj+RpSrb0NHB4qPfQyeWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rXy10ZkO; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rXy10ZkO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779035285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OwzbtTTYqiL4pShWiGkQxPeTW1obh95IMjB2QL15Rp8=;
	b=rXy10ZkOEqCQDYX2v8Vi3hfLe+jx5GNQok4yZq5qUYzdaeep1y4+Q7Ep9NGDf/bArE32ce
	G2CAhgid36ysZoaD6yqSOrtT7vKyZrCkFnCW9Gc6ouu7LEv7yu5kvQrC14DuH4gbtWpxcv
	XUX1NMWAuzRTsfkJClUhs7bjH5gfigc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>
Cc: stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-sha204a - fail on hwrng registration error in probe path
Date: Sun, 17 May 2026 18:27:40 +0200
Message-ID: <20260517162740.1250-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1483; i=thorsten.blum@linux.dev; h=from:subject; bh=edBBxxv1poLSjMB8ohIHerWYeMF+vu/6TSkucKR5d08=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmcb2rUm7NZGP7IlMtLr1APUWjtXP1c6NmBjnqx8zz5E zZ3rcnrKGVhEONikBVTZHkw68cM39Kayk0mETth5rAygQxh4OIUgIk4T2dkuMFke3GuyFuBVvew dtH9z7VfLg8Sjb4nJXKpY3LUF/OGNwx/hVWXbenaNdtQ/uzsyH96vVPevG4ICGk/4OB+3VYuXDm YAQA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
overwrote the hwrng registration return value when creating the sysfs
group, which allowed atmel_sha204a_probe() to succeed even if
devm_hwrng_register() failed.

Return immediately when devm_hwrng_register() fails, and report both
hwrng and sysfs registration errors with dev_err(). Adjust the sysfs
error log message for consistency.

Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha204a.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 37538b0fd7c2..12eb85b57380 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -183,12 +183,14 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 		i2c_priv->hwrng.quality = *quality;
 
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
-	if (ret)
-		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
+	if (ret) {
+		dev_err(&client->dev, "failed to register RNG (%d)\n", ret);
+		return ret;
+	}
 
 	ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
 	if (ret) {
-		dev_err(&client->dev, "failed to register sysfs entry\n");
+		dev_err(&client->dev, "failed to create sysfs group (%d)\n", ret);
 		return ret;
 	}
 
