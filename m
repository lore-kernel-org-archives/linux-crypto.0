Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331A83ED109
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 09:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780998450; cv=none; b=eSH4PcoBbjRHKo2jhB0DtmfJHd1dnHDR1yBNQQkVTM9NsRzCoCTp0Tyz7dvLjrbDaS1ZGe07BUfyhHf/kcU+zG3UlFL9EU0GLQTHp9oWwOvP2eAA5VA5DaEEHxpDkyPknCIoKB0XlWHd+WJZXUX9cFk0RWHfnmH50EeNojG6M8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780998450; c=relaxed/simple;
	bh=4nAM0qRZDd0zFd1x8M47OSHlI/XmBd2QndlfY46yPsM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YaDcNLmkZIxvjlxlWkJ7Wv4VKRjc9/LfGhnu2SGR8U5omF0CMQsFSsi0GWAsrYXzh8LsFSLFWURI1AxBkZ7skCxGq3KsWesXZStenMyAOxG+QNXz1b9FmW6/MudiqhP7g8C7zPIaXxzvFcmm86LGZK8d8v/G4c5+MVEmTqznwU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMt+btAI; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMt+btAI"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490c28f84fdso9170345e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 02:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780998447; x=1781603247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N8+mvEz/uros8or36J+62LaI0/57hxHXfoqkEFi7n/E=;
        b=FMt+btAIdhqbO4ltlmj2GmM+uxYSkBPyzn8bkw+4EbVQP3IBW21QUvxlzWIKbdnuR0
         WAYbzMUYLlknPNCu2r+CO9zug0riPWcCO+jzVCMg/+Iaz4RPE8+eHxhT0r/6Gk9CS5p5
         B9uN6fQNtnCj9HdJehlshwAlO8cMy/mBo7nMYTWu83uegp6uW+/trco+w8D/xhpRYloJ
         q0dX3IaoGF+Tnz2fzT3WM2TpGT8nJnTwD2sn48MLV1foMz6v2FVI1mlFpZ6gdfJF74sL
         nIpAz4KY+BWMMJCBu8mq5wEEqNWv2rQeMdhf7z+VwfilYGDzW/QBMUZ3CctlzO2hsLg6
         6wnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780998447; x=1781603247;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8+mvEz/uros8or36J+62LaI0/57hxHXfoqkEFi7n/E=;
        b=Kj0cxR7/19iSHtg8J4KYliMuNgFXwpyUcC6r3xTp6PSGTkvhgD7QSckTawJ6OBLvo5
         c9RT+C3zTk4h6pJN0vEXmjS+pr0LyYMxdNyB7RWC6fr5a4EfMw8jdGELA1+nKuN1FcUG
         xV3ABIx+0y+2h80iMzdIsVBvKMUs7ZM1w9lk+rhnrKi254Hc7pbX/6Ai1EZOJdcJtyJq
         FkxVpJaSMlWFwelDqvpJZTYLI5e+jvJnGKDmxb5nisVT9lIuNE6QD7Dzk5FynbIWdXJ4
         87zxX3a9WbqTUfBRbpCUTqxE5dd+Y+Yai3I1gYngFU+eI0pw+V83l/szmjg6OcFtI3uz
         26rQ==
X-Gm-Message-State: AOJu0YzL8AprSJ3ar8YJw7WeUjLT7mU4PHdUkypvgIn7epqWKHplrdLh
	clbr6aXjdM+pVmLDwSZj8ZyiCO2GrIhzwCpMQBa2EGvuRlPfg1MwM5qu
X-Gm-Gg: Acq92OHCFz6Rte+caCpPXEQL5W40McLGUsJDs5ipPeaz5punjzkgl5FwwYOIgvW4oE8
	6YKPerdbtXvuX2S6HvqlqxB/x/vU50fhj7D86c1dwx8xyHNxc1kEcVMq7rQDNnLP3ac5xob9N7p
	OPuO8c95tqkI/qAIWKUUdhOiQwCVTFSk3CsdpmlrC/R2Ay7/LI39HMKHee20u5s/utycTlOmaNU
	Hnp8uNReP1+YW4EUjd7gyiuhxVZAYYb32GCiz++7Kz+JBZxekR+u9JUIoa2YZ2nR4LGiuBZAsYa
	cexq57t6jXTZSczFrJgk8cSlX7jsZcV7Eq8EGGC+FGrw4+an0GMlHZbm/6NNadTqDi+Iv7RsTIx
	CRYFKJonVLgyq2UwXqjlLsohcFvK1j53heqDEGeqofFYUk9NGhjLDfuM2P8YAM7lKalNupwBsPE
	bqW3ZjE5mbDY7jck6Mze/RxeuL3reX7uGMfoFXmho52nn1lyxCUnj7N0Qbz4+RRIb4u0pP+bSn/
	w==
X-Received: by 2002:a05:600c:8718:b0:490:b2b2:87d2 with SMTP id 5b1f17b1804b1-490d7255c0bmr10214735e9.5.1780998447423;
        Tue, 09 Jun 2026 02:47:27 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3e59f5sm496152705e9.14.2026.06.09.02.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 02:47:27 -0700 (PDT)
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
Subject: [PATCH RESEND v2 1/1] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Tue,  9 Jun 2026 09:47:23 +0000
Message-Id: <20260609094723.47237-1-l.rubusch@gmail.com>
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

Fix this by freeing the pending work_data and clearing rng->priv when
the I2C transaction reports an error. This ensures that failed requests
do not leave residual state behind that could be interpreted as valid
RNG data on later reads.

The explicit clearing of rng->priv in the error path is retained as a
defensive measure. While it may overlap with existing state handling in the
read path, the ownership and lifecycle across asynchronous completion,
read, and teardown paths is not fully localised. Clearing the pointer
ensures no stale state remains after a failed transaction.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
Assisted-by: Gemini:1.5 Pro [google]
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha204a.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 4c9af737b33a..20cd915ea8a3 100644
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

base-commit: 79bbe453e5bfa6e1c6aa2e8329bfc8f152b81c9b
-- 
2.53.0

