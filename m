Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8412877D7
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2025 08:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762503386; cv=none; b=PhzcJsjjNJyfV+pxUXkWuvMqlKjvQH4ltfbNGHli9ojwNB+ddGb2jCIm2R8D4PmMW5TVBg+/u13EqByGqPioErtO6DulVx0JFgeYDF3N9x9W4Rer9lFCvX+dZV8NSTxLJ7zGMDsTNkjvUfrJeyE35wjN+jvByhsA6LwXMkQCUqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762503386; c=relaxed/simple;
	bh=KzWXn+yRUUjpBHJaXgRwSAXb1HJyVmNmYBGEb7asavE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NXoUkC1ynTRUQ6I7LhmG+7VQQOhDq2lo65WxKaxcBz3pVD58fS8bb7xt5H5/E59NHl/OIUdqxOGN2ZWAA9idAWHX03Wxoor8cZOy85WR66UPuuXXROAnp0kBw8X+5PhxX3nSxPaQa0HLMqzPSxk0OMEAczfR5/uHF3xteyMBTNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wJoPvWAj; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wJoPvWAj"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-429c844066fso60405f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2025 00:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762503383; x=1763108183; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iCvxgq9zYPyMV5RPPEtwvCqno8HSagbXhXnbN1FGzJY=;
        b=wJoPvWAjDNsQo75o9F1XihcBniaON/4swlNWgWa+5PVPviJ6CMpzqbN5WMkRgK+BmE
         J81GVex6q8gXnVo6r9V6CJiZi6ij6vsKCFXeFyF6vWpopqkx0fIceO+HcHAcNN7yr6vg
         EsJaK60hkablPQ1INA8MS/LBtUbQcEuWcqsLTmABEOtSLIFGzm31cgyiCSpEGEXdT3Kk
         +DPyBCVn+Pxb73Tl51Kx5qvxL7rU5oT672uAE5aPho9UyqZjDse/DLjHqWJeT4ulEDYi
         j6Wel21fZ4fxWxsZ1xV+FHWfI/E2Kwy3tIa2Tkz1TRajblUS9LmkasTMKNtuKNp9BXQS
         2z8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762503383; x=1763108183;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iCvxgq9zYPyMV5RPPEtwvCqno8HSagbXhXnbN1FGzJY=;
        b=G6EIH0DAnOTDQf/YMsZOAYvFlLaqMcZ6lkpGz0P+LIO5dDBwj6FIIyBabo93iiX84w
         bxmoQR0Kj0o5ncz8LnTp5rNq2Qfyl6i4SvZ3xfPFLx1x+F85gh++HYCntWmTvaTgqqBD
         eHKbWu53VvS3ThCIxJEozRQlM2T61CoCP7kBjkLa+jqHtgbkK0mQNWEH23LmM+t7dDtR
         snfkBFw4DkKpv8ubvSB0xJN7DibQnLOdLt7qQUBDcthjNV0S+gz1HxowzxZGk6JsWbWZ
         G+X9VfinB7RwfD1tEoGkIDELn+6jsTd3T+XyzWXrCQrUqE5coq3P/9/h6B3remD5g6ZX
         yeKQ==
X-Gm-Message-State: AOJu0YwNwnmoFLx8O1sC8SSY8lUx0WDYyHJ8IbRJlBiNl7BAITDBnTDg
	ZoCDk5wIHF6ThpDk+tAKz8bCQwXh8FvYfV0XazF9TowSKFYPGPlL1PX7Ky6PWgK0sVo=
