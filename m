Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05A9338F54
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 16:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816748; cv=none; b=s7ue/h7tld1M5W4TSWcl4FEYgGQcLHszaMVhvEg8K9j78DZ6N1pJraU+1qNMo9EOjtmbVPOYgFWWK50upM+QP0K6InRzkAgeXj5XoUu8EeA1NXPc0schcVT/Ppo1ouaPi4kY/LUpt2vjNidqOkg6locghZRURHAHfbp+R+DCv9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816748; c=relaxed/simple;
	bh=aWtpS5ukM6OTjJwDQlBjaGNr3tNfLPWIVyHdFTQw0ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNUg/C2F7FLi5pfDzXiRx8vldsONCT90P20i4/bWx3XOZoBqxx8Di5Im8bY0njpYObWxHRGDtlQ/LW5r6j2/k+bihXhvS+fRBSKOqjEauXihWBNoCsOJ/yVd2kA4yv5Xbxvkeu5ALeOGQuTuiPGW4M3ElyJJbYozSFinnzj8774=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=HO5Ey94d; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="HO5Ey94d"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477619f8ae5so28540635e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 08:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765816738; x=1766421538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzTS/0ZyMqSoKPg7ITuPysU9ip6EyV6+iAiPmDW2/tU=;
        b=HO5Ey94dpj6zWOoz0L5L0y8X69hFWvbeT04BkwlyT15jYCnbM2FPY47xRyxUSuPqq0
         CJYW5lrSNVziP6MP42xtzYz38MBnBl+eQurdkmVKST3mU2BBuppssWyfRd1DJcAkyG5o
         nLiKHlcX3Ds2BaedHt4ULkda+iLUJ7HgaENTayK0zbAufiulvaxMUHf/zJoJY50jgaPy
         vf3yqbvNxTUMYaeue/9jMOH6gOiWO9r5tXQDeePfB6H6ovEP277cbCOC+Se54QTf2bvp
         Q52StpqomWhNzdtWO6Nw007VnuvwxvRYkKBjjmLU5SY5IHblpNiPFHBan2jxZDCBPbZF
         zUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816738; x=1766421538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NzTS/0ZyMqSoKPg7ITuPysU9ip6EyV6+iAiPmDW2/tU=;
        b=PL7W79Ahc0W4tb39D2yE/ktoU0Mhd8m3danucj3tkQYshr1FSLH58wG7SEB5MWtYVJ
         fguZHn6bxE/JyxMRozyaQ4hKKXyOsw/WxOfKpQE8umDmjGSlUEoujTwyorBBkF2lkrzp
         q4YxhNOnISs1Cdlr/xDFptafa4euxB8yWL1TUiy1KYLZpfKqGSrmPzpNE52ruq1CIQKU
         yMn5guYwHWv2dUUlOszxiEBrykG6oYdR8EQ3L0XBwRitQs4vEJCXdmULy0viSKqTZUIV
         ob/Ow+dHXRoEaWnGFiaL0yniCYf3RSzItAVd5ADlMCiR4zspAB0Jn+DlUlAwvA6t9yJv
         ju+A==
X-Forwarded-Encrypted: i=1; AJvYcCUYiz84HyAescFyAND4CYpELkXrFDy1ABOANYJXQ5Xof5AZUQ6Q6l00N6WLbSgzNLLV7SKND/zBYVb7wOI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtyq2QuXPXQOXudDh8SBt7JPYUpNs4WMJIvUp83xumKctYmGBx
	NfeNbQS/xcv4gwfwpYmBs+GA9voFTnPUWukXvOO5K6dZ5zLBF7kNfR3cdLDo4iq944E=
X-Gm-Gg: AY/fxX6p6vasZMwqXts/w+fHN8fbKOzXcdx1ydgTisCfRF2KE8lvB0EXEQVWn6ZWdtM
	hfZFt4DNXleXCgPdV8dgMwFIv5gNzhGe4AY8tma5MnPmiyHetc67i1vgBYgXbVhn6I1pqnpL1/Y
	aQnoCm+7TZzg0l0907lUSy3xxc7ea/4pZWuXew86tpaRyuspeP2IU6E+SVQcZlJWO2tIVtPp+AR
	3qtN7VKT63YovHPrt2u2DYIOPtCl1vgXbrtNvzm0bkmCrkK+F30hdpUpvqrjNuHDElMjohJ+A0b
	2M4I5vNpHTjLo/WzyNV2Jf+tS3pUpySmxlDUMAx1fHzL7v55Lr4bwLiBLFpsI9NKFA0pUe35MAJ
	zje3S8Dl3es59YUDaXDAeLwE/PXGnluP+sm2sLd2+TNRdrNIGeDU0kbgx9A5Q1hLPIEd8WD4b5/
	CeOAhWiqRqEs6Hdhq8rxkBrUJDfx6w1tlwqBS9IbVYbpD4Vv7YaN+AYbU=
X-Google-Smtp-Source: AGHT+IH2I2yw55Q0CXhaNIPIXzNi6FBLabOFndmnwZCutK6Ow3Ht3tHRyLRJOxKZGFug1XR5+KxRHw==
X-Received: by 2002:a05:600c:3b8d:b0:477:55ce:f3c3 with SMTP id 5b1f17b1804b1-47a8f89c8a3mr129879935e9.5.1765816737723;
        Mon, 15 Dec 2025 08:38:57 -0800 (PST)
Received: from fedora (cpezg-94-253-146-254-cbl.xnet.hr. [94.253.146.254])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm192209725e9.3.2025.12.15.08.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:38:57 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	linux@roeck-us.net,
	andi.shyti@kernel.org,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linusw@kernel.org,
	olivia@selenic.com,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	richardcochran@gmail.com,
	wsa+renesas@sang-engineering.com,
	romain.sioen@microchip.com,
	Ryan.Wanner@microchip.com,
	lars.povlsen@microchip.com,
	tudor.ambarus@linaro.org,
	charan.pedumuru@microchip.com,
	kavyasree.kotagiri@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org,
	mwalle@kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v2 13/19] dt-bindings: dma: atmel: add microchip,lan9691-dma
Date: Mon, 15 Dec 2025 17:35:30 +0100
Message-ID: <20251215163820.1584926-13-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215163820.1584926-1-robert.marko@sartura.hr>
References: <20251215163820.1584926-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document Microchip LAN969x DMA compatible which is compatible to SAMA7G5.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml b/Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml
index 73fc13b902b3..b0802265cb55 100644
--- a/Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml
@@ -32,6 +32,10 @@ properties:
               - microchip,sam9x60-dma
               - microchip,sam9x7-dma
           - const: atmel,sama5d4-dma
+      - items:
+          - enum:
+              - microchip,lan9691-dma
+          - const: microchip,sama7g5-dma
       - items:
           - const: microchip,sama7d65-dma
           - const: microchip,sama7g5-dma
-- 
2.52.0

