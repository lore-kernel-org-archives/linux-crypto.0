Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389F937F72F
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 21:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774301293; cv=none; b=CJ1rwc148glWARqMEzr2mYoHM6aJnwAbr27G8vGLjT0+QV/6XSAUb3lvjmOvSi4mxTfntbU5V87QklALjxOa60RRXelXaJFkADddnL+GX2tBe2Na5QZCL9cLWD8jFLYUvtzccm8vyElZXmtL48UdSZOejk49Rdbk3KHuHNLH/3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774301293; c=relaxed/simple;
	bh=qTQRJLJNAq8ElXyosXgSrnt5ksvp9QO20t4c2pOQpwo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J3MYthUsldi42mprZcnsV6YNFbrUyc2KR+T3HdQmJFHAv2vPLD0zXTNa/61Cspc0pFKBB+rrQtUJ3odwnoRBwIJWd6nL2YAcAlHzn8oJWeWNQucOAjVHFdH+rFpzlk6iE92K+LVEvFAu2WkaBAKuEwPphw5wUs+E7wMZuT49a4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mtQUz/X1; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mtQUz/X1"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so6043315e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 14:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774301291; x=1774906091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kj7GWfvFlt9NmwOl42exx2Iv0v0a3deVWNgthIQl6k=;
        b=mtQUz/X1Nk/ZnCuFdjd5zQHprTbxeepIzdzJXiaDoPyTLQK/Is+N0dhZGb1ynZ/7hN
         K3xoiy2xqhwpEnWbiySgMtFThHBYidJt0hAW8OWvr+p8qcEhWYdngeSbC+EpiDopUtzY
         Sut871dcp+TRyJeEBNVQl5VTDdkavq8Y24AWXHlotbjaM0qaccpz+/6guuC7B6MAw8tO
         XHYhuwpFUCdR5Or7QZ7sMSuW1xLjuyZnYsvll5/RaNAjoLOECAMilGXLQRmxuIfPHUTC
         SLn4AcoZFcLtae7S3w1Q5ispARYJxJqIBT1/35ML5Aju71MNFE1l8vUjfrbe0USTPt5a
         pM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774301291; x=1774906091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0kj7GWfvFlt9NmwOl42exx2Iv0v0a3deVWNgthIQl6k=;
        b=F1wzqWi+nEWVuzSZ/V4rnubRqMaiykMOU0MZQ8iKus25V+NLQO4CUSveaNYRtlK4Hq
         d+z4UlPa40L3bLT8AtpxZWZSm45vmuxzuXlEhWpxsi0n3dqdah7lXIp05BHiZjcsBYM2
         vlSkmydajmpiMcg5HUnPjfQEWfSC4GOLNMTF59pmkr61FKZw8AozLS/PYNjIIHRKLdRM
         VeWEBgeYsVAYGODyBSvV4EQPAewJ31fjqfzbBUHVOjO2IbaGkTU/yt/Fnl9RPyBP1eWx
         KCRdQ6jW34I2kg+q1i4bvonfyhZvRFyvYVvDX6sX3yyu+rAgSIXDTuaLa9bQPFqoegl5
         /w5A==
X-Gm-Message-State: AOJu0Yy0s1qIY9YgtMjUCr2qzcEJvo4IW+yjGy+HVicTXF3AY1W1zfRW
	p9z62m6Rg2I0JWdVKCgEkmrCcxkiErgQU0FMTa8X49qFBTNC4HI9R+2R
