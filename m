Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780934;
	b=lW5QtsOT8eRAT+Ybs8nBMVeXcBm+uyPXPxMAE+OTeC1to86z+VPcM9kAdYKTdwxDvbrO
	 LOQkvMyhMv3GXDayL1W34tH8x5lxSPSH/kD4GZ9X0RItEAWS3b9ZDAmE5Td2puuzTr3Ca
	 aVSDqRTCyuop5tRXJ27EGkgdyAyrBlh1BLDorROTtEMEcWf3Y+KCVs8+SNJHE8ELbSQ6a
	 BsTcY9TNiDBrdIeoeR32pxCjTHykQxGBt2386QInW5d1PviM3Xz4rAMNkTwpBsbprDal1
	 mEf6GIVCz320xN7g7HcTOdQR3NraecVqCBI4OGzX7Qt5Vo1BRxJH/rHBfB43cBDTj9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780934;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Gs/a4DDZkULpkfxaE5kGJ7kgjNQPkZBpTJ4KeEOsPSI=;
	b=adbnh+iQRSQxjM+CPaFdhibu7DRzLal7XaQrBVvWVBbDvG9EOMsT702v6Gf1fhNGceIu
	 9LISAwrW1qKx9J6eYGKWpRZv6ozP5qJl+2zQ6LcwqY8lBYrPynSTU0cz2vi0EdOqCm3EO
	 lA3x1rDfYxoZwrwSAcv91di2LcIkFFWcUCFQBLmP0Mv9gaOr7VQPyXrPK+f1CZiMO20T6
	 LP4LBB/Pf/v2z4nP1sXSP1rwqnGpGYr/BZ5Xb2Ct9bFZQtySlJTCRSqGLGcUECPWBXXRf
	 XbTMLW8z9OaQTpNGrtgxnP7RENITO0Lemxj1v0OvSNI4C1Z3RJSWUCoSAYgJDCR9Z4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TEeSDaBO;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731CE606A323
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 731CE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TEeSDaBO
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4b467581b98so77312195e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780933; x=1796385733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gs/a4DDZkULpkfxaE5kGJ7kgjNQPkZBpTJ4KeEOsPSI=;
        b=TEeSDaBOuKB7e8yLbfTESsaV7uZ329NFIgBiFqGf8GEVWnaNCCJ3QyAPmqvm7pJfHX
         qSvwSkmG9yl6ntyMUIKHGEA6lxF/z4uRIF09gY8/faM5Cg9BRRfmUF/JR2ldh41oBMW/
         8HtHwPvpGkcEPWRShgdSDrjfKkXcsnZGtUFEZj8jNuVwu6GDKLNzzXLSJ7su7ClOqp6Y
         rZ+LdwZijz0cFxXL+kMlcUtsgpNKZb94je+OCcYqGRXrzSI/POxxUqyaSUsw5n0AZ9eK
         3SFXIqrhJMg9aGTjlOXjjSRynPaq6vh5lvQMofShwVSSVmEhj/51kkCwRo5a51Jz9xCl
         xrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780933; x=1796385733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gs/a4DDZkULpkfxaE5kGJ7kgjNQPkZBpTJ4KeEOsPSI=;
        b=H9tq5Gns0w2Vr0CZCBYD1mVq0bUyrfPSfm/9ffoGDWxHIviPJbTL0cJyfqFBMgq91c
         edyxlBFuAaPlDWnj5mOPSGbRB86Qr92WljQP+DzPAGzkYLRSJGk1qM9Rx7PMVtNShOTz
         sTJXtbMrzIQYuUP2xT1iDqLNo7VizpscHSBNhfnu/awjq1u9zgZaCmLLIcdvdltq/Kf3
         cq43+APgvCKDPTIA8JsNmi/sTvpVZ5/2NpK2cFxHa5hJEda2lfYMAatkC2JBpwwIi71V
         tlriuiM97S0RjdqzcynLaVm7WNk5cIMTUNlrWKnW1vxSvkfx5bLOnXfXQR6A9jp60/sz
         8cdw==
