Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721620;
	b=1a7XCwGHOQT3ftxfFGC7a37YrensqpzdZU/oBnNiy9oVwVtspmEDiSGyI1jzpSawwdFF
	 Gi3hDYunjEnleav2QAW+/IWxygRt6SDRteumh7dDcDBCHzq5WRoiKwq8CGWAYNn7B0lSh
	 QoeSlqMUiYrG0xVNeanQAKDpqliY/rj/jt+JoSeWQpye2INEQVs3eL6VfQ8TLzr9qPTi8
	 2A9T4mPaBbAL9IYpH+M5eCVoorkvKLy++AGQKEc6UMCaA+f0oj09o/rZt0+8rLytlEJSL
	 NC6dGBSiFBBbdq+ZibZhvUdRwQFgdOT67P2AM0aAyU9lErij3Lhxzs3+jBUu8iBgZZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721620;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L7TYh02oTJOZVmPV/26Kf9AK9AugmvaVvF3eHOWqM4o=;
	b=A+8e7dokAqCMGCnwJnAvNJuCSqic5FaU9UP3TKAU/SCxqogeJ/ugReqzgtP4O3hDteC+
	 6KR1juX6qMphf91gxPSjvbXi2RrKaGmkmsrizLEtlgWYH5x5sCd3aoe0QDDf28VHQeYys
	 T1Ui/Z/4AsrFGM4TzG8O6ex+9rhmnJGG2e+VlU/OQdFv7n8tbX+Qje/7XCy0bzhxus2wD
	 AKBYzt9q7RapvS8e2PIRdLZVksjwqzN86e58LgalXT7tjH4X+OCeIv3hxUGKrKF7Dl/aD
	 ji7PPn3mqh4Z9lT9n07g5zeQWT5OE43BBIIf168AJxTXSrnkoogZQqrhNSUG+MGKkZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uWSn9Dkg;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B21606A326
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17B21606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uWSn9Dkg
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so48154455e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721618; x=1796326418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L7TYh02oTJOZVmPV/26Kf9AK9AugmvaVvF3eHOWqM4o=;
        b=uWSn9DkggmqiqlyDjXE2iIzsxYnRI70J4TLtr6CcxEUJ9/2F0ffcgbUKyNw53HMhyq
         p/ccO7dqJVDrtbUs72vxr3rhExDSrozs+zETKtcavvFQXHzLBfudH3xzOTV5ca3YvE0M
         wbU+dkWFE6ZKvs+/IiyRpExAIWCu7fqzWiR0WcjoLmbjhzEi9reZmLZKbbfgfnrKN1Tw
         FGnH2NR6Y6tCXJDQKpNdVO3lc47Mj4OiC1X3ZqWdDRCGAp7nNCT3GxPSm/9hO9PJBD4E
         CCfAlVRc5g8sDSr/L1r+C6JOJfmOsMUvN+VB+f720cbyXhpWCMoWjgRJQnplj+Z+HJ/W
         CBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721618; x=1796326418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L7TYh02oTJOZVmPV/26Kf9AK9AugmvaVvF3eHOWqM4o=;
        b=xXJuZ6ksICShLvcJE0d1RY5+5SvIZoXgDyp1S7p4gDem+X59M+xvOMt+fywUDj+ooD
         rGl7cG6GLiCB292DdtjO1IIJRxLd1fFPk/be84LPGlTfaInDEbBVX/N8kGZyODMeeEiE
         5z3/CV0u375xWoE7gb7AbUA848H0SZ5AuFNxWlXj0nAC0b3FnYY5T55+fuAaSrF/RqHt
         fn+hS4uAsv+kN6UpXznVon4kyn46KZXv0iF/8FpgVhfjXMIQh/J7M75/Gb1ofV123wEE
         74XTln89FeA2xFXe31HqkDZJLMU0oMWUAOrdW+wzjbe9rgdeB1/CPu9rm5GK6Ykz4SYF
         TKXA==
X-Gm-Message-State: APuU4Z/q0PGPIxvu+mzwp/qT7bNG88cZTHSU8Rs9OTnjja8nUCYicW7G
	bGE/NlfscNHaXnFY2q1Pf4rqjmQGJ1eAPZmRkQtFawE1LDiuAUWUbzx0
X-Gm-Gg: AZFdTZcUQmbqMV4gDy9alCfxaUG7mAFo1ed1JbUMwEOkbF4Pk1XZBhfoJkgk6xslHZf
	ozjvSizzpc9T1zQi0Zk1zts7q101tNlU9XrjJqTe5Lu4tBiK6lAJvIqg63D3AQ8gpmxrlw3zqsz
	qctWKZ8eqsWhetOE939FGXOaHGJYusi+YqX8jUvQcmlUHXcn+83b0YY6h8/eBNd2139AsyAbpaZ
	x7ZtbHU3MSV5hxOfjYJPwHpeHQXMZN15lNND3oT9klxDUX6fjeOVoUrDp2cLKE30WNfaUAUqdxj
	Y0+Aox3AVcB5qhDOVnfx0btnc2k7Hji4bia0+jWOU/oaD/3VKIgYXkz5e0GSBzfvpI50XaZU8nh
	Y114gSA0QrOZx54cTwAFQLknYupapePcGnEz+czIxYF85Xa+fGHo38UILBo5Rz8r7jo3tO60m6n
	rvmej2N8vTt/iRep2oe38v3rODxkXkDI//dLRUgO+1yIJeLPlLLnGlGYBTuHtLj9JqRV1eTRMeQ
	7dMSkwb4wX2Egj/+tgx61+t3dsk8TnjpVaywGIkrIaeBKB0cZF7ED2uwHFF6RIsygAhpVge7RgU
	Mz4tBuYt+xnLpkC9B/2L0a2ldiEYE+erB1HbPz397Mj0uYBuBWnMXAtp2HRpTJUGyjA=
X-Received: by 2002:a05:600c:4f84:b0:4bb:8701:a2df with SMTP id 5b1f17b1804b1-4bb88809950mr454205435e9.17.1795721618450;
        Thu, 26 Nov 2026 11:33:38 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:37 -0800 (PST)
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
Subject: [PATCH v13 23/25] arm64: dts: amlogic: s4: add crypto node
Date: Thu, 26 Nov 2026 20:32:39 +0100
Message-ID: <20261126193241.1471372-24-jnieto.alaber@gmail.com>
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

This patch adds a crypto node declaration for Amlogic S4-series.
With the Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index 2a6fbd530836..de173f40e15e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -71,6 +71,12 @@ xtal: xtal-clk {
 		#clock-cells = <0>;
 	};
 
+	clk81: clk81 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <166000000>;
+	};
+
 	firmware {
 		sm: secure-monitor {
 			compatible = "amlogic,meson-gxbb-sm";
@@ -621,6 +627,13 @@ mux {
 
 			};
 
+			crypto: crypto@440400 {
+				compatible = "amlogic,s4-crypto", "amlogic,a1-crypto";
+				reg = <0x0 0x440400 0x0 0x48>;
+				interrupts = <GIC_SPI 24 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clk81>;
+			};
+
 			gpio_intc: interrupt-controller@4080 {
 				compatible = "amlogic,meson-s4-gpio-intc",
 					     "amlogic,meson-gpio-intc";
-- 
2.47.3

