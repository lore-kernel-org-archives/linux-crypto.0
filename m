Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721583;
	b=r244vfDsHQD3IzikbLCa+LlFJGgBZAaxFXqe0c/Pnap1ZJkZIILX8monDYgoN1NMzkpe
	 Nq2csxYkfJHFaUvyTXT4PP1fw1I0BWi45AjsII4KL7ul58HosmDIbIrGO3SjnQ8Rb8BO8
	 8iVRMiy1ZFmB8oixYuEtn9uUfaTyxIAifP1ro2QCSs4+F0KPU5X6fDF/wXSof/RK7zVna
	 0INxHAcDZmTWEIe2aCGbqVVVKU35StfgR16cTmD4XxzSz2OU9rLuBumOId4iPUqHEFvqU
	 h+LNAI7PjyfSNGr7OS7OWfTd/szwCfNEpfmEzyb8inY9VgBk7jOKESDrW54TJ6eTRyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721583;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yslwO1t9MXGHf6kGSQvi8Jsla7lrMGXHDb1MA6K0JGE=;
	b=gmKfJRFOrPQ4ll2i7cSi3PIi9d2oiwwFCk8mRiUUJ2U+QV/aL8YTFnh6lA/qlRQLzYlt
	 uABsipNhqsQ6eaf7+iP4V6g/5xZCb0heO2KvvO3z4oyTtAjkFn3GRXnbrt6PfkGJzCSC0
	 ORamO5ogT/hGbTUqTxk4+sJaZboVYyBNyF2GDOuKz1+djxsP1J35Quz0Ovg3nJC4sxxv/
	 ejiYMRVrcc+H1aSZTfxuZTA6X25p9rafcb277Z3sA4uILs1JDNAwuSuBVAIfe8NyZ0hMF
	 s0c3Jo8pjVolqZE2zFkLvWNsTpwOriODO710FUhlGH7jsvLO28CUiR6GpRBGSj6R1NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ivuX4+nj;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF901606A321
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF901606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ivuX4+nj
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso68523355e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721581; x=1796326381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yslwO1t9MXGHf6kGSQvi8Jsla7lrMGXHDb1MA6K0JGE=;
        b=ivuX4+njXIxjCdyHHok0kE5C6lUcPxDZnGAGn9pOqGeTr1zY7qMFnWX5i9SYgpGl68
         aSVPQzef+IMteddK4OCPOQPbeN1Tp4FirzNZUJ1eUl8ljCLUgomkmTwjErY8uRmpQxsW
         5xzYY/q0tOnzqqhQUCfzAipDCtfTvyJa+NnnjvG5+vpvKRFwSMNnLGeJ1KReM9QbtNKI
         FYmSt3nhucgwEf+x1A7uICj0fzSLpJC+r0PA3l5aSlZq37HNPl49/bYnblph/drowf7x
         zihecJ8gZlpPoiHYkHS3MTPJL+kzDqCD5Gx9yJYerRk67ukjmaPlfgg2LOL+4QbI3MBL
         lFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721581; x=1796326381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yslwO1t9MXGHf6kGSQvi8Jsla7lrMGXHDb1MA6K0JGE=;
        b=zBapSK0AzdQWN25vR0vJ+KxATNdLqMSY/o9pweEmaJ94rd3lVhuE1QL0B1chfeGJIf
         71J1kybeN5OK8AqdmtaA6UznnCyNX/WsFcmVHWjlBuQWQJhe+HroL81LFyXe2/TlVusk
         CBt6IphOhKX/o9RzIgUFAPH84WhbLGL/JQZe3gMEEVLKyBKO8KiSEQen0o2pJ8ZDOlUH
         AcNb45JJU1WLLCYB6ILYXg1+YeRwkXF+FNYUzU0TZsMhJiOAtwM0GPHbhqK50ip/8nxE
         T+CcDEagsQMnWv0ZauUiCPlNh6ocXKWnlgl0C4fwCVwB4b1SJCWKKsX3+83jb59Igvh0
         /HFw==
X-Gm-Message-State: APuU4Z+9hpdu/gq0P4MtMNr3XsW3b0it9Jwgt0FiLP7Gtk11vH540XE3
	Nw0spOhZRa+8DtR7gVzq0WOpDVCqWXLFIL/zrM6m1yOGZYSj+LomUK1u
X-Gm-Gg: AZFdTZet9IcJ+OLmjEw2iRsmr+Tw0rsGXJKeae8bgJ6odIwEVmm/e368tNFOcX/uBsH
	Ghlz5a5TdNwMzbEbazwbL/uBG4rdH5m7Ye38rCHCJXsgkI+bTu510fGf7FmsQk+jcWs64Jx2Aav
	AIEMmYmvBFR/lpgL4bS96Dc3wXrufokN97ekkrGNjD+MdHwbRwyXUDVmkYcFGnENaSEur1ykGFz
	jltmTKtW6RPnOYOrBkDgSW1jnpL41WfLjzWm95pmJ0bddRkhO2q30JknhuyFpbJjObuLejz+2Or
	OO/xzuMLhE6mqkoyD5Lo0gAygEGBqSIWpnduEW3MPeD1ZHxvKHU+KrhUhpzyXp6nQ9mWXy8csDi
	T4krUNl/UUCZTyeacuMHY2Ro8uZmw7Rt5M8bDYziGjR3r7FM8pQI90I9ct8p9YNEZVn3/hC//9F
	SSEhk9MWP/3UGvi0veyQicvGTLEqjinrqkiyhBpb+z6dYH40BrRu3cktNRDusmC3Lz3LQnrM6e3
	47ZM0r9O4zll5VZTw/Q/pCPzyQopQimnYMkiL0QTT3srvKxDc6ePU8UAGVuCtv4DMrPGImbNTzE
	mujZMDAQSKkf0WqFDmeP8yt7wxrE960NTDrt8njOlA+chg==
X-Received: by 2002:a05:600c:64c9:b0:4bb:8701:bb14 with SMTP id 5b1f17b1804b1-4bb88804d1cmr475541865e9.5.1795721580895;
        Thu, 26 Nov 2026 11:33:00 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:00 -0800 (PST)
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
Subject: [PATCH v13 01/25] dt-bindings: crypto: amlogic,gxl-crypto: correct clk and interrupt lines
Date: Thu, 26 Nov 2026 20:32:17 +0100
Message-ID: <20261126193241.1471372-2-jnieto.alaber@gmail.com>
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

