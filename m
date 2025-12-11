Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430D2C324C
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765473362; cv=none; b=sIlT8kKVL67sjL06Pf/pz8q0GVGzZ2zHguvSGC72XG7SYoKRMb5DPd4rdOCUBPRX4dm5f1N+JrisIqzprv7TviaFCue8MLIfdAuw6OvtAZ/boan1bMldDflpZJV2jKASm8tY1DmBPEahYg1+odQEgEai9C8tTKMaVcitXd3UDRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765473362; c=relaxed/simple;
	bh=ED4QDS/p5ezOJu9uewMwjvvUOpx4P5cPN2q3KMWraJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBQHtm06mf4k8dMP3D3mSbE65/Aiy+ZK6Um/vFF96wzCYAfvjZi1IzFGc7jT+LGOj7WNzCWBBL6GdaBWS46k8OD26zyRERpNmXhqivEOryKltJ+QdK0GaOoN+Pb933qnelifdqtWrf7YVA4SsOm5swhc+9ZdikBIWKJU+hMSzDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=UaPOZ/jh; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="UaPOZ/jh"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42e2e40582eso242123f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 09:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765473358; x=1766078158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2sYBv0VIc9uiVK7zr2SScY7OQ8xufQ34jRkhj5KD4lc=;
        b=UaPOZ/jhF/bbyo6KpQfUEhzZdan9fMXkQhmENLWWwTSDa6lurV0N+jUXu95lMo3st0
         55G7/RUmf1sGq0+rDD6MfyZ/1KjETo7tfcEC7oKCGDJqwUZ66jDVyY6ODficOzvXcOMu
         65qiVmnL58VI9J8GVkVXfj+hG0o71B2jz1NqsK01dvJWdtuKbEVos4H34+mhUXANhb2T
         s3H/qLJAFCJsGTZXPy/CcpfCGVpsQMJ9CC0BlIBLNUac05KqwZifmBnmnNYgSSYRmiM8
         qKGCTPgXTnsqdVGqEuIWNX+0rowIztO2nETmCM5RxkewNnYR9piMmJA1dEPgPduLbv18
         n4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765473358; x=1766078158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2sYBv0VIc9uiVK7zr2SScY7OQ8xufQ34jRkhj5KD4lc=;
        b=MoWgXNUwtmkj2qBpRq+QmPof/+hRDG6SwfwGmmdakCUVLb8kpDjUdXxFh8487YCcbC
         ff2hiRJzgW6tp02KQc1vbwO4FW5bNuD7tF5bLD0QYM4Zuq9ceIOeFZtfyXnl/BG1mWMn
         lhplH90cIQSTxkxCoSN1OfH+x3d5CUeRbADS2kKlTv5ATb0+YJ/+MQ8/SEZjcttDaXMf
         tyP0f+Qap9TmmI4SvKbwOIVLwYddZhDVTFMn8iK2c0wARFzLBC9vUXxNb4H2wY7EFk/N
         QhkrMFQJdyJol7EdR0dqk4j4z6a19XppbreClDeIAFSQS+QTabEGLp31DbGSrk7jfTdT
         Azpw==
X-Forwarded-Encrypted: i=1; AJvYcCXT8YiL45akOoqNCcTLO1HMAgRh6J8yIQlKNq5BQAqkLsJlSXCk553+sdwCi4GJo3bEX88nz2veLpuvFj0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7X7WOhjGl0XQftkECnsFSHuauXc7KEknOUNFVsQndnKnz5LDZ
	VooMV3mytplAbt5McwAvQnrO5tCKN4Y88q9MV04QYStdw4eUg1DmjE0tqvv8Vxyx1m4=
