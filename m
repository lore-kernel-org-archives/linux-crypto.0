Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211761849CA
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 20:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718743532; cv=none; b=WHsGNqoyR56Wms+MghUWVWxDdAskzzjqduY/N2CpvfxMP3FYcgDph94zjSIJUwHKMw7H1tK0lvJAXLwQtKqQ9KTufpVaBzU0NPyjdrUyzVV1hzSMypW4X63+uWGSfPUtHE0RX20Cgpn7kav5vDpK53PTwkuRLZCE8+wm212rfZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718743532; c=relaxed/simple;
	bh=OTr12Bi8/NXL7P/8SsOisfRk21WzJPQ5t6rWot8jDSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J77Zx4Eth+a4CVR8l3IIkPGADlozrKEbjbr1dlWUnO+A0YLFWn059UsUGfT4+acE24H9sdQ4PMdfA/oNUfrTtHb8Q051cCSyM5c4Ok0EimYrUHIaJ7eB+Yz+U/MPB988pauPDJXpW+POYf+IbLx6tuDEMj4N6k61ybZcrtSVqaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fwD1UANX; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fwD1UANX"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6f8d0a1e500so4359492a34.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 13:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718743530; x=1719348330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=An62MJeGUMiGGgvWvJTRH6LH32AiZhil1QbTJRqvu4k=;
        b=fwD1UANXPhuQFNeXn3tyjKPmjRgb0RzjMolQ5d+F8KZyOdw1ybhQ7kbI28aoLCxeUk
         se5th8eZJ/O9caG/Z5Rvt/Bv32NwRX3cg/QNEiV6gsHJvEm2n6yP13eFGYFoyiHaYtFH
         Cwx/he5GGrhUQ6qTez3iPi9xBh00e8smX0UTEPqmJeNSySSWFECVX8BXIjcdovHfEcAE
         YwUDDYZopGHj//69Qdjy8B8o2yH79W8/SGuhDWfC9xFCPEdB5D5/P+Y5VHyL4eK5+Jzp
         d0zwSwXHpAvjRpHbg93M94OmDdkR1SzLupirHUVnCS/thwvaWaJbMdwjiRmOfFDZKbVx
         VGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718743530; x=1719348330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=An62MJeGUMiGGgvWvJTRH6LH32AiZhil1QbTJRqvu4k=;
        b=A7ff1ILm7ULvbXOxnmzyEvTUP8Y44eXeM/uPqHB3Y/yEPpeDXedu555rmlL+27t4cy
         2apjlk5Pxg5HK6acdJdx2FEn4Ly59uoQBaOXyqBpJuxvr+Z4yj7+krFyUCalbZ8gEnde
         LgADsufSeUujADfGQkVCK1KAgzFqY6hJXBnXHXOZ0vUirwJ1EfhUcb6Pw3+HUyFeeRP5
         7VkEVh7ynhKz9Se0J4t+d2XxLEuMWvMaldlYC+L8O5Y6v7GOcKF7GvXUWZxx/DsTwveN
         Uv4wUP+mBOuj0EfDPO2rpcExrfEj3aYCk3zpxsGKXZTH1HT2c961CVp2Umd+Y5NrBL/8
         EwXA==
X-Forwarded-Encrypted: i=1; AJvYcCWs6rucJXweBwdo3iAbc9jhbUuHRlgpkmfmKnIqnMHDfyOm3MfxR+nZE4Jp275HH37qLyjUFywHmSzLUcZ9oxU7Xte4MJURRthY1kEl
X-Gm-Message-State: AOJu0YwWPrpIliEatQEZMSonXzBdPTiNzSDmMsz027nWVmc2JctmKm6E
	lsk8fFrVOhGNRPpD0nU60KQo1/8mtFw8qDr/R2/B5iTtozP02dLZ1epU2ZZcLfA=
X-Google-Smtp-Source: AGHT+IF/wZnyEwlmp014WzzyEzK86air2V/fRVppB5R1D3+8KBOP7B7VGADdvbG4uR9hRt+kJZiG5w==
X-Received: by 2002:a9d:7d05:0:b0:6f9:72ca:fdcb with SMTP id 46e09a7af769-70075a7530bmr843183a34.36.1718743530058;
        Tue, 18 Jun 2024 13:45:30 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6fb5b1e3adesm1931562a34.36.2024.06.18.13.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 13:45:29 -0700 (PDT)
From: Sam Protsenko <semen.protsenko@linaro.org>
To: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Anand Moon <linux.amoon@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] arm64: dts: exynos850: Enable TRNG
Date: Tue, 18 Jun 2024 15:45:23 -0500
Message-Id: <20240618204523.9563-8-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240618204523.9563-1-semen.protsenko@linaro.org>
References: <20240618204523.9563-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add True Random Number Generator (TRNG) node to Exynos850 SoC dtsi.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
---
Changes in v2:
  - (no changes)

 arch/arm64/boot/dts/exynos/exynos850.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos850.dtsi b/arch/arm64/boot/dts/exynos/exynos850.dtsi
index 0706c8534ceb..f1c8b4613cbc 100644
--- a/arch/arm64/boot/dts/exynos/exynos850.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos850.dtsi
@@ -416,6 +416,14 @@ pinctrl_core: pinctrl@12070000 {
 			interrupts = <GIC_SPI 451 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
+		trng: rng@12081400 {
+			compatible = "samsung,exynos850-trng";
+			reg = <0x12081400 0x100>;
+			clocks = <&cmu_core CLK_GOUT_SSS_ACLK>,
+				 <&cmu_core CLK_GOUT_SSS_PCLK>;
+			clock-names = "secss", "pclk";
+		};
+
 		pinctrl_hsi: pinctrl@13430000 {
 			compatible = "samsung,exynos850-pinctrl";
 			reg = <0x13430000 0x1000>;
-- 
2.39.2

