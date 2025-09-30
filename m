Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A8C14D283
	for <linux-crypto@vger.kernel.org>; Tue, 30 Sep 2025 03:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759202940; cv=none; b=NupO6lthLySsv8iz25asSmRREeB0pNQKoHiReX1ueWo9xhduE/OoZilwJzlmkl/61OmruykXIaAWaoTU1YOtYl1ZZsqquHsQ+y3v9FWo1BiXI1cFcBVhob4emAOncDdRRP2YRdf+Rrdd0aH20qhyvtMevzAgUZYwO8VURTJV2yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759202940; c=relaxed/simple;
	bh=7zYrZGktQSibeqiljwRaN88A5/xgn9ZA5DIxmLh9vBw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Tn7Gdh3OSXj+vuzE7bNq7WxK1tuI5d/E4Osvn2G9EpFmQW+zEpTeiMaQ0IltJtTxlxvwVMQDvuz1nRbz19rfKLguFv0KTv+Ez5z1DDFUh1PkOXJeWoF+Cf3Z7C8uK+SGVeLslmEnrUkLUwt3OgMWc18+biwaOJvCzn+LYBboiUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXfpVh85; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXfpVh85"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-32f3fa6412dso852678a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 20:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759202938; x=1759807738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TRFovpZkQdHmlzVVmXKLh8sBZCVYZYGw/tVsJurBJ/8=;
        b=WXfpVh85S78Mf3SvRJfiibAXDZaiEp8CFwwq0qxcU5kHe72GrH/uQZv2BO3ZtSbV9a
         WXZmyTSquC3AO7s/uQzDeDvPsCxCRHFHYZpROEGbX6e0KE6zwQsbYXSVezcNacC8Trh/
         /6ODd05DIoPtkgqEp0SC0qv3qnw0IHZApZQ6/odxl38hY4aURIjEuAtdGhWF/6d9lGuM
         d01vHssWZ6uYDBO6YZpdU0bePkHq+ExoVwbemBGKOkHNak5NLp7PFavgkK7X8r0Ppwr8
         SZeCvuoO7PqIMiHgY/1MWafZbd9z0VFaofgNHNBpId2kbG2HMuDET3F6einVLN0LVmjS
         Vwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759202938; x=1759807738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRFovpZkQdHmlzVVmXKLh8sBZCVYZYGw/tVsJurBJ/8=;
        b=VXnY1SzclhPzdMy7icHCdyDPnpZUNS1FimQolsE03AGs9zyf2oJh4h1gW9U+GVoQDB
         cWq62Thwucj9BbZ9mjb//FCSA7/sstZiLgeTjszR3xbMjmJ7TvdFU77S+vYuedqB3Vrx
         yU6YTvB2Y46B9FxYXfZmETfzmpVgVNTSxgwibw/i1Z8jONkzwZ9iwqwZgdNGrNCjFAYq
         vHTOPMsZu7rd3MaXfPGp40CvJMAbDfhGqL2oMchIUoc1606srkIPa2SZinNtgWH2m9lD
         II84WGREX9c+J9t1t64RxfTUQ4KpxYZa+VDSvxQ+FmLysQpEVTS4Eg6WbjtX8GSqSzqL
         6XCQ==
X-Gm-Message-State: AOJu0YwpH+aOAH/NVUBzXAs2SVCJnXBRy8Umzj/ap5H3TSPAXRkKFmw9
	/pcIB9HBkNn8M/wfXKUB9Lia4q+8EmVJSZkKQElVdIDBvj9Li8M/jtg8RSIgDIrQYAJD8Q==
X-Gm-Gg: ASbGncvz/rbywsreloY7gz/YhmV+3upV3hbFv8WMOyBxh6HB3SFGU9wzaKHvjxMTdkt
	9YWdv+AjQxYWQJ1i3J1wAiK/uS0Aaeq36NL0RIGsLtzTgotEW1eMWTMq9Pfh0ildiYDG0NK6l02
	zKyFTfPKA/u9re7W263/NinZ+1JfVxnVjCe4We38vjBGLbEHdK5hV4Dw/yWfLRT3V/n6xW+MpUW
	EzCXQqaV5z/oc8X9l7PHXYlbiEnkYQioaowtFUF0vQiLutCmRQs66PgNbowbNHVB8sRnNb5jZ6c
	cfwaZ29nxiyauUcTRXVfscVPmMEjW+OHJ0FGwJX+g2Bz6CiogjqZ4dbegNIMrBSwFAXpuort+m+
	59f1R/OzrZwGcB7xMzliZl6RwW9o9YVJ+kO9JepCdH0AARVsYdx7tBf1A
X-Google-Smtp-Source: AGHT+IHa/N2ohw99+ghxhjMZEHetlp4jEaJChxesBc5HG2FsPQSuQIS2elCMYeP0rJiGyOgxEHFHNg==
X-Received: by 2002:a17:90b:38c7:b0:32e:e18a:368d with SMTP id 98e67ed59e1d1-3342a332253mr11227633a91.8.1759202937489;
        Mon, 29 Sep 2025 20:28:57 -0700 (PDT)
Received: from localhost.localdomain ([101.44.65.32])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-338387351ccsm2841318a91.23.2025.09.29.20.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 20:28:57 -0700 (PDT)
From: Dave Sun <sunyiqixm@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dave Sun <sunyiqixm@gmail.com>
Subject: [PATCH] crypto: fix null-ptr-dereference in rng_setentropy
Date: Tue, 30 Sep 2025 11:28:24 +0800
Message-Id: <20250930032824.690214-1-sunyiqixm@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When CONFIG_CRYPTO_USER_API_RNG_CAVP is enable,
algif_type_rng->setentropy = rng_setentropy.
If we setsockopt on a af_alg socket binding a rng
algorithm with ALG_SET_DRBG_ENTROPY opt, kernel will
run to ->set_ent in rng_setentropy.

Since struct rng_alg like jent_alg dose not set set_ent
which default value is 0, null-ptr-dereference will happen.

Check ->set_ent before call it.

Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
---
 crypto/algif_rng.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 10c41adac3b1..26a75c54192b 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -303,6 +303,9 @@ static int __maybe_unused rng_setentropy(void *private, sockptr_t entropy,
 			return PTR_ERR(kentropy);
 	}
 
+	if (!crypto_rng_alg(pctx->drng)->set_ent)
+		return -EOPNOTSUPP;
+
 	crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
 	/*
 	 * Since rng doesn't perform any memory management for the entropy
-- 
2.34.1