X-Gm-Gg: ASbGncu9Yicea2+9lC/BN0G/nJulptjoh/zBSyXtKmBlb1NMPBEzOfjiw3gjy4wekl4
	5Q2MInlhfEPcc/vy8+5PSQOEMhl6s2dAxDGKc6aaM0IMiFL+/mGuJi964dlWIN3jaFHp9dj2BA2
	bqKu6mxrJ8bUFgZ8P77kM+b9+t72iNspRcSKZf4TMZJ2ZyxU7ykf/oULyojQPmXq9Q3g6SLCJ0m
	3317V7rbFp3/xwLhcOOpT1E78YJ0LA1+XXqjrkdroksUxa/OIYqoYh7QPzRx6O4imRo/TtfHo8n
	RIprmAZwa7XzbXSw5iibjPZRu8npZf2f+THsUCPrpTVdq4C2apM6INcKs7576QvQdA+sgHJK7YL
	VO1kRgiSG/7ENoHR2KZivjU0I04VJ+eB73OcZAsW6uBuHR/KYV7vdSLtLoc++d//gbyTOhODLqo
	GFcLbRoinOlCJfBxHBT3B9LBkVoV0=
X-Google-Smtp-Source: AGHT+IG1WfPwzcneuCdATSCE09C1Y773iKrUOLTnPDkh/cXKuCKQ3K5m15q+fwccDXPfnzCmzpQ3Jw==
X-Received: by 2002:a05:600c:a06:b0:471:ab1:18f5 with SMTP id 5b1f17b1804b1-4776bcc5334mr10868915e9.7.1762503382674;
        Fri, 07 Nov 2025 00:16:22 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679d544sm4058381f8f.46.2025.11.07.00.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 00:16:22 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Fri, 07 Nov 2025 09:15:49 +0100
Subject: [PATCH v2 2/6] hwrng: bcm2835 - Simplify with
 of_device_get_match_data()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-crypto-of-match-v2-2-a0ea93e24d2a@linaro.org>
References: <20251107-crypto-of-match-v2-0-a0ea93e24d2a@linaro.org>
In-Reply-To: <20251107-crypto-of-match-v2-0-a0ea93e24d2a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1474;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=KzWXn+yRUUjpBHJaXgRwSAXb1HJyVmNmYBGEb7asavE=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDarNNAJtIDGyF0BhraA4Wnr5mnztF9FLWAyE4
 QqQdRi0AUaJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQ2qzQAKCRDBN2bmhouD
 15E5D/9wMVJ2fBEQHcIitgPv5MZFIyz/UJUAVG5KpW34AGSs13BNXX9GX9JhxLopOlp4kbCw7LD
 LM83IxKwW3aPefI/ObmGin+Z8QuT7c4+iBH3BF8oZLMY816wuEvhUUOBK25+MN92Et1e2GK2x47
 D+7l2c/Ckz5y/KZKuUaQVx4yqIVYHsDgQMmpYdQo4jAHOZ+vZ4UE5NPul6Di0O4xtNSHbdN9ppU
 ojKI++kkK2+aHUG5bbdZzh0HlXyYzYnZL2Mwd6d8eH77j5+rcOlmM25j3q2Rm3GHHyQlX72/WqI
 XyHZLur3iHCfwdLU5i+TnSydF02ZTC2RgmlW8g7JsRaIxaDnv8pG5c9Lv62kuI4uFyc7wpRN1eg
 D7FH7I5nO86WJUf9XsgTqqyBZ3xHsr372Xlmmcwql4bGQ0W/mtk9x6oINveXqB07jplrUK6jgaT
 ica/DQIrHkSwtGAYP1d3klEQJl9elCyP2rbqbMAcwCK4ugqTH9sKrItpB7nolG/fooCvwZhscaI
 tCvarQKE/ugM1/VKq2is7VECZJX9RdjtbVR3JDUqqt32PkTM5xPeCBbusX4Ze9O+FNPhtc9OqYa
 tJI8rzapmJEkLvPLX93C4eW27wIra8myCvPx1F5zyQh3z8LFN2cgajSoT+1h4eCE9kN+S/Y5yX3
 ED+hsjI9pJQgvqw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Driver's probe function matches against driver's of_device_id table,
where each entry has non-NULL match data, so of_match_node() can be
simplified with of_device_get_match_data().

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
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

