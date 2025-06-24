Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06162DECC1;
	Tue, 24 Jun 2025 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773224; cv=none; b=mVOnQFRxHwSOCrYv8dS36R4GiAuucAU5ZKLpBMswRzoRIwPgFGfDh+qukxL7RvC7ZcwGcucBHmEVlQ7BA2a+UWN4J0XayGdpfnRL3jwUrwMgI5Dhl0tfywlEUrLoJu1C23Mhqm7amKbBSRLLLv+VdM4xv1GySPos8eBAJtvjDq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773224; c=relaxed/simple;
	bh=+tyvBQrQDjqUZZ3igayxlQkzfN/crQ6BQzmaYmCVgV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aWix+yJLYQ1B+Nor1lqIKL8VMwMlMdx1ZcFAUS1Dr/ZWV+oWu0NJ303vBU8JytrPLicKw9e4IZ4alUbYUqrq7HNOueC5kw5bMbkLaqsa19so6YD/L0QtoB8Iw31QZm/wnw6zi0MmpN8ZItA2wpIU6cUc9cj9U8Eb0GKf+lfk3uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WL9ppkrQ; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WL9ppkrQ"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-553bcf41440so464519e87.3;
        Tue, 24 Jun 2025 06:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773221; x=1751378021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/kNUTOdbC7EKSH5yBbwmpZAVzw6PRlNtho+61DZvd0=;
        b=WL9ppkrQXvpw8OLEdAPq0xN8Q08PjSjCZnvHgrzXIgCvRhuC3lSEde5fLQ9fFgNE9+
         fTS9RL98HU2hhg4ne+5VmlWfgzZrShxYsXZH+O7b2GVSwPa7hoiaUkqX2sMYOxedoW9R
         hzOiKO9LqyeuQ2pgwNCPtY0CMFfNPjV4U+KfwXD7kiJUkhRkKtVX4PtLYvImhEs/wHvB
         an0xVUeSU8S+B65VX3ZKzBBb9o0ewcyyK9lbBWobQoJMC6I01btSAZlcCiAkF4UmCEv3
         dz3Q6uP8TMQ54CZ3ZLdAp4t0BfJruchfU+NTLmOrDp3a7kktnlVmIov5wtiBQGV+gvlY
         +uNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773221; x=1751378021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/kNUTOdbC7EKSH5yBbwmpZAVzw6PRlNtho+61DZvd0=;
        b=ti7/Mc7fTkgh6spwgck8SnSUGZafHH/LLTJ+SkQ0BwV+csXB77P02UJUlCqeY/Odnm
         SlaKBnRVVBnTGj5ZWGKiypyZdzlqdzmrJ/RRbKJMOWNHlTBafTFS4jTB6oSt40Id/JCJ
         2Fb9S8U8CQstgH1W2jrrjJ+5PNGw9VdM3gQpV5AL0UCqIs2rq7+FajrjrIM8C2rm94SV
         WvsCbk8jw0d3i3RGZ9SIalFZD3ellVUhFgumKRM/gFQEgKbVyKHKjwWp0eAFebnFx0gI
         VlaGP25T7roK56OhG9TKjJ/E3lMpwDRoHVlYdm0UxSZ0jyRuaBj2jFz9evCdnE6wzFRo
         NQMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSgLL075DUgqJCt8oCuwNDO5Ah0aqanKWmRI6M7D5kO7ZQ4u0xuFeIXJB2Tm/B/C4K5sM0wgiT3CUQ@vger.kernel.org, AJvYcCXfF4YcWkffC66XdMmy2ajxl2xxY6kcu5DYxVatFKY0qu3wcLYJEmf2rE0zYhudE5N4n2gLtHdAoaFADtPj@vger.kernel.org
X-Gm-Message-State: AOJu0YyYIguQE0aIxXOh0jFZE0id33rrRCHLfYUvg8Y6ikrPj7jNlnuB
	bMDLfr3FjCuTwTiMNY64Ipt5x46V3NxNvdoP4EDYck0/FG/3G60zWIya
X-Gm-Gg: ASbGncshtt/aSIVK4C57PtxQQqID0bI8LvwtH0mlfbjKtT9pqFEoEbySUBlmjMjtNmG
	xyRqwArAwi7q3d3kM7X7cZrN9zPygICioXkrq3+5ILKKLihXzRYs9hApVz7KfjE58qxXrQ3Pp3x
	zZn5pBnIgtr/HRzvC1c/Opi9uvf52WLf+NEmroxnqxvEBihph+AZQimyBii817nnFA3NgUpiRqr
	QX3PH68GhDawbn1A/ZeRiFkvEgYpLwAyqQeAwj8Xlw9lhimLz/K+VxbjM0zue6ZDuChFGh4CZnQ
	jORLN2YkychygGI2yA4tPL9kAm9+6cbb7qTk0veuvRwTKPiDVmz81q7sQ2Il9O+g23bzgAqSvRY
	vJXwos9nFs73fcdCDOH18mDTYE1gCbz3Lz+mgSJkLMjhXLD65t2MeGFKNyuYlaQ==
X-Google-Smtp-Source: AGHT+IEu8py0reQYVPpn8LASHx/iO2R4OjsoWGj/5WkGy9D0unPBfn75Kkp+T1/d+Wm91hqFvsrYWA==
X-Received: by 2002:a05:6512:114f:b0:553:adff:87da with SMTP id 2adb3069b0e04-553e3beb932mr4323147e87.29.1750773220869;
        Tue, 24 Jun 2025 06:53:40 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:40 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 18/22] arm64: dts: amlogic: gxl: correct crypto node definition
Date: Tue, 24 Jun 2025 16:52:10 +0300
Message-Id: <20250624135214.1355051-19-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
engine is hard weired to clk81 (CLKID_CLK81). And remove clock-names
field: according to the new dt-binding, it is no longer required.

Also, GXL crypto IP isn't to seconnd interrput line. So we must
remove it from dt-bindings.

Fixes: c4a0457eb858 ("ARM64: dts: amlogic: adds crypto hardware node")
Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index ba535010a3c9..aa37358382aa 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -68,10 +68,8 @@ acodec: audio-controller@c8832000 {
 		crypto: crypto@c883e000 {
 			compatible = "amlogic,gxl-crypto";
 			reg = <0x0 0xc883e000 0x0 0x36>;
-			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
-				     <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
-			clocks = <&clkc CLKID_BLKMV>;
-			clock-names = "blkmv";
+			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
+			clocks = <&clkc CLKID_CLK81>;
 			status = "okay";
 		};
 	};
-- 
2.34.1

