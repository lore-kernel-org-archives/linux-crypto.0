Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B0230BFB;
	Mon, 23 Jun 2025 09:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750669870; cv=none; b=B258clcwxfuaAanw+Kto0jFoOZTaSvAdgQQRYehWdNW/TodfbDtEY6twXt3zJznJavCODHaBG2DQ38mMV+lF/3OhqLjm3pxXfMRx6Nq2sRZlxhkNCJBBkFFNjn5U6xeSa/3oDfSZUbNZCiUQnb8/NwqTB4/nVFbup80gnt281Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750669870; c=relaxed/simple;
	bh=jgDGs6S8aBeEsYJh3stb90SoB64xktcDYB4e9GaxcnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PPnbaig+RukTqxLYpUeSLDBIJWkmbL1lASyQGjHNKrE4bQZJNX4Te+sSOqwcAg2hVl0MJps5Zkrg3n9/LIAFqYHcSWfQtp5OZ0tnauL46pqb21TkK2Xmi0wkAcb2NQDVzzqgdJIg2ZzR2J12ttt7PKOIXTDcVgZPPrHQ9lJK22I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VPJiVphB; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VPJiVphB"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45306976410so1101615e9.3;
        Mon, 23 Jun 2025 02:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750669867; x=1751274667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gz8t2oZkkwfZO8pX28gYQB4KOa728jeU/jhzTTj6UZc=;
        b=VPJiVphBewlnR0xYbCOAeTl9zCUO3DuySWECRKIUqhZ62uKm4T0FWDjFUoonP/jD7L
         82tEmvn/M1Qlu5fToAo3DlNuHxglWk/SQpFojYDo/5Fmg5LzV+a355rqhQ9bKjDganKo
         t5tdfbfdgitsNTCzEgqBQg8B3gR7pRP6FxHOYVSF2nhFjarX1qJwdsR+Lf9pQUzVgxU4
         OFKZtAyfm+5m55E6rYIGnHXipLdPO0ggZpC/alUX6UbhWvVENZESw3S5X2P1B9LRxe6h
         mDlUjmzXUxmj82eWg7ScYJ5Ra4ilG6M8cpr4KVuXXefRMtuGJZ8uBFg/ROESjDHyuNz8
         G1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750669867; x=1751274667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gz8t2oZkkwfZO8pX28gYQB4KOa728jeU/jhzTTj6UZc=;
        b=T69WchcJgR/6fvHBTi6ckHR4jVbhCZ0tMkxc52wzUMEFXvKHQ5TAZmCEx/R2fMFB6V
         2iJKHPtUMQ+R32hcEox4MF0LEvNoLRl3uBO0yXJN+QJn54fELQR5YkKzGrOlONOJmkG6
         oD2y9DnHcBPcub45guZGSAhOsAjKdYWexBX1o/iRH22b+78r2jZjDzotJr0Xw+KmlGGt
         /Wzep2nsEkIfIg/ZjAcsPYtZDDLI7f7GP8OAk7bslKYFYW5fHdCBvdHNZxtGgiwsQhXt
         xZTu4PqfkP6hnaMK/XRv/i6pmv4mFcFrnPTJ+5iTpMDBpjVl+HOUQlIm+mlixdKvT4W8
         SirQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwx9Sp4+NLT1uLKA3pYHTUYCPgw0/fZ7C8PG98/7oTYNmT/Rvnc6T6AeQlmK2TUfOwmkKKsckSibZLfQuo@vger.kernel.org, AJvYcCXg+6ZJrLIHl8t4Px5Zr3O/T0zVhc3cEZNBkGvgFKoHAECPtmGDVJKtrroDjnwpI9Rrf/WDpEh+ksabgXU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZFah9Zq7/dKVLv9DA/75RpP38/edNkgMQEQqItD6vAnB/Bp4D
	CXp0g56Qom9gFTOUJ8LSgq62tHJO13XyWpBJcsxb2u/plJ2piNMr7diN
X-Gm-Gg: ASbGncvMZ5oZDrxXO7kW8EnjGnae1lsOx9UXMcuzfMEjxLo8RnwnE+9nJNq0B5sVWkw
	hOIiHvz3os5XleyygzQ3cYB7Mgy8PVSU9vIemuqPf24/CL5zSTb/6MS920eu0Wrzt5ZmYfeHH5K
	USYzaOdaDTHxsknARcHNo/XUXDZQxghgRJNLeBmfILHMo6Xz3NrF+PjZiXPiBmRErQM2/65NZjU
	oVn0E/XO7sr10mIXK5+vG1O1XJzU84rezfjQ+s53S8FhQEfoIRbID5oqOnal91WB0OGM/R+HW30
	5Y8Wx6XlZNPnDzSFwoQX9lYVW54BBkF4WpGILXBlshJGXiBEhaE+KdEXKOOdLHuND4K1l28LODD
	D9pSQxQcv2zowTOMQ2zucx8UqOA==
X-Google-Smtp-Source: AGHT+IGDWWZaT403xBnNIukKkNikvHSsmJYoL9MI3srvKJv2z/ou2KLsn00R7ev+p8rY646+IShMCw==
X-Received: by 2002:a05:600c:4685:b0:442:e608:12a6 with SMTP id 5b1f17b1804b1-453653d3d5cmr41354345e9.1.1750669866408;
        Mon, 23 Jun 2025 02:11:06 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:9a26:612f:7b52:ee76])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4536466596asm107683615e9.0.2025.06.23.02.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 02:11:06 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: sun8i-ce: Fix `dma_unmap_sg()` nents value
Date: Mon, 23 Jun 2025 11:10:06 +0200
Message-ID: <20250623091009.65436-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `dma_unmap_sg()` functions should be called with the same nents as the
`dma_map_sg()`, not the value the map function returned.

Fixes: 0605fa0f7826 ("crypto: sun8i-ce - split into prepare/run/unprepare")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index f9cf00d690e2..ce9d071f5693 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -326,8 +326,8 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
 	struct sun8i_ce_flow *chan;
 	struct ce_task *cet;
 	unsigned int ivsize, offset;
-	int nr_sgs = rctx->nr_sgs;
-	int nr_sgd = rctx->nr_sgd;
+	int ns = sg_nents_for_len(areq->src, areq->cryptlen);
+	int nd = sg_nents_for_len(areq->dst, areq->cryptlen);
 	int flow;
 
 	flow = rctx->flow;
@@ -336,11 +336,11 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
 	ivsize = crypto_skcipher_ivsize(tfm);
 
 	if (areq->src == areq->dst) {
-		dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(ce->dev, areq->src, ns, DMA_BIDIRECTIONAL);
 	} else {
-		if (nr_sgs > 0)
-			dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
-		dma_unmap_sg(ce->dev, areq->dst, nr_sgd, DMA_FROM_DEVICE);
+		if (rctx->nr_sgs > 0)
+			dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
+		dma_unmap_sg(ce->dev, areq->dst, nd, DMA_FROM_DEVICE);
 	}
 
 	if (areq->iv && ivsize > 0) {
-- 
2.43.0

