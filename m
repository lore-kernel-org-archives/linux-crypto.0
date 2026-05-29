Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5CE32692C
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 09:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047825; cv=none; b=Fl8blvJr91a2AhZSBJjVadode/ZkGAO4DQcSSqNMtTbqkR9jxvt1rqkLtINaLlBcobe0N6VsL5f3/b0EWfusc1snqrt0BUgTddN+ldX+U7NVzpN8sadR/hk7QrV4/MOWdBs+x1IjtfCfjlkxv8On8znK4Z3QX4NhrZyeKUQ+0h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047825; c=relaxed/simple;
	bh=nUqj6e6W+fTzzVcLBUpy5rvjFNaY+mC3XbzNoDLkAoI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ggd95EPEjvysk0/4iY7pwFhAJeGz6WRPIzC7wARb7b3A1eeVEeME3BtRukbJFvDDcQl+MaLbU2mPGTDMsE2Ve1NcHMlKaftdt+uIVFHsTOT1yVmdk71RYpYCCXY1Jgqi5kRFX+/aJD9mifH40Qqux9S82iQ6/dgt9kAZhOnfSyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q3Ji75Cg; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q3Ji75Cg"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49083c865f7so1885335e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 02:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780047821; x=1780652621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8R0NpUKrRUzKTBjBaspaFed3TgMMb8WXLvF6QWVgQA=;
        b=q3Ji75Cg7G0P6/kaaPjR1kJlZSKJWn4SoTNu+zFd7OFfiXuJTPbA97NI0yaYAXCxF3
         Zi+dtjCXfJ+gHLWwfGSDg2xaeh1dQ6o1PtZZ0MgBNxTCywekuy2/OUHSJwPKgzQhGpv3
         5DtdPGhaIhdgOVDgQdj/0oBAMYj+W7jcVsJb8ZtbSzfZ9x2MR2EssS0+W+qpSBGeaA0a
         ur981DEE/LcuPnIa24XNu29qBueKtMqiuyYqFOLE5JXvQbjE939Emgk+uph+t4zwQOQ/
         8EFPvOPJ+8eurHspzXnzD+K/bn8wvhhtykpu8pYB/htjtu07FFPE/F1qa/vrtzfnCd1O
         vPzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780047821; x=1780652621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8R0NpUKrRUzKTBjBaspaFed3TgMMb8WXLvF6QWVgQA=;
        b=Dm3+7RST/WBQDGJPneTWJcexh9fj5OLLLHZ212w/CjeSRUYj2N9n5ylNIPmlkf1ngm
         Ow4UNgX0E7IUD0AwHWQ8UasaVrokXJBA23+/kcaiTW77jRgcjaC43ZQ/ZNNViuXgoSQv
         bWb0KqgcE1JPNxMVGZVclIelm/cowau7vuqSyjFXYYQGVcaZDJ+VNARZMLY9ZNw9ET/c
         PjlGoF8Y8tVSKOFBy7BLrjrQBZ130KXaFRw44iv7FCttXdiTHeu+jGlo1DW4MjGaabBV
         /cdtEKAJ+374jM0trBG+SWX8QELETt+RL+0P24g4+9xqw2bDM3Z34s5W4sazmJ1B2JGO
         oS4w==
X-Gm-Message-State: AOJu0YwFIyqsRpD0uJd8q2pldxe5RIQUqfQpQ3Fh8chMWOmvTd7zZaS3
	+j0QJ56yABW2HGDSnw49BhRC108Av+31UwohyFc9KHMpCDBmF+BZ/IY2
X-Gm-Gg: Acq92OFG7gFOdZ5u3YUkvoF7PzQEp7CkLOS8vmWQYjsqY+znx1i7ES5eSjDKue7KP1k
	tFccqJ198MQqUGXjV7ZVcZLrHGkY8sJTlQjDeBgeaUyXxQX5pD7MsdkodEY+K5ZiZhlQ3+hop+i
	dL9N+iNsVX6utxmCS/LMY5WT/Yy0gGcNUSfKLu4zm+B11TemYzXTCB4VeOd6pGVKHJBsPbW+v41
	1aI+OtBQi4yvE86xRoaOW4UdVdWwFo95/Z1sdUOPafo7eYwaYaaxNqSGinvFm7KVxhb7y1OiuUg
	x3ErI1devqgNOaLFKsopJukRmQC1P+ZAIxq6i6BF/KeL2rGBMvcvU7lR2/1zqDytzJj8fUpz9Pn
	jpkyeW1ZkgCoGhvInoPyjYO9mAnYsdQOkuf/YMdMxNq+ZFW8XvnWP+zzJeOyoBsuvqfnN3/+9jk
	CX+B/29tVyHBdcg7MfFhz95jji+vw0VcCWvqPKICqHdUfQvD9BqOPVDCUZZhgzh6lYl+AIr5psb
	Q==
X-Received: by 2002:a05:600c:4686:b0:485:f1d6:2b1d with SMTP id 5b1f17b1804b1-4909c03bd6fmr17670255e9.0.1780047821322;
        Fri, 29 May 2026 02:43:41 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c07ee36sm14116865e9.0.2026.05.29.02.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 02:43:40 -0700 (PDT)
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
Subject: [PATCH 1/1] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Fri, 29 May 2026 09:43:36 +0000
Message-Id: <20260529094336.33809-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
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

base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
-- 
2.53.0

