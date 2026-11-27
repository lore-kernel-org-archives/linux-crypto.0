Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780875;
	b=dFr/Pw9QnD9paUvFUrpAl+QuS3YOauH+dI+/dH45PQnIsbMinMNpSIDfnRP5dMJ7nN6S
	 Jd4zm/ShpWEaBCb575uwwJeI7IpX5W0L0meicMW2iD+0p7Uvn5IFf0dPTQcVYyGRSACwb
	 ZkvjiH2OecpdX5wr37Rt6VqummYwsbFLtQG7ZmcEJxhG7RE15iHM+crgiE9qUcmRy86kV
	 +pfN2U4q/Q+iLW9CiCyhmJXjRsnYyfeVSpxf6Lge2ntCQH1SWQ+AoEzPbd0GxQDOBCvbi
	 Un+zl/oMvFuajMA6FxaH6qdSThNsVQdYiGPwgVclV8iQ3MkrDHEZo5+P55X/yGOsWWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780875;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yslwO1t9MXGHf6kGSQvi8Jsla7lrMGXHDb1MA6K0JGE=;
	b=sfmGNlN1WF1OGwdEbNcvO/nkVZm35c1rqjkmf6WeWFXjIFK94xTjEi8iWlksxovo8G90
	 aZQLt0eUcWFUM4rmGqLI8aGlMO0VDH+uwQvFsiDfOHREZ+nPGdLFH4LEc9WxvWzbRGtoO
	 xxDQqSnXx2HuhwfEZFkEelDonx1kgJu9TOsnSX0dE3tfmzNIpaBrgcvzdGiScsteTWUWR
	 C5GkBWbOCQFHCfawdWEerDJRa8musoUvOkqyVqvFLPco/jsSq29sYU7bP+/ZGs4kV0faf
	 1DKCRO+/+DQkI6p6O5mskkFfIJKPNEHdsWpdK/P2+x8q1d8S5GrR7NkNJExGro4xstA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=foK5S8ED;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785E4606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 785E4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=foK5S8ED
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4a68190a2a7so6802101f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780874; x=1796385674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yslwO1t9MXGHf6kGSQvi8Jsla7lrMGXHDb1MA6K0JGE=;
        b=foK5S8EDypCGyYz7Ln78+2iClqhaLe/Na41jXLaL7NmCrKavI8avv37Nrx4FXbMZgW
         RzJ3QWsNgv8Jw+6L1+A5BEyRcPirg+/vM6/vA0TK8FolAnaRNKaJ7WILBmteUPQ1QOHP
         wnf9J6Dk9kXRpsULzWw1ewxN73D3Wcs4nbzSEiqeA8Oif2n03z3HRL/xGKkD2MLjynZ/
         aGoN4GaHw1T+DFC0gNut7hUKgWtJTyACFb1UcVhaTsO1xVwnV3/hb58PeJfkjBGM9vsK
         uo7EHLquiqguELo683LllLtZQxlw1+WkminR/amubTC2/QSXcOq/WWpenf50pbfIb7xV
         W51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780874; x=1796385674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yslwO1t9MXGHf6kGSQvi8Jsla7lrMGXHDb1MA6K0JGE=;
        b=blcW7MiKn0grdiNZ5d8fM8BY18uSy0O6pZqzskIa4TxSUDeRriNIEPsEVdwr5LXI6W
         NmTdwgi+Z6ANOCPbwrcr8zWYkEXGNrPN7Ca0sY1JnVlPpdM8eRsQR1BK/IDHbGpyAQql
         /T6jB0Dys6O7yk8zut2E5vOiDotnkSYgtGQzwDvXhLyn2Nhzk7ADueZU1xuulcGlIlb4
         GU6wlQ/y0xc+jvVucW4JZU8U/Y2rC/zA8ZYts08DBoGqcLKUIrQcdzLwrImEJ44OJ+2M
         DeQdZUpD2s5TSqbLbI5QKdKXqXQxoI1X1s43LUxJeCW+3V9w+1inANOx9MYUSkz6pgCv
         orVg==
