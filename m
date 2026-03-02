Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB023361DAE
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 11:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450527; cv=none; b=t8ueZQ7T8PlchBVkhj+Awk1yj+duONs5H7VZIu8PHi8Qf2a8mStv7p1PvOJupzQoK9aOOcrinUsv/DIaQ6pi/orIpjOqwuq4UaIIiuOPMbnOFixJZgFNeJKjMG6R7DAi1kOAtSkJeg5M1zuVYl2qSmYE8uiSHWR8UGijM9bDOx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450527; c=relaxed/simple;
	bh=oX67Uf2cuE1+33M2za+xbEhq+YUjBZnozzKI30MQNUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m87TV18xFamhdsB+nOFahl3LDhdBBROGLBKMTIpx45LGiBtPOTTHd6UR0giJKkKmgTNYfO6ARHcuAL1KrW5AtOY8yjiMGqJJd/iuhwwhpIuA7Q0OozVioJgsRSPIINP/65ETF2eVbN598dS4VdN7VzSWrT3k1m2wDtgj7WxL8xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=LCeKqbO1; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="LCeKqbO1"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-482f454be5bso47311845e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 03:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1772450524; x=1773055324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5eHw3BS810lHNeg7f4xIwnSQSat/sp8IElQzLbapwg=;
        b=LCeKqbO17rP5109OTJALG7smNOybvBTsEVgvkM3TcmGnYCcAzUN5fSoAOK1zB9IkmQ
         WeEeXt1F1GMfZb542AAlvPWN5q/DtUezGrgHUpwtGBrMw/rlyQHPclh5dFoA6h+K41jn
         XEM0uGw164ChBXSCR/q6znMhnkdqqPZlWBu7Mkq7+YbSaJtH+ULVDYO7G3DajKhF2Md0
         NNj1G2CPYwGVQ+9IqnEeU3Gv7oVuhJLyHQpbEKUKI0+uR+YqgSqXFhfYsNWPZzn2sMcN
         25nSYvtPqaHgedcPA8CIx65s1r3ilq/EnNxbcbzOL8eJhQJJqnlwOgqszGl24mP31upQ
         L2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450524; x=1773055324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P5eHw3BS810lHNeg7f4xIwnSQSat/sp8IElQzLbapwg=;
        b=nOhrgGyDrzEXMtUUbbsC+6dT6PXmcQXPlB14rbLPbtc542nH4qPuUsoHorsU6x6xfo
         RG0yasCdPnZSeA5h69XLJqmDCDMaG4MfzGVHWSw6MyaXSKHdTQAnRQD4FiO2uFG8Hitd
         GXKXwXTBPYpensIY/To9jLHFlpLzlHAgw+KU1/FBZZU6NKwHW2ejsPLW/MTVuQiWt/OS
         uINq4wH+KRAJX83YrjXQffXzV6oN89fuQgnkym53sSx54VrvU4SCydELwb0RXpLymhHc
         iKqli2qGFC1Rjm+PSD3HYZAh8P+sgTWkPcajYQgITgLnx0tAGBwElRbRgLeJUVsXl10Z
         PAFA==
X-Forwarded-Encrypted: i=1; AJvYcCUwcQO3qTHDYUjZJw+ikIyCdrcEGbbT/W5Nxg9Qpr8vZRdgw3shotQaWSU9Zsps5A6XVfkFC4nlygsaMEI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1QUmJFhOvYIbk88UKNycDGNyGQWw3E17ZuQkqeQeZtWmeMBre
	VHiov283W9QkFzMA9jvu+pziKlfvMHykgA7VmdsyEoseEugIlysQWVvMoNq+aQnA8Vo=
X-Gm-Gg: ATEYQzxDmaBpCqkISqDIMSuQaecv1or93mgWcPKES0rR4ahIfacNZ6B+3Rxrh+qPFdc
	BAiGQ/6YQ+tbfuIPwOGkGtSz+UGnFseIRbTUGIFqdahA3n9tZe6YUV05p+APEJlItN3gQ5TwymJ
	F4oVqxsnN+P0Wr5u16NlHeSoN90Zfbq2Kh76QuthafR6rwkGk0vwk+PbrmV6Mm7I6+kdKBBG6+L
	BqQv074kGTpaA1iSxSOWYhuoo3Kr/u53xS1UI5jbQJzqDCj6d0nq/MB0WhBvRY+d6khnvykwyjv
	lz9MxrCQ2kbSyko7OlQ8eqD9oddfe2YRitd9wxj+Th/RAEBBaIRk2Lu/St6HgODChRmH+y0Y+5d
	b8TWJ7mgj9RI9b8rsylLFvVLPs6KgEryPGSKbhw20atRf9Wedb4mqYsZ1GforGDYBRKE7elCO1k
	f7oZvsG5WkySMktYaAsMIOWnb8fGkHM+szNIyWhroygC0ok6wkaka+MxJf2cXBoIsHN2orysozc
	UrKCaCm7R2YIsYeJG3exoXa69pvoZC4PiX+Tte4YJY=
X-Received: by 2002:a05:600c:c8c:b0:479:1348:c63e with SMTP id 5b1f17b1804b1-483c992e3a4mr192566935e9.9.1772450523941;
        Mon, 02 Mar 2026 03:22:03 -0800 (PST)
Received: from fedora (cpe-109-60-83-135.zg3.cable.xnet.hr. [109.60.83.135])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-483bfbb465bsm292493035e9.3.2026.03.02.03.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:22:03 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v6 1/6] dt-bindings: serial: atmel,at91-usart: add microchip,lan9691-usart
Date: Mon,  2 Mar 2026 12:20:09 +0100
Message-ID: <20260302112153.464422-2-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302112153.464422-1-robert.marko@sartura.hr>
References: <20260302112153.464422-1-robert.marko@sartura.hr>
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
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v5:
* Pick Reviewed-by from Claudiu

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
2.53.0

