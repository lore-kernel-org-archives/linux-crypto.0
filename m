Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C0D37EFE5
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 21:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774301290; cv=none; b=CDwZXYuQiutXkT7dI4eaVz5yCssRWJn5536YMV83By9hAJlcBWqJr5NosFBiksqa+45gmQcBzkBEm2CErhqMhquo5sfvEh7cazFCSvD0f3VNVBk/5nLj6nNw29WBgXd4gW1dpi7Z/tTIDKdIPO2+jpVKIyEkI8NgRmBPp9ltRhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774301290; c=relaxed/simple;
	bh=+MFZd/jt7u0zU2651JBWCrMkeie7unjKau5SU/tLqPs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PtrFyaKESz4UHcfX27QF+3nFzXCxtR4bInnGFoCAAzpx1Y+GGNWolPxitXD7Go3z7aHpr8jLt0HnQplA8UKd1OeCRQJjXN0NcAwt3vht/f47c2ufcjAVlV2ESqvTTWqtId1QsayZKY44E6wA+OBR4gBhNH+gA6uiVkm6VPuamRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rTIqhOci; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTIqhOci"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4853a485721so5560705e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 14:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774301288; x=1774906088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JYhEh1fUyIpN2Nz8LjN/J6gClgKVHGYq375zHFqaMk=;
        b=rTIqhOcimSdlxe54Kr4SGo7SOJ4z6mwwz4hulghritjro5r7lLwbNDztGLebC6h/pg
         U9JJYRBfNXSQJd0m1v2ON5vuvOdizceZwD4+uV6LPlKQUOLQIX0eLrDpz1DA8lGTtf6h
         NEu6ExWZAyK6satEYlQzpVPi6e3St2SnIn5BLr1JdwFXBa8MmSuqTxG/C69YFCjOtLWv
         WHjr1U6tBQWw0L1hTyRAjnFsA0aPcdZ4qUYVlX3Ue1SH8ykqOlsZu1hIII90L3T38UNV
         rR+Eai/iWrZM32g5NpAv2vA43AFocglzmTvuuspdzNYOEQbvG66B3Wt+TlvUAKid+f1N
         4LLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774301288; x=1774906088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0JYhEh1fUyIpN2Nz8LjN/J6gClgKVHGYq375zHFqaMk=;
        b=cFxnHWCK4iKEaUenWwEMku+uX3GcDIap95InFRea1wg7thb5TKPfvwR1kClKu5v9rv
         aq9tdhA+cyfbEaljvVxtWHFeazaB9yE1D9rXhMex0p3XfkC5RbAvIaNPHNLeCm9VjABT
         z6Xl+fIIqPMHZ00teaQ4J7CLSbg6FZIjdVR6vJIs3Xh6G5UdTJli8DxpOqpaaw0sNrjk
         sgYiZ7KS9kuOmjP6LG8mL8LIzgPqRz0cssGQvk5QF9Cf7fd40iUn3a99FBH9ehUjSfJZ
         fgO6MfSP2usd14bblqCBA7LcHPe1XFOnwM2HpoGsWTGbNkfAwQk6WOnjxz2AtrfzOAky
         fKeg==
X-Gm-Message-State: AOJu0YxM1zjSIlWJRszHt425jIPWHJAtyOMuu2riekn53cLS7MQuMsCH
	EldCf4y5f1UOBTcwPk2m5sKZttHotuZ8JOPnhHhYEsZ9FgBtogSVh5ul
X-Gm-Gg: ATEYQzyz4YBdH1W/mv1n3DWyxFWNtDuCdwFRuXfyshOFaqVbtMexxOMj41ZK/3ShfRn
	UEepiGnZVmI0oExpY9nGN9cIhUSfar8YyVfbji8biUMT7H1IeLXVFKQla9lGMOfvozR+ajrI6wc
	D08MqLk50Mpwzqh1e2cxq0oasOQ2V8WSRkQGKZDYPcYxYw/En6cm0qWdYsgplt83b8teD7cjxPo
	gFRC5mJ9WkOoQ9Lp98vhWySFZi1p9JtJpH6z+l/aXMJ0uVMTREdpo1R7nNHHL3WQIupMdFV6VUa
	ameVlG9ZS72fAd5Yo485DvfVe2LxPPID98RT3ZbReqx0oWYmi03g7LuWbqS+efeuH+dAGAPSroM
	tv6y/RNi/iNbmKBI5diCGJSq+lQY4k2IzWMHg6t/5USz0M/Cv+ZqaZ/H0yE1c/MEvZ3TOS/EJ5y
	Tewo72k2ukciYcL3XbbdkeJW0sbWEXJMfFtGBD8K3+//B2/32QZvWnrXnBQkriEcw=
X-Received: by 2002:a05:6000:4007:b0:43b:4e32:c2a6 with SMTP id ffacd0b85a97d-43b63fdcc61mr10787942f8f.0.1774301287519;
        Mon, 23 Mar 2026 14:28:07 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6470393fsm33386975f8f.17.2026.03.23.14.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 14:28:07 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH 1/3] crypto: atmel-sha204a - fix memory leak at non-blocking RNG work_data
Date: Mon, 23 Mar 2026 21:27:53 +0000
Message-Id: <20260323212755.687342-2-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260323212755.687342-1-l.rubusch@gmail.com>
References: <20260323212755.687342-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver allocated memory for work_data in the non-blocking read
path but never free'd it again. After first read-out the memory pointer
seemed to be recycled and never was allocated again, due to some errors
in the logic, so that the leak was not growing.

Add kfree(work_data) in the completion callback on error. then add
kfree(work_data) after the data is consumed in the subsequent read
call. Finally ensure atomic_dec() is called only after the data has
been consumed or an error occurred to prevent race conditions.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 44 +++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 98d1023007e3..1baf4750d311 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -24,15 +24,20 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
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
-	atomic_dec(&i2c_priv->tfm_count);
 }
 
+
 static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 					      size_t max)
 {
@@ -41,31 +46,36 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
 	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
 
-	/* keep maximum 1 asynchronous read in flight at any time */
-	if (!atomic_add_unless(&i2c_priv->tfm_count, 1, 1))
-		return 0;
-
+	/* Verify if data available from last run */
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
 		max = min(sizeof(work_data->cmd.data), max);
 		memcpy(data, &work_data->cmd.data, max);
-		rng->priv = 0;
-	} else {
-		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
-		if (!work_data) {
-			atomic_dec(&i2c_priv->tfm_count);
-			return -ENOMEM;
-		}
-		work_data->ctx = i2c_priv;
-		work_data->client = i2c_priv->client;
 
-		max = 0;
+		/* Now, free memory */
+		kfree(work_data);
+		rng->priv = 0;
+		atomic_dec(&i2c_priv->tfm_count);
+		return max;
 	}
 
+	/* When a request is still in-flight but not processed */
+	if (atomic_read(&i2c_priv->tfm_count) > 0)
+		return 0;
+
+	/* Start a new request */
+	work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
+	if (!work_data)
+		return -ENOMEM;
+
+	atomic_inc(&i2c_priv->tfm_count);
+	work_data->ctx = i2c_priv;
+	work_data->client = i2c_priv->client;
+
 	atmel_i2c_init_random_cmd(&work_data->cmd);
 	atmel_i2c_enqueue(work_data, atmel_sha204a_rng_done, rng);
 
-	return max;
+	return 0;
 }
 
 static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
-- 
2.53.0