X-Gm-Message-State: APuU4Z8PqIdjBbVyLD8w7qhJm/FlSR4KKUDIFb59XV7QXw8ywjdsMK4F
	4AwLp40gIi3QDuMxpDFWKm0eEKuVykkVMiAbo9WSUlerUGVtaNJNqNSU
X-Gm-Gg: AZFdTZcmWKT00S0l0NgFDd8ipNIxOhFGtJpP2o3hcv+IP4/Wz2v5x/+BxN1asFXB6og
	tajPABeklowYgtUjy6DLInhyXzoM+iVliHN/ePmGfsBycuJcw+Ljg62nFrYT4MBU9htsrv8xTc+
	t3VdhfF8/xBaQ/8cQiHO1j7iVeOYVVk9TiBBaSZ3N65uvcHioBBt2ap9WRJ3bsz8+ntjTiZH7nr
	x49XNZVgjpFjPjtM6onE0BV3p66LBW+96NkP3xaInVF+/ILGOH9gieEQQy20/OweOh2LPExbFVg
	yRvZpXCwUKIxJZJ2+OqICX5Rvtefth9OzxLOCQtL+HrEasf8cwrTCrZnnf5LhJhqiAFT7s3XOPz
	yI+ROeCPu4R3I1YAHm14DttU2oshFsl/smwRepszbwHVNLzPZOF8toJTv0ocyxDkhj1WIYeOGp6
	0QRawqISd7VwLn5J0kqqthX8wAdm3U1HnqRNp2trMRukwHm12PcqetVakFJtwCS0+ZCi3gVnRvd
	wpi9LU9PUP8IZAfMgHZr6jv6NTSWVjHOSdQnNRIOzw3fAJjKDAkE5aJ1XnBoRcEkE7StnyOu8Fb
	NzUD/jjILSW/VM3s/WEoHgJo/lYueFdMICai8Wh8g1grI7gK
X-Received: by 2002:a05:600c:3b8a:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4bb8892da25mr486388005e9.22.1795780932698;
        Fri, 27 Nov 2026 04:02:12 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:02:12 -0800 (PST)
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
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v14 30/30] arm64: dts: amlogic: use the system clock for A1/S4 crypto
Date: Fri, 27 Nov 2026 13:01:03 +0100
Message-ID: <20261127120103.1532882-31-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
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

The A1 and S4 crypto engines are clocked by the SoC system bus clock
provided
by the peripheral clock controller.  Use <&clkc_periphs CLKID_SYS> and drop
the synthetic 64/166 MHz clk81 fixed-clock nodes.

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi | 8 +-------
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
index 396260b7b398..1b064c556c68 100644
--- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
@@ -691,7 +691,7 @@ crypto: crypto@6000 {
 				compatible = "amlogic,a1-crypto";
 				reg = <0x0 0x6000 0x0 0x48>;
 				interrupts = <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
-				clocks = <&clk81>;
+				clocks = <&clkc_periphs CLKID_SYS>;
 				power-domains = <&pwrc PWRC_DMA_ID>;
 			};
 		};
@@ -775,10 +775,4 @@ xtal: xtal-clk {
 		clock-output-names = "xtal";
 		#clock-cells = <0>;
 	};
-
-	clk81: clk81 {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <64000000>;
-	};
 };
diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index de173f40e15e..c004ab7bbdfd 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -71,12 +71,6 @@ xtal: xtal-clk {
 		#clock-cells = <0>;
 	};
 
-	clk81: clk81 {
-		compatible = "fixed-clock";
-		#clock-cells = <0>;
-		clock-frequency = <166000000>;
-	};
-
 	firmware {
 		sm: secure-monitor {
 			compatible = "amlogic,meson-gxbb-sm";
@@ -631,7 +625,7 @@ crypto: crypto@440400 {
 				compatible = "amlogic,s4-crypto", "amlogic,a1-crypto";
 				reg = <0x0 0x440400 0x0 0x48>;
 				interrupts = <GIC_SPI 24 IRQ_TYPE_EDGE_RISING>;
-				clocks = <&clk81>;
+				clocks = <&clkc_periphs CLKID_SYS>;
 			};
 
 			gpio_intc: interrupt-controller@4080 {
-- 
2.47.3