X-Gm-Gg: ATEYQzzvU6Pwj1tOWfyo9Hy3qPD1jASc8lTMX5soYdSGZvEUWD6sogG4Ov0fdoG1zNr
	hf2QFKHpwol/wHl8Zw1xBqWrNUF5670+DfLAK1Y1Gj6qzbAfjG3tCbsyRlk/vLZq58TZaAaCA1k
	Dov94D2kYSi7O5UmIoD5tmi6KjlWw96Y3efCq5hmzRgwbY4OOZvB5WpowgavFM2lgNcWnfAavyo
	+fVt1L5J0tCY1RbwoazU5BhsHc3igCuQUz+zFt8mTFgeWNc4SOLBgTLJM2K4dz7ZcHyyhkyhiJ4
	BBA/lzee/ABUuxGSdOOgmJTarnr7KkdIiWQb0LIO0VSbfzWKEnRHLJrKF+qd16Q+aYPHQmlaiJK
	Db22CIPexiDpUXxdr3dRyr3J2DP+PuaEMELqiW19jhFXm96KxTBQyK3JHDCWtr/gU9Bl6aQ4HL2
	M8AJwUsHCB+4/+5iqnLtzKFBcSI946ofXboSPFaogpQcZn8WrPH/4PH2SYP19VptA=
X-Received: by 2002:a05:6000:3103:b0:43b:6172:91d2 with SMTP id ffacd0b85a97d-43b6427f665mr12174742f8f.4.1774301290400;
        Mon, 23 Mar 2026 14:28:10 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6470393fsm33386975f8f.17.2026.03.23.14.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 14:28:10 -0700 (PDT)
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
Subject: [PATCH 3/3] crypto: atmel-sha204a - fix non-blocking read logic
Date: Mon, 23 Mar 2026 21:27:55 +0000
Message-Id: <20260323212755.687342-4-l.rubusch@gmail.com>
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

The non-blocking path was (also) failing to provide valid entropy
due to improper buffer management and a lack of hardware execution
time.

Ensure cmd.msecs (30ms) and cmd.rxsize (35ms) are initialized before
enqueuing the background work. Fix the data offset to skip the
1-byte hardware count header when copying bits to the caller. Correctly
return 0 (busy) to the hwrng core while hardware execution is in
progress, preventing zero-filled buffers, which was the situation
before.

With this fix applied, tests will look similar to this:
$ socat -u OPEN:/dev/hwrng,nonblock - | head -c 32 | hexdump -C
00000000  23 cc 42 3c 90 b1 38 fc  54 37 35 4b 09 c5 e1 0d  |#.B<..8.T75K....|
2026/03/23 14:30:18 socat[858] E read(5, 0x55be363000, 8192): Resource temporarily unavailable
00000010  73 3b af d9 02 70 76 bd  2d 59 4b 12 01 ac ae 2b  |s;...pv.-YK....+|
00000020

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 350ba8618c69..6700847c56a3 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -32,7 +32,6 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 				     "i2c transaction failed (%d)\n",
 				     status);
 		kfree(work_data);
-		rng->priv = 0;
 		atomic_dec(&i2c_priv->tfm_count);
 		return;
 	}
@@ -49,20 +48,19 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
 	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
 
-	/* Verify if data available from last run */
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
-		max = min(sizeof(work_data->cmd.data), max);
-		memcpy(data, &work_data->cmd.data, max);
+		max = min_t(size_t, ATMEL_RNG_BLOCK_SIZE, max);
+		memcpy(data, &work_data->cmd.data[1], max); // Note the [1] index
 
-		/* Now, free memory */
+		/* Free memory and clear the in-flight flag */
 		kfree(work_data);
 		rng->priv = 0;
 		atomic_dec(&i2c_priv->tfm_count);
 		return max;
 	}
 
-	/* When a request is still in-flight but not processed */
+	/* If a request is still in-flight, return 0 (busy) */
 	if (atomic_read(&i2c_priv->tfm_count) > 0)
 		return 0;
 
@@ -76,8 +74,14 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 	work_data->client = i2c_priv->client;
 
 	atmel_i2c_init_random_cmd(&work_data->cmd);
+
+	/* Set the execution time for the RNG command (from datasheet) */
+	work_data->cmd.msecs = ATMEL_RNG_EXEC_TIME;
+	work_data->cmd.rxsize = RANDOM_RSP_SIZE;
+
 	atmel_i2c_enqueue(work_data, atmel_sha204a_rng_done, rng);
 
+	/* Return 0 to indicate 'busy', data will be ready on next call */
 	return 0;
 }
 
-- 
2.53.0

