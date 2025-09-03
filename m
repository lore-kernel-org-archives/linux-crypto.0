Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2170B2E1C65;
	Wed,  3 Sep 2025 08:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756888551; cv=none; b=ptMd2EatStp44Z+Jah6z23aZEL5NY5hDWX/njKm2vnpyLej/c0B77/Ewm+mLJX6BF8UfzjHqDjXYFe1HLCyO3v5Cs7S4SFZA9mrADrILUsWQLRe3DfuNdZ2DFjuQDRbCa6Ql9mo54RXMQg/wPCDP4mhBRMJNTaBi+rD93/uHNv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756888551; c=relaxed/simple;
	bh=FXpJSaReT04wGYnyjEuW0itvPN0byZHu1d9vbckyoXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pG6PdbsebBkkXSLIsPBS0Jjzlww7p/4HH/79xh5igOpbfRIdepIspiJnnxwxAj2R0Kbc0gtK/upHuEcpT05QAde1GPqv2k8etAy8yp5zM/6/AqRubntxY35vdnE755Dgd1okMZEmYC4J/fyPxOusGPWWznwTY4TAPxMs6KHRQ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V7JR/Hja; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V7JR/Hja"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45cb5c60ed3so748035e9.2;
        Wed, 03 Sep 2025 01:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756888548; x=1757493348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tBLclJ49GwXW6Sl/7GWX5bwphgDLjuO5JM0C91emygw=;
        b=V7JR/HjaaeG0IvfXZ4y0MGKwyoOVlry/LZwt7hoBgn7JqREXWSWi7eqPMxCUUdjwJX
         Oad3HmWOoeDY+R2bg/0EYViesa3reVHxXJQa9VQ5dgPYq8+yg8kJq9dvpA8Gr8OehVOW
         U6J11s/a2upWuXv1cz4el95n6aRaPnaRGqapgsBh574ByDs+UQmu3yDGjy9y97Bzoo2n
         YXhQDw4j5vbBb4Qo7ZIuPWvNKyMS7aLDNDuiCJi27ScjfB1KdfgiFkldVH5oifIR0J/v
         cZzpL2XVYvBbYI/rYivF0pMlYBHG8AoK3iVKAqOuAHedNu1vEdUvc3mSdrGECkNC1/2l
         mugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756888548; x=1757493348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tBLclJ49GwXW6Sl/7GWX5bwphgDLjuO5JM0C91emygw=;
        b=alzb2EmxJRXa1oYOajMtI6EeXKZJ+QomI/l/ppaTYrpFzrfS5Rn5HM5srUK09UHH1D
         PV8FmCITay5zOJ6BdvZS3QdXq5pZWBr/5ILMNYCo/GglDVSTgQVUOq8iMMfmOmkj0D7W
         EjBC13fQp5kQ+eB+kyjcaiXYAGO2C3rIW4cANJ24TvORbRfn1XjXuyzyFqFVAzn6gzw7
         INjpcTTh7H8p+9gD3uigMg2B2X3biOWoGy9zGWN+dFIs5fe2gVSKpOaR0UBb2lyA8VnQ
         mStMpKBo69KI63G+yP3ec8hAnqPlqQH1hJ4gC864lz2BeqINkML2VdDvFdjpfw058vo4
         9gxw==
X-Forwarded-Encrypted: i=1; AJvYcCUhAshcs0n7n50UtHDG1WpM+WuonpPZxjSKzQLjBW1JkMXY/ehJAL/eqzobkfbhTaIA8YXKztVZt3NTNuD0@vger.kernel.org, AJvYcCVhuTXbnz7i/OHHxjp91kxe88EhhBjhMktnlHvNU/sPAQVNFkNG86aHyHOSb3sf9y6386PF5QFE@vger.kernel.org, AJvYcCXqZjYRWSKUUipac70zkQOwZ8NUD1uYQgoCiS1/9t/wDpM5R4wWmUuP52kJw//QUn+jSWtz3BYo//Zz8I8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWFrnha6rs5RQxA97uHgMEN7Rh+9cWct/aNNLKzi+Ia+Y5T2xp
	ou/WhCdZDvb0146BYmSqFgiIN864vtIUTNTxmNGh8QmIUiOnqfO6Dtd5
X-Gm-Gg: ASbGncsQTZWdI8HFC5bKPf3m++LNsANXUbn3zlZRxd4rD+uSy23L71UprTrkwX82XSG
	NMPFhy8WOaQd/TpPuAQcbhSCqWUvUHbbTPjtRt/A6dNn1TDvohFGMluZe31A3muMqV/eLsZaJfL
	jaOBD6hqOD47LwKF618kIQAjLQ5Q4dGMHbNIbsggohKwW0BEY+K62kDIXYx0Ao/JnXuRvMLSvNG
	x8NVtVLbtx/QHmcqKDR+D2QyKm5eVCpm8pkA/Dayf1noXSM/Ub6livyzU0o0PEe6CGd0d0jmPT9
	mEH9GO0y81keee0fokchMoAFqKMeQ7xtbW8MpEVeXT54Ae015Grjir1e2bcFPAg4scBVqnUtrAU
	TwG8UNfEpYv29XsbtPWc1pcJxI7NDu+G9nlm0jVoF/4qiHXu9Q6lNT4uypkN1nA==
X-Google-Smtp-Source: AGHT+IFW9ALHmxwCXj4TL9k6+4FVJDaJACd/tV4951OuhZUxWmtj7iVAKFlPyglc3iIZQiAhzOjBKQ==
X-Received: by 2002:a05:600c:3486:b0:45b:71fc:75cb with SMTP id 5b1f17b1804b1-45b802d2fa7mr81398485e9.5.1756888548145;
        Wed, 03 Sep 2025 01:35:48 -0700 (PDT)
Received: from thomas-precision3591.u-ga.fr ([2001:660:5301:24:6179:26f2:8797:e6a9])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-45b87abc740sm164460585e9.7.2025.09.03.01.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 01:35:47 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Nicolas Royer <nicolas@eukrea.com>,
	=?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel - Fix dma_unmap_sg() direction
Date: Wed,  3 Sep 2025 10:34:46 +0200
Message-ID: <20250903083448.621694-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It seems like everywhere in this file, dd->in_sg is mapped with
DMA_TO_DEVICE and dd->out_sg is mapped with DMA_FROM_DEVICE.

Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/crypto/atmel-tdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 098f5532f389..3b2a92029b16 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -512,7 +512,7 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 
 	if (err && (dd->flags & TDES_FLAGS_FAST)) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
-		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 	}
 
 	return err;
-- 
2.43.0

