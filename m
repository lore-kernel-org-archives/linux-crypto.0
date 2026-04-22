Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78A336CDF2
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 21:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776892192; cv=none; b=Ion/pvmv7lkMQH2Qb93xjKqQKgSSeTu/GqoF3voQfyqgCMLexRGYbopnzdF6XCyaqYHBxYTcsPTEtCwDiOoUTPzgXIlcVnGt0CVHBcnjs88kZz/vkClxJkvxQeqrS0LEAKNMMUQOoH9gLxPRNfZTSbTWDFarumVjP+FSVdCu8Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776892192; c=relaxed/simple;
	bh=CWTfy5Lc1Yj5Iqo4EanzIFN6ZiyVeBIDFOhpC2O15bU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j3aw7JTf8GFyAZVfa7aUAu/exbw4QMN/fVAWKLAyuqfDdT0/dHasQStEImSEXNcG9qdQxDmXuHv2mXm0UE3ACHoLrcVMnVLTgNQK5eW5MwQvmbVqhGk+iYlUorcgy25G4CTJlW2SyvN+OvLdCEwsRSsnOgSfw8LAl3iMmrEPXgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dtd/8txd; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dtd/8txd"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-483708b697cso8624275e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776892189; x=1777496989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=clwVc7+iR/ZLUiHHguQE2LgazwMIBXludQgv/pgrOYk=;
        b=dtd/8txdlkNsRrEjM8IH7qLXdY741g+Lo8EQOjy4pLx6z5Eyrsl8YB944f9eSvdP3Z
         IjpiOmyuEgs9E6veGrZ5bvajcmzCNTDhvSxm511be2eLZcQDEofbGdrB0iIysLz9LoVn
         1FVFrCc2fcCiGAIWtsEbSVo4cAmhJ4jcRuSXJa2uIjzXclDMRUF6442oGOybRRGEfs9g
         QG5NaIndInwc+f59FtfyiCbRj6lKr0sgaYezJ1sgEGNtbsPhisx4A1+MebhsszhjpGyu
         3f4lMP/seNE8MzTkwfwwXubn8Zu3qTC/+cDLOobZvfi/Xf2JFqvvozjvV+C0hrv7z7eN
         4g9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776892189; x=1777496989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=clwVc7+iR/ZLUiHHguQE2LgazwMIBXludQgv/pgrOYk=;
        b=GHiEYEu07xP6K+mMe+tF2/gUCn2k1LnShC2Pigcxp5I0uG0Tq+jEjgZfL/lbuNEDDz
         UKbIVfQWQ/cxuyBIqf3+BC1Y/edli9O7uwHhXvvW4gQqt24suq4k72xbUTquqrzMazid
         bIsXrQ6mNDeJKxLFZpL2oPH250i7XXkvK8mP2K4OARCM20x6LjwpHe7bSYGDA9hQ8YMB
         Obdfzz2NRqt315LkBMrhxRCCvH8J//8yq1eckCYmJDppni0Ie/ipUNQFI5focHZ+y+Cj
         DGPFl6PN5E5iRl7nz9cTpz5iGQgaZ3tRagdFY03GbH6KLWTAY0RouYtTiaW/0DpP1Jm0
         +WtA==
X-Gm-Message-State: AOJu0YyGKOs2kOAagzXzXcFgO1IgNKsUuuWpG3UEyc3iSvCvZP9RlZgy
	nv2FFj+4H4MUCigTWHOnzGUMqeL7fx9xaK/nEpI2FXkKO98gDpFWf52k
X-Gm-Gg: AeBDietXtmpghh52ymWEBNe3irUyYRi7m7CuMCWFUKTDuaBh2f1cTUbRM5nHHlVBOhp
	7aU8H3K93vGTPMEvvWXQZ/oInlaAUbc8RCJikzlTwRP4ta4vS6PFTFJrSZ0lq+QuWfOLF4DKp0i
	tv2NeNwfJj0yGQuGanLnh5SzhnA2tY41/BCYe02f1d7ST+u0qT3GAjTK7sqAeq/mDzowIY572Gf
	Zu21yaJwzM1kTkKj2GuOWnqfKWqIfxT74eH7uKNMeEFJTAm6AhaREDTQNTaT+Os7NWVktj6IlxY
	sTCvckef7hFFW7CCFLGylAh3jjWjjrgPKEATsqukxZr9YWIlI8mjHzO3IQlrVwymJxYHaiHEJnr
	j+fZCo7IYAEZF8acsYWzocamwAEokG+HwmdYK8gQ0DGSa0z+wGrh9XPvZuOGSJ+W+/yinpSl99j
	wmBWUFY0o5/qWF7D+RRTaTlaBH3XRWJD5K9H9PbMOK+CJvBAeBQaJcQK7d89Z0WsiJPTLsX0fYH
	z70PZUB7V1s
X-Received: by 2002:a05:600c:1389:b0:486:b967:5c9b with SMTP id 5b1f17b1804b1-488fb75b9f8mr178126435e9.3.1776892189199;
        Wed, 22 Apr 2026 14:09:49 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a4b329542sm352469085e9.3.2026.04.22.14.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 14:09:48 -0700 (PDT)
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
Subject: [PATCH v3 1/3] crypto: atmel-sha204a - fix memory leak at non-blocking RNG work_data
Date: Wed, 22 Apr 2026 21:09:34 +0000
Message-Id: <20260422210936.20095-2-l.rubusch@gmail.com>
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
 drivers/crypto/atmel-sha204a.c | 43 ++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index dbb39ed0cea1..19720bdd446d 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -25,13 +25,17 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
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
 
 static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
@@ -42,31 +46,36 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
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

