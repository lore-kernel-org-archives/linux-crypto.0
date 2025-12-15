Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A93335BA1
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816732; cv=none; b=JCKYwVZlclxlHd2/AZGh4lKUO5uowIONA1hUYoLcCSFLqYP6Q5MFWCpEuA3LW5WOrSDaw1cnO/sOXUU/qzpEGuZwM/78S/JC5eRpJ/+gNm6qCmpgtyoQROz7JWVu8kRdGHWtcRHnpMJkwOs0tJ2vJF+Tbwr2wNShK7FcJftXYT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816732; c=relaxed/simple;
	bh=71vt4iyiLZEhN77G8cDPBZ3tS+ZW0JysnwtVg4Nk/+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyLLXzIpSKGUL4n6/qK6SyPwmg6Hm4IfLX6RS++Z9gNlPuvbwW7JDRhkpw5lfYW93W7SD5m/kw7OvlYcIK/65yZrUmAcCtVgg9jNjcaBAlao5kOMvYeC6O2Rq4viJB4tKRLDWGibCeXeQvk73Mm+pL21vL7UVklDktneWhGZRdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=ZR2hFQ8E; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="ZR2hFQ8E"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso16393365e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 08:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765816724; x=1766421524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhZHb+UU/3uI1zhxQGkYOMy2iOjOd7yGE5qR+fmsO/o=;
        b=ZR2hFQ8EE14oGueyiW9ZKeCNVEf16QNkEo5WkatjheEPmXvl7ymhA8dsYlgoCoUFpO
         G0JBjD0my2hDkyDD1bKay7O2yESjV1Ycb4Oc9qR9az/UnPJtLuRIB3wvRkQNuarmafk/
         tmN9uxP/RDWnozUp9hseevemJsQHJnP8zSx9/LQM+LbL4ykX9dNQb2JgkWzSpf2CK6GA
         IKsPY0AxDee9H96Zz3+irzWfjg2suiTW4kRMPje2G2zRXF4+w9VDHE03DKZ4Lisf01Ct
         Pq3uyZeglNn8Ik3WHr/M0J+96bkPqLIcuMNMeP2ilD8gzxiDkxXUUxKDZbsIPMzS6smC
         OSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816724; x=1766421524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lhZHb+UU/3uI1zhxQGkYOMy2iOjOd7yGE5qR+fmsO/o=;
        b=jdY8/UhG3tN0i0S2eIPHhcH+IWHJ6cmulxz4VG/zKcCJzTlnjiyALjlnoAUCZUhWnJ
         d3USKFVL5VolzF9+0KGj8hLx4K6joTFJFiZPSBKRVedD0ibXLV1EG8OJR1Z/jsVEpJ9C
         THp2vPGYKnMQ/ArLwxVFMLY46SEgIeHyr95yx5ofBQzPBvPPsXSjDYaegKXRrVMfmr2C
         RClodKXotBhlviu4QgzmvKgN7D1L8sJdD8CyOlmR73GyNPzOq0xrAfrdy7NsrNuMOJJl
         iu78mPWo6okYsTe5JQs6K7UCtyprzLzPXo2lwtgAQPllGSULAeBy32facmLgvk7P8tF5
         mCcg==
X-Forwarded-Encrypted: i=1; AJvYcCVYcLJ+hYZoY3e9sFEZ2JkfDbZAoLqrcD2apueu7RbIXcXIfK+DpghHT09hclzMggDFXEEpPAJIdd6YJL8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIqsE6MKezUch/r4Yp+Jb6lUkBDwMzp/66he0GgSRAp+G7oVSy
	xxRFntds0HKbQhb93Rhw7iZUsZ/xSmDY05Zlv5w2trsYTXSmNdd1yxeyIdosMxdbfZQ=
X-Gm-Gg: AY/fxX5ko+3oDphh0yvGPzhNaxs7pE0qKJjb4Gp1fnP23pRzLF2/citLqFsAwN2QISh
	eWIEmaO6XoaA451oFYpuzXk6zjP6Rc2rCs4MsuCGxWt+eEPp9BuYpO8tt6hLPdZtiztQE4lpoKb
	oLMEnRPE2ZdIhqe1QWXdg79S3HmSjrVHaePiko8dvcpuFOudeMkNOmfMGUKCgnwVSrWcEis4mjB
	Ua54bW98swj8O8dFbVglgLdVTNd/rofeSRwKyKq+OPF8MA3tuyi1p0Tr8t/mnB4oHBEY/PVv6F/
	+XX8ORqkbK3sqp2U1I6pQBFOJROOktN/50FkalJ3iGq1pTX/lXk5uffQ3Ok4BVaDbKcZpurcfNR
	XPC1BLX5eJUMwnhU3BjnuPwSZwIPiQn/bFdH++S3GJ1Mbgvwb1I+i/NBzj1S/DwKA9rMa27lS7D
	oAljPA328ay0ByHRVQ9ShUkG87TgnZ50Y89UHQXX3UIzbQ
X-Google-Smtp-Source: AGHT+IHtktJVK1XDeqQwSAII8bPqSZeOj9G+2EJJX5Ej20zke2p/ReS6z8A85crs/C2GxQTMQp3S7g==
X-Received: by 2002:a05:600c:46cb:b0:477:7a78:3016 with SMTP id 5b1f17b1804b1-47a8f8a7f0fmr122138175e9.8.1765816723603;
        Mon, 15 Dec 2025 08:38:43 -0800 (PST)
Received: from fedora (cpezg-94-253-146-254-cbl.xnet.hr. [94.253.146.254])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm192209725e9.3.2025.12.15.08.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:38:43 -0800 (PST)
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
Subject: [PATCH v2 07/19] dt-bindings: serial: atmel,at91-usart: add microchip,lan9691-usart
Date: Mon, 15 Dec 2025 17:35:24 +0100
Message-ID: <20251215163820.1584926-7-robert.marko@sartura.hr>
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

Document Microchip LAN969x USART compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
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

