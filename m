Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458DD2F7462
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758200144; cv=none; b=RgO2Rthhrc8oO4xV5Ne5bpOV3eBpChotOregx5XXd7RjUaZtSU+iLb4a1EGrDRYQ3j5rmBMBAzMHnUaR50Z2ePn3C7aZjQNqem5Jaib4gJYAuZUGzJIrjswhQqHuH06Q/hPA7/VLw38mhq8YHZrUBli9m0Ycr4zzioMrdPUlInQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758200144; c=relaxed/simple;
	bh=SId3DB5hqfnfahVT0z34tvWymLGz7H03e4wdeT2fwQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YNZlKQkinG56aCGr1HAfIc0t5PVC2iv93C5T8EuXLSN5/J8NwL3paAieHTCV5ZuygVXQz9d3okXP3E/NqYbOTM5wWRC6mcjYbLLE7fsLQEOCxlLrAAkYpwWpmqPzwNJiUzBQoT8rqbO/ADK//fM/74U8k2PbmJUqVbzGUyJwGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fuhjaPrb; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fuhjaPrb"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-77da29413acso477308b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 05:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758200142; x=1758804942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1PMaQk64QLYvKLuvrIkNRq4RT2wpYqM3eFsm/MQrmOQ=;
        b=fuhjaPrbuoIv45XY64mm9g32pBv/ambHaaS5mOj+rNyjBG3dRHCuS+peMpVtcHwaST
         SLZCqefArI120NYYln/AEzKiQACWkN6OwINyPYQr8QT+WeLvldNHmDFPkXkPl564bCud
         jzSugu0a3EXhNMpAIZs1aDvProQQftvS/qE86jzuQEAgd2bKwfkqROH6MDxYE6ajH08S
         34o9fqu1StPte21yqKQnni1dGoRcAAeEGDwqwrJ0626APmOkujdIbh8/NNdegW9rcMP9
         u7Tg096Izi40mw4GG7jDEAOasxiVAM488zgNUsoFu1dVVh0lYYB5MEzrRjdOrgmj/Gz9
         y/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758200142; x=1758804942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1PMaQk64QLYvKLuvrIkNRq4RT2wpYqM3eFsm/MQrmOQ=;
        b=rKdwWFhb7gV8bQWBdzSjeE47UhNa3lckfHm1TEeORM1KY8h1c2nvzw05c3PcPWuxjY
         z9q7t1NkEO1XKvC14zxPSZI9xuaIix9CtgLmf/QOaFZeO5g3itROo581npX5kSx5IMJ8
         GVn5HSkchUi5W4LNWsgvWtoqVWt8f13dp9jIY4SlrQzKQ6fHngz3dIj2hM3a+19GMaCy
         3VBqoKGwO1OckaHkWCpEJ/vPYIkdm5xs8ubZ1V8wfT3+r2OR9C3rS0ONiZGDZDQHWtfC
         ZEo8PBDRRG0LA0OB+5D2EZ7ft2mowg6kdQt0ChUSZ/R5ZyghUPCTuPhqVGkDpVK+ufDI
         s+Uw==
X-Forwarded-Encrypted: i=1; AJvYcCXpmMD+FnsMS9R6nI8CNQsh6Vny+snk4/8e+eKYw8DU0/Ko5Irn0ColV05D0fKC2bVeDRgFw0xUvibT4NE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV5qjMX+hTMRkGqF/+opq/NT1tojvVYZaZh+B3wvMH0XWLce+g
	wuBx76HVvf3ltKcFi9kDGX25wzegL17tgZETmd+FkKuhYTTR3NlYhRQi
X-Gm-Gg: ASbGncs+e5rhMnSoD8bPax9N+IGQhMeYUTPei2OJcRRacOno+89+KZaj96mxJUY5YuW
	FqB+rkm4HUqiHvhR9+utGaj2/0dy4mPKQ0TyU+i6qh6fiXSYjLPoqrVTdcun76NLcBM4vMqj7MQ
	hTDeDidPPDE5cq639USpw+Mqwfpio9I8m2ForhXpxz+aWZ71w3EYbrhrKdUjXVwt1h86vfXBi4V
	q82O31uT5lnGEBY18P98ny07GxSLL0ygzZxJahj2QBwGmftweRXzmgVeYNqIoPk+Er2I7X6T8P6
	DU49Bdj5RuTZubFiNWfzmEGNvOK2/IINfNahq5Qb9COLDl+YdhPR7+FrgAPu37AnP2i0g5lF4gX
	H2/ydKctQ270LyHsBKakAQ6nzp4N1zm27VgrNGQAlLP8=
X-Google-Smtp-Source: AGHT+IE4Evwn4n7oEvkfL06fZNeaCExpJfqe2hcm3yPgDmXEurhEs6dJZklynFlriLWZbAPRGw8rVg==
X-Received: by 2002:a17:902:d4cd:b0:246:d70e:ea82 with SMTP id d9443c01a7336-268119b2be6mr84670615ad.5.1758200142591;
        Thu, 18 Sep 2025 05:55:42 -0700 (PDT)
Received: from lgs.. ([2408:8417:e00:1e5d:c81b:8d5e:98f2:8322])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698016c076sm25939065ad.42.2025.09.18.05.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 05:55:42 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Dan Douglass <dan.douglass@nxp.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: caam: Add check for kcalloc() in test_len()
Date: Thu, 18 Sep 2025 20:55:21 +0800
Message-ID: <20250918125521.3539255-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As kcalloc() may fail, check its return value to avoid a NULL pointer
dereference when passing the buffer to rng->read() and
print_hex_dump_debug().

Fixes: 2be0d806e25e ("crypto: caam - add a test for the RNG")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/caam/caamrng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index b3d14a7f4dd1..003c5e37acbe 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -181,7 +181,8 @@ static inline void test_len(struct hwrng *rng, size_t len, bool wait)
 	struct device *dev = ctx->ctrldev;
 
 	buf = kcalloc(CAAM_RNG_MAX_FIFO_STORE_SIZE, sizeof(u8), GFP_KERNEL);
-
+	if (!buf)
+		return;
 	while (len > 0) {
 		read_len = rng->read(rng, buf, len, wait);
 
-- 
2.43.0

