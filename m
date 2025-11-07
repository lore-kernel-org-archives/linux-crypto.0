Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBEC276058
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2025 08:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762503384; cv=none; b=QUb98VwPJRIgv3O0AfbtwkfIUCWKtNfLilZbS1ErDQysX7AbYz6o/5XpacU/FCg0ZXnMhlV9CYta3T/maxKY68l/5QHQ+NJ/PpJ///L8vUVIOsrt6upddH9ShWIdBKWV/WDRpckXIRBQCqjFdM8ovcSC1pDbC8yB71lKP6mFod0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762503384; c=relaxed/simple;
	bh=mwupmXstNf8xEWIA2tRou1u+HCCZBqAzg8Ar7CQRwTQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OCAh7wBpN6wOVi4GBy0ksa83g+FNZZaDN/g6yCYS7RzsI84avv3cyaFhFNfMvoq1PUEBp0rr0AamJ5gV/j9kcdjRwhFuyMiWxowcAHzZ8d+lFgwkitfg5FoR8QpN57YgzDz81xhIb5IYm7DC2D2wuKvLt8sp4S9SDPf/Po0dwz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=COiR5rzY; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="COiR5rzY"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-429cbdab700so24953f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2025 00:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762503381; x=1763108181; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V5wQ8l8yRqZt2AYZdeFxAu/RxXTrH/Y9KHqi9cP6d1Q=;
        b=COiR5rzYvR8NclwASqoMET8P/+6PttePi5axJ2FD691eaSQkEjEyv6TEkp8Ykw/6KS
         elNRREER0fzJEp4kaXS9bU40reXenItUVvGNA150ARcQT8dotbBRXWlSz0QMvC/66B6i
         OoJ71CVfDOGFPSURj8sgDhYrtGXi6QoRkHImVn+2Q7QsBdji7PhR6/6Me3r2d78hruam
         H4OQW+PLxbAFf4gg5LdEQFOypyoiCfowf4X3urj9wdjOQ9lmyajQSj/8fLcT+oFDzIg9
         oXk/eBKS8xM6F3/n/CB/Y2K5Vq6XP4dvAyjD9/u0lZDk+k31Hy83MTdt177jyZ3M61G2
         YgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762503381; x=1763108181;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V5wQ8l8yRqZt2AYZdeFxAu/RxXTrH/Y9KHqi9cP6d1Q=;
        b=wm56Xaai6B+k1ZRzWPESh8hMz09P/EVTXy5kmpFpKdm4xocjZM4251KQPebARN3AR/
         Tp+EDsaSHax8pnwKAt3SIZBN9NKPv/vCWKatY5wuS3Jf898yUpktkQU5i+6TBJiyRNhm
         t3uRzJpo7nO5VdNA7Rn4ayfLFdq+RIFuYXsv0Yt/D029+9w8PRC8Rg4nC1mDNaEfAOXY
         z6lFM4iWnUD4KWE8dMGPIgxfB39oeAYBSZUcgPnD68Rtat6aiBQ2mBmKgps3WDx76PLX
         OiyUWR/8vVa51oSVcFT1RNI6g85Vg3xCRUGVwcl1XfTTaGksX3XYL1Y3i2urw18k2hlH
         KplQ==
X-Gm-Message-State: AOJu0Yxih1+nteFAhObJzLJsxAs5CYZ7A7Cd2gDYFu9mCSCL0fVgisAh
	Lt/N4tO4S2Pnc3ek7RAJ7KShObLzs749AwuYKzzH32aZmKcgEZaytzyIgFBVuow7DL8=
X-Gm-Gg: ASbGncvL8v3aq1uJl9jem4aKPlALoJHXgMYNizOM7FGmK0YfO+LO1b0reEfhegg0KhC
	XjkRCI72jYnIFBo2xv+gbA8R2/q8o7TKTOTG+3LVftOA+2bcHPWbCRcpWiKzZM4y/jAW2yd9tkZ
	8ORWHy8FcJL+PEjBd42L2MPrdxTDhPDs80JRF+lm0WZy4TvasXs89VVPAxiR2+CWiz7/jbVWFnt
	0nGY+FAz/YHsCyqfMONbcBC614uR3TrqoNb5FNUCH/7cp65KemB3eL+RxTk23ByZc3L1yvNSG9e
	mGX9pjsXhlwM41bzE0Z4CrE2gMFxicxdRp2lWh51FAesaNlZ1Ba8cs54IFlNNVjrgkd4P/yXX/c
	5j0TaYSjufOwJ7xeVTkXpDmOEdG8Jfz9zjW8XA6+cakO3wh84pf+KWzeXRM87kNgbywXtYhwuYR
	YMeKMy/ktfoDOrlI3NvAXooHkxmiw=
