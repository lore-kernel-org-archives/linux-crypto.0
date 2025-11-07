Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FBD2857F9
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2025 08:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762503390; cv=none; b=oOuaSIpQE5V6zxm9Q86BIU116IvP+gSzYK560kVD9l2WCIq2DcGu2TDVG6fN3M0LHK/qdkJ2rw0fQ7tMbomKNZLCh+75BAPkyX7vopfBs9WuUmZLdcmLEEElq6xeoUo5acIvrRMLh0ZAVGRGKcooBuvvD2AfZP+erbSdk984hTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762503390; c=relaxed/simple;
	bh=EokAsdidD5G1bR5/UOxAtpT3N5gkiVxF5vZQDUQTwTc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GPx9yajyrJeg7Ir0NDUieYT2ew9nNOiVS6+KKHDd1h3ANhs0sVhpX57vdL04nCtbhZZ9f5JJoUaMtjvWvDjCTLFh5GZ1pgRqploFLNbwUL3KguKLkGq8N+xzqRrvm19FwQ1BLfr6YcyMVlXDGfWncGVGJuN3HTmAVJ2tJFXpkSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Jp6f+29s; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jp6f+29s"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4271234b49cso54109f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2025 00:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762503387; x=1763108187; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KJdRMzE2sMirb6Tls9X/j5sk41mA68F2wG8ZNddDp4M=;
        b=Jp6f+29s4EUbf6fOB5YYFn3YUD5f5wC7T8Sq1zqn9Kb7BgUsTfkkAYHjAk0m3dwvMV
         s/AqsLKSdBkJiILoChvahLcKZW6TvhrYZqed/tqOV5ThNZvWUz4BFo0u7Zr4dE6VYokr
         fUzMCxBDngXv1K7joWX2KHjJrHccT7gY20uQXL5VZlOSUrYBxAOM0DqsnC0rc+2LfWpr
         j+KFsbQF3s1F5YsGisP2I3yZIGcwrSesnMKqLXIKNi8qWMeIv9EX/Obn1w+cFrsqFX95
         cw/3gmdylJVZIQnXG3+1l8CnvWo8pC+pt1IfBOW3diiPmv6hwjE2k/J/vTy7Y62rwYG5
         TCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762503387; x=1763108187;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KJdRMzE2sMirb6Tls9X/j5sk41mA68F2wG8ZNddDp4M=;
        b=viPGfQV0ImUILjNdLLtbwrimoFAng132wGVfxsL7LnuKP7NEjnyZYsZipHgZM2Q1aH
         WZ/Tgj+c/+yaFgJXCyQzFu+/qr3sLwLZbyQhZFIZ0CQAx10aeX+YMhZnZuB4Cj1MKme6
         ZxY8iNbnStNkGsqVeCf8YZBtsODfrWXIRUErRZnLqWGQTV3IdJCTTXC3DJbUKG64KxSR
         7Syex4iD8JdhZUTm93WqyNnolqrm1qTUXrXIs9hbLbfUb0WVT27kk60nd/82LQhhupsF
         CvO7mWtcVaFU1cOVvObMgyoeI2erJycD92TfT2n7iRR/B/L4113/qRHYmonGmCP8vZ0k
         lbvQ==
X-Gm-Message-State: AOJu0YwDUvs8vox47F6l7RrP1IwY5kw6Gr4UYnhm68i9R42Ww0DwNjko
	ZqYEn+sjjin4ypmYJxDLAsqnRCU67dqo444OjWGu7a239uafCVePiIdjq/u7bgEuNzI=
X-Gm-Gg: ASbGncuUz+Vcl5GqPwS2xrFQHxhsjjqYTIqIuubF5HVkCvNQojKHBlxTS14atvKfYxa
	DAhPoJHJZSqt3uVnHQbmL3RDcPQVQ5mTl4HiXceR6XAUr60jN5bgZ5+UCO8A6hZSCzTWeslm0pj
	uz0tcXbWUk8YUmIaHFF30vjCyxEDtUa/Ng0kBD91ww17JhoUgASHNpTw25YpiLFNVMcw0Bbq9Fg
	E8Svt7x6cgw0KFKmzNbQZj6NXEr8PjhvmZmOwce9Y+72qxi9DUz9PK4BBvRfFdO7p8AC+r1+ej9
	9pAHFu1vnA7cMwrW6VUfMmc1gfa063JuFiLxcJJr8/Aasm60rfRm90+4lqs3Jdvl5t/GrKsVXxD
	SDV/zCRe3xU5GrbB4r4AmsVdNaY8PsqsSzjSE1rrK4tMwx+opWB00iBG+cjBa+ELvge1Cw6vsTd
	kkzF679ljj4c73mzSX2vW1YqheZm4BX6Va8jnqlA==
