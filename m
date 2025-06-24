Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1CA2D29B7;
	Tue, 24 Jun 2025 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773230; cv=none; b=r2tcQahI1sL1izDRJa7FyNI4t0ZHuuJ9gLHzwKgOwdakszdcmCgqD/8NcHXPHJvUVti7BsZC/WZzeXVSRy73bEJDu9xbRag8RWCS+S5Hg1Fn5ixr3t7l0nc/yJRFhX/rOexP6jtujvX3LL72yjHf6R9VS9lGu6zSazZBGtR6S6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773230; c=relaxed/simple;
	bh=vQx3ZdR+2/ODSuIo7HtfBXaQBQnGh2LvgbJSaSQsZ48=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rhoQ3YUeK7ReCmWtX7MDwBstX/lvAsaSpFCb+Uwf3Z2Q5kMqVeYDxZOk04mqITmwRwQvfBf3AoKp904Fa+eayul7akoG2PIv1gHnvOW3LoHq+WFR8fR3ZYw9PNcfK4LqOPBhdEMA1w5w/8pjcSC0k9ms9/rUVonEc7jPlzLBbsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XEaCYPCa; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEaCYPCa"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-553b6a349ccso5316137e87.0;
        Tue, 24 Jun 2025 06:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773227; x=1751378027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jQJntvtFNmhsJjBeprIa6dD80s/DsqB4EFJk8MMruo=;
        b=XEaCYPCaOBB5ScguHTgWG6KzemhBLSzLBJasPGk0UgdMkge7vVHQDqJQVG7AfMFplf
         6xMOgRePfjAXVZMlHyxZCsDKGv4fxsJ+wzDdpNWQBccR2B9kOxmtB8H8BepwWY893ll1
         53j8OCriCdBcsR7k2Zel+312ijKt55Nn0g7raZkzygmbXOr/J7fwjeJmC/7zFNJja8ic
         WuK0VK89yJW4FoiAyBXmlBdgM1eaQ84WpXAucvzZupQS2eckZLKfmnCScRmVEJUwm1Se
         p3J3IAob6wkyQANgX3GEofEM4y1lD5YcFhsHw/PoaZZQ0uwmQFbZlziX6PUkO6mINWCn
         JFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773227; x=1751378027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jQJntvtFNmhsJjBeprIa6dD80s/DsqB4EFJk8MMruo=;
        b=pY0+Huly/Jt6qPv0CfFD+YqRRZR/7VZBICVoZSEOJqKf5Opj7bqIuhZX0svJReqevD
         8wA0PU4iEh1/Vg/ZJWb8F5YTOkGa7r2cVhwSL4wxOshsU/MnaqxMlMFPmC05W3+W19lT
         v9UKOjBRW03haRvkB/3griFXA4BlrbKrQ3nhmxbqOkZgf+8s+/o+8FuZI58RStjwjsOf
         qxFylmJu5yYdKrR4pP1SJ8g08XNXL5uJ5g6D5axIJeepZIRd/PMZZaVpKxaVFGavgocG
         4KNl6HlpCq00KLRiNRrz+T7PcxVgdoT4GH+5bSBbAfckJ8Ki5sv+IiIVNkW6NjqDOj5I
         ydTw==
X-Forwarded-Encrypted: i=1; AJvYcCUt2g8K5qN9AjFs+OI9YRHPlMJl5GM6uqMdLWKCQwAdY2xN+0rFWJ1u+s6pZAVJIR7zcdYJCljZvar3@vger.kernel.org, AJvYcCWd7zIRCDpVfxr4CvoujDC30VN9twM/qOqwHKqiYaDuV6xTuOuE5F7I/J2nl1Sncvwa0JgCfjNHz1dkNBx/@vger.kernel.org
X-Gm-Message-State: AOJu0YzjyP+41T2NbwyioT1VipGcbBL2TfMQlBjilGMMzkD2y4zdRIJI
	T7n2U6FStAbVe4HsRspGy4Yt8rMVp4XjrqvQeu/Uf8hr6EbmLet3smc9
X-Gm-Gg: ASbGncvx2BAmX0D+k6Y8zEUQE3MIm2Y0cikmFKHXyaHcRgBxf6MdeMdwLkolugBVQam
	5ghfdwTvu/Vr6ZcCLDj44TdU1pcxrZPLMw8dglkyDSZ1EB13ibPdSbgyAVqcKZ4hwoaXla6+7Th
	53OrNPmT6FKz+uyStgaMIJC3l+en//Lk+dL0uvrnumyW6FnaVpHs0z3Z0h43aZ8m0c6fofB/O3f
	9W9B9ead1WidlnKq/QG2OTAJOeA24fCzTUpwtSv9P8iUOL01GP4mGpyml+FyM9gCBCTSFtxa+c9
	IIyzLpIQCVerhh3SAQ5ksHrCsaKJ+86P5GDcTEXl9AChpXQowpS4RMU6S3YUISFl3+wWXY2bdhF
	K1eUqlmqHGNikc/c1ZXi7h+NNQpoMSulXDoLo7715ZmiAk+viUOEgGMnXJ5ilGw==
X-Google-Smtp-Source: AGHT+IFf2/S2YwjUMKEFcRmp45CHy3/r/DAg440cRi8qGGyTc2TTxQABrRcN2lyeM/hW/FQn99VBog==
X-Received: by 2002:ac2:5692:0:b0:553:d573:cd6d with SMTP id 2adb3069b0e04-553e3b990f6mr5756759e87.6.1750773227044;
        Tue, 24 Jun 2025 06:53:47 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:46 -0700 (PDT)
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
Subject: [PATCH v12 21/22] arm64: dts: amlogic: g12: add crypto node
Date: Tue, 24 Jun 2025 16:52:13 +0300
Message-Id: <20250624135214.1355051-22-romanov.alexey2000@gmail.com>
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

This patch adds a crypto node declaration for Amlogic G12-series.
With the Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index dcc927a9da80..d9aaca9f9598 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1733,6 +1733,13 @@ internal_ephy: ethernet-phy@8 {
 					};
 				};
 			};
+
+			crypto: crypto@3e000 {
+				compatible = "amlogic,g12a-crypto";
+				reg = <0x0 0x3e000 0x0 0x48>;
+				interrupts = <GIC_SPI 180 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clkc CLKID_CLK81>;
+			};
 		};
 
 		aobus: bus@ff800000 {
-- 
2.34.1

