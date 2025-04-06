Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DF71C84A2
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953569; cv=none; b=FshEJB9XF309sTJyKj9Ur0Xd+2PMQUazVu2pztWTQnGJxt4UGFFU8UmN0uN6FvDjWhpIotxeDr5jCfWK0WF+NhU0PjatpvRiO/29u7paZkb+ACEbWBUEIJ5JyF5tzRbJVFEyP5mrmJntd5QzaQwhGHTrujx9aTFs8hLx8xW1zqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953569; c=relaxed/simple;
	bh=dQ4FW12shnEjM0GPrn4VV50kmqTq3AwSVyknRC7pKxw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YptWLNAPlYpVDVAtHFervZ/y8ZSOSl5SVqNlg8DQtgEDEnuRHRUh0nYCY2WtAKDaFeh+2s+8EhWXGIyZNVBgcpgTZFbD5vHY2NHiNenV+6JWf5pQJFzkbAfDWZcYOea/CVE9KbwlDMkoKHV/WYKLzwolFKTgxqwrCpvVeR02gDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TpekYlRh; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TpekYlRh"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5499614d3d2so4079499e87.3
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953566; x=1744558366; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ONAYYSHQOAtd7XflFMakQ6L/UMvLNi1xTofa7izw9E=;
        b=TpekYlRh64TeOFJ3kwPUB/7qoeaRGXtQuMf1YTesxJnYYaVym9wXGvadclKEnldugm
         iUF66pVkvcckjJXci5FVmjT6wlcb5Z7wlr+cn+YvjYKyk834rIy4fW/OJyR0avxdyHfn
         uD9dw0tAr08aMM+nQL6Ht9MdyfziSCP8oOM7O9OA0pdHILILQRvla2qvI9XB2SZFuMgL
         DPh96Gr+5y0jMivZhHu968PjNDvLNrGhNu/VTpuAZLmuN49/XoQNeeTdftH/1QLRxI9R
         Fqt0aExeNuJidhunQ9QoRVSRv/dD2hwMLC9ikAFiFJG5+NwfhpXXAZtevzplCJQ7cYv8
         q0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953566; x=1744558366;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ONAYYSHQOAtd7XflFMakQ6L/UMvLNi1xTofa7izw9E=;
        b=bEGkwV08pbisK0gMVkYmfVjjjehmdrBkifyt4BppCz7CTeFwtYDVGf+UxoHu2q6lZV
         2YTBoW0YREdq9sWngUDke158q2ea33NVlXFaG6ZUEHczZxPan6pIiRC6bpnRAfsLYgJi
         rcnbN394QMUmGN4iRA9bh8rATRRXBbxuoc/b0fJfm+RBcw3jT9y0jDkkJPIajQu3qewp
         JHuYeo58U2gs0uD1EmbDyGUZtudw7a7z6dqbY4IzRH0QDtfmMS+2c4xkBi5VDSwvEXCa
         x6CY+0f87wGUkt9xsEgNQiAabcLA8cy2WeExeSzQWradKuLFKYVUVG+Gmk1yFXXtLXS0
         cAdg==
X-Forwarded-Encrypted: i=1; AJvYcCUoJlbstrTn27vHuEs+Bk7r2fL/rLjLpWVZ5FGXRHk14zSojKhhoESf9xn9vqIV5PPTo/7T+tGkb1de+6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdXssSVtWAgpzC8p0QoCjLCMRCr+BYMdp0DkosBZ3d56UFY67h
	mC2Cn7OpK4943lC0rm2DgBTfL0GXndqq7YjE9K1RRbMW71gjeojXLkyRidVqw6g=
X-Gm-Gg: ASbGnctP4Q+lMxvJjhaSc8A9b+1ba/CPk7k6anFf706Jv/Ndkg0+nMGImXQZr27wOXZ
	JYu+5TH1+6smNem7/KZxOIQWZ982G55PT6BXNsHm4p1u6ATAniPTE89rj9CHibhyMhU7ZlX43G4
	bDfsmP4f8er2bCwHeP8BJnb5WLDAhACgja4OkXSsQdOcAPrOeNCAFBEgx6mxHUzj/juysnyOcFK
	T0wesbxEiU4r3qWzMjEkNpRNO5HSCYp8NuExx40Y213PmuUr134o0FiLuUfdvLIkzZ0fE80NnfC
	bTrTFTM8nyDqnyz/HXgeHozvWZl4erapMafVZMeQgj/OzjtfQBfWZNE=
X-Google-Smtp-Source: AGHT+IHnpWs6XO4mteq7F+ZLmGE9IK5O1KFZnDXVhMlRd4bDWyefxcqo6/2QiR1vaEXZVx5eFBlmSA==
X-Received: by 2002:a05:6512:1313:b0:545:243e:e2dc with SMTP id 2adb3069b0e04-54c23346866mr2216950e87.39.1743953565786;
        Sun, 06 Apr 2025 08:32:45 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:44 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Apr 2025 17:32:41 +0200
Subject: [PATCH v2 01/12] ARM: dts: bcm6878: Correct UART0 IRQ number
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250406-bcmbca-peripherals-arm-v2-1-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 William Zhang <william.zhang@broadcom.com>, 
 Anand Gore <anand.gore@broadcom.com>, 
 Kursad Oney <kursad.oney@broadcom.com>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Olivia Mackall <olivia@selenic.com>, Ray Jui <rjui@broadcom.com>, 
 Scott Branden <sbranden@broadcom.com>, 
 Florian Fainelli <f.fainelli@gmail.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-crypto@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.14.2

According to the vendor file 6878_intr.h the UART0 has IRQ
28, not 32.

Assuming this is a copy-and-paste error.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm6878.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm6878.dtsi b/arch/arm/boot/dts/broadcom/bcm6878.dtsi
index 70cf23a65fdb5ac7ed9eabc986f4ebb4df263c43..cf378970db08c05c40564a38931417a7be759532 100644
--- a/arch/arm/boot/dts/broadcom/bcm6878.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm6878.dtsi
@@ -137,7 +137,7 @@ nandcs: nand@0 {
 		uart0: serial@12000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12000 0x1000>;
-			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&uart_clk>, <&uart_clk>;
 			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";

-- 
2.49.0

