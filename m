Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9855E23ED6A
	for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 15:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777218591; cv=none; b=UACBjK3ToOI5rokMmsMeYgDcXYE8+4Q05o4WDp3RLDrUtuKs9SYN2ElIWhIp9PMAOP33XzN+LdGmDhwAKh8rw3EqWBZ5KXzGmxkOMTJ932Mczv/zIDyBabmZydS56bK27a6QsfU5TBwiNijvj5uyzTLFGbpBGhH3LYxgAsUfM7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777218591; c=relaxed/simple;
	bh=BoRrP1z3WfziTkwQFPAeiHKgRh28FkywnO+QJJlWrSM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lHcefgTuXy8Bh0j2Px6VzYc8LODkbJasJh6drtLpNfqj1dbCBhtZmbGGr4t8FHmZJyQ5cLDrEQXOr4/GNyFxIOXrKO3NY3QjuuUqa89KDskewyhg18hOArcm9OLtFYwZDaJWlWT7hNZnHeMk7wDDTlAGBf3nM2L9Q5/W/z04TkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8sDYIrk; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8sDYIrk"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488a8f97f6bso17103715e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 08:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777218587; x=1777823387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=68cWQlXwjgEl1dmYGzLjO4qteIR6dZpj4xoC1U4PHsU=;
        b=Z8sDYIrkxJcqvZvBPofoi5v0y/NvwWMno0zwO5YpCfLoqd/iQ3ydWdixVp5eR09s0J
         coOu+U0TFdg99ZW4KL1vubSWrsj8DoGuG1bcV4acoR+etsZYt/AzELLHYc6/EvAi3/27
         2V42llI7DwT+aoxG36GWv0W9Y3JjnB4d34Jx7PVp9sw3cmTzBz+1GUUxOAkBCTyHbtc9
         WNUlMHKHI5ZeyoOZwFgfPdMPnjuE5ZTWu9aZIL9lSUkisjVKLiDdFKAMIJLtYXUF61Wc
         8jw5AcrjJ7nWzmGZlSy+/X38a6nJHwcTkOd+ZHHBkFRBgqtMImeZTia3ruMEuGLitZxX
         hX7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777218587; x=1777823387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=68cWQlXwjgEl1dmYGzLjO4qteIR6dZpj4xoC1U4PHsU=;
        b=Sex2p3hPWXdxz1iusRRVp616clWfLr3CKPpI2Qb4+W37/srSNeKLpWtJt+vYCZVydV
         P1me/tnuxNxFCCTiRAnX59Nh53FSkoAgx6TwYmMGrxGilpLyffGGCed/tvO3LuH+ZXCT
         R1quh1MnBpb1mIy7EqV6kZZE3qm2IIDij9xoBHkdfjE/9ZDxrTQvS+euDak+9fIrebm4
         nf5FIQUNmKsdLA2rSOYJnOob0RH2/JwG0mjiZgaVKdySbWe0uu+8u0jn/ngaYY9rbZGj
         htD4aDtMCvCSvpAwmSuoKASAXrj1jVoi9ooWpSxw34XWVsqbpElAQiTS6+9u1W9kR7H5
         7KcA==
X-Gm-Message-State: AOJu0Yzm3Xe6HO3eYebVIdVa0SuXAVuYsRkTw3YPzp9n74+/sVCFn3ao
	3nO1qsORPoyuBxY95FFaw9BRXqTvPEW6TpCQxa4Wo6H8JgHVa2K0ox+OZxw6Vg==
X-Gm-Gg: AeBDietPf+jK/nawuS/tu/RrtC6xtAMHzvclI79jwiPAQlM1wXeSHmihHCrIg4oRGQk
	TqpH95aDqF0J3K3wyWEY1scg753g0SOQQHqAaTf6wbwXbKTz4o7wRCF7MVbdx2r0iTn6yC27qSc
	rfWOUj73rFaLqUyLdEjm+gWr26A8rSLS9VLts/ZIruZWR/sWAUzr45OoSvf1bfhgCgI+NBJ+LWD
	ZiwWx7DToDbR8td1GT0vaP+7mA03zZyv8RJNO+WftB2yYg7vQBJI27ZsfELSUV+ma0GCnP5fGpX
	gF2IqES/VJcvEEhUXhBZjfYphq+9uA1fPHoQ0cdiCRKbTXgQ4jLKj9CF3b9oCHGZwURKm/dKuxJ
	GSu602CUukoSz3z0yZqN0HwK914lfqhqBOmjKvNw5ad6QfeN8fHOq0c3AiddTcjp9kD777LWHkd
	G/XfPvChV3h3sJKI8m4l+FIm3zTQH2+/3RY6y9M+JQL0wLUKyXX+E1gSStFPPIl2lYlMiXej/td
	Z9rTwRg6Hqw
X-Received: by 2002:a05:6000:1361:b0:43d:627c:21ca with SMTP id ffacd0b85a97d-43fe3df01c5mr21025546f8f.3.1777218586806;
        Sun, 26 Apr 2026 08:49:46 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a341sm79799339f8f.24.2026.04.26.08.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 08:49:46 -0700 (PDT)
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
Subject: [PATCH v4 1/1] crypto: atmel-sha204a - fix non-blocking read logic
Date: Sun, 26 Apr 2026 15:49:40 +0000
Message-Id: <20260426154940.24375-2-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260426154940.24375-1-l.rubusch@gmail.com>
References: <20260426154940.24375-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blocking and non-blocking paths were failing to provide valid entropy
due to improper buffer management. Read the buffer starting from bit 1,
only fetch the 32 bytes of random data of the return message.

Tested on a Atmel SHA204a device.

Before (here for blocking) tests showed repeadetly reading reduced bytes of
entropy:
$ head -c 32 /dev/hwrng | hexdump -C
00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020

After, the result will be similar to the following:
$ head -c 32 /dev/hwrng | hexdump -C
00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
00000020

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index dbb39ed0cea1..39a229086a84 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -48,8 +48,8 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
-		max = min(sizeof(work_data->cmd.data), max);
-		memcpy(data, &work_data->cmd.data, max);
+		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+		memcpy(data, &work_data->cmd.data[1], max);
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
@@ -87,8 +87,8 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
 	if (ret)
 		return ret;
 
-	max = min(sizeof(cmd.data), max);
-	memcpy(data, cmd.data, max);
+	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+	memcpy(data, &cmd.data[1], max);
 
 	return max;
 }
-- 
2.39.5

