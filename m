Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF3C3DCD9B
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 08:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774945282; cv=none; b=PQGm7IXvjS/Dd4UbvoZDcdmhWJsS6TZDwE0IZUl6fLioUbMC7zIg2lq9mAEAmMv77k6Uub6V7Ym026fR7QdzrZINQtqdhRgwQTQmgP3zDaHeykU3HXkonGNZ1dY1FPJJqTb4a4r5aKhep5dY8YQF1DRs5P5QsIzi8tP4YYP9VNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774945282; c=relaxed/simple;
	bh=2flK/UJa1UrZ/JEeL6RqU15Vn2qjY+wp87o+KBrBy54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mfQh/4CLFvdft0l4Q07FuQ5/FFpu4nQX26bJCJq2NP7NJH2t6yx7Y4EUH/qOpzYikBM69YL6VM74jNnTU8KlrOKhCnC4dHv8jMbAioVkQlId0Cilt5pCl3ZCj9Wm7sQ/I7GiBYV7VDwzAxYZZ7IrRx2cwWv4lM/sBojJ9gBqFCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ifqEdwyA; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifqEdwyA"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4836d9d54f6so7221845e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 01:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774945280; x=1775550080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzLIANwxZ+5V5JDtMYwIGXlBV/CrkOF0yZpzbS4Kpx4=;
        b=ifqEdwyAxEcS/UMN6E1KXgwW8Mv/IvRIVmdNS4bzGwztqNxUDMfmUOBfmjAJ7HeAnW
         G8tObCYK8KvjlmfwANAJ9eJyKSeA/ZN5eeIj53EKElK4AeiBjz7ZwS+yw0OUOGp0vI5W
         MefpLiP6kbdCL0nzQxrKSuJ5nwjMNGdcinyzPG02KSDXw+HdolB+SRIZHmfnRyDL5swb
         q/MuSBCeFy78QtAfwgbKHyqIrjhpyMZXopMUDU/GT1KeHhEtYFWVv/ponzoxtTh47Ti7
         07P2qrX9UUG+zjhBGPtyfiFPnjdEXA1PirbCp4dlLKJ7KNPj3eovZqVuxNWdQatuk2Ne
         HDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774945280; x=1775550080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pzLIANwxZ+5V5JDtMYwIGXlBV/CrkOF0yZpzbS4Kpx4=;
        b=DOAOyAMWzz86YrsNbJdA0wvjKeLWDkTlhYAy430XQsaO4L4Xu3WFQeS7bCnr5JB/ti
         RWxltfh3LRmv499Mviqx8W39cnR2le7zHJCgpjY8OIQ9Z3RdVkiflopqojaeH6eqP597
         O/8X3y90xq7mKPgidpthYInNAKljpxp9XCVY61oIJqMR/GtGidAPIj/M3eIXbQR35Yrj
         ziGUSePmlpkaNm2K0pxZdHPpnunNBvk4+rU4Mu2Vd1dDeHmAMfOXeaww4N69C2g5pHWU
         /D/wxeNjYzafxNw+E6fwL0zGtE6VWCQU1cgIJHpoOO3cJuV+98Bkh7bPlhi7aa5OuwSw
         Ah6w==
X-Gm-Message-State: AOJu0YxxlU1lFpxcRfBUkPeVTUxMJlUeAuDwADLyxmpPs4ACWdXAs7oW
	BfMEhRc8mc/JLMOfR5JRTvMQ8gSYf3yxhu6TYQE0nvNEzXRpOQaIdwpQ
X-Gm-Gg: ATEYQzwxJUKJaxArKYPSrmQS3mcYuAc0jps0Tas3taaPsJ0GkjRWXBKedk1e4tfCZ2k
	oG04uHEi0mgZQIzWQMA033C5m7ZGSFRjunFKdkyZncgbcsqTIUSzTFmt5mvHNyjjVy19BztB0Os
	OF3YzboBEyvNK2+hMWKfH2lQvwMXCJxmOvB2NZxqepqGuBFTAy31wiR9WuuZ51FCnBeuZioiHE5
	10mOaUNrhFzmNtzG6hJyAkFnVGaBYhjPID4HfEX6VEXUg+iLyAMJlsH9lPVpQkGwDe3oOVWbcXV
	Ug/urpPTiKgZ9CW6jsUFhKSzMWjFbZZcha1rps/MjUIXFWbUvPM88d+ukOM8/3Rpy2lnjqjSzil
	MeTpI4EBK65tyPnQXQZk9QBU+SRW6DSimePOAbA3nNjjrEu/pAWmMQ+D7yuRslKyWRI/1c+WIiB
	xEyf04S46TEa4KYcFcLMiKQdUf3btvpfdoRWBzWXfE33QJpnF6+uqcc8Gun9uY+P4=
X-Received: by 2002:a05:600c:1d1c:b0:487:1fbb:5a28 with SMTP id 5b1f17b1804b1-48727f2d043mr122939545e9.1.1774945279542;
        Tue, 31 Mar 2026 01:21:19 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887ad8d28bsm14542485e9.10.2026.03.31.01.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 01:21:19 -0700 (PDT)
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
Subject: [PATCH v2 3/3] crypto: atmel-sha204a - fix non-blocking read logic
Date: Tue, 31 Mar 2026 08:21:05 +0000
Message-Id: <20260331082105.697468-4-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260331082105.697468-1-l.rubusch@gmail.com>
References: <20260331082105.697468-1-l.rubusch@gmail.com>
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
index 350ba8618c69..c0a1d34bbd9e 100644
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
2.39.5

