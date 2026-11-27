Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780924;
	b=x4HjmD7HhtwXcq0uZ2mc2VPuETRTH4E03JyGvxN0SX+2YEDT852IL2w6gvU2Uka1DY6O
	 3CAcp13zw5n2TULc2Hw0AM16onIEK1s9Z7bJgIUNq8hYiP7ZXjegm7z3+MF3hRwgz0zL4
	 8+5i/5WKUz3poUGON+phJWCvociRkGLiHWo5Bia3+s5x4ehYP2qrCQIGtLzOY8aPKFUUw
	 uqF+0UYlu01lVoQRxju0zaSnxvyQg6qnMl+3TJUViQcd6ktcD1craEOgug5kyqupN2lA+
	 X7334xpi9UKv9I7JPm5mwo2KklEHenz8E4ac5dBxJYhTTHA6dD+Jw9C0DxvHLIeaoHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780924;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L7TYh02oTJOZVmPV/26Kf9AK9AugmvaVvF3eHOWqM4o=;
	b=IRhn7G8Dp/eyTUPSU+mXXdbhHJYAbiUe10+12yHF4aR9We9XDOdwLnMa4Z+GlFcTOkk7
	 xxa1vJRvpv0/F/8mLTQxWp0oAeSd4cfuA1S++8MJlyikIfH3323D5Oa1+GB3E0FVMGglF
	 tuwJNjtqExAqtv3waC3XIvQpXo30KDPfBsve1BFofpWSHOoMabqEbJ5nqr2TCa9I50BNg
	 2e5NYhpok3l6eZf+4xAf9/lZpUwZcDGwow4s5yzM2cH0chjI84hNXlAteqfDnGs9Ejqbf
	 GI0E380qShh5UEkbX8vTzbJzbhwlF3ChcJyczXUj2Ee58u1SuYBIo8fhh9at0ScEXvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T7kxU9AR;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996E4606A32A
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 996E4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T7kxU9AR
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so7320564f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780922; x=1796385722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L7TYh02oTJOZVmPV/26Kf9AK9AugmvaVvF3eHOWqM4o=;
        b=T7kxU9ARjFf1WbLVPz5TAmx7eLni0kTl1CysR6FYPmPTXQT4IgwjVK/lebHSlxX52d
         B8hxM/59QXcIzYDbgVc8Oxub1ibLay6RZqNsXDgkGOHtpw/dlDtF6vKNEddFtrLfMmBe
         armbz6xxNFfEITgIlucI5CCIIBO195Wm6am4vsX/+fb9VpltxUXsBIaMA96azmF0+QGr
         UoI8lIoymQKTRNTMGBlLxbtrW/Cvu/QwuiZkJCboz0jGZiGlwAxIcodyXDQg2gtpa23g
         /wuBOibh32pFKmsBEYjLMwUzKqHMe4lGh2s7Hdm+T4DYDTFxakukBR5QyV139L3icas6
         Fk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780922; x=1796385722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L7TYh02oTJOZVmPV/26Kf9AK9AugmvaVvF3eHOWqM4o=;
        b=nQZtgAzog2saCE/3/NESruXZmwo0+Ewhv2D6tpYmsl0riCcbEsmGNHdKgB103bhKw8
         f1WTDfrptCn9RhvBMfT7jcJfTRNBQBKO5bUpATSb7MTA51WV0PzY2mRw4GK2jVbgqOcJ
         11eWQkZYE8+fpIGJ14BXJZu7ur3UgNsIWsTOdgolp5/2mvQSiOuqKTucS1ljAvemt2DB
         G7p/Yqbn2Md0e5/uw9kuZKeFy7bwY5SX7TBlgBOTiBFlvEo8OOWV2mrqbzs0yYJZQALI
         EodbfKmVupHO0Kf+4Xh6ooqtffyBL7j28BfCt2VWbQPl6+7LteUbO6p6jvrie/OgfUf5
         Y3KQ==
X-Gm-Message-State: APuU4Z/Od2Wk8xHL7AMVXq53Mun35CxWP+S6cR+DVvXQci2RUaUMGOQ7
	TxFH9q/3gbRcubXYP6KkBuvnCWHd1s37u3jHCwP2HOqutoW85L+1GQxq
X-Gm-Gg: AZFdTZclBe7x1AJAV0x6Hwtpx5Ox3b//KCJxsvEe+gCEE3wdo5gDl3KhGQuPeIiILd+
	dOWWnqUY9BGDOjxyc4ikYW+GGI/hzVUDJ8XA/dP9EB3v7GUqNfx0EFPIQSo+KWKL494BT6mVMsL
	xJQs4B7FZBeQMJW0eeMtB2BUg8iO9h/K54TyVgMp3wx72aIaMrybNXP4mDdtUwZ4NlfMRkPG0qN
	avZTxdDv6B4DCj9L1olLG3Y/pJqIVnfI7ATRPdxUCfiZpXJAlPiXugbpjyhRD9y6ZaNZ/LJnnNK
	DBphqk7ineoCNefUXNR6L5Fuj3Unz4VhZlu7EagPQ90XFiXsVfAC3yDO/VJ0+FFmgFkvTOVL4L8
	jiDE50kgxyU2h8/H3s9448xoYKwtvkECmLN/6gNrfhkG52FZx1ApAVVYthi/UExbnXd37ZoIupe
	0pKTf6NzoPaSzlxEmGgxjQtmao9/h6zvlulfBo7ONhUr2dQFCLYYtvSqYHGF8vvn7s86lAYciH0
	sLUP5frQvu9Otx+bHkgM+7TXTca0m60g22+dPsiq8GUoMv08uJ6e1UdJDG+CZ3Aox5SLFsWAzR+
	f0DCHTANsZ/boTKyTKu1hdeeWjWoxg1XZcBkOrUylYScaK/y
X-Received: by 2002:a05:600c:3b8c:b0:4b7:6c16:7b43 with SMTP id 5b1f17b1804b1-4bb8881d019mr479327835e9.10.1795780921851;
        Fri, 27 Nov 2026 04:02:01 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:02:01 -0800 (PST)
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
Subject: [PATCH v14 23/30] arm64: dts: amlogic: s4: add crypto node
Date: Fri, 27 Nov 2026 13:00:56 +0100
Message-ID: <20261127120103.1532882-24-jnieto.alaber@gmail.com>
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