X-Google-Smtp-Source: AGHT+IGiFUrINL/leIojlLr7ytWK4S+6B3l6Xe10W7uJ5w++tU15SiQgprIswsFrF6XRbpkzN7rY/A==
X-Received: by 2002:a05:6000:2886:b0:429:b4ce:c692 with SMTP id ffacd0b85a97d-42ae5aeae4fmr919422f8f.7.1762503380867;
        Fri, 07 Nov 2025 00:16:20 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679d544sm4058381f8f.46.2025.11.07.00.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 00:16:20 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Fri, 07 Nov 2025 09:15:48 +0100
Subject: [PATCH v2 1/6] hwrng: bcm2835 - Move MODULE_DEVICE_TABLE() to
 table definition
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-crypto-of-match-v2-1-a0ea93e24d2a@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1222;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=mwupmXstNf8xEWIA2tRou1u+HCCZBqAzg8Ar7CQRwTQ=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDarMNQIEm7jkhc6p5V4t84APz0kMHwWQbHoPN
 T6F+7S44veJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQ2qzAAKCRDBN2bmhouD
 10TND/wMoqicvebUpoVcbR1jTLD/jtqocL/+JgZIAAmze31Z0LQKSRT4Q1CF+zbBQSHqj5JeLKg
 Ic1EiE7D45QLDkW7P0NqLKpUu9aOvL9yR2l61QOJHjYwQcWN3rkSm1AL0XsskMpvfjL86947cAL
 K4wnFPuYC2EJ3Z1QZRlLohYdj3kbwLQlUwkKe1BUHowK6xDLkhh1FQwl/lpJF3A8pCnVFYWoquV
 9cBX6M5iDQzNS8kjLfehHPeBSLELEHOLv4Aa1Yu3glnUqw86Vj1z80RXG8l9QrozkZ5baBor+t5
 jmIM2FSe1SDsryYOIY4+Z9c69COZ3KC0vNeo5jtxYCQmnuQ6Vg7xHFooOY7uNT0LqFVR2ccNDDb
 g3Ifga+yKoycnjifcaYo0Xa3qTkincp6NpsNCLDA0mJqkFGoXlP3obFbOoi9OTo3TwvVyIw4R/O
 TlDK7Kx2mBRiePZPpvG7RNeGBAdhPkhZqbvNsEjdArJ23DGNJq63oscVhaJxBVfrcP82iQ58V5L
 Jem3bCHqb8h1/treM0vEkuXFpvD5seukFp3QZ9DYRKyLIgLLp1dDmDWKaMhmxE4N2HC1cWOGvFW
 OH6YJIl9Umg9PxPe/Qa+V63YDRjFyb2V6dokZRU0z0liBszqXCu040y58hXSoD82sqxnmNTqjye
 of4ZE2UIcI56IRg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Convention is to place MODULE_DEVICE_TABLE() immediately after
definition of the affected table, so one can easily spot missing such.
There is on the other hand no benefits of putting MODULE_DEVICE_TABLE()
far away.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index aa2b135e3ee2..0b67cfd15b11 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -138,6 +138,7 @@ static const struct of_device_id bcm2835_rng_of_match[] = {
 	{ .compatible = "brcm,bcm6368-rng"},
 	{},
 };
+MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
 
 static int bcm2835_rng_probe(struct platform_device *pdev)
 {
@@ -191,8 +192,6 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	return err;
 }
 
-MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
-
 static const struct platform_device_id bcm2835_rng_devtype[] = {
 	{ .name = "bcm2835-rng" },
 	{ .name = "bcm63xx-rng" },

-- 
2.48.1

