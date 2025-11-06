Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DFE34EF18
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446731; cv=none; b=dU3pxP2zjmK+TOP2hldYyY6pUa3BBXZl+R1ZOsOhOVan4qz+F5RwmM0M5YAKnJRVD6N/qi55vl4uYa95YJihsCSHVEMDp1rkH9CAcA/88SjDnyU2XegkgNoG27ltLI8IkXmk38PFvXCNK4yKNWFCkK271q1SR3RuNaqVCiDVfp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446731; c=relaxed/simple;
	bh=qaBcxm2OdLxs0cbfnFvZZbYz3chr7m9FXFGr3KSadGE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fWBhO9+rl1uCWqZN82n7zO9Pt1hbSHrhZaaHj4uiTXo0zOW+qgM9t9O7OXO93maM4LEw5Ekx05et7aZ4taWuH7DJr9M6YgFpQP9DK1cyi3N1h/lUzjsq713ARSwtON2yzyMNuZpC7bsN2jPbgqh/F8FFewqAneowuk7Jz9d71tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FQQhQ5Lm; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FQQhQ5Lm"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b72574b4e47so15385366b.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 08:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762446728; x=1763051528; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9SV8B/K9NFLtBTFXPw5h6HrR1/mkLN9jhMeuZKyIEzc=;
        b=FQQhQ5LmcAEZu1A7kjkyRTt85T5wkBf93KErlyfPqf9kQgkx+q73zH1NEbxQKzzGbJ
         gb6RQT/v59B65idkHJL4psWpLof6Sk0rxLtI4nxXJdz7SJAxj6+USvX0gEeVionMvKaN
         tMI3ukBsBXah/6TI0z0SSCeR0vTfCxjMYvtDRM6NLDYsi5G+VtBbGV61BnSmVr0qGAZE
         uaG7Ejim+D+4x1POuQJwIdIYZzJQvKzXD3G/lni432pw/InnDIoCL4xMC7gMpdi+SlJY
         SngM9mRtNI6srUo9KIfhyS+X0d6tQZig48Lhb5tFaqNVBAyMaNdP2ArsVwFRL0KQzVVd
         JoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446728; x=1763051528;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9SV8B/K9NFLtBTFXPw5h6HrR1/mkLN9jhMeuZKyIEzc=;
        b=QERy5D4cdihaAtPkB/F9WNCV1YrzUftihaEysaYLKbgVj/3rj1nh8ZO2VpdujbreBB
         R15jzINco5EwT4F11TfzFPqa2BLj4ylgK6FGifXq44hWjqVyhLPuZM5gcBjU9eQkyqXy
         JiqCOTuHc1pZhONz7cMTEPMjh533owzkdRiEC8sLiCvYSXpgAfHAiagHASn/l4SyLd+N
         k9sTTgrd0qPUpYzGlkgr/HfrneIwB+TDvADUokHL713TTBu0OcctrhIMe7VlbSupU1Eq
         QDtDB2mY1oa4FFEbhPE/MAjoAM5WuBq2YSqOWIlVYe4xR6gZJWMIVLCvpTyMZkGxzW0x
         M9Cw==
X-Gm-Message-State: AOJu0YzGBbE69QtMoazCGO2rUQZjDWSMYQn9KBf8JdKgj5/4JID3xfqK
	+d0CbDHyDebrsVkx7jHcVKFm+lucZ8qqE15tpj+mFISIfoGn0EfIh230+SkEBtwaKVc=
X-Gm-Gg: ASbGnctHea/jXaSRr2Rc/j3jAdfkWR0u7lRezcptZwSWJ1oBW7x99pR0lqOEzh11PBn
	4Mb6vgIinq3FTMLK4o7uzgcvAf0aN90+Fc2kn+JqqU5knSdUuJscWq7EA73sDbJ7gxBbZKkxE5Q
	CEtCIU9VLqQYsq6wtcVKmQvpM6ob5c2ezuhaWQDf9D8gCUEzTD8Ck8Bpz3ilHCo3pn5HgdlNd16
	IHNBbsHc6rYxiyOOeSjhwe5ucgAgN8JUCZccETm/OmH1jlYdDxRtfKpHswMAHxSDRR/9oxA2roe
	0HGdBJyeaaMAzPTtGHtMvv525QTGYWAh4uT8UDzfMunr1eFv1zmnXJ553jAmpD9311UpK5FDG37
	4prnEc2eO6vAAki5aTKD+qX3/sjOml74MmtUuYjM/3oC3DFZP+CfvLWS35Y4jFBegB1L4t0SNqV
	BpFOZwCg58qBk4Qvii
