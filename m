Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9404A1E51E7;
	Tue,  1 Apr 2025 19:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743535441; cv=none; b=LWCwf2nmFKekHvxjsuD1cV2CbLgTTlRe0mZUIk40bJ2WGwNIx54QVBlb27NJ6Mb3ioxJRbXhpBNcY7F8asRD7SO+6yO4RFGwCx/knOOz0kzbgMDar9Q/ih1msbxtMFlncOE/4qL4P2QWmSy3MKbxZRzP4ozey6lho8ZbUCOa5Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743535441; c=relaxed/simple;
	bh=C4U1jwV2UTE3RqFfFsVaxqmVcfNk30K3AoLQSuFxdSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ra3+JFpKlRP/YeIwYGCOwMPekgfjIpqoqiZqCmNgKi4nLca5+Eq6C84gzu/lTXnhGROIoSdY3xiCpxkJ713JGLa6YSXNOQlT8DVJSll2XzYaYqUqxjfYPf9Ffop4otc62LXLG0OSw07bvuzad6QpOLNggRmY2MZxFHjUSPvhGSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5Tkqe4L; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5Tkqe4L"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3914a5def6bso3391734f8f.1;
        Tue, 01 Apr 2025 12:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743535438; x=1744140238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bH5VLtP+seSAMs8ZXZEEtVjeNgw0O+SRzuS1o+Cett4=;
        b=Y5Tkqe4LskI2G6HaXGp6C6DSViqitcSv5WTIB9umKTN97oy0qa3RF5P9bwCevC68kB
         2ZSDeoaw1NHJ7XcBHrgB/3z7aHbDETmh5rhTgBUgxpMUq8GCpylsXbcQTmxDYGUhSopP
         JG9Z6+Z7I2sPatYxEOPGDdP6dfCqC1z9foeLmW9S0POYUR7XT951/Qp8e1UuhgF0lI/2
         pBkTZdWkdC5sNzcD8/rUO96qkIROFy4ItrtFWfhDZns6gy8LvpNYUCHqgeodD3myACh1
         q2UsnTPxfhILrZoC8uVJzanzo6MXkHa3ALx/MKFXrgWyt+JPxchQKwIVKxZxerV3dz48
         Vs5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743535438; x=1744140238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bH5VLtP+seSAMs8ZXZEEtVjeNgw0O+SRzuS1o+Cett4=;
        b=mKvb8v+d+mt6oaRF3y7KEEXAoZCjJ5xuiro88vI1VtOX/9b/UN3GIPwfRpLDoS4KV/
         JirUoAH7qy3BHPeFCknp998+PnC1fc6qJaumngWNDDjj2vO92q9t7rKYXw8+9UEa+7AS
         6ky11dFqU1BVOEB0mpxzbpvzuqC7pqjMyt/xSaB+F6LtkTYvE+VH6m2TcrI6IvyrYIUj
         rtz6wYKWYwig0aOhdxJxiNUz2Bl54L00pXszSaGHZ2hENVNUZyzoC83sTY+HjUvtRsRH
         on6B4cK2aZGajgPcoSPZ6NWKXjiwvOf0UYsL6WBwWCDcPFqpe4w5LByxENFhGQGvP56z
         JmTw==
X-Forwarded-Encrypted: i=1; AJvYcCUlxTAXiDzzb6cXk8lebTpbOePW619RRKK5SaxYB3KvpXusNJOGQC+z+yWdw2+RJDMJtV5wjZw1MyavXsKr@vger.kernel.org, AJvYcCX0SEhyFsrkMo2wEiS5rFR5itEbyPxPNh57mtMxXyZOaXMsm0DDv+nvE1Szr+4ebO/g2R8ikbrUYBAkqhM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1NtydY5+4ZnNjGwfPfUHcOqEBn3QPCyOdppsj+d+EAr9RFvWH
	PGfy/vEWvbBD4cDxuVgmPmDmZxrcgDI8eOho+DP3USMePIW3PWTe
X-Gm-Gg: ASbGncviEgzAMC8Ru3zP6ULWl6tz4K/Fo5jziuei/9+IjqTX6eF4Ztc/RItD4weeMTi
	9asYnCwJAhZdjJJVC8vkIJ9wqAgmRUY7nbrW3YhS4SfIr728dxRAZcovt66DPhSJ9g+0aWtknWo
	NudvhfbuRgMZpZN2gr6yp6ntKacXhC1u3Ik5yWH9/6qVQwrA+1jkJsrqOpRSLSpHPCvRk4SvO2R
	PJxzDayvcG23t7Vtoqtt5+EsfMJ8PJ9A6wq+9pal8OlIBV4/OEVO2dAChnqX/rR1ROhCrSVnwqQ
	ke1ieycjGv3q3ey2Nyg2a1565BmKIP6C5URQZnuYBIkmhApau/A9UZ9GcwzA20+mbbMA5nB1FsR
	JYzfPHe8=
X-Google-Smtp-Source: AGHT+IEeNatuio+GXvnz6jtis2Ifu8CXZWb0U2xpbF/9zUj/YkR/FHukm5fxlTJZb1XZQEdPrISlBQ==
X-Received: by 2002:a05:6000:40cf:b0:391:2e6a:30fe with SMTP id ffacd0b85a97d-39c121188b9mr9767506f8f.39.1743535437739;
        Tue, 01 Apr 2025 12:23:57 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66aa32sm15353438f8f.50.2025.04.01.12.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 12:23:57 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 2/6] crypto: sun8i-ce-hash - remove duplicated fallback checks
Date: Tue,  1 Apr 2025 22:23:17 +0300
Message-ID: <20250401192321.3370188-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
References: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove duplicated fallback checks in sun8i_ce_hash_digest(). The same
checks are already done previously in sun8i_ce_hash_need_fallback().

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 3f9d79ea01aa..2c2d285de154 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -244,21 +244,11 @@ int sun8i_ce_hash_digest(struct ahash_request *areq)
 	struct sun8i_ce_alg_template *algt;
 	struct sun8i_ce_dev *ce;
 	struct crypto_engine *engine;
-	struct scatterlist *sg;
-	int nr_sgs, e, i;
+	int e;
 
 	if (sun8i_ce_hash_need_fallback(areq))
 		return sun8i_ce_hash_digest_fb(areq);
 
-	nr_sgs = sg_nents_for_len(areq->src, areq->nbytes);
-	if (nr_sgs > MAX_SG - 1)
-		return sun8i_ce_hash_digest_fb(areq);
-
-	for_each_sg(areq->src, sg, nr_sgs, i) {
-		if (sg->length % 4 || !IS_ALIGNED(sg->offset, sizeof(u32)))
-			return sun8i_ce_hash_digest_fb(areq);
-	}
-
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
 	ce = algt->ce;
 
-- 
2.48.1

