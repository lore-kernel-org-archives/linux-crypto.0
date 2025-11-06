Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489B257831
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446730; cv=none; b=fa47qzpPHKfO1xClX4Q4FOOeaTtCjenidl9u21C2ZbgWt62aCCBiHL+kg5Y0XgTu7XPKBTw/H3wv/LQJFS38VihWY1JlfugD+yNj1p07Gd6ZiCdL93mo0j8xYHM6Iq/6OMN6mSaPxf7dRA9CWd4JF5EWJIYeV9leyCyMHJPhPsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446730; c=relaxed/simple;
	bh=OSkOsUuVlg6GLdS62ttCYUPhNKUQP/BVpUmRlzCzTaI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DxDyvm+McKu93UVwFYcHXQ8RkcsIcvAf8ZL+qYW0Ws8ugSDV9j54ZkpV6ofLMrYc/mWGl8uUJnU3n1k6nx9M6fyJbZWTK7xklt7Vx20pPUxzpRZVX8JqQVIMiUE8Kq71MgX4sOkD5UaAOIZX7tRLND4dRMxVNpb/G3qL3TGsGG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AjIE0wiP; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AjIE0wiP"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640ef485673so200648a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 08:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762446726; x=1763051526; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nl8B6nEMFNCaIMxBOpENwK7soxjPDYqVlsWMLGlYbqo=;
        b=AjIE0wiPe3Djxm4DvMi463ezQnXZ3b+SgGqVSQzf4gmD43AMGW/LpjWsok6ectbnj1
         I0jQnW5D/nC2T3ucSZ2bxDDmH1gqPbD1/95GQPo6vwNCB30mqO4Xy0UDU4Zb90gG5T+z
         PehcthdqVXVQdRiFzPD1igmA7IMAy5aV3L0UUA52x4fqz+6ODEZQzgXGJSqg6dJOZAWy
         +qqCaJaVbv49NBMD/xfP2z5qvH/Sec6hdCBrGCuM90B53aYWXnR6bRZ+Yh0c1+PBdlL6
         s/9VFA/QPu5q4wMMN+8Thi0SXqTa+2oD7Lu5r9fkR5cfPt30FRnRJ17VeCOtoptZ47KV
         fRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446726; x=1763051526;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nl8B6nEMFNCaIMxBOpENwK7soxjPDYqVlsWMLGlYbqo=;
        b=IEToToM37n9J36B4k88m4Uv0/qEMhPtLaNY/vOp84R5TfP19B9oiIABmVRg+A09VKa
         RY+Tlu87918RF1BqGATPGmdXU0mpPvFPEsQypzweNtDnnDW4VA62UytdfH3zngHyji4l
         8T+ToZXU68UYF4qv42TSxRchYYUhXvR+uXA4bFZbvNT31iO5tbHNM8KlKncO0hGOu7U/
         +BvomOCLbdHgqWqSxMIx8xuDkSk5+Vec3oR3u8XvvOI6BbPmKy51qvh9x3R6OstN9nlA
         4N3vmNCJkSmvxUcEZnusJH7peTNON5AoxBzwOIjObeP2fEqTUWW3H49s9VxAH77eRO+Q
         IoBQ==
X-Gm-Message-State: AOJu0Yz5xDgoD6XIw0ORZ2OKjWsFj7UB8RtOGXn2P8Cp1pxac+6+zR1K
	OG0mCiPDGdMdeE+z3ZFiGk0zKj65MIbKEb/JH1+JIkGxJdvkTo6ZJaDRmmld2G5GjjM=
X-Gm-Gg: ASbGncvTxRZFHJVXuqcqCdi3Xoe/OV/HHyA6fqgU3Mt5YSbx0YfCMh89Vjq16f3R8Tb
	3onBnrcDRk8OeJX61RH5K7M0+Z2oPef4nfC6OgDZg1hiSd5dp9E8foNcqU4baWP5UHwaEVm1tZw
	PcyYDAbo3YM3d55/s/XmbVHKF6pUTtlfALjigQWkIeTgs4lFMxTucNMUjy8aeQXWMrZ7irtz1D5
	BfevUKtvcgiIivFimuZWDb2ngXHSAZ0q3LFjgpj+X7AaBt74xAEGxbMFys6VNJ5wU9v8Au/09wC
	YKFpN1MmUGztdr3SfC72LZEoCnUpQIjJjMa/wBYGfLlwGUDScMJWOD0KBuNrGVWiDQSOa6+4Tma
	d51PVFnKBv4Zw3Xy6IWh/Hf3tv7dv507JK01GnQLOBtAmsQvSCFffIHV9I8Hg20d+Xn+An/b2tf
	WPG/pCJJH1z5x+1pFCCydrKv7NZlWXu9G7JXAs1Q==
