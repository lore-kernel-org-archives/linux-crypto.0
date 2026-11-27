Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752276;
	b=mz/2B4ApJk1/gcn798qsmJ6sAQYy3wXMBaA9GxEzibt7C1yVS0zGZaPTNF+Jao5yHlnM
	 ZJICWJ4R/05x2btWEqCv/GU86dj+C5eSMmkwOxkZCeuTRWh+7oTQUbnTeHbMSTVIGf6Hr
	 L/z2UX5CBN1Yqw8EFXaSNka0W3vV7sxLrJ6TNhSs5oMW1KVLDE2rnaLbQqtvDMMXdKvF8
	 n/yGqbMAUcU3cgS15zjspsZsT7h0vp0XKC9QyW7Y+rbZo/dGpJFT4sqa7YhzNIZ6CUloC
	 k9lWTAeIWP4p96VXKemdMowJY+sJdIuLHaqAwEs9Qfz/vTI1E6PCq+DeUK3KsjEUGpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752276;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zHnAZdsZT1RXBp6xHzgc7oXcZl/LIIyKm7emqwAQYGM=;
	b=o9V5flmoso0s+NBOoU6qdN+uyMqm0BxyO0HluWlJz5PBWAhwtMAB6Rp5K1zucve94LaE
	 WXRxHet67+cGn7sq3YHGrfgRL/HW8QK5Q+FLvAORy2jA/OZSZJ0pmB068XmD37CpePvPx
	 XgIVzdA0AgQQjUGIME2wk+LrMMNieIF/fwbZrc8W+EpDlNyrYH2Ua5kRXmy8hmOjmxsq0
	 +hMIBfvVsYfbV91WPpu4vsSysuwR4vc8EnOBZ37nCJeLheQ7sl5J2ksorBZfySQe3AVG9
	 tifSeGWZWLuTFZRaQCtETx6Kz3DTfOtgKKiUrViCw1LzRSCG7v5QkT1PvUCu3xJuMsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SiqlYOHr;
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE7606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBEE7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SiqlYOHr
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cdba1bbde0bso2977508a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752275; x=1796357075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zHnAZdsZT1RXBp6xHzgc7oXcZl/LIIyKm7emqwAQYGM=;
        b=SiqlYOHrA5NxOCHyJfUG7fx7uu9HfhaEnz9pZTkZ+NsZxYZ2FR2p/rDXyaZK4vGjBc
         xbvgG/ordkZJcziUjFN0dLi2QlyC3xyc3f6NCSsfxphuiM1JizZYn67Lkd9ghez3FaTX
         4okJ8lG16MaT/r0OahHlDhA8/bRAim8A3CijTevR318p420jKCuOYLNExsB1SMEzQFe1
         rK1P0cFx7thx0DqEArhXZTrUTOnAXdXk18xTs/l3XvfQf4oHiYi/Qq6n0O2TKzFOtDiA
         ydiaNhNhINvSFIBw7zsQlfSf1AAMsLWLB/saKD2v4F/RWhPEpDoGdKoiYa92n0zZxKkY
         LJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752275; x=1796357075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zHnAZdsZT1RXBp6xHzgc7oXcZl/LIIyKm7emqwAQYGM=;
        b=D7QfombE/jH0lirLAtv5qcaDzE33OATCbHLFB0FSpSAG7c98NL/dgEGsem4zl3e+Kg
         G0rAeo09g+cpZx5DRCh4LtMqiuyKDacyL/+F5ZqJ9vBPYTsabBU42lkbJ6qf6RpDsjtr
         X8g+qsHVRiWLWLp9SntZ1nu5UOEs4OXzyAbK/0CYe3uzbro6lRhM68lhxJteRpnVHhjh
         xv3kPitz3vhKf1j03KGuBzfo9OvPwzTv3lmoc2krW810ojBDBRv1E/PgzVALkBgKbFCF
         W1FEEk84ADxRoLP5/OXzhX0nB4EmtV2kMtI2X3zAs4aB/26IP7uC+Hqeoop1DPRLk5T7
         QfBg==
X-Gm-Message-State: APuU4Z8A3V5BzCtPSZ9zvz5i9ewM8NV6XHIiAK9asuCZlOuPaEi1I34F
	xEJ/jU5jSiTsOEWxfWk3GtTkYl1YALBB3tfjHyY2xKTzoqtC13BmvgSWnCUcOA==
