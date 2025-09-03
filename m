Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2E22E54C8;
	Wed,  3 Sep 2025 08:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756886839; cv=none; b=IB54/gBgcO+IcLS3giM6zR4e90gdJC4MmRwILjPm1a6pzRKypCdbDvWNX41RLEVtS5QvREBmSSf9dBKHMpX2f+WwKwFwpNzP6jZKbLy+FYuvrJQ1Uyhg86p2fVCXbd/e/WBWwxsC8CNSs+IFcbgK+MfjAUHbhWBJp0y7F9UrTBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756886839; c=relaxed/simple;
	bh=VshbNHGT/d2pjHoF9/J0MH2WYAbtTTCtbfaiPhsWUU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BrrcK3J+VVJftdp2LPcxacLNqA/uVlZ6YATCAVjg7BkZ0Mzv0mjEnhzV+tVK/jlaYNRiM0UnXTxbqkrwjFuzSQMyE7KpXiHAfLSWTK7/w6eQM5jL20hQQ+yS0c1V0xbjpNLURJrtl4SfrZMhCWd+GAxUMDFunsadX7lGilYm/lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YnbBQYr+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnbBQYr+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45cb5c60ed3so694655e9.2;
        Wed, 03 Sep 2025 01:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756886835; x=1757491635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hZTy5PSuTM5rEw0pIf6nxs+pKdYAXNk6URBgB/E9ySA=;
        b=YnbBQYr+cX9Bvd0pZf0BgdlnmPtTzRmZkAnNTxC7zpCR0rEoAXKqc7FeGJdTmay9pi
         ODpH1G5c1Co/0u2rYNTOO1j+Cy3/WyhZDzNdvJpRNvyKzewaK1Nhzx3C3ZvYi2cH1cxZ
         p6ZOBpXvqbe+AQOlkSvGrHuFMQjOSlmuFgijecHLJuwUBhncU7UAcGE+Q+Bs5ovtB+wU
         CqhQFd5tKJgzXTziynBwq/+ePt/WIDIie6+9BQBvyo+SXb8+0mYiRHtglzVEd8GhCWOY
         vT4jvLarlQ5zWaNYU4ZbwqjyWyOYZwGLaIiCWcIJDc8B7C1PB/oNQFc0Tre24HpT2Xpt
         PX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756886835; x=1757491635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hZTy5PSuTM5rEw0pIf6nxs+pKdYAXNk6URBgB/E9ySA=;
        b=mjQjuMBr7wSU9TJwUF+asPattU0Bn5V0XUb1Zh4QbAB2B+sPf7JCCa/GeYW9WoYSG6
         Mzs07Jy1rJLs0WWvwNw122diRAk1F3lz6h1PufJhDRsIpbNIR9u4/aI+5Uut+BVT44dg
         /Nvx9KvZp8u3BogHVUGdnAlRgpQrvxxR8N4R8BASADtdhGcpyziS3d1DzuyF/jGIeRnE
         N/8JhLi2+fsjFCg9EiWu2XWjmxzJitrmIDRkPVTwlZLKRzR9xTFCYiRJRPtv6TzmEU5i
         69UjFW1arXw+JEw4tCusdxJio8VVaSqh/dKpaOY4MaK2CgNZIcewGeT63G4d4fDeMDB8
         Xoqg==
X-Forwarded-Encrypted: i=1; AJvYcCUUMk0kSyh412lNVd9IJYlEeE4ovCa9e+gMbGXSBXbE6lP5FSxrxXbPHWbuacg9YBR28R1Tt+abH8lK+lk=@vger.kernel.org, AJvYcCUxyp0MI2LQ4EP6HxdC8bMfKVoQRMBH1vNht1a286U3GWFurw9TucdfMmDOS8zB7OyoE8H9dd/myf9Ydtw5@vger.kernel.org, AJvYcCVBC2gKInije7QQVM6gxy+gzpAo/sA++TPPMS6ZkXHTUi9Unzwq48NRO2mTa7QNYvaJupnjW1Yk@vger.kernel.org
X-Gm-Message-State: AOJu0Yxph0U+Prvl8x15pWZQDW2npBwrx7Z88TjOmaAOoVtY+M9wp8bi
	wThwFWU+u1SHpuIHyQmmeP/YSvaYqLcDwzBf4dDLfmpIuQdsGHCNtyOh
X-Gm-Gg: ASbGnctPk3h5JvKTFlM28lxiwSdGJIpveSe+eCU1FBGDZFTgGcmUHVtbtXMHquih8Xb
	WMDWsqkkERCYynH5qnTHNKd9RTfcugjwF84HtgxZPw8ioXTp35oUPAbsgPKTx1+jCjTcAzXHkTK
	ZtxhBprhld9uPJI/xGRpWh8yz2xwtTdTY5twtTrbja+Ql3l3Q8xsy2uPIvM31wzv3Fd4DBw4zRV
	kCu31D5JBRBRtb06iIsPTX2bUELdoESpEbVzarR32q3U9y8LkdGNSTlt4X+i2WWjlpsRr1p02Cj
	qUCxi+a6BScXdZsvjARnoXichdBBKPqfhDwqdwf9MhfeY2yU2h6Cmq0Y5UpchAzaGRqhonCPzqq
	d5s16ZFNuo3q5zMNF4dMvTcXp99bKFV348TZP6dTFkVgGKsHu+ic6QJ1+2ZX3Pw==
X-Google-Smtp-Source: AGHT+IEpGBOP1B1Jph5fgexU4vMmswDuYQqgA49JGWQuOcwTIUvg6AkoYPsE1hTfBRhrYgvcN4/h2A==
X-Received: by 2002:a05:6000:2883:b0:3cb:9930:78bd with SMTP id ffacd0b85a97d-3d064dfe9camr6000577f8f.5.1756886834510;
        Wed, 03 Sep 2025 01:07:14 -0700 (PDT)
Received: from thomas-precision3591.u-ga.fr ([2001:660:5301:24:6179:26f2:8797:e6a9])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3d3a7492001sm17768599f8f.42.2025.09.03.01.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 01:07:14 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	John Keeping <john@keeping.me.uk>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: rockchip - Fix dma_unmap_sg() nents value
Date: Wed,  3 Sep 2025 10:06:46 +0200
Message-ID: <20250903080648.614539-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 57d67c6e8219 ("crypto: rockchip - rework by using crypto_engine")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index d6928ebe9526..b9f5a8b42e66 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -254,7 +254,7 @@ static void rk_hash_unprepare(struct crypto_engine *engine, void *breq)
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
 	struct rk_crypto_info *rkc = rctx->dev;
 
-	dma_unmap_sg(rkc->dev, areq->src, rctx->nrsg, DMA_TO_DEVICE);
+	dma_unmap_sg(rkc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
 }
 
 static int rk_hash_run(struct crypto_engine *engine, void *breq)
-- 
2.43.0

