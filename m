Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780920;
	b=FBBZCa6oZM0DBKR6YxQ2tz/Eb7EHZwP+6UcqHBuM8i48cBLK86eFft4Q8V79SY2CpaHs
	 tumCCtSCQyODzS8zazU0xPmfVKfyczO88XHQNFZjqQ2bt4zBoRBUuXmskyCHFjDDoRTfB
	 C2ShrFj183udLoKNUlk//yj61RCtQTaTeCownx3dvqmpvHa4wpjMOHbB/+aLX9GGhfpdh
	 wMNa8vmiXW+dYiUm1MeYa6DawZslh2G/LYUPW5lCNHhvXehFLng3ggA275mlMV2aLP/hY
	 QLemZ4LYC1HxeJs5LnUHdkDPkj5WmCViVuScFzvzH27w7qwWXCyoDzs7fDVON91C4rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780920;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TyMpVGhTjV/u04TckFiyynsoMuEnZrBpJU3DYNeD5YM=;
	b=idOiGp0yyWLTT5VRHW9wDvFpqIIwJtimV7Xx5ebOBoMLiv+QdrVQQtbWVVnK3O1zvL5V
	 cB9yYzWyxJQjLmXAOMocJGBfvmvsgY6CHP2r14Aie3Bi+u3ri3CJj29X35f3n1bhoe8bw
	 GmGp7spIVFqLxMBlsJa+OEDzRtnffWuF9icZL4rf6QSV+devALDm5++u2R2eGa2PfNi1n
	 aklRjjAWPRx/jkFVfHpLfsq/WxDWG9OMNd3X2boXBXW+ufOd7g9VTP1W4yOp5Jzl6kP4W
	 NhPVw1Qs+Ea2s8OrIknudyi0LjOQmE/pyTY1PXv+owV22g0PxK7wYIQqvZ/iRINR4wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="SgJ/q9wl";
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98CF606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A98CF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SgJ/q9wl
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so51558355e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780918; x=1796385718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TyMpVGhTjV/u04TckFiyynsoMuEnZrBpJU3DYNeD5YM=;
        b=SgJ/q9wlMeSfHahcvtFB/QgdX9QpUlGXy4GrOk2LooUbbGPsq1d5S4M1lhXZ5AmbI3
         6tUdu8tGeikf1rI5p5RY+2MERL7NTgtgdnA86WMc+Wn804AAGQYKNTafincIVLQmt1VE
         ksaMGhhdUF8T28Ku9HYDUYAdkvb0bzf7wSgfygUedwz/kuHHe7nbOLrwzNXfIOS9wKlI
         HE86UktKg3OMZErbXGxFwjkAqrZkzGxSgSicR3BIBufjMx/eJQAHpOI01/xnQNsQ83kN
         Jtx36LTmH4J712nU2EDXuWCQB0xOkrCJVjKuDcmJLH+lxQGtj4crodmqK1SZ1pBrLbA2
         2B+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780918; x=1796385718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TyMpVGhTjV/u04TckFiyynsoMuEnZrBpJU3DYNeD5YM=;
        b=K4bDUiKwPTlrxAAENF68zN1SXkxz++ebYVotJGJGy5U+0CcImZkr4UmxvKAWKI8qC0
         s+h5kK95u+PvEZ5fdQRNd5Tqubf5LxEMCt5RcQWr2zBuTy9w1WxFJIzDTpUGB3t/EKf8
         VDMJt22yUCffP0Nn1ji0emuNiRh2RRKeVl7ocmHRIjnxWuqk2eBQq6uooVO8UNateRgC
         +D+RIGY7wVohsGgmXUsIOPwQMo9SGZc1+yCbx8GK9yY9RvwzBuu5gUhH/6xXNs9xvP+D
         zQLyUDyFEbiO7F4D2lQXet3WHmGzJywQ4awQmZrZO69NZiHsqANBdfZ1dE2EVVpYoup5
         vt9Q==
X-Gm-Message-State: APuU4Z+Z/tXC77cnA8Iuo65Tro6bVHqVi+X3Jw6ZxvV5B8QjvOBYGrbX
	fI4n5QGfdeJIQMPQYPfVRCcy38PZnd3cUNaylBKgb1HHXdaAn73A5nOI
X-Gm-Gg: AZFdTZdpgixOs1RcRZ1WV8VCM3sukCzByOxwlHI2CJIfh1lfB9paZWkEsARKQT24uOg
	uQ9orhe3lUSjtnLHnTPpEexcSeWLjXJsysZGILo2GnAsmKh0gY+oqZI/PnZHvQ0ft0AuRP2ROiO
	7ugLWIGGZEyGdeX2zZN0N0Zgr5+gbItN4B3jw2WDZYDvZJgC2ouPlG7oLWu+Gx/0K12777Y65Wm
	XDhMbPiBc4utO0NAaxY129CJhoPIZj/14cCWl8KvX/Ql9yZ1pRixFOoulCLV+FY7Rfkec9J67cD
	psDXki8h7Piryj8I5fhziQzC+iM5WvFLv+roLlwGi4Aeqg+cdwkj/My05hmt3hTMCA6YmjF4rbG
	nH1HOgz2mSzlzGPnFXHkIEoazGndrp9iFjdDYuO4j/BAT5Ofo1ym5mjqz+Nynv/2MffhH2Op9HA
	WcWX3+Qf8q7Mvok47ZUszqDoqyJKkBYwlsUFHv/o8nTq4BNz37dFPIgfl3FMQ14CzZ87qSifMsH
	vBcACyr4byOcNg6HRxrYZAeIjhcFztC8GwVXZ8Rh8/Xk14B9voxJeg/G5RQqFmo2sVYEijJrLel
	ZmGM1hv2kflqLJ4vd6IGVl2L/gyVKKf7GYlifzrqmiqefe0=
X-Received: by 2002:a05:600c:a4b:b0:4a1:dade:f049 with SMTP id 5b1f17b1804b1-4bb88806292mr505147675e9.15.1795780918009;
        Fri, 27 Nov 2026 04:01:58 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:57 -0800 (PST)
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
Subject: [PATCH v14 21/30] arm64: dts: amlogic: gxl: correct crypto node definition
Date: Fri, 27 Nov 2026 13:00:54 +0100
Message-ID: <20261127120103.1532882-22-jnieto.alaber@gmail.com>
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

From: Alexey Romanov <romanov.alexey2000@gmail.com>

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
index f257fe3860f7..5d0bffda8f19 100644
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
2.47.3

