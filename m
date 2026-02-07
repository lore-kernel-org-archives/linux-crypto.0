Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1AD3112B0
	for <linux-crypto@vger.kernel.org>; Sat,  7 Feb 2026 23:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770506991; cv=none; b=oT1RwjJEaqauTLjS9RFDvQrucTuEP/TPv3/UlMNSUtSTVwWX4Da6s/9Ie/6RFhlzNlz0r4WNYpUyQjlkYFVHoDhNbkrL3GkA72IOZnz4yXeRTTziBK4n8gd3BDTHE5LU5DsxvgbKKhkEsTdifQy/NgbAOmKFqWhJFap2SK/zP6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770506991; c=relaxed/simple;
	bh=S5LRtN2cYZxCPFq3clmBP5tySJGGhqx6JeYNKfllNzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p3dk/SVYWp2PaNvb4EAnCyL1I/vaRP59tq9QwHY1srTGOiTGklZ/pEqgMiRPSRs62nwQaU4EYQlP3dBrb2Gt7dBvNkukFWaaaO0foP8eo5R5P0yBImuEr2NADTBnq31lwWS/0mnHvqZhMEiMkplV11j7qajXStdPoQGwPVEn0SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M6guzDsq; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M6guzDsq"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81e8a9d521dso1180514b3a.2
        for <linux-crypto@vger.kernel.org>; Sat, 07 Feb 2026 15:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770506990; x=1771111790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v3IrltYgdwJMBJH6ZoHd1x1fw2BBLHq1kcsJPRiYpys=;
        b=M6guzDsqj2rhBsrgaMXqL3gp7WgKFSH9ntKm6EqwUxKjUmUeEPZ4wqtnVpFuex2j2r
         Y9c3dRKd2haThe43jZQ6rF4m3RCPWXnLYSsXW1MJBlkHsgoBCZwB5V8Jr/IhJfIyUiID
         /yLQ3AldObaSDnirLEQ++qjKUjf1aaRFLT2Dl9AP9IgCraSvA+neABwck76Xl5ypRQ83
         qXt2wZI2uXC3c2pzexWWMDt5qbuaoybh7ps6j7glAPIF3EY2afv5WdVOkh4plGjw8hbD
         p/Q1zGlGYlbiNW0Vnq+UhS4xXSEQMZfje8yi/RTjdllGY0l5LEt3us/hFJ0I2xG8bDJO
         MsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770506990; x=1771111790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3IrltYgdwJMBJH6ZoHd1x1fw2BBLHq1kcsJPRiYpys=;
        b=Gw6JS/d6tontjOnIsgzLnG1YuMxDceEDRl4AWN99SVeszYdLdTdWlxhHDZpqvzSPiX
         kF/9qOClaLLBWFy72x/EVKKyL0dhBVXU4l3XwpwDz6ddH3eWzdxXpNn/Ulo2dwLyGl11
         qzSZyQKvrbqsaIKsw860zAn5XGuYydsyjS+0biZgXt8HYRmfXy5TCoVobYi1T3jSYWEy
         9tM8kb6DSiXQtIfq7RhM1Uf5Gn71lDJxKLFKd0EwENdT8Prp9Vzpzn30hF5kbsfgqtz5
         qWTTkrrdXftFBgLCU5jda6ZzexXm3uDAOmIJ6yWV6ytJ7yq2rjA9xQdT3asLR4F80LYv
         A8cQ==
X-Gm-Message-State: AOJu0Ywe/Ap5Jv60SO1TPEUdixLHbhojjC3oaeA0EAtxqYr7rBZWokoK
	HsttSCY7e+6VwN8CCWNjH4HiH8W+GvYcxNC2M3OIHJqOZRsGsrBGW5zT
X-Gm-Gg: AZuq6aKqAqWS68K7NN9rMVxJRDHQKWUodEUqDUpyf0XlLu0q0zDNCYarZHhuZNxXaew
	N9auTTFKGDP68x8bypRdXQi/SVVMcua8TbvPSR5AfPO6cA/a+x/9yGZBKwYJymlHJbbf/lsRRcr
	vIhtdjh5VnCwOnAX35zJ0duddDBzFAsc0UQksMYDI7R3q5quRaPAJ2hmTqHe40ddADzCF/5bCvP
	RHoSD7Bd3yIM5tRkApXlt0ioESz6LNUZz/Vih7SypJ69FsSLOZDPrJ6ugJaKW1QN2G3EbCsOko9
	a+KSOFmBn7bOndxnRCZ78r2Ja10vWBfUoW2QrV4ax1wbaZ8tnp9uVRgAvGUuCIjwXaDqsKQnMqM
	33EyG2j54tuwq+z58P7YWYC1BkBZR0PH+vJPVdcXcbIFNBBvrmPc7X1BWLEhz2Rs4jwSrAE+viX
	+buM90e1ZOc6g8roPmj+Q+UCny2vvNWYTOyb0lmVna7A==
X-Received: by 2002:a05:6a00:2da5:b0:81c:96b7:7faa with SMTP id d2e1a72fcca58-824416e485bmr6390145b3a.41.1770506990450;
        Sat, 07 Feb 2026 15:29:50 -0800 (PST)
Received: from fedora.domain.name ([2401:4900:1c80:515a:e2d8:fc5e:e39d:5717])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82459b1190esm2325739b3a.37.2026.02.07.15.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 15:29:49 -0800 (PST)
From: Rajveer Chaudhari <rajveer.chaudhari.linux@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajveer Chaudhari <rajveer.chaudhari.linux@gmail.com>
Subject: [PATCH] crypto: drbg - convert to guard(mutex)
Date: Sun,  8 Feb 2026 04:59:25 +0530
Message-ID: <20260207232925.80976-1-rajveer.chaudhari.linux@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replaced old manual mutex locking/unlocking with
new safe guard(mutex) in drbg_instantiate().
This ensures mutex gets unlocked on every return and prevents deadlocks.

Signed-off-by: Rajveer Chaudhari <rajveer.chaudhari.linux@gmail.com>
---
 crypto/drbg.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1d433dae9955..d52a7bd07322 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -103,6 +103,7 @@
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/string_choices.h>
+#include <linux/cleanup.h>
 
 /***************************************************************
  * Backend cipher definitions available to DRBG
@@ -1349,7 +1350,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 
 	pr_devel("DRBG: Initializing DRBG core %d with prediction resistance "
 		 "%s\n", coreref, str_enabled_disabled(pr));
-	mutex_lock(&drbg->drbg_mutex);
+	guard(mutex)(&drbg->drbg_mutex);
 
 	/* 9.1 step 1 is implicit with the selected DRBG type */
 
@@ -1370,7 +1371,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 
 		ret = drbg_alloc_state(drbg);
 		if (ret)
-			goto unlock;
+			return ret;
 
 		ret = drbg_prepare_hrng(drbg);
 		if (ret)
@@ -1384,15 +1385,9 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	if (ret && !reseed)
 		goto free_everything;
 
-	mutex_unlock(&drbg->drbg_mutex);
-	return ret;
-
-unlock:
-	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
 
 free_everything:
-	mutex_unlock(&drbg->drbg_mutex);
 	drbg_uninstantiate(drbg);
 	return ret;
 }
-- 
2.52.0

