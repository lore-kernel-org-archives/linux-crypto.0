Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EE51C84A2
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953571; cv=none; b=d1hr3Bm3dO8igeIou7VVEyIfw+wlg03b/JUdmgtnuBweZ+qyBFP2+R1zMw3T2vnLFP9U972Sb24GhQ3ul1c4l5dta9Jubs2FREKmFTffVTwFTGAdXFt1g9AITHIW4N4ajAZXfgIf/wKmivtQRgh+BFhUoJtNjCtXRrh+AAOgiF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953571; c=relaxed/simple;
	bh=NRCTuI/9+TNRF/ljcgOEbRYIJbVO3GJW2faiktXcuFE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IU0R3n/puM3XWu98MVXo1N+GwbOOiwispuNhFVstScQpYSDZn6tshmHeXqayCufcKpjXWEMtXm7ugsSUrHpZFkMOpHmiZQK6d9z6SzXIDUKf1RqYIQ+gr6dJzjrkZpt9jUSc4j2ccyJs2xJn96o/Vdy/LT+M5GgTDgbXvM892uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TBp39DWI; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TBp39DWI"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-548430564d9so3970895e87.2
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953568; x=1744558368; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejx7UzIy/ha4XsDoZ22DLZHvDBVGCnO/qaRmPG94r1s=;
        b=TBp39DWIB+FTrZEoprqgyk8u9cVIoHkxr3Az0fRxtUH2C6bDyIhrjSAN0cDP4SZZ5k
         NUDhc7bAytY1qpjn7hwPbbQyezuyre/Pkzsnv5XAE5Jgl0QMAy9Vuk4nsYMx7/X5K962
         KPmayX/S4WGse/2Atw3N7lTI3feOVFJyjweblXlP8TVr8kMTFumSJHMaGVT9waLc4KKZ
         ptZ/eGA1dfP5Hkqy3XylMWh2RF8zzHe8rr07+j2CgCv6T8DoHsX37puYjGCVA6Iflyyv
         wl9aHZscxbQaBID6B+t8e+GcyLokW7137UEEiyqUezegP0rgf/XJrMyQvoF6+xBrx+D7
         P78g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953568; x=1744558368;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ejx7UzIy/ha4XsDoZ22DLZHvDBVGCnO/qaRmPG94r1s=;
        b=jJ+l2gQoreF7yNLm9sz8IbLlwW1Iwh4N6OeMK7+OGtAk5jEE6sX1R5uc2qBPAKHl38
         ge42c6d36p+Pnek5oMhYMQ5MM2G9Qg0xpMbKoq+FzYffY/gahv63CNSkowCw60VEbsBb
         oCgKvp2VJN++f+9K1vkknmywhmdHgsfRnsZ7aRFc5MGQCiIqZrpLINKe84TnmID6Oxaz
         owotbKwAB4/cMiiLNYri8QOFBXSlDyGWCPicPTaYeWdqJf7wRXhjh43BIqt/5aDLwc/g
         umn5qxgXXNeXGebGaeKa/FMpOzXHdRDHOmhEAvGpjhk+39/Di0SMIqJk1E9JR1OJGYDd
         l0ag==
X-Forwarded-Encrypted: i=1; AJvYcCW9mAhhuc/Zj4uFCO+hpm+Lww6lnBv3XehpZOQ9CrEED7ewf+A0DGmS7VNYCVENhAnCwLzvzHdC3Mp6Dcs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmwad0OqTBIwqCcLCYcc2qyQYq3IXatnMrHvgcTvzBakDHII1j
	3c1p/HNgzskydTR5dgJ4NSUU31U9aDtYfpMh37X157pPEJAmBM+MGamZJOxjKr0=
X-Gm-Gg: ASbGnct/UHyNGZuH4/6dYJNJeEmUhKcq1Cv/bkm7x2gHlT2o3OYchRoIMrbJywj6/Zj
	Bfd90cOz3m5snQDHer+GUZRAuuH+t4dJELb84TilHXx4BzxX/UYkW5ch2mriUBp70B89fKjku5b
	CEtYmnNwiRgz/Jor+iAXzKUSevXhpmgAGpKkPNE0r1uXcBacss2x5Z9F0ybG1Hh9MQtTysViLV3
	IK1Gtg82zgkprX0OWAB1SlfIXZstm0TXNjr/L5G2TxcgCRyU0WAehvEgdvVokv4yU72Nx7B6ufm
	P5EfhFknrTZnQsdjaA3GHJZaKysNEKkwID1iq+ILmx9l/FQ+UZew3Zc=
X-Google-Smtp-Source: AGHT+IG4UfmmllvK8v3gDCB/1PCYbzn5UK3BAxYEZRnyxkcG0076NiwRReAE0eyQC894t+mrcq9ZWQ==
X-Received: by 2002:a05:6512:3510:b0:549:4e79:d4c0 with SMTP id 2adb3069b0e04-54c298480f7mr995890e87.53.1743953568149;
        Sun, 06 Apr 2025 08:32:48 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:47 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Apr 2025 17:32:43 +0200
Subject: [PATCH v2 03/12] ARM: dts: bcm6846: Add interrupt to RNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250406-bcmbca-peripherals-arm-v2-3-22130836c2ed@linaro.org>
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

The r200 RNG has an interrupt so let's add it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm6846.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/broadcom/bcm6846.dtsi b/arch/arm/boot/dts/broadcom/bcm6846.dtsi
index e0e06af3fe891df3c3d8c2005cf1980d33a7762b..d36d0a791dbf4ca3442797691957c3247c7187e7 100644
--- a/arch/arm/boot/dts/broadcom/bcm6846.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm6846.dtsi
@@ -196,6 +196,7 @@ uart0: serial@640 {
 		rng@b80 {
 			compatible = "brcm,iproc-rng200";
 			reg = <0xb80 0x28>;
+			interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		leds: led-controller@800 {

-- 
2.49.0

