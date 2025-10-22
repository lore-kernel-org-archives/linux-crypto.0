Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170D3333448
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 11:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761131985; cv=none; b=GZz0vhusE1R9f5LrzY/2Q8fPlsBwkGhS68Mcu1yYUQBQVwMltSsVulxPGrcjP9MCbjCvLdKsMs0YWH5bOukEU829k9J8hdDB0RbqDLAJtzgHIzRJ5/prX2OIBjCef5+jDio9aR7Qal7wWgHBvGsdYqhgIJfY0RQEyu3FLE/wzIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761131985; c=relaxed/simple;
	bh=1mrG/yol1/JtpGKNAwtm5R1RG+GDRE/X9WA1wtY9TFw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ti6/3Xsf90Rb6ELPu+aUO6GYjPMR0nEWoYqaI2sSWVt2per9Whvum/t3mpNbktgIVFSWei8T8IDAhzQU4RAyWgVsb74uai0LiYZvS/N3fCxYdJAXuuq2nXc8YQ+L0TWUPbJWsV16Bq+WeeJLd0R1zw23pUu8cikKv8t/kEcTblM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WujvrG1h; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WujvrG1h"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-421851bca51so5544172f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 04:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761131980; x=1761736780; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SUARhHfbTngybzaWH5xMNt4+HQhGBHN+eDo+AihXMvI=;
        b=WujvrG1hcHgP29j9/I8E0gdlqc8glzhqA2TPs11VcjqGvWX+kOT/PKzGbMnFuDeaxj
         JttUpcEvS0ENS++sDY2JMFmuJHvszXaKMM3e9spRFWxX5weNsGAaUe1hsOMHBzVae26I
         f2AbePcRhjipIolQFFWxeNNO6c27MJ619Jwsgnuh3hWVMsvGJ/4aCsGlOoz2ytN+wB3K
         Kqg2sUZ/dofOxgA8Va+XlV7qPGlWu9oZ1QhsH5tbPGyWcwFk85aM5zJul1fMXtlYrnTQ
         uXgo1FXQ4vrjco7rU0epox4E8i2GTxucMjrvNCtOzS/cwYdoTAnBwzjCZ2py8me6kmeF
         GZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761131980; x=1761736780;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUARhHfbTngybzaWH5xMNt4+HQhGBHN+eDo+AihXMvI=;
        b=csfK5qafw6/XxHW4P0NzvLrSKF03Kc6ixMZtfBUD+Ie/jM2GwUp4AHOgkBcdafu9rh
         8rSqeIzjorKy25pYj2I9MEY94jrhan5kFj8Tp2FvXUX9pwegn+oAxed2qx6bNDGyh44y
         scoc5LnDhokUEz21sseM2m3kCPYW3wAaRCbLDDM/F7g4mo5QfRoKhEfbTgksPoFHleF3
         p1yIpX1FgKghrHHu7hEfbll0JamTk6OsCG/1Ljm6nQuIr5ZNjTV+XcLPKyxatOvQzs+X
         CbANaWEWwpyS3gCIqwKql272Kp8SLmg7n3KKjTCUkh7IxmXq9fVDvsPI5O/ydsz9yJOB
         VesQ==
X-Forwarded-Encrypted: i=1; AJvYcCWo/MMAFikQYo1mE/yL32xaNi8dEzD/QHtu+xwQ+SLmORz7HgG/ja/qrKxadQQrmi0JmM93l981Cjur6Ls=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsmAx3+e/ma9Amby7Hzv6eXJ4ZnWc1YxBDkWX/IO+5BL2OOD8e
	kRl2qn1wN4FSu7VzbPuT0j8GBJO83RQJfrjs2d3rV9/mHjY7Qukul5wbg3/0OY4Q3E4=
