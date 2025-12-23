Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEA52848BE
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 20:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521219; cv=none; b=B11GeFKW3TjjHrLIThJsEJD5SRB6FEDgZBTOzhBbw3rULJrzBrXvIIfK+6uWME1AQ6vDeE6GrxBj6oAA6AeN9ns9F0pyht332xh/nfjuWgkHm/prt0uwUmQCuM5IgCGATPcVnUQ30WK7duNvOYqnYxvMz9tm2YIi8FqwomFZKx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521219; c=relaxed/simple;
	bh=GSmfufS+BjcFXAR7DhKTmRXgeyl65npdKjntCPPDfHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eu843zYEoKRvyzwUEycZQHqIlzAqNsrot6oOr1KONfoS31351OxR/Nf/5+HERhGlS4ulbu5CYDKpNxOh6rn5mE+T7/2zu/ey0YhqE5O1yjpy6Tl/hkrKwglKZyZnUz5i/WDLBDr77MA0u1i15M9yeN8XCmZ4m4UGoLw+11dNHEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=mknI3aHD; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="mknI3aHD"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7ade456b6abso4458420b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 12:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766521215; x=1767126015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2FSF4N3N2MYzlByPoECc2cAz8v8tXyMKGpnQtUm3aY=;
        b=mknI3aHDk/xx6E1DXCAkhUtT53KYTa8H/fy7ZqYi5lMAYZ2pnjDOEBbpIn+PxzsEih
         Wi8gHCcxw6toR6SqJxa0bt8CxPRFrw2FGeuOBXtyqNd/OiX8LDNzXflhB1fmTCJggOR+
         YGkdiMbAf487Cc3/wOyoWB7V8JvpTpMJwDUOtBr7clyUt5ACpOC3y4DWtOmXN/0bgspv
         S+1LRRlkfT/LfRuRi8mvNfnDrTa7d0Rz3fVOwnNtuYqX9hOvYGnRNM8NwkprFzIiTiGt
         DCBGCog1PbUG/q40amKbvFtSJI3QV2PfA7L1Id37cDtu8ahGqYpYnBl3zRj+quKK05rp
         MSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521215; x=1767126015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m2FSF4N3N2MYzlByPoECc2cAz8v8tXyMKGpnQtUm3aY=;
        b=kRKpTNEbUskRG4fypLg8RsAtxDxleBCFOe/3ByntEz4zgImmhq7BmaPr1rH5FfY4ZV
         fDbgqIMqumviY7lxzM0uPpc4BNgcxO7JAgZxsBIb3dTHO6cdxFljg5+ds7zZ0sF0NLZQ
         ZwPnTj0HWUNYsIPKPA3Fy/QAWt6ydSmQrj5XGihpBJpQE0pSjERHxccBbUxjmH6NFsIp
         ddWUCXy5qVRsWAlpQLupeUTM6Ouod0mLnhA9RDerNPhTfvxa6dmabT9xRMhA/P+jY1w8
         pvKP4eAvMINLJIwAE4X968y18v1Hbervc+dZus391TVdzlsS4AtplN9eTfxzHpQRn/uU
         /cMg==
X-Forwarded-Encrypted: i=1; AJvYcCViQYn9eaKb0UDZwsC19bTcYccpvioM2uh4CR9frKpPCguOPE4oMa5YOkj7Hu00aBVsB8cCexZewnEU734=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYES0G+BXCb1EUKsNSVxv++k46+bdFcjnSrlPwJb6lfFedis9m
	sPxBKWUtISIHoASWrtGv+oq7cy5UK5uXxpQpLa+Mgk/Wwx/j57Lo3xQ7DcfvvXT2UXo=
X-Gm-Gg: AY/fxX4fXU8cRy3uJeB6AwjFlY1quxAbF4ylIbvCOCe9qT/BlBkTyTB0QgYxdgVvRha
	ZaQBxAGJD2W7BQTV+ioF4Lx+uzVbnlze98CeU8+ztasmspIyISfLmXU7r/7CIC0HMcsawSsKdMp
	eOGJ+EfxhCcCkaL7/V+pVb+a+BWFERU7jT4+Y+EHZsyNsfXDpJcP3DlWYyfP7ZwBlBO/dsnTZdS
	CEHtP1neW+MSYyRQZ0ep0UwbCDDZ3ybFTRpPhCEjv0soXNCs57O2ELjVoGLIB+vvdqJv0HKTW91
	6sisARW70K1F3sAoXbY6u60R9ALs8NieFIVclCpEmhPU3Kx8hEYFdV8Gal+V4RhGcN3igX4lBLw
	xQu6sqpya5Lp28zfNLHDzVDUAlnjyYKL5Mn27uJtFhePiSfPxf00aZIcxxEry/YqkxKsRPSAIGJ
	sOAbfHfqQLY9BdDTqq4oVHXNsM37eTzakc/Gp1uxemFMGT5hDXbIbKrHOFp4x1XjHRFry2vi+57
	pS4D2ym
X-Google-Smtp-Source: AGHT+IHTipKQ2GYkfIzCrgEkT5HgaT5cetpxH7RTkCWDpkBy3UcCKVeG1Kf0FvBM/eI9Sln/VDayPg==
X-Received: by 2002:a05:6a20:9149:b0:347:67b8:731e with SMTP id adf61e73a8af0-376a77f12e8mr16762772637.14.1766521214766;
        Tue, 23 Dec 2025 12:20:14 -0800 (PST)
Received: from fedora (dh207-15-53.xnet.hr. [88.207.15.53])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1e7cbfa619sm12567549a12.36.2025.12.23.12.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:20:14 -0800 (PST)
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
	mturquette@baylibre.com,
	sboyd@kernel.org,
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
	linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v3 04/15] dt-bindings: serial: atmel,at91-usart: add microchip,lan9691-usart
Date: Tue, 23 Dec 2025 21:16:15 +0100
Message-ID: <20251223201921.1332786-5-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223201921.1332786-1-robert.marko@sartura.hr>
References: <20251223201921.1332786-1-robert.marko@sartura.hr>
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

