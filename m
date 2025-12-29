Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CBB3370EE
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033623; cv=none; b=iKA3TlvEWtWgI44QiOWXa53XJ8djdtzkDehUsXLOPwu/0XC4cVt2B1OLBI1kbhM3mibema0gw6/bCqRlsf99o+j5tKjh1NtUDfetOBlbuMzrUXX9rQMSe8eOOcPdOsh6md9Gjad35vnxtLs8XEzi3ptb59EwWcePo8kHDFX1ELc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033623; c=relaxed/simple;
	bh=GSmfufS+BjcFXAR7DhKTmRXgeyl65npdKjntCPPDfHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMpC3h+fQmH2JltASkv22lEXoBCrtqb2pbro7kWixMHV6HcMNNOnslnPK0d9DBLGSzVukMZ/CnEAgfMzxpLkdlSKP8vN5WVncDNFHQ4johIRl5Qy0crdlTW8gft1banpRHXJWQmGVOYElxyageCZc8f861+1TRukx+wl8oDDg5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=JcqlzjRA; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="JcqlzjRA"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so44613495e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033619; x=1767638419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2FSF4N3N2MYzlByPoECc2cAz8v8tXyMKGpnQtUm3aY=;
        b=JcqlzjRAY7GYd7DXROYgWaELXWB9Ssktmv0mSGBMky80lcqfObTvF++Aws/cnbhLIt
         yMn5+n7PQsVaPG5S0nSJdGjAQv+rbOP7HgcdcPpJ397mAkKVT5uX3fyEiZz4iNDImAv1
         ygQjSfkGsJtE4BH6mibkK5llo62IgL2R6umMw1dy0lu+we47jagIw6mQtfbEdcJbvIFs
         sj7gIiiZW5UrWkm0ZabFQQS5bX4/iAVnhv0/33iHD3qs/a9XjKvmtSqSoKgynE0Fb5bW
         zfOQUkXxivxUuLlwihW02aUZHmiajEMBEq4a1P099s5Ia7Jcqgyr+cJNoEthuSEHRpJw
         8pYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033619; x=1767638419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m2FSF4N3N2MYzlByPoECc2cAz8v8tXyMKGpnQtUm3aY=;
        b=qgCXuc9+WwMfdJDne9amX84GgWUxp2fiQfhk4PiKVrmBK8L65J97zCyszIBahv+IEl
         RmnOpMjsAUBQGGFPeeHVeDuqD6SoHqDhcvqHk2x0cBXoA7jR2BHulQ+kPw6ZJWqdGsYO
         jy3FJ8CgoRaHGIRTRaXmBVTfrdP0PelFmTFHiX2gYgBLIoF0Xyq4e0VKjeRC7LRjDPWB
         D3rTetM8hGIUs0ZXH0Fpz7DtyQN9k/Pt0pyNAnAvQ7Omw3G4yyAkN9SzfxfsQRbQdAQW
         rHdOPMd16GyXr05qi/OIvkveZbIb3wutQ1HehYY2cVmJgjVEocWQujzAXW/5UVch3r/E
         6XwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUs+Yr7joFOJe7kyJ7VopI7qkHW0LFXiLB0fpMXJe2AZ8XyrljYmoNPb6NpOCGR5E1fgDi0BC0ndIkF7/g=@vger.kernel.org
X-Gm-Message-State: AOJu0YySEsZ7u1Qx+FrfJvqpqzxjvlVhfQQw/TutCwT3+uQHshgf9UTw
	MJLM+DZh0Mg1ft8ETkb0CmlGCf5Ltjd3sxa85URh/AZ4+RnoEFHugKtfgeAJ8VXW90g=
X-Gm-Gg: AY/fxX5AgC0jymRW1muOMR9GjdSXBbkZ2lL8WAAYsiWKpIp7BYKkD4rqjx2eQBQCcPX
	5XHkBzjkMZhv63/wNknioxMFo6kqqF6mOqmir3T6FADO0qVyaNI3MoL+rKidjM0bpK+8F29d7Gt
	r0FcGpObjEcGB4H30pIiAEablKPnrqr5zKcW/rvvgwXv0puktGmvSi1GC6LJHWo3loekBUAQMKB
	5UwB64hBFS3xgJb9OQlh2pz0mfONZdHrmVFIMFhsBj4z0Ced/9dFWhfMRwVLG47ZXn3kBgI1Tgx
	HGkXLLBaYFldoTHdcKzdc3CYGMIY2qV+PbcXRUw8X0UTMulsKMPjVeGmgQXo1XXrlrYewkc54z3
	eNXpJXxlYk84YEwsJ6sinoHEbKpdbfo8x1qMm0ZzQZIGKySrW6V4GmGDJKJ4QVqxQvJhSosmjCh
	F055cpkwiYZgxcqzFbMRRzAzB9lHT/itN1JPiqRPolTByuTLof5dSHkbX/mUtC7bDpLC/pDebb/
	OlYmChDJvs+x9L9nQjHiAaLDgTu
X-Google-Smtp-Source: AGHT+IGouKdEkhppybsCuf/IfO2U2/Dz9wh0+2E3/5N4x/PhA0Nd7PQ1c14nBgJEnbaurS5x35/GCw==
X-Received: by 2002:a05:600c:4e90:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-47d19557183mr403585065e9.15.1767033618979;
        Mon, 29 Dec 2025 10:40:18 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:18 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	andi.shyti@kernel.org,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linusw@kernel.org,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	olivia@selenic.com,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	broonie@kernel.org,
	lars.povlsen@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v4 03/15] dt-bindings: serial: atmel,at91-usart: add microchip,lan9691-usart
Date: Mon, 29 Dec 2025 19:37:44 +0100
Message-ID: <20251229184004.571837-4-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229184004.571837-1-robert.marko@sartura.hr>
References: <20251229184004.571837-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document Microchip LAN969x USART compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

 Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml b/Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml
index 087a8926f8b4..375cd50bc5cc 100644
--- a/Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml
+++ b/Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml
@@ -24,6 +24,7 @@ properties:
           - const: atmel,at91sam9260-usart
       - items:
           - enum:
+              - microchip,lan9691-usart
               - microchip,sam9x60-usart
               - microchip,sam9x7-usart
               - microchip,sama7d65-usart
-- 
2.52.0

