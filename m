Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1EF2F3C08
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 10:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758190545; cv=none; b=JxI6oKZFTQojXuJ76RL/bmS7RtW8EWg0Hw7560CXbsoN3yvRAa5RdtMLX5Ny1isM+oNTpGPHKRJSDyVt7Cn8791MjvjhHZvYwW4AkNmNmlSMCXu1Cuq9Ujm7M0aZOpI8opM7MBblRzY7AInxEGJohatP8DuArKGzyAUaFSbvUYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758190545; c=relaxed/simple;
	bh=a5KnwUSk1PbWVS7mlC52gOqleynRC/2hkubAYqM6uOM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JIsifRbhKHeWMKF9xnK3caL6kzomsvx0p+KZwTS8BpaZfReO5l+PwadIKxzZz0WjBl47fdRKZQnaGXKVgAalemX++/HeekC5iM/eVua1/Sg05MJ5mvnS2ez19rnf8GtbtA6AvnSpBRCpkuDtxRHKW2OgioYU6ZZXJoCmYTsk2M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QRvvxQlM; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRvvxQlM"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77615d6af4fso1181098b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 03:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758190543; x=1758795343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ul8ElkgeTFthD1gCeDvetsXA/BGz8nMUUjjJgS8RCvM=;
        b=QRvvxQlMTgmOQveuVYZR0m7E+KUESnOo2MdlzhZ+kFxcCd0k08SiZqj/BVge0KC0Gy
         Koep0aQP/rQTAjGtTMLcz0ppDXQbzBeLtAKoYA0mdhVsYYqffCVlXFGryfpDjBrv4jqC
         NqBLLa6rzzMXnMH6OGthoYkJvuxkmqi97+dimLq/7i1kfG10XaW59F8q99QWRTGm66sq
         Pr5dsTn0+O49ki69J1ZFWLhukiR2Er8z1e9CVeT2l7BQXSuRbyYd9le2EoAoLI2033SG
         18Ao/H8+Mucqaiz0ig3u7GEBhfDll3b0jN/PsfCsYHvxfVGKNw2s7/lF1Lp0m5cLHMRu
         FK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758190543; x=1758795343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ul8ElkgeTFthD1gCeDvetsXA/BGz8nMUUjjJgS8RCvM=;
        b=PPhJneYgkB5zxxb5sAXGS5IYe6VOXIBAFr8W3kPmafe29R0vm4KohiOFImNG9XbO5L
         H6AJ8whf9yTSAmjCT4F4oIp47YwJRSj6xguJA7mbjbCVf9RyQOAPKC1Ifs/pB47KJq1A
         BHN+v+6PCfcqBbnwKB9Ts6B7uxhf3HwqhFTpxdZwZ05TiL3lCELe5x1Qgx5JP6xQBZpX
         TO7hJnGg8vpyOjxQ0oLv6rhu5SwaGaCy8XtYwiQASfJhpBG6OGmhxiGRW4I+Rh8q+Nmq
         x7ohXTYiPdzIZt1y/HNQFdnk7JwgoJNPWxHP4Xzz2o2rq3AmIxto1FfODhjPAYWM4ilp
         VFJg==
X-Forwarded-Encrypted: i=1; AJvYcCVXseEbP+ESsngJIFgb/MvMeRTiElqabsDdwA9jJ7b/hpl7yppl8addQae4ZvKuaWTHQc2wVJYbKo/NR14=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA8lvjRv67WsYcr1iSfoZC+aISMkf0zoFRxCQY8wH9IYaABfIp
	JB02sUs0dd+KfZ7RngF/qQy+34ZOFQ2GOsedAakgoIuB2/UgyWMmNJoD
X-Gm-Gg: ASbGncvW/dOxgU+AbIs38JtXs1xUsxLjTd00olPIc45/KEwllujylgEFrDUYyMPvOeA
	MTKgu8Vd7Gu/amWS9a+unieU43vEl7k5jekxbV+MdXGNJdHHQwRSSIr2rlSsbkxCzwDku/E+9/Z
	JmxFbyOIQPwZQy8Kntgaagl83W/LrB6VYImTnIbUs597skURgOehGptSTRf8QpHTcdl4gZkc6oS
	Sbvnpk9HSFIioydHd+kNPRJklIE08dDnve2ze+vRsQRPfEjpaZieTFhB3kImr7llx4u5Sq46yEM
	p0YQ2WqE7UK/Ch/nguKyyuErqHZjVFWpzBP4Ipc1pMOP1MhFCT8KrT/ghokhHJ2BZNalaQIuO2x
	ZGN8OZG6N/84Tq+KsCviUJDbl+r1mgXYDMWTPrZw=
X-Google-Smtp-Source: AGHT+IEh098LpUQZCcn5N0gPt1Pj74yLqq4l/+KzbDeFs5lavn9UHh3TfGQl7xx/Rwo1+Q0mJENLyg==
X-Received: by 2002:a05:6a20:12ca:b0:24f:f79d:6696 with SMTP id adf61e73a8af0-27a9a7e77eemr8131532637.2.1758190542727;
        Thu, 18 Sep 2025 03:15:42 -0700 (PDT)
Received: from lgs.. ([223.80.110.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32edd97fe58sm4740780a91.13.2025.09.18.03.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 03:15:42 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Douglass <dan.douglass@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: caam: Add check for kcalloc() in test_len()
Date: Thu, 18 Sep 2025 18:15:27 +0800
Message-ID: <20250918101527.3458436-1-lgs201920130244@gmail.com>
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
 drivers/crypto/caam/caamrng.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e0adb326f496..d887ecf6f99d 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -183,7 +183,6 @@ static inline void test_len(struct hwrng *rng, size_t len, bool wait)
 	buf = kcalloc(CAAM_RNG_MAX_FIFO_STORE_SIZE, sizeof(u8), GFP_KERNEL);
 
 	if (!buf) {
-		dev_err(dev, "RNG buffer allocation failed\n");
 		return;
 	}
 	while (len > 0) {
-- 
2.43.0