X-Gm-Gg: ASbGncvVYE84TLOOe/Ymw92lmq6xFWn52dRVsk+YMtZ0zSIhmSoIg4/zsvXiuEWOtWT
	EYJdh1+bF1frjQfYHZFQDk7MZcwtG2xz1rVis/jutbjRauPaMb45moRBaUJG8w5dpb+G/18Wc1k
	Wn/XHeyQdvQabag7gHrrcD5/KNLihkXMrn3kYUBDWKSJUBnVYjyvw4xZPSFRdmmfAtyJcddnnHH
	sJW3mK4w9myl2lCfOtcMN1y6AXk0GHO8FVqJfqI7bNIsAQBX1VwCse3FvFedF0yzOLAdZlpYq8J
	APIvuXnlkfj3oVKgIfdk8SrC/C0Bu1oEZFMXGiLbKXR3chHIsSzs1AjwQB7WJRbpaMwR12r3ZBL
	/w7SeGPX/HIpRYcLwXDQqBaD1ClolBKQ1PvQp6H7fuwQkkqH/g3W7ywFzUVJKd3v8PXBp9/hrn6
	0jQuws4TzBTwIXno2wrxpVnppFJCNgzXmoTekSGP2dmXL/cW9NoVnMVzXv5tkSnDk=
X-Google-Smtp-Source: AGHT+IGVU7PNSg91ufp9cPjVd4Gpkg96hHzSv4SIyKY7C0GpIrtxcWnGzFIXHyAzs+v1iGiF52UTjw==
X-Received: by 2002:a5d:59af:0:b0:427:60d:c4fb with SMTP id ffacd0b85a97d-427060dc744mr14141519f8f.60.1761131980105;
        Wed, 22 Oct 2025 04:19:40 -0700 (PDT)
Received: from ta2.c.googlers.com (213.53.77.34.bc.googleusercontent.com. [34.77.53.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a78csm24820692f8f.26.2025.10.22.04.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 04:19:39 -0700 (PDT)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Wed, 22 Oct 2025 11:19:36 +0000
Subject: [PATCH 2/2] arm64: dts: exynos: gs101: add TRNG node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-gs101-trng-v1-2-8817e2d7a6fc@linaro.org>
References: <20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org>
In-Reply-To: <20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org>
To: =?utf-8?q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, semen.protsenko@linaro.org, 
 willmcvicker@google.com, kernel-team@android.com, 
 linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Tudor Ambarus <tudor.ambarus@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761131977; l=1126;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=1mrG/yol1/JtpGKNAwtm5R1RG+GDRE/X9WA1wtY9TFw=;
 b=N48x9p6uzGpyNoZtQ8hAMytjHe8+vJa5kkVV3y1m06z+AB9vHk0dNsc9uu/baMA5o2430cy1j
 F397zeVUFBlCxW6+4mUwrPVIDH0nAoJpuD4Xo1txP/TALKLTxBnAyBu
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

Define the TRNG node. GS101 TRNG works well with the current
Exynos850 TRNG support. Specify the Google specific compatible
in front of the Exynos one.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/google/gs101.dtsi b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
index d06d1d05f36408137a8acd98e43d48ea7d4f4292..380f7e70910ab8bcc28690782532fff87ca7e30b 100644
--- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
+++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
@@ -630,6 +630,15 @@ watchdog_cl1: watchdog@10070000 {
 			status = "disabled";
 		};
 
+		trng: rng@10141400 {
+			compatible = "google,gs101-trng",
+				     "samsung,exynos850-trng";
+			reg = <0x10141400 0x100>;
+			clocks = <&cmu_misc CLK_GOUT_MISC_SSS_I_ACLK>,
+				 <&cmu_misc CLK_GOUT_MISC_SSS_I_PCLK>;
+			clock-names = "secss", "pclk";
+		};
+
 		gic: interrupt-controller@10400000 {
 			compatible = "arm,gic-v3";
 			#address-cells = <0>;

-- 
2.51.0.915.g61a8936c21-goog