X-Google-Smtp-Source: AGHT+IGFP+Or1TYRkIggpm74Ke6SdN/q9dCVPUOpMov35dYLEJd55ABeP11Qdy6D7TpbjVv7dJYVeQ==
X-Received: by 2002:a05:6000:4308:b0:429:d084:d210 with SMTP id ffacd0b85a97d-42ad6a771ddmr843479f8f.0.1762503387155;
        Fri, 07 Nov 2025 00:16:27 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679d544sm4058381f8f.46.2025.11.07.00.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 00:16:26 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Fri, 07 Nov 2025 09:15:52 +0100
Subject: [PATCH v2 5/6] crypto: ccp - Simplify with
 of_device_get_match_data()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-crypto-of-match-v2-5-a0ea93e24d2a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1518;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=EokAsdidD5G1bR5/UOxAtpT3N5gkiVxF5vZQDUQTwTc=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDarPXV3bvhby1HPb99NpppHEOfCQPiXP0mxXL
 SPMezY6nieJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQ2qzwAKCRDBN2bmhouD
 17SqD/4sJRvlNLj9QaFrjoihtn4kBTpBm9DNcJcEdDkpBrrZRHV5vbXHsL19SheBL+VcjF9nb+K
 SbcDaGWK8AB00dRiJ1ITbkQa/F5OWgeFnhLn7iMdnO+dgGySM8EtgxkVVembbfubkJXNczRGevV
 GkMvt80eET0LpLsk3W/7LGBiCm//if1txGfFqys2QeFpsWFCQk1wVrbp5zzAKKd3I8f9lvssNHv
 jhTDj4W6Azu84Qu0cSZEXv4lOhqyDkGnA6amZzPyNak2vsTbKzi8RPSETuFKjNhi9e/gkA5WHwO
 UVTq6cRtUxy1o4z19Elg8Wgjfb1mIJ/OBC79xSRKUqDUA868qJOghxDoNpPM5Nj+0B2u17MAM4H
 4jo/KJfLbFM5ziArw4QZKC8JJSdCWjJNwPIwgiPoxqI2PApv0mA5NtUJVAiRPLyWM063PDPzMhs
 TBm4rDhmnpCR7YV/XyCbJ/YRGFl8vTpWeooJth8f5WXG6aNnZ+Zr8iFrNj4s90tTp3Z1bSFxQn8
 nMR27brFMMM9b9DgZdhvwNLVG9g9F0WBlUr34sRBdTAZ1gDR6oOxhDvu07HEErc0C+wfJ0KM01z
 37LUf+owsWufXqLfPa6Q5u0Ci/VcUIYm0XHOZULuCpWshPQA12J3DOwZBkAgUzr/DiR3wgOUtdw
 uW5+O/ePtzNubvQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Driver's probe function matches against driver's of_device_id table,
where each entry has non-NULL match data, so of_match_node() can be
simplified with of_device_get_match_data().

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/ccp/sp-platform.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index de8a8183efdb..3f9843fa7782 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -52,17 +52,6 @@ static const struct of_device_id sp_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sp_of_match);
 
-static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
-{
-	const struct of_device_id *match;
-
-	match = of_match_node(sp_of_match, pdev->dev.of_node);
-	if (match && match->data)
-		return (struct sp_dev_vdata *)match->data;
-
-	return NULL;
-}
-
 static const struct sp_dev_vdata *sp_get_acpi_version(struct platform_device *pdev)
 {
 	const struct acpi_device_id *match;
@@ -123,7 +112,7 @@ static int sp_platform_probe(struct platform_device *pdev)
 		goto e_err;
 
 	sp->dev_specific = sp_platform;
-	sp->dev_vdata = pdev->dev.of_node ? sp_get_of_version(pdev)
+	sp->dev_vdata = pdev->dev.of_node ? of_device_get_match_data(&pdev->dev)
 					 : sp_get_acpi_version(pdev);
 	if (!sp->dev_vdata) {
 		ret = -ENODEV;

-- 
2.48.1

