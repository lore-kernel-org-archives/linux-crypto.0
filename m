Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08592D131D;
	Tue, 24 Jun 2025 13:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773230; cv=none; b=baAdtdz1JVvJOTOKvXMZ/rob1fncsp2Yc0Jv682qYJ0GoiUGY48UtSzZ8+ZpxZwujETAfXAnEn1HiMKhBorcvQMkl6D/UHMRgUruGE4ZC5WxWenXbEYaYl8hYjI33iPPRkDYXNx6rT5E8XQHc/8D3L+JhOQKA5QD77DSUvhCguk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773230; c=relaxed/simple;
	bh=VwbAEzyL9pZbHb7fvpzTgy6XPbSmaknMngB6sM0R8GA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e28+6gSSHL6+dLHD/Qn5XAE4x4mJqK4uf2XDvCIPNh/CJocbRP0EmpsPbAfPmKb+DCGDPvnjkxEx/jxDFwhpnGYnBJ9BZ/lRQUSFiCYKo8yFOOm541HdxYfZSM93ws+a+LrVdI8GdBB0zRbNskXA41wm57ondNnDgErVrXwZ/8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D1bZ3bZQ; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D1bZ3bZQ"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-32b910593edso4149301fa.1;
        Tue, 24 Jun 2025 06:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773225; x=1751378025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZPoRk4bv9TKG/GPtay/klnJZ+Cs5fblRZBWiTndC3ps=;
        b=D1bZ3bZQZpFhM94lVsw10XV4H+bVmVWQZ0BKEH29tPQt0pjUOTDon9yNeKtx0Kcx4F
         +5A87PJYwhz1g0RIp1B1g66aWbRDITDL3N1f1t1Mt6x0/ejpJbnkGW08JJnz12JxO4ir
         JNeWxRFFReFxg6EDFS8qd9CyBUxeI4AYRZVShbLgsCWrZYko0Woc/AzKQ6zvb2anauP8
         vSsHktM7Huz425MGm95xJriH+bfzfP+cf6VW0LCxbxr5u3N8ka4NxCt3jjvtnGfVHaEo
         sAtdzciJWd8S1uq5jhxvZiiYDrCWf0a9mCSCFgCXPDzz7fewbMoFEWgcfMQaQRqzRZ29
         zXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773225; x=1751378025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZPoRk4bv9TKG/GPtay/klnJZ+Cs5fblRZBWiTndC3ps=;
        b=JdMMusJWqGIUCKjHGPF3JIgi6Cvsl+a3fH5XFxAXb/778AEOkrkrKXq4QLotmYbKn+
         7tlrnIWZ8HuBvu8uajlnYjHsDxR5xcd2fVALYH6MVZ+R7leITmHDi5M9gQsrejvE9tRp
         TcVakImkO4xzd+rZXbxETBMkGush/A7EHDkimdqSQdFO1t7Q9XiPoXCrtdymVOm/jLcn
         lLP2Z+le1aI1QYDHPwYp7U/ozGBSE1YE0LdHhGKiDceGiRX4JwyTpRQETttOig9ZCMau
         UlXZDU2Nv1kwVKQM/GldfVAGyb1p9eMHAipkuoOfjzjriYUBoqZuzz7IR3YDukY+6sQb
         hEUw==
X-Forwarded-Encrypted: i=1; AJvYcCVyCfb9X9GXJgeHnv10izGVdpZboQFABci7xj1fEsrX9zc1Wy77o6XYTietrBhWE9wyRto5xHRFKgSQ@vger.kernel.org, AJvYcCWNkCIemDA04T4ZXkkSYleE2Tbu9byVf6vbg3YeoSQ14lYuy17hicMs4x+GAFIPLDmBaA6ZcyvqXgPJ02kS@vger.kernel.org
X-Gm-Message-State: AOJu0YyqsK2HzdEWDarQ+ubRTZMX4s/605o2fru7pH4GUS9qn2fG7xGC
	yKXG/pS5Iy6eb87lKico5tXIPZXKs4/eFp5D90bO/vruoTGrMForfHWR
X-Gm-Gg: ASbGncvW/z8wm6LexP3DEE3Nx59Wu0hM0QD0gxaTefHGojgV9cZ4BgumZB33157qH6Q
	oJ7tl3zts45jSNFZ98nc0DXhLaz8JPh7tCcEdN8kTZzkuP9lf0ZWDAl5mA6DE7kiVnd6Zuw96U3
	K+Pm9cKQtVIW4b6ucjOuJRaWf8EXidttJMYTRAWv9kL9Y3zvzaQ4To3eC/gqaobC733/Sx4sZfN
	mTc2escBspp53+rq/gbO7iGHlefIfYy/hqgvId1qbVaWtq9v4gesXJJYL7zVy/b782j6csXLZpR
	+QzI1ZR4NiW4R3S0pwDxHwYpyaONWJMbybeXOQ3IPN16MyrSlW+lm4cISygxqQ0PYA+e/YkqWKz
	mYYWdH9dvU17SzNdtONwa1f/ku3JGIb/mV+8p4ANcifU5xYZzlTyhDL7u4ecT3w==
X-Google-Smtp-Source: AGHT+IHWrITTZvm4aBKFUE/hCxGWyHHpvUd1BpQ3eCCcJAyK5yg5EVhrHzcqwCBgUXfsrRLShgxK5g==
X-Received: by 2002:a05:6512:108d:b0:553:2e37:6952 with SMTP id 2adb3069b0e04-553e3d0e223mr5416531e87.55.1750773224715;
        Tue, 24 Jun 2025 06:53:44 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:44 -0700 (PDT)
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
Subject: [PATCH v12 19/22] arm64: dts: amlogic: a1: add crypto node
Date: Tue, 24 Jun 2025 16:52:11 +0300
Message-Id: <20250624135214.1355051-20-romanov.alexey2000@gmail.com>
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

This patch adds a crypto node declaration. With the
Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
index f7f25a10f409..a2f2f377bf99 100644
--- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
@@ -665,6 +665,14 @@ sd_emmc: mmc@10000 {
 				power-domains = <&pwrc PWRC_SD_EMMC_ID>;
 				status = "disabled";
 			};
+
+			crypto: crypto@6000 {
+				compatible = "amlogic,a1-crypto";
+				reg = <0x0 0x6000 0x0 0x48>;
+				interrupts = <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clk81>;
+				power-domains = <&pwrc PWRC_DMA_ID>;
+			};
 		};
 
 		usb: usb@fe004400 {
@@ -746,4 +754,10 @@ xtal: xtal-clk {
 		clock-output-names = "xtal";
 		#clock-cells = <0>;
 	};
+
+	clk81: clk81 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <64000000>;
+	};
 };
-- 
2.34.1

