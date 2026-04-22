Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B5D365A1A
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 21:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776892196; cv=none; b=mHTsXulcUSMr0FRUZ008lXkc20YutCTGI324A39sp6kF8vWrHmXLfefh2dm2e+w9FmyHzVsQoXAUcFF6yImieNXw9nEQm7B+PRyID+edm91xKBhIsCsRJWr1AnhbT8vOb6HyLgxreLBGMPXSq/1EobAStXBXnFZyVoIn9jW499w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776892196; c=relaxed/simple;
	bh=fPUaGhBV9y5Y+5CqPe9ESQSxmwi2xQpZVeZbeoJlQuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EpIgr+vyZ/WCttvh0sCzP/rM3c32p6BRIp5U2iGDCh1Sj8C+WVX6XUyKMF+6W7RNtRi1pn5lgHOrewaBhJTZHnD3gAo2km2hnE/WwBr+LydBdXGusO+bROMeijKwywoq2m8CYVQd97AFzzMKiB/1MJ2z71Do4DgN2PYmYPzCPaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cL8BQ+LP; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cL8BQ+LP"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488a8f97f6bso10996715e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 14:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776892192; x=1777496992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qHDnqtZPzLje7acSFaV39CbG4kFW6b0D4B/rafiqA78=;
        b=cL8BQ+LPcLC0EFK5+p5xvzMD4/8l6dPWKJ3kgmiMDMOAy6YJUWADOM+5GKA76z7hgl
         juaydtZmqKp+X47qbH7pLEYia62nTL/kHmdL4ANnUnQRIMH8iwL/pJlSIGUf3Fjo+QRP
         hsWlyprypIRmHagA3k5PYlFZIXRfqD9jsXDqPItmjrGGmBKm0sulG+fdmyAqKC8tG3o9
         YWx83GZPmpXsLyCNzPBQC1DUCTM3a+wgZtTeX0FgspNHHEfW9wQWxkgYghNe48ZGUKzI
         6bvDbYBAcnWlKhC04UJmXbwm3PtgHqI5cv7LG+f5gSAryWA9mSb2Gothu6fzhfMA4Ji6
         c07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776892192; x=1777496992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qHDnqtZPzLje7acSFaV39CbG4kFW6b0D4B/rafiqA78=;
        b=IvQhew09bfL3IcL7M9i1EHFPA9N6CjPsBmXkHm2nRLabhAf0nMaTEIUvLBIB7h/rdX
         Y5SRYCld2G2ta9/4+U3gDjGEKgux6DpQox5Zx27yNDeYFfhR89KpwotvHgbeeVmJZui8
         ZpP2I0Fm55lXZe0j+wZKw1vbnzwA3jnV6an9daHKPDLG1RmE69f5qrxSX7VtAUNdKgVF
         S3E7t+rsNhF1qoT+8gkTlEfRG9P2DvRoWm/RB43+0RK3LzN81G/LGowIb+9qlTgbuepR
         NA898jUlCxRR+2tP9+qltn+3k1bdhw6dGjzpZj2n1JFcY6h9VA/L6QXOKY30WbXsw1PX
         v1xQ==
X-Gm-Message-State: AOJu0YwxCJrFHZ7tLf83TCwT1Ty/lEcRiXdINYq841RfXkHjQz/Vulhj
	x/I+nVeBNwafLOB1uBFzrJKERIO+DG4zmCPH+CI+H+tHUzDJPNpdnNt2
X-Gm-Gg: AeBDievkyBrP6TwYGTyv4460CDh/jVgopS22j+YQ5BzqyfeJsEml6F+jhX+OyUOKo7+
	dRYN1KyhAT3OaCE85DaR80tOhWPZDGnQu1Z0+MiSOkTg/dQTta+xxA4D64/6ygGBWqBmBA+6h3s
	+e5B7Yox6wGRi+nIv7wqyJm05g+RNrQsv0j7HFom4UE7EssbPuvFc4TJN7TohyGN22Uls3oHgWl
	FsDODgSXS7igEHbzhOTpbipoWTsaEPh2wDYLOyMM8lXcE0DPUTWOlCtTh5RYSbf1/MuYjxBJRzV
	Nz7+47P6Wn3LiGiRDrgkR3ATRt3mzcrgnbODctKV26FJjr/bzr7AR2JmdEyzkq/5sA3TDIy1uCt
	hKyG3/Nerr37IZNTH/hAgbAbg7R1wyIuSd+0vm8x2rTdsH0JKl4o3MvK5579NEizl+ErbIVpg4H
	NVeeclNiejskY3Y25swB+WDDwrHpFC2kzjKIZd2jG8VNCVFDD1YmBMXXSXEfgZ0bsw9tvUoACng
	W/lWKbmW5Gz
X-Received: by 2002:a05:600c:4ecb:b0:485:358b:e7ee with SMTP id 5b1f17b1804b1-488fb6e1addmr189465975e9.0.1776892191490;
        Wed, 22 Apr 2026 14:09:51 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a4b329542sm352469085e9.3.2026.04.22.14.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 14:09:51 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
	thorsten.blum@linux.dev,
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
Subject: [PATCH v3 3/3] crypto: atmel-sha204a - fix non-blocking read logic
Date: Wed, 22 Apr 2026 21:09:36 +0000
Message-Id: <20260422210936.20095-4-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260422210936.20095-1-l.rubusch@gmail.com>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
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
index f7dc00d0f4cd..04cbf80c1411 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -33,7 +33,6 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
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
+		memcpy(data, &work_data->cmd.data[1], max);
 
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

