Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C476D3368AB
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 20:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781382044; cv=none; b=bHmv05B06MdwXltrCOX4uuIZuHfXVR5tx6Bo1fvWbvfS5Kd6YgmiUFa/RxwXOPPicQ+43pyoxXTZ+GsEIaD6xh+rbdnsp47/P1hotO2ErQjALDS27pZQtK8YDGqNQTJRmdDJEhJXBfpQhJFV1wLotiFHKwF6vv4w9MJ4omLnFaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781382044; c=relaxed/simple;
	bh=JD4sU/lh6bgl+zrfoe9EhQV49WX5ddYjmerl7XCgF7s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CbyqMJ5jHRaxVHwRdCrmrWyeSMYkhB7LW/xQXgSyUPVjlu7q4U25xGbwM8TyybQnOVwYrewILJap/BRWLej7LTWrLuobCSJITocH3dGYznG0Z64EWAY7NrosmuwZJ7Ue8M9WkE0TRJTaEpiNXc1nybEHW0aTAyRnyfJAiykj2Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXv7+H2x; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXv7+H2x"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490c28f84fdso4690275e9.0
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 13:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781382041; x=1781986841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2h1pIz+Y3QiNp1EUEItf+otEd0xBBWZpK67JdzPkqGk=;
        b=WXv7+H2xUp5AOy4rRyoj5eolCH6ZrUcLW404Zfdu6suHU/t4EYIGjcGwAlG6y7/U5v
         UQ0uxbtV7O7o3r2cOYxx0sFsvhJro84Ao1P6OwP0CObbJ+rBhtDwsihLE1vCghoa07e8
         Ef4K5cx1A/S6QTGruTz1qsYTzKIOIfihC5pfCunfJDmTuvuvPFM93cbGw3TYlKf2Wqq1
         sMHALE+zvF5dXzxU6cMSCWbA7WvzVGeyUgnwaAd6xMWFn8dxfBoaLkt5UojWHNRF/ldz
         hV09KtvL8i9mV0/kdfakYMC+Ug6k4kHMWqubNbbcuP1E5NnV/pTYsjoYe6tcjIxKadWu
         x60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781382041; x=1781986841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2h1pIz+Y3QiNp1EUEItf+otEd0xBBWZpK67JdzPkqGk=;
        b=NVUSMD4O5wdFdVUS5Q4fu1XTgiebgDPFtBAlY33P43B83FkuuBbgDqJr8JoLOmmE+K
         uJtca/gFRMIVQJQdIjWDjorgZ+rPUsx7+IBxhHozeE4kOUdlOc5khIDZe+gDBKRhEwxi
         uhC4aYsdavo2j4UE7oyATrMaNXiJRCfXQ4OSe1Xpf10l2nLvfncBxMzAclUi39uMLgge
         nIm1FxzyWbIM84FhCi2gTW+eSBKi+vkKrjqEzJZeoQf6ibERXryCViLD2eL5MmXDplYD
         Tj9KzfLpNwyVe0I+py4kBjL6kevNPruZ9E2KZsyq8FLsSrJhLsghWCzJZntrGumuV5X3
         C+HA==
X-Gm-Message-State: AOJu0YxZ1ATwKGbpF570Ey652q5wOXWZIuphyNElUGHQ6yJXk5AbFskd
	16tHmfIaoIjaoeAlPjZDqv64gLV7D+SYehkUt4yC+faCTGWw2qCboRwv
X-Gm-Gg: Acq92OF76A/xc3K0jfA+pHFVqvcf6W3NDiTQRgNn/hB1AQRwGne1Iv6rDUFoRjh/wo8
	rGeuSKDUAF1N1SRu4+zLkJAn1e52oBmjF076yC8xLvVrE5WSjUL93lV6DpFpQNBTGqOQlcoh7Bh
	n7BHNmT6Gl66eKEQFOZF5XMyAGByi43aAIVL0VB92f7+9GBZLJMa+4itEz/dwsiH9rzGAFLaYAm
	O3urjqbkx9bcAHlXeQSWec80sGJm394pjQhCZE2sMaMBh1muRNFsjFlyhDfmYvueHZ9zFOmwYao
	FKuhNgzE0FSfU1jMwivopBmone1vvoKbwR5AjCLahxCQKBms026MeJf2LLfXHcs5XxMVzfaRUPQ
	yfoLj+H8UGB91pvG5P+ZcMe7E9xNfW62CntsWXiKALnXvbwglDQB72Nd7o0BgP876s45qvPQjg8
	izFbKhWiCmcHZGdsO3t5qXqblHbJVfOd9TqYhwAt4Cr21sNrL99uZ8tZDUs5Cf2NY=
X-Received: by 2002:a05:600c:3492:b0:490:b2b2:87d2 with SMTP id 5b1f17b1804b1-490ec50492dmr42515025e9.5.1781382041044;
        Sat, 13 Jun 2026 13:20:41 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492203c0801sm90785635e9.10.2026.06.13.13.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 13:20:40 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	ardb@kernel.org,
	krzk+dt@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v3 1/1] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Sat, 13 Jun 2026 20:20:37 +0000
Message-Id: <20260613202037.47744-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nonblocking RNG path allocates a work_data structure to track the
state of an in-flight asynchronous I2C request. This pointer is stored
in rng->priv and later consumed by the read path once the transaction
completes.

If the underlying I2C transfer fails, the completion callback is invoked
with a non-zero status. In this case, the allocated work_data is not
usable for producing RNG output and must not remain associated with the
hwrng state.

Previously, the failure path only logged a warning but left the pointer
state uncleared, which can result in subsequent read attempts observing
stale state and interpreting it as valid completion data.

Fix this by freeing the pending work_data. The I2C transaction reports
an error. This ensures that failed requests do not leave residual state
behind that could be interpreted as valid RNG data on later reads.
Clearing rng->priv is done at the subsequent call to nonblocking read.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
Assisted-by: Gemini:1.5 Pro [google]
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
---
v2 -> v3:
- remove existing error-path cleanup behavior [`rng->priv = 0;`],
  update commit msg
- rebased

v1 -> v2:
- reword commit message for clarity and precision
- keep existing error-path cleanup behavior unchanged, update commit msg

 drivers/crypto/atmel-sha204a.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 4c9af737b33a..5eb76245347d 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -31,10 +31,14 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
 	struct hwrng *rng = areq;
 
-	if (status)
+	if (status) {
 		dev_warn_ratelimited(&i2c_priv->client->dev,
 				     "i2c transaction failed (%d)\n",
 				     status);
+		kfree(work_data);
+		atomic_dec(&i2c_priv->tfm_count);
+		return;
+	}
 
 	rng->priv = (unsigned long)work_data;
 	atomic_dec(&i2c_priv->tfm_count);

base-commit: 6ea0ce3a19f9c37a014099e2b0a46b27fa164564
-- 
2.53.0

