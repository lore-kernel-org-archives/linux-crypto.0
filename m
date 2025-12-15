Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B78332EC4
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816755; cv=none; b=qe48OpVPsr81dgk9yevK8lWHrqaSR38KrogJYIEYJsGJPR1N2J+Lp3VjLtgU5kVlI4OLYzJeod8FtbAWp0FePSQjF6xmWvm30TUpjrS8Rf0/xhXXAWHq38vm1JuZZTThJyP0Oqs90ALF1kIAXvuoq2pU2nF/Q4G+BS49gn0iyLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816755; c=relaxed/simple;
	bh=VPVs4jF75VJXH8mdDS9PaTAypaYoWoEKaAjTQEnezGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdHKSiCtzv1+ggFipxCYhj3zU7WHtwbknpwZjK37z887Tk9x0kbF2f+SSRPxFhWvAM3i78baYm2mwWvfEIW6UCW1h9WyExYPUhO12IQTQTDKxGLfEH+eZua/v2/MXg0TkHjsqL/IY9x4grws+Bl1tUXWBFEEqmquJXyyCWaN9Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=VZQWF0V2; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="VZQWF0V2"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso29790785e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 08:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765816742; x=1766421542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s0OEssTGK11BYSFNM6Q5GJFG0lDY4xg8K+duT0eXTMo=;
        b=VZQWF0V29r1IgpfaJxCInv8zUo3+O4jzEdgE4tPFejZmplpHFTHeqVt5D6cXNZ3Ukk
         L6AEFF6RG8SFASe5M2a4eiD/KbzxAgbQH36T3jjYKngJbqaWT/TPp/q/OpyhBY1sXQhj
         yIpYTxkVaUCjXyiqskr0VF/Bhig7ipzAFn37azEXrBmSHDP73kWveQSfb1/oJyoZhBqz
         rtPZItei02rqsC3yEHu6GAV6lTw9A7IUX0CoC7l23pFlwdi9C53Jyfagb4uKlZFcbfRm
         cI5aKxlYdr7G1ZK6jgWC4oGsmO+YoJznPt4a0HmkcFxhQfZfAJomZynzewNj9NqRqbRN
         jstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816742; x=1766421542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s0OEssTGK11BYSFNM6Q5GJFG0lDY4xg8K+duT0eXTMo=;
        b=YPrGmNakdBu/g3r8MPMNbz3V8L0VXh2AFydx+wm8mDIDNVNoGBzp8aXzoRfV7c7wKY
         d+XkXcChxAIx1G693JGySV4ttOTWf+Byu9BnVCifLj7IQfytQS/z2zmceyG+4IY2EQOD
         4eOHKnh+WZI/8g/VDSJiBgefqUig5dssNhcxHk/NO6kF48sbGsGl+WqDkExmcGH6Ug0H
         Xjtauv3zbM2ZUz2BE1m0oCkkiPaSpOEV1AIpGzQ2ouXMxgdaOl3KEBWzWcYOWgX35YBo
         tp3JYxuHAyiDmwi6fHYJU1soXRH9uJIkc6PZSO2hNsXE2P3SLKYyEDuLJlS25GShD3qp
         ejDg==
X-Forwarded-Encrypted: i=1; AJvYcCU5pVa/tmPyJ6+Jyw7T7S9LLcSxzuVcgoebPeYY+O6XXIPk1Y9XM4iPI3skNADuXdZOSU7qI4vuOYCIjII=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUXkMG7HD2QWOVsgGVI3XLwbz2XEYHXmoeG5ufoC5dl7Qfp2Se
	Mm8Kdq6JLrGIZUupZTNGLkVlPoLquT+8Fbn9UQ912etCYrq1J99Fb3/V0Nv+poDhSnE=
X-Gm-Gg: AY/fxX6nNsmd8pUA5bbaXgWAmbfE1Sy4OkUv2f5qvCJm9WBdq6hoeS60/3G35cCEEbO
	KYPknuv5pIZK6YDCkOLmsKOLQzBEQ/iulnJypjfBR0+uZMYNjpEErWy7wf6S7oDZ12AJKePv6oz
	eJwyiHgvPU6aVRspgEWgKWbuktwXJUdYBUewtJ7cAR8Ln+L82xF6a2DrvRjSIM5oJPN0NbVxZZL
	oID5W5FiwpukEAt6kRdHvcyXrq1u1xvkmPHYmJXqFe+xRDa4vf+6iGm5ZSoDL3i4WWATNaFIn05
	Q6Y+vLzqShaYVtzfSbwYH5GEl4yb6Heja4jPS5NPAvAjHQOjXTo4e+vq9zWb2tutR6SNhyz6POn
	VUpNR8yswT0+thf9TEb1S4bkzXLQWrqArzDrtyYbgeHizaXRfJ6pp5u3ourh9GvFAFN1abP/GTC
	EFUCYuAVUhi5MdlRbhgjDwRXuAnaF7wYZ5nMDs6vMO4yXx
X-Google-Smtp-Source: AGHT+IGZRk0nLa6XE7JBLcVbJ2etCXd7oowIPMfnZx4Z6qSPahCqU8A7b4zUyWiscDsHFjn+GrD1MQ==
X-Received: by 2002:a05:600c:8b16:b0:477:7c7d:d9b7 with SMTP id 5b1f17b1804b1-47a8f915711mr129583515e9.33.1765816742452;
        Mon, 15 Dec 2025 08:39:02 -0800 (PST)
Received: from fedora (cpezg-94-253-146-254-cbl.xnet.hr. [94.253.146.254])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm192209725e9.3.2025.12.15.08.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:39:02 -0800 (PST)
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
Subject: [PATCH v2 15/19] dt-bindings: hwmon: sparx5: add microchip,lan9691-temp
Date: Mon, 15 Dec 2025 17:35:32 +0100
Message-ID: <20251215163820.1584926-15-robert.marko@sartura.hr>
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

Document LAN969x hwmon temperature sensor compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 .../devicetree/bindings/hwmon/microchip,sparx5-temp.yaml  | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/hwmon/microchip,sparx5-temp.yaml b/Documentation/devicetree/bindings/hwmon/microchip,sparx5-temp.yaml
index 51e8619dbf3c..611fcadb1e77 100644
--- a/Documentation/devicetree/bindings/hwmon/microchip,sparx5-temp.yaml
+++ b/Documentation/devicetree/bindings/hwmon/microchip,sparx5-temp.yaml
@@ -14,8 +14,12 @@ description: |
 
 properties:
   compatible:
-    enum:
-      - microchip,sparx5-temp
+    oneOf:
+      - const: microchip,sparx5-temp
+      - items:
+          - enum:
+              - microchip,lan9691-temp
+          - const: microchip,sparx5-temp
 
   reg:
     maxItems: 1
-- 
2.52.0

