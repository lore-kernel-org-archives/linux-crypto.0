Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D423F39D1
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292653; cv=none; b=jHiGdzlLP64bmj8GR+8bBATaISSIDsXUO7cy1OYGLOqavwQyVUF0alUdZR0Z3vSW9JsYH803yabBEtw4+jMXHUTkrifOo1+QxHIkGGzT8WCDx631OMeyAj2ACBEfGe7NNlaq1HWm+bJCXTpoSNZICoLNlaNav9vK+YfFwmS87X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292653; c=relaxed/simple;
	bh=GcT4179KEn1MmyXneciyyOy4CZWvu0iEu43IoD6Z7v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=seeH3NR+DiaUv8TFEHFhWa6+iMwD6UswlgqIk+siE6URaMmNRdYULeTQaGpq+1KNKu4KWPgX0KO2Gt+du20OYx2Y+K+rcUwy/zxuQbr3+d+zJUFbvEnlJkU46K1CuRYc/ED7aPckMmN0t+8ZCIUJ39U4vkdQzUNPD8MBBcKP4xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfg9BhpI; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfg9BhpI"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48e69e60063so4651505e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292647; x=1779897447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d00Co/CPYFX5ZE7rQHh1/lw+DiNtp4wsDbvq3jgMwnU=;
        b=bfg9BhpIEV1O5nTTBchU0I53Qigv+0GXX6B5Yed1BlNU5/Be+eqMGfybxxToMyTjbt
         Ssu+Xdw6u73WjHV64KQ7TWJ6X6fiIjiYyAReshHyd3DOCmQfTySi2sylL9bG1wa2gzOO
         RzVl+v5WhvsZQFugAIGOV/dJtsMTEvVOYtPkYVMB/6st1eIQKFxwr7zDkpIrb0lM0Hbl
         fa/vNFt6H9tOhDiZ5YLHiw0QRP3TS01ADhtt3E4pqRwrFTHUWc7jQweV3jm6el1FzjrV
         zzkdaCgQvC9uJCyJzrulxLbG3+A5OX2+ZhalZss7Mf1uAToxrZ6/cnxYACUfPM9DIbrn
         VV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292647; x=1779897447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d00Co/CPYFX5ZE7rQHh1/lw+DiNtp4wsDbvq3jgMwnU=;
        b=iH/YEzo45DqFFL4Xva5auKV+3Czu4qfrA5HBiYco4rcbRulUA9pj6Pt+8xcalhu/F4
         puSWM7LWS+xckO1N1yDvMX04eMOmisjuoFpy79VOnWseedFoCwJvqN0mjKPZboPcK67o
         BAjA2Zr25nVPru54daQz7osC5lkyzfNMO/xnP00e/PI5yluVUWEe4s0zBsX7FwnN0vlz
         Nau06FroMSoyabHli5C5E7bndCHqeOclfTwutD3S4YMTqDtuyfwpgfLTFlDwd41KcJdX
         78jig5EmMgGcGxYOEL1wIel8Ewsww8LHo56BbWWyBaOp17GsCh6SwHi1aEnA4zrDtwwU
         vK/g==
X-Gm-Message-State: AOJu0Yw59dyXgtluFVceizJ3RmfFkq05WhY/ktaTJXWE5A+U0XYYBSJz
	/iKbnsWBeBdqzJgEbGjCP5yA8Fb0ot9IMFEER1CQUWKEEmWjPEEimKTx
X-Gm-Gg: Acq92OFoYBr4PvwcvSt9981uulVwt9uBhkKjJT1j4hmaELNqmbq5jRTGnWpsIdwG/Yg
	v21q0ltyD62ft3/6dumoQptsc5//cBaSJ+tkdvNjG+cso725FV+OTJqZ+4m5/wWUqelrSyHsHLr
	FbPgGKgOx9MIgABe2I9lKPznxtRno5O1BbE8VOoyMcHQnsvo2N+oyENlZz67upIplM5lZSdtpP2
	TidZ2fQhPG+4gOlllyqu2+r9RJ7lRdr2k0t6wuNSxbiUW9jNXe6CLKI8LoHcQxwi6OdWshMUJWB
	3qeOxHVykYS+dRxkYoLu7MQHq5Ppe8iLxjZuOlGNPVZYhL7XGMswWEH6iDHSHkcQzyZjGGn6XHZ
	ZVEc8cjvK+U2Vv2PbCMicaRQf8sDoxQIrhi+g7hkBziv/Rrcbk39ijxtLpoyMuRqnUGnhpqXZWY
	jMWvrsBPspQg5+KnKZ9WYMVgPcXJDcdcojDbGxgymhZCN7i0J5FA0t570R383478o=
X-Received: by 2002:a05:600c:3594:b0:490:502:8422 with SMTP id 5b1f17b1804b1-4900d55ec74mr107484465e9.6.1779292646691;
        Wed, 20 May 2026 08:57:26 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:26 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v3 11/12] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Wed, 20 May 2026 15:57:02 +0000
Message-Id: <20260520155703.23018-12-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260520155703.23018-1-l.rubusch@gmail.com>
References: <20260520155703.23018-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a non-blocking read operation is requested, the driver dynamically
allocates memory to track asynchronous transfer status. If the underlying
I2C transmission fails, atmel_sha204a_rng_done() logs a rate-limited
warning but incorrectly proceeds to cache the pointer to this uninitialized
buffer inside the rng->priv data field anyway.

On subsequent execution passes, atmel_sha204a_rng_read_nonblocking()
detects the stale rng->priv value, skips executing a hardware data read,
and copies up to 32 bytes of uninitialized kernel heap data from this
garbage memory pool straight back into the system's hwrng data stream.

Fix this information disclosure vector by immediately releasing the
allocated asynchronous work data buffer and explicitly clearing the
tracking pointer context whenever an I2C transaction returns a non-zero
error status.

Additionally, duplicate the tfm counter decrement within the new error
path to ensure the reference counter is properly released before executing
the early return, maintaining the driver's availability for subsequent
requests.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index db61ac0177f6..b51031ced7d1 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -31,10 +31,15 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
 	struct hwrng *rng = areq;
 
-	if (status)
+	if (status) {
 		dev_warn_ratelimited(&i2c_priv->client->dev,
 				     "i2c transaction failed (%d)\n",
 				     status);
+		kfree(work_data);
+		rng->priv = 0;
+		atomic_dec(&i2c_priv->tfm_count);
+		return;
+	}
 
 	rng->priv = (unsigned long)work_data;
 	atomic_dec(&i2c_priv->tfm_count);
-- 
2.39.5

