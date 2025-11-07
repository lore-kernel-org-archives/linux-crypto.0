Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E947230FC33
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2025 08:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762503389; cv=none; b=ZlVEdt5WlgGVlWqmOpF3WS9Jc9Gr7bLLMr7XiboZC/do6KjXEQWljTgja5WMubde6SGayBBZrKRnOhF3Tjrk2levbTACBTNEJ6a2PzBoJo5b2kgYtMf93FeBY639l7SS/Dg81+5Q36RWn/WZ+hQGQ3qzOaC1bRARKARno/8gWSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762503389; c=relaxed/simple;
	bh=DQmjxDQk3FjHige1OE8Ou8+bJv85dK/Lal/Y6klcg5k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dCmqMdnh0IB2CvsKgqH38fSQPiud/phO88sb3V91PypdOqwf2h9uZ2BbJB4vRXrfp3/X8WwNVjvX4EPPpWtbg+hrSaRnnCjtSLOyBpOHnDpae1QC559u/zf1f2+fOoAsI1w1dLenbIZZyQAs//AZdtnbjlr7f025vA3gI0360b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K63IoFjk; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K63IoFjk"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429c8d1be2eso32901f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2025 00:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762503384; x=1763108184; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aU3ckHK9dgiwiJ1SDtj2Q9mmUFDa+cikTDpXLmxraq0=;
        b=K63IoFjkE26DOlE1ZZ9Fl8CV0LPB8CfcBwJOsGPjXbczI7AtzftR4d+l77aQ+cFdHc
         3QdWXlqjddmZaTB5Z0xjFtCw4ZLIVTrOx5DtuaCeV1gqBsuwkCmwvyt7iq5AB1R9D85Z
         kw6/44HAsK7b7eibQEbrhgkOpGRFYv24liHSrCKnPaSo90gRzs7X0yBk3XZYZGsyrHhm
         UKSrJmuUml9+oj5/u5VA3ojWn7LAulegbqLK4GZOrJIAkU9ngVLE0/nuzVrOCZgqNghs
         tl37qLkwpeoUuBo+NkIcnG9Y5iE4xAQnIRk7zCTwa6IA8dFuY7qUlLGt0zvbRzN+xn4H
         IzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762503384; x=1763108184;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aU3ckHK9dgiwiJ1SDtj2Q9mmUFDa+cikTDpXLmxraq0=;
        b=l788fdsFqq14jFJ9yT2mhWGUA2vuHpWV4YNZjFtI2rk+MJQVIz6LvzPGbJ47H0VswY
         HK68k6S+b7ODHG3V3to06wKbrJGA/LHeweW6CPnpnSCl77Bq9XNr8OtiHSQ1XM6nUUB9
         P4SsJpr93Bi5zXqZK3G0UmVEYQtGfILEjJz7zfUzY48VeU0igw39+G2iMwODdVZy+Zha
         ovA5NUJKb9QkFPTGlzAgts+04DM0TYVdt44rQFvURsseK9S4L1R2jqI7GgBWmK12fmJa
         T5boXH7h6qdB69apoGuIeMMz6L5VJREPrEmN6tT/O0ox2xJsGDmEC3NGwEC/wRwCsMyR
         ehAw==
X-Gm-Message-State: AOJu0YzgV2/a3Z0UcrXES5UIxe3QY8LMftxjR1sbsBKgIewrLIqPHS+w
	7Hb4TCbCGeR+xMJcRGD1vH9jvmH/KfqcQ0QsiGQhQRDAARInwk2kkSNA5Yejld4iZVs=