X-Gm-Gg: AZFdTZcusi0ZwCsoJatJMTzCuDNau7EO7xsKuwO/IH6DXtU3k4jHZELAI+vYgz/reqr
	eLuTa8RRL2XLz8ldgRDlnVt5ROh/esqul2wmnQukYq+k4Qgj3p6/BOizIEnn4jS6bNQph3esGSA
	j5nAjE4tCLHAcbzf7rUgMIVfiTjDBXoK5H7jWu8OooYm4cMS3CD8yJWYKdcZ3CwVToSwVF01eKk
	SV5gv0NprNIHhPXizmZKfFsyXlAPNNR/1zVMJreX8BjC0cfhhTs4+Aiiie33A6gdOuVz22Hb+CT
	wqm9I5dKMBhWAUDRwhyMXuKL8vC18DjfQ0IVxZ7JbMYZg0ceB4fYMbWGskwKCyIFl1FpdQ08PB2
	VFN61YPVZzPYz1UZwq6yUzKVS9bJx/QWOPpkOuIVKfETY6pYWrAsYS8WncPM24tjY/KJq4vx1rN
	GDRsOQOhckhGJ4H3PQOU9rn5Ex0KDytVOtXdmDIlQ+L+4iLugV2kAHLW8fK0eIUrHnkK1CzZsFG
	3NV24iuiYDwufg+g3m8lMH49iYuSmmeaU6fMmaSSzkMi2I1lyHmFv0DmwM06b4IsI6pP3cR2wZ7
	weknDrxR+nvNhZhvqtCpiaHBA5FKfAUehbQ7ibc36sGAl/qBGRyqlah918zlOUm666U8FRn1tDE
	W0p+yVneQl3hisDK/pWIPZTmJZFbFNhjWsH8ZJquhNGBtgN/8guJp6h1op5XB+7DtgAFun0//JX
	S5Cg==
X-Received: by 2002:a17:90a:e705:b0:3a7:f4d:b23d with SMTP id 98e67ed59e1d1-3b41c97ca8fmr20533653a91.52.1795752275027;
        Thu, 26 Nov 2026 20:04:35 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:34 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 4/8] crypto: amcc - set up the TRNG before registering the algorithms
Date: Thu, 26 Nov 2026 20:04:19 -0800
Message-ID: <20261127040423.1023233-5-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127040423.1023233-1-rosenp@gmail.com>
References: <20261127040423.1023233-1-rosenp@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

crypto4xx_probe() registers the algorithms and then probes the TRNG. If
ppc4xx_trng_probe() fails, the error path unregisters the algorithms
again. With self-tests enabled, a test that started on registration may
still hold the algorithm and have requests on the engine at that
point. crypto_unregister_alg() then warns that the algorithm is busy,
the driver frees it under the running test, and the IRQ and descriptor
rings are torn down with test requests still in flight. With a TRNG
failure injected on an APM82181, each algorithm hits:

  WARNING: CPU: 0 PID: 2547 at crypto_unregister_alg+0xfc/0x158

and the module is left with references it never drops.

Probe the TRNG first and register the algorithms as the last step, so
nothing can fail after registration. crypto4xx_register_alg() only
fails before registering anything, so its error path just tears down
the TRNG again.

Fixes: f033e862a32c ("crypto: crypto4xx - use int for ppc4xx_trng_probe()")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 6131fd6c0607..0dc23d29845e 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1347,19 +1347,23 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	/* need to setup pdr, rdr, gdr and sdr before this */
 	crypto4xx_hw_init(core_dev->dev);
 
-	/* Register security algorithms with Linux CryptoAPI */
-	rc = crypto4xx_register_alg(core_dev->dev, crypto4xx_alg,
-			       ARRAY_SIZE(crypto4xx_alg));
+	rc = ppc4xx_trng_probe(core_dev);
 	if (rc)
 		goto err_irq;
 
-	rc = ppc4xx_trng_probe(core_dev);
+	/*
+	 * Register security algorithms with Linux CryptoAPI. This must be
+	 * the last step: their self-tests may start running on the engine
+	 * right away, so nothing after this point may fail and unwind.
+	 */
+	rc = crypto4xx_register_alg(core_dev->dev, crypto4xx_alg,
+			       ARRAY_SIZE(crypto4xx_alg));
 	if (rc)
-		goto err_crypto;
+		goto err_trng;
 	return 0;
 
-err_crypto:
-	crypto4xx_unregister_alg(core_dev->dev);
+err_trng:
+	ppc4xx_trng_remove(core_dev);
 err_irq:
 	free_irq(core_dev->irq, core_dev);
 err_tasklet:
-- 
2.56.1