X-Google-Smtp-Source: AGHT+IGhxLSDzqFDqIdMNDKH4DTk1EKeSot+LXYTt6aZhf6l98vZ6t5WCJen8f3ZR0l7jgIr+lzJcw==
X-Received: by 2002:a17:907:c10:b0:b41:873d:e215 with SMTP id a640c23a62f3a-b726515d4a8mr420650466b.1.1762446728255;
        Thu, 06 Nov 2025 08:32:08 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7289682544sm249625566b.53.2025.11.06.08.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:32:07 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 06 Nov 2025 17:31:55 +0100
Subject: [PATCH 3/6] crypto: artpec6 - Simplify with
 of_device_get_match_data()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-crypto-of-match-v1-3-36b26cd35cff@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1624;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=qaBcxm2OdLxs0cbfnFvZZbYz3chr7m9FXFGr3KSadGE=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDM19Zv267ptOjwUqI8uxjH8Nnwd/rDNI9wyrc
 WIueB+DbWaJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQzNfQAKCRDBN2bmhouD
 149CD/sG6/KMDXmvV2vb0OxQfgnGFVG0l4bRcysp74kh+NtHFFCHdMve+71r+c9ZlnDkDhjtQAO
 LVlTRiZz8eSYuTx9kiHXLZRFFm7NAJhleLzU9kN1tX6Eotq1fU6A6/V5J4raRma45KqsOajkzsI
 DoyqgWD0gS0j/DYtYYYskMpzi3LAtutLaqaYSZXDgGBGiIvZggh2zYqmk2nytjh/N80QHc26o0g
 3xrdxg1DRK1SOBp8o1XzhFG/kETzhg0oO/IRz002V3RvZmutjBMe6DBbwU6Gkc3AIBUOGqKEQY5
 tveA98a4EAGf/W7+l5nhR3sfBJ7KJosfa6hwXEq/GiuGh8GYedTqQ0Ep6aioMcKacrcfRAZXnfa
 YE6skmficAnkdPHOfuoH9IN07ikeMpMlAmAES9CcYLU6P1Zv5m9PrRUrXSGMiTeuYwUtSJpY4He
 vcAhowTJinhA7ngBjntyuT/EL+naNKRqgJdm3xSNMjcgIPC760vl7n38XGA6k2+ZTVMrmiWH7UH
 U7AeZyI4xsgRxoKqQLlWHuA9qITgsCx55Qu3NA3sHWGi9PPCjgxYqlgij1LXj4oyYLmLs3XzcAG
 2CYc76oTX45O4T+z4RW0zlSOGzvCgJimsKHcnHsgSzSJ0LTwLyMLF3GRptV53kgEOA/D3NvjzZl
 OqS2XJirPWNR0rw==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Driver's probe function matches against driver's of_device_id table, so
of_match_node() can be simplified with of_device_get_match_data().

This requires changing the enum used in the driver match data entries to
non-zero, to be able to recognize error case of
of_device_get_match_data().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/axis/artpec6_crypto.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 75ee065da1ec..b0d45f5333ac 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -252,7 +252,7 @@ struct artpec6_crypto_dma_descriptors {
 };
 
 enum artpec6_crypto_variant {
-	ARTPEC6_CRYPTO,
+	ARTPEC6_CRYPTO = 1,
 	ARTPEC7_CRYPTO,
 };
 
@@ -2842,7 +2842,6 @@ MODULE_DEVICE_TABLE(of, artpec6_crypto_of_match);
 
 static int artpec6_crypto_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 	enum artpec6_crypto_variant variant;
 	struct artpec6_crypto *ac;
 	struct device *dev = &pdev->dev;
@@ -2853,12 +2852,10 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	if (artpec6_crypto_dev)
 		return -ENODEV;
 
-	match = of_match_node(artpec6_crypto_of_match, dev->of_node);
-	if (!match)
+	variant = of_device_get_match_data(dev);
+	if (!variant)
 		return -EINVAL;
 
-	variant = (enum artpec6_crypto_variant)match->data;
-
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);

-- 
2.48.1