X-Gm-Gg: ASbGnctdOJGmt4vfr/V5ydbmW5qzGePmKmWOAdV8ijsAIXE5TwvR4Hm/CKm4xvMQBOZ
	UetSMS9Pnkj5VudQAFvej+eqwcHymwxShqYt8iIvyuz6+bjslS7J8NL3qB4W6LXhunXAj3SE1Zf
	jQd97Y5ZIMyj7y6d3IfUIPy0rwhoAiWQGdizs8Q5gTVZP4+xFTmthl/8kBKNPLdRVHvVAEqPVT5
	fjX+14MBg13lbh81R9GSMV6U0K6TsxGEyNn3YBVuWzIpEQMxTtE3rQ1MwBAHJ6JzquC5GXnT6I8
	gW9n+UNIRclgNpUZ8UZkiqp9OHDC0vCmhwiW6ADU9kf2O6ktcoWPfP2LmDXp9qGiGXzWzcEDUtv
	2q9WrIJKLp/2GL/sOK+xFHYpIHM8MIv9icr59qb6qf2idPkQXkcVVw5e5a0+mRtHBcZsavaGBnG
	5nB0uHCpmNzQcsCqJT
X-Google-Smtp-Source: AGHT+IH/RG0uxXiS/Bad3Qza1ZSpzCt5mxPh4pMV3zd/0zfxxfO/oX4SzRHF7EYOxVilfXSfENyJNA==
X-Received: by 2002:a05:6000:1848:b0:429:b751:7922 with SMTP id ffacd0b85a97d-42ae5aeaef9mr862850f8f.8.1762503384161;
        Fri, 07 Nov 2025 00:16:24 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679d544sm4058381f8f.46.2025.11.07.00.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 00:16:23 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Fri, 07 Nov 2025 09:15:50 +0100
Subject: [PATCH v2 3/6] crypto: artpec6 - Simplify with
 of_device_get_match_data()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-crypto-of-match-v2-3-a0ea93e24d2a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1653;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=DQmjxDQk3FjHige1OE8Ou8+bJv85dK/Lal/Y6klcg5k=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDarNuKezPIUCrc4hA8Jc267ky7kEGrYSaIA8q
 xzBceHykJGJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQ2qzQAKCRDBN2bmhouD
 1yXbEACApfTnmc9QitQZ7XSNkCS4VPyfKF/yLOgWiI3obDxmie7No/brRdIf5LMnNazuIyPCZF3
 cFWq/lMz/XGuXHwd6JfKiB/7CaeiEGhSVesqCG6xiLwn9swYpTXCRAkfkSfvLUJ1zw6Dqh79+nm
 RcWi4MkYDvpv05EKstpdQAc0p93wcuPKRkneKXx+eaPyUE/Lh37ne4zR3Ct8U+21S0sLADr6CoN
 cEwOiG5d3LIphAp78Y3xCT7+UqZKyQfKVrF04V5E3jF4bAbL9KiZhgHxfr6u1Ymtoigbvr75tHF
 rrjHned89Lt/e4LJnp716ojV8vi8qBD0fziwotfbBGbZc9WCPWIddPJKbtcD6JEGZSBGptebElN
 q5XqPkiqkSa4aWdQrwmi/H/uZ7aefqryw156F+Bj5DQwnJTuw+6tA4vFnB0N2caGA1hNIAoqvJQ
 QS1fmrXafW0XOKw2lvkL5EJSix7d5URiz8RrEq6geM1aajgUHhypvhCFmUw3Pg1Zs0rp01uWCRd
 CHkS0/IfDTayW/vN1mHLSqv81WjvP1xoesX5Vico0Y4V07eB8RwSIC8cGNs+0A2EgDPy6mJyacY
 bQ/pElgAalP6edLqPZQS5dRVAwQA6cVRgw2JqSebY+zuOKUJwlNxGqWvYZbjVPpq/nQp8yVweXr
 9i4P/m1X/ZKL/bg==
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
index 75ee065da1ec..b04d6379244a 100644
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
+	variant = (enum artpec6_crypto_variant)of_device_get_match_data(dev);
+	if (!variant)
 		return -EINVAL;
 
-	variant = (enum artpec6_crypto_variant)match->data;
-
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);

-- 
2.48.1