X-Gm-Gg: AY/fxX5DKAQahkd1oHCKZ2w1Ml6V1znp+XvlhqxXrUJ9QnNPGyy0fQZMwhah/uVzlNl
	PTvBCnXa1Jm/6TPaGFuB43eJOXX/EbJEV1aRx+uokIdkW4RtaTnhPd5omWHonEM/Slhu5Y9+LOH
	RQNtrFePNQQ/BgyakcbgKCyLpSi5qfzVoEIo8S7Ol9nbAZS0m8Zn748TxCEHr9BIqLkcdMWyMdV
	pKOeZqXUg38GUqoEvdIn8btOw/ekVvOl7/UblxWBFNkaEJPL/P8IWVwx1N/N5Squ3a0PoLe7bby
	6nLSUsn9SSx4SO3duUXhApobGRdWULTX748kGF0PJiyQpHAmse6VCn3iUjNr2oY5N3tyhqtODdu
	CkjGJJ8SjEMWX07+T9PmiBMejCSBbPitZ+oDPkCKVblcrjHS+KXJgAsIZGIJztS0c57rK3bE68d
	cXpKDRIQ6D640dInPl1IJvCBqZPrr0KjZsXR+8aAZcn+ATu86HcJO3WXbmFRSlG4q1fS4M4e22I
	rE=
X-Google-Smtp-Source: AGHT+IGF1uSM01yvW8d2TIvQK6LFiBzRrZVRvLXXlEpWqmt343Ufg3Z/zBmzXdNt3aJjfGwNiJhuTg==
X-Received: by 2002:a05:6000:4010:b0:42b:3978:157a with SMTP id ffacd0b85a97d-42fa3afe913mr8449237f8f.39.1765473357944;
        Thu, 11 Dec 2025 09:15:57 -0800 (PST)
Received: from localhost (p200300f65f006608b66517f2bd017279.dip0.t-ipconnect.de. [2003:f6:5f00:6608:b665:17f2:bd01:7279])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-42fa8b8601csm7593114f8f.22.2025.12.11.09.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 09:15:57 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: op-tee@lists.trustedfirmware.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 04/17] hwrng: optee - Make use of module_tee_client_driver()
Date: Thu, 11 Dec 2025 18:14:58 +0100
Message-ID:  <a2560b5a16c01dc1f63437ce0d60b3ee9c7cb3b8.1765472125.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765472125.git.u.kleine-koenig@baylibre.com>
References: <cover.1765472125.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1263; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=ED4QDS/p5ezOJu9uewMwjvvUOpx4P5cPN2q3KMWraJk=; b=owGbwMvMwMXY3/A7olbonx/jabUkhkyrP7KF1stD5hcvn3powhP5/7MvcLiIFF7SWuTDpJSzc /eHO6JHOhmNWRgYuRhkxRRZ7BvXZFpVyUV2rv13GWYQKxPIFAYuTgGYSMx29v9FwWuOs71I5nqu zmoe1RIq1nFZ7ejRsCy9NXscWbR2XpUws+Hlsz25wu1CQILcllxh+3c77n/y/nc9Kpyx86AQ15+ XBV+5+tOmeHamRL1ke2K5govz1RU/rSdqd93lS6x6v/y692p72jxN0asM+/6nTnSoCDpjxXrukO Y+QfOw2ylu5ur635IjjLYZzzxW57VVyUHq2NrkfcdDTu/6lRGmXRzI8lRli3CHTeyaWdwft2tGb bvK89DmqPUd9lPM03T73New+71p+bqmNEu4N5OtxtLXb3J3g6Vkiz1nh5LK6hqDp35/JXzcg+V/ ez80OeqTJNSuWCjMeeIY63tB120PLJps9A+ESm8Vzq8EAA==
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Reduce boilerplate by using the newly introduced module_tee_client_driver().
That takes care of assigning the driver's bus, so the explicit assigning
in this driver can be dropped.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/char/hw_random/optee-rng.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 96b5d546d136..6ee748c0cf57 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -281,24 +281,12 @@ static struct tee_client_driver optee_rng_driver = {
 	.id_table	= optee_rng_id_table,
 	.driver		= {
 		.name		= DRIVER_NAME,
-		.bus		= &tee_bus_type,
 		.probe		= optee_rng_probe,
 		.remove		= optee_rng_remove,
 	},
 };
 
-static int __init optee_rng_mod_init(void)
-{
-	return driver_register(&optee_rng_driver.driver);
-}
-
-static void __exit optee_rng_mod_exit(void)
-{
-	driver_unregister(&optee_rng_driver.driver);
-}
-
-module_init(optee_rng_mod_init);
-module_exit(optee_rng_mod_exit);
+module_tee_client_driver(optee_rng_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Sumit Garg <sumit.garg@linaro.org>");
-- 
2.47.3

