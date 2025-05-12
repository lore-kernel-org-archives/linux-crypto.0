Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582C329293E
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051555; cv=none; b=k9qnPWGAgz6GCPbIMvJEK9bZXC1q7gbAKKwYbbvLmAHR/V6W+/K75cPj0WlahPu84yBcV1ncsM/bmWdk2vwlEAYImplWE+B86QWQQ1rDs8D0ji6MSI1YvNExvYrB4hGEhz3LlMVH+amPkzf38MXKmSfsNL79GZUQ01L9xDccvRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051555; c=relaxed/simple;
	bh=mBsQfdUHDG6bui+qrQeNpZmuaYG4JqLdBfTIXAoQHSk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y63mkISgmRAkZPgdUoYJM7qkQtLcfWnwa17Sn3lJWDqIZDJvYQqIHZTrsbmKoln4MdF19zJL/ujKIwxpRcQvwmYzcfJC/WP1Gj7UQT2lnhb5ed9rrtMJaTcwpsWHH8DBE5EZNGzzToRDh+XECJ3WLA5XVzzR0IYFTNVWAQ4RfH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iVN0Wo2R; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iVN0Wo2R"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54e8e5d2cf0so4408239e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051551; x=1747656351; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SkP0iqtAV8ORY1eZgH6I8IG6wC09KK/zaOfIkhxn6iI=;
        b=iVN0Wo2R0/KQqJi7HhqL+d+AKcjlNNY8yanO6DGMMyW/eKAQK9T7LAaugX8naZzlIN
         IOHlaOKpvRK8d8qmonNJAJINTnIuv6xx/mQJ7nawN0kUh32ZblZA7Oqu6FPK82nh+6dU
         CDarbCRpjM6qG7rrgyB6mbwXXRSjx919DejRbPYCLn2MgLlb3X6oNMjQKtgrCKscXuuM
         VCOnrjFQGo3vsfrqorNFPpaaR6WZ2ypFEsxFqE8nKdT4HdQT2gAE3puyHEK8QZbotdVe
         2raipYN1nBc2aFh+EiiTJSx/dMo+as4iRNRUCOftbk19i7Pqh9rayJn/TIYEyAzsCn3v
         mZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051551; x=1747656351;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkP0iqtAV8ORY1eZgH6I8IG6wC09KK/zaOfIkhxn6iI=;
        b=eyPSVTk0VAtDLFNJSAc4pWbByA5J4QAgDpQ+FTUzyUruhX+2t4Z0S19hqupHHr82kV
         X3INi8eXnVdBJ8sQ9TJxVNNaTQ4Yu1b1xdpjJhX/kIC46Va/0KTIcAtcKkbApHLbx0FJ
         nnODIIgQnfTbYX+pJsjB68+NhR4J/LcfsB/zD010oZREaqj5FNSLT8wo4nyGN+80fgzi
         clv9XQ4k+E1tNZvZyNhp/tAJQD27U/6ftfd9KWL3UwuB3ZL9TpmtCW7l83Onw0e38eUS
         3eK9l8k2YwZ20U5SDu0vBpctHz9IZWJpZpOHQe52NUwB30JLzp0GgKI9bfapSc8Fok/c
         2P5A==
X-Forwarded-Encrypted: i=1; AJvYcCU2ZpQhAvfdXM+e4ixlBYtn6ydJqb1QVlqv+2Z4zlNNyCmgkBtEyJvYZcSFvOJho6XiokbY+LTHeDtgrOk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2zONyu5VsR6X2gagZjS3dSz5bcPBstlHhUjoVrfiCQNtIiojh
	E41TNxwx3LJv0DQqt2Qsd0fDrEFUGwwXN+irSFAjC0qOZ5+3I286RkiLYJu5+5Ftx/8inGCQrZN
	T
X-Gm-Gg: ASbGnctXLfX6Y1nosd2QgjHRX3GuqEUSooW5G8osJ3XBRzBFHsxDijMUkZMJFxu7wdS
	Odf8nLZDczhcIvBgxc5wvT4+wrdg2YWW4FVVIX4KeQA5pF1W2L2xu8EDzg9hq35tuzwiStCjZ4Z
	OU2gfA89f/wxLoURUAH8+AWcMb76gLD25UM1eWnWY58fHdcjWl758iw3EESPW30DbKrsvLCegQJ
	1QE1qaOHN746Hdz1HmGUWAsLAy/TQpKMOKPP+IcEXYAG1+fY/XTXEk7/ugdk7S15KrJFKbzlaky
	5UKtBJUCUARy5xqe57/wxxLtpqIUv3c3m48m7Y7IgT+Zj1XnDpYC/G7NZtGgHToBszKyt9wY
X-Google-Smtp-Source: AGHT+IFR9Nx1JFMLBQ2HkT2lwCOY+IxKJSVXbedntzV9xfWGZUYC+w6s/M2ra/sM9ro0Y82w+A8WvQ==
X-Received: by 2002:a05:6512:695:b0:54f:c1ce:9bbb with SMTP id 2adb3069b0e04-54fc67ecf35mr4581782e87.47.1747051551149;
        Mon, 12 May 2025 05:05:51 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:05:50 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:47 +0200
Subject: [PATCH v3 01/12] ARM: dts: bcm6878: Correct UART0 IRQ number
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-1-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org>
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org>
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
92, not 32.

Assuming this is a copy-and-paste error.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm6878.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm6878.dtsi b/arch/arm/boot/dts/broadcom/bcm6878.dtsi
index 70cf23a65fdb5ac7ed9eabc986f4ebb4df263c43..43eb678e14d04be487af39c9365186b6fb919cf3 100644
--- a/arch/arm/boot/dts/broadcom/bcm6878.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm6878.dtsi
@@ -137,7 +137,7 @@ nandcs: nand@0 {
 		uart0: serial@12000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12000 0x1000>;
-			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&uart_clk>, <&uart_clk>;
 			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";

-- 
2.49.0

