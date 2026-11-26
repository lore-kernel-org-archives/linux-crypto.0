Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721619;
	b=lORi/Gm4gcbSLpRmLALpCqPVl1KbmdVGSftstNnE7PYlNSvKw1ckhhBRzh31tUR5b6tJ
	 bgUBrRqCCu5/sXc6Sqy5yr0UA8C5PeO/IETCV0JiDUP55TnqQoyXfa2ryToxkNZWP6eLG
	 9if6/Ag0ciDlFaVaqCxjWSE5603RJCCLjYKyHwIIejJ0GZjpvD5N9WWs2WwnEfX8Wzwqb
	 27mYeaoA8H+YPHMm7NVvrNvUdK+rl3TfRhPimsphDD7E3j3zPKextphEtNxaJ6JC02ft/
	 yU8iB7k1JFVbbvSZfctSNOVY86hvz2/9N2JZl9gT9cRHssbwhe3khIFaze0iWj6msGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721619;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9EgS1eeYniF1lumgzc+HBSwMC0WmhqQn1YuP8Q7M2uI=;
	b=clmgYS0XXNvHlc/ooV8d4Kal2kCn3YSKqNeU1pPHZvCSP9awDfCJL/JxJb6aGiwVWoJH
	 QQAkSvvz1IXlyVm02FpIHfhvew9xFeCEcMKVf+hC7m1jmbN0yq+EXhEIW0XsMX2UqqyAK
	 JRo1cBiAYRxFN9A4Enq/TatvTJAN0csbBzJwcw0UvXeHsUzNbVxeM2PtbubVRlwckamFH
	 VDmfoxknKvn+pxw3sDYyVU3fGaR0JZ7/w+RPNLFEEPUUF55bSE7SvHCFrY9g2mDopdvuG
	 sRo+DNrj0w/rzaq4UbcdUt0m5xptMT5OMZ1I+8K14CjEXdHA4AX8xLFae6Tf+uC8FhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ES1hNiPr;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D0F606A32E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5D0F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ES1hNiPr
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so78771255e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721617; x=1796326417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9EgS1eeYniF1lumgzc+HBSwMC0WmhqQn1YuP8Q7M2uI=;
        b=ES1hNiPrfToNYalQi4c40LaWthhVZxy4scVR2l63wZtJKIxdY1D5M2KwHrF6oKtmlH
         V3TjvbVd1mkB4xh6yQJm42Q/wPpNbD2ZSuFuphz4Z7N0PavXu45QmBQdcqkhsbT2oYQg
         KbPVIOpPlESEvKFctcY6zUq2SrbReABpBKBy/qfxfLrStYRCc7Vzj2An/B1ufQWq3m5n
         cnqy8uxI9D81An3FC3C6f5dgLibR+tzjapX7CvUAZUQV4N8yoXlQK0+cWIhmnZmnfGo2
         2y0D5xEGF0F+7UXrb5Vh6FkXv1aTKLAWkFKPZSTwbgUx2aAXGZ7DxfxKfbe4ycSJ+9ho
         OAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721617; x=1796326417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9EgS1eeYniF1lumgzc+HBSwMC0WmhqQn1YuP8Q7M2uI=;
        b=LJh8JtZvRJERmwNY6pc3RibKgzS688EGISasbL2Kr9MlaCXFPIXaQ3cRhqxYMcadto
         rKMkCsz/O11XwZ304VdVJ7eeKcEoFA4i4b0oWpJOlD0szpXjptHEDSMbW3QQhc69eN8e
         taXoSblxU6PerG+5Vyo15apRJGXfFvMfWK4KvIicy/y4HcAoUt79mRBmsArcxtqTeayd
         +hFcAbc+7WS8hsY7lAkDtqP/WgzI2N2BrmmAPLeRsRkPWSxIgNJREcma+/I6Xb9489QJ
         Xa13gqXn6IlBPHw0VXlOR2fBWypB5c0R03y/j6o5Usx/Ss0GlNMTWQjuaQ/vKMAZem19
         VuVA==
X-Gm-Message-State: APuU4Z9NyZgPZ3K1HcDmOK0z4mwcqwO8rZeU3VGlXj4y9nBb1H/4CvWh
	y91Njn8m6iriAQ/dfk92KDdjjDudDrG3IVMBxp8sPF3Xkgi07i3L3Hek
X-Gm-Gg: AZFdTZfw8ld3j7yf4zJ5TNnrlmaGSCwQDAfuC+4r36MQXUKv0c4vQ43TsqrpAyV+O1L
	5PZlbOehwPRpbPjsDpvWAX0rCVabTypXym83sJfqS7aPPOtLKdm6Rybu0gW4mg4dhu65Ev5JFE8
	ayuy0MmakHzyxsw64JzkEVCzEJBm2Twshi7PLo2JBF+zeKLs60OHEgwpT1h2tp8WzK8NLO2rQUe
	kH2hnZEHVSx9cIL51c4CYVS6EXhRyZFFNV2VkNdwMEkX9cjoXFGjVvVX5gWbb5w5jOO2jaUhl3u
	UqaWOFB56/+X2G5yzHfIIkS+RyNoj5imGq+wW7Wk0S++d2XJNAjNQpvBR4PyfXJiif948YMIGE/
	FJD81Y/MXACJdNm3/RX7CgKDBnzZ9/YlWytgx+8NDpSLxPmbY3WocOOpWTEd6p8qEvt6Y9ect1c
	SqCeJ+koegmeu99il5ml9RY4B7cZU6R7mjvTeEbfSVMU9v1pwL1Kgl39xbPF9xRvcJWKwAFRm98
	PbQ/wAAe8TxLTKqg/mpHLl8rBICyFT7EP5ghFv6VrePxttXm+y0WxoQ+aYOnpdqp3YAivwTPdHA
	4V9qmN620ZMKzRwYSBUEFL3Thtd0C/KdgR86RQOZs+LRqA==
X-Received: by 2002:a05:600c:800e:b0:4bb:7757:fe58 with SMTP id 5b1f17b1804b1-4bb8881b9d7mr459950635e9.19.1795721617102;
        Thu, 26 Nov 2026 11:33:37 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:35 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v13 22/25] arm64: dts: amlogic: a1: add crypto node
Date: Thu, 26 Nov 2026 20:32:38 +0100
Message-ID: <20261126193241.1471372-23-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Romanov <romanov.alexey2000@gmail.com>

This patch adds a crypto node declaration. With the
Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
index 6f6a6145cba1..396260b7b398 100644
--- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
@@ -686,6 +686,14 @@ sd_emmc: mmc@10000 {
 				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC>;
 				assigned-clock-rates = <24000000>;
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
@@ -767,4 +775,10 @@ xtal: xtal-clk {
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
2.47.3