X-Google-Smtp-Source: AGHT+IGNSl1Ed2xXDzHWzebcvMpuMKE0I1VybzAYLIxqfGPNLYgMk+ia6VoGdXlED1r6tZ/tH76vzg==
X-Received: by 2002:a17:907:7ea6:b0:b70:e685:5ac8 with SMTP id a640c23a62f3a-b726529e5bemr390647166b.3.1762446726359;
        Thu, 06 Nov 2025 08:32:06 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7289682544sm249625566b.53.2025.11.06.08.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:32:05 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 06 Nov 2025 17:31:54 +0100
Subject: [PATCH 2/6] hwrng: bcm2835 - Simplify with
 of_device_get_match_data()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-crypto-of-match-v1-2-36b26cd35cff@linaro.org>
References: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
In-Reply-To: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>, 
 Jesper Nilsson <jesper.nilsson@axis.com>, 
 Lars Persson <lars.persson@axis.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
 Srujana Challa <schalla@marvell.com>, 
 Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@axis.com, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1411;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=OSkOsUuVlg6GLdS62ttCYUPhNKUQP/BVpUmRlzCzTaI=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDM18i3ym17y8uHBLXLjTcNt6evy0G+AKTl6Gd
 KTpxitcse2JAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQzNfAAKCRDBN2bmhouD
 11svD/9xYqmLA5ExQT3JeaxEHdcTHOHgHeupGZO8K921owhdrik9RujjUgBMCnQBrp53sjGaY4p
 KLbKsGzvIxi221UDIU3IrSgbYL7KPyXLMc9CzNt7i2GYvSm+MeOTy3sGLlDOQDC4feFji7+rd8e
 m6DlsXUqamrdzqLXQUDqslEsZKS+DMwZqT4W5lN/YiX/24PxVruUrJyf2mUvTwnySDtjp4m4l4s
 qJo5wFGyjtr2+PK5AED2MayM0EWroY4ihWedi1UhvK/wuocjHlqKEsHKwHrAvFo77KBZH7GB0PD
 c38ZqHOO6Gry0ggpbIS11Fz3PVE/Ndq6gE1K5IayVQpBj/YwN41QalHiumyUbxqthETKpyfTEuQ
 Qdb5nHA1zckfGJPGPvBQQLOByJWSFhhklmKbZHJgjioSz4FVx6lw46Xw/gEg+bGbOI8KgeuBm/d
 omVXzSxWYONHkIMnI3/TcxpJlMftG63wJWuTx8D4HFTg2QeQzI0ZPIPN/ExHreXYWGGJAVGk2Uo
 T1ImI3PJchId3h5YjzhIBuTwfmR6Yv3L79nJEydV1A6O9Ei/5elrZtuPCSlk+syaZ+WCj8zTzX5
 wrq0aLqX+ap8+UjECEMh6wF86EjoKkDHFqAK8PKoKXNu1K4UXrjdLGX/fw7cMaeYN4+XccV0gKE
 OnvLDOPHm7JkHBw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Driver's probe function matches against driver's of_device_id table,
where each entry has non-NULL match data, so of_match_node() can be
simplified with of_device_get_match_data().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 0b67cfd15b11..6d6ac409efcf 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -142,9 +142,7 @@ MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
 
 static int bcm2835_rng_probe(struct platform_device *pdev)
 {
-	const struct bcm2835_rng_of_data *of_data;
 	struct device *dev = &pdev->dev;
-	const struct of_device_id *rng_id;
 	struct bcm2835_rng_priv *priv;
 	int err;
 
@@ -172,12 +170,10 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	priv->rng.cleanup = bcm2835_rng_cleanup;
 
 	if (dev_of_node(dev)) {
-		rng_id = of_match_node(bcm2835_rng_of_match, dev->of_node);
-		if (!rng_id)
-			return -EINVAL;
+		const struct bcm2835_rng_of_data *of_data;
 
 		/* Check for rng init function, execute it */
-		of_data = rng_id->data;
+		of_data = of_device_get_match_data(dev);
 		if (of_data)
 			priv->mask_interrupts = of_data->mask_interrupts;
 	}

-- 
2.48.1