X-Gm-Message-State: APuU4Z/9MHGZ9jEF+ryneO+9Bv/Gqvi0rxeS4uvPwC6UWiksnLad+/o3
	McBi0kMZqEXrBRTkl5ZPwQPMoP3PvC4zCpk/8U8a/VuaC/qzU0DoWHbm
X-Gm-Gg: AZFdTZf5m5jnhTxgbaX12WFVb7ADtu2qtH4xdRwW/kIwVeJlQOADiYw3m6d15H62pKG
	3xXAIfYC8n2BafzD3p5IjsmQzCyRIx38pHE1JlzE+XrUAwnmg+ZPGcqGsoWriD1jQyoxojxwBYe
	8MrBEChLkmBLIMRhNvjKqc0Gg027HAOTxcRg74rSsT54xqI6eqVMbiAdZf5nyl/NLUGPRi1dPuj
	S1ntk5kUk85msVAnmAhIrsOFhlIuMInquwgujfNBoLfRw8WAXyVoVLipfrViyNEiBZJS1UoYeHt
	mhecxU7kyQHUXZbUPh/ShnEhuMictdZ8anuftrK4s4gNWr/U7PAMtE2Yi8wPqIizY5X0fK31pT1
	eW6PjmF7KdiQ9+1MqsrFHW2sSiR6ollsggvIE3nzOLTGZR3JUCkFau3VqsSv556orhhBkaxj8OK
	oRhNX/RH3ymsg489HvAvdWAO/8H6GPuC6lvgkpIVaBDrh7v3TCswjlVAJi7wfd+4jbbDQsrHfLY
	aE32H1ZzY+VDqdFHkzxsQJvzbhwBuQm7gkg+3JpEhlpOTvp+bQeqGIdhoR8vyxwE909ZcqwmywK
	ICkTjQqYfN6B1F4uqfyxtQ4lmMO0cQ7KblLJh69bTbaBXg8=
X-Received: by 2002:a05:600c:8486:b0:4ac:aae6:6401 with SMTP id 5b1f17b1804b1-4bb8880606fmr497694375e9.12.1795780873562;
        Fri, 27 Nov 2026 04:01:13 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:11 -0800 (PST)
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
Subject: [PATCH v14 01/30] dt-bindings: crypto: amlogic,gxl-crypto: correct clk and interrupt lines
Date: Fri, 27 Nov 2026 13:00:34 +0100
Message-ID: <20261127120103.1532882-2-jnieto.alaber@gmail.com>
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
engine is hard-wired to a clk81 (CLKID_CLK81). Drop clock-names
field from schema: name "blkmv" is invalid and "clk81" is confusing
and sounds like something global.

Also, GXL crypto IP isn't connected to the second interrupt line.
This binding is useless, there are no users of this line.
We must remove it from dt-bindings.

Fixes: 7f7d115dfb51 ("dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto")
Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../devicetree/bindings/crypto/amlogic,gxl-crypto.yaml | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index 948e11ebe4ee..fdc39797a2a9 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -20,20 +20,15 @@ properties:
   interrupts:
     items:
       - description: Interrupt for flow 0
-      - description: Interrupt for flow 1
 
   clocks:
     maxItems: 1
 
-  clock-names:
-    const: blkmv
-
 required:
   - compatible
   - reg
   - interrupts
   - clocks
-  - clock-names
 
 additionalProperties: false
 
@@ -46,7 +41,6 @@ examples:
     crypto: crypto-engine@c883e000 {
         compatible = "amlogic,gxl-crypto";
         reg = <0xc883e000 0x36>;
-        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>, <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
-        clocks = <&clkc CLKID_BLKMV>;
-        clock-names = "blkmv";
+        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
+        clocks = <&clkc CLKID_CLK81>;
     };
-- 
2.47.3

