Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDABF332EC1
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816727; cv=none; b=aEnTpaLkVlOSZQAAuxstSSVZmgyAvHOizHHesS8hDtoSpQkqAiCTHcZUiYu7PBDOPlqJ5ufyro0GR2MCXIrGCEJ+un1BQJfcj9fPQY3lLv1L1QoLCP5ZY0M42vKJ23UsrTujxjqldVVjHaCo7hW5YXJaw/4kAUMzPMXIEiS3Y60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816727; c=relaxed/simple;
	bh=Wi9AS/Q9Z9rJWlYN+9bptQ35O1l7qMfPD8Nl+Hhabzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWW0Plp+DMTH5O4Hf151ueo06nbySYFbnmqZmIGyzLrQIawvZVYfAAHCXddytaNHxLkkoNXh8+zy7wIPdez8rWGcMYLgmK5lx6Lkk+qXb95ud1Y/mc9suV9v00dIuMMEsirrk4Qq7MIf5dVehMnwOVQCQ8iaqKXfTTqLVMyTFd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=mh3bUpSK; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="mh3bUpSK"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47118259fd8so37293145e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 08:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765816721; x=1766421521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dr/KALHxcw299I9hw1j3lrM8oXcQDyuqwKf9keXmbo=;
        b=mh3bUpSKu6JlE2ZCje7XOGuaHUYeu2cxxu+IFs9v1wVAGHi8paQTpFs9+NH5OVCp0N
         IaP1HdtWkevWI5zyVvTj1IT/ssgm7NUeftrGx6xtKwNhtFX3HeSnE2DO8hvKzvkvMeqK
         bZbhFfk/QeR0QJG8UnZ8noCrwYcXUu0soBEQ/4uABPC2yg0ey0hv1kKgLI3f4Li5fb48
         R22A9VIhPq666CCEvipUWez6Zxxu01uB+fdRWpn7Ka1i/uiypH1W0PqYYEw8+Rl34yz2
         JtFz/ipWF9b1RitIgLBKMqQMVUoZyjMQPSiOhcuTPsd90t1A2ohaklznD+C81YD7CK2a
         4eQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816721; x=1766421521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2dr/KALHxcw299I9hw1j3lrM8oXcQDyuqwKf9keXmbo=;
        b=KTI7OBQlh7NudDPGpgGnB4CFR28gBShLvHfWAi/Ocg7BW9leSQPsTqkd5cxMnCtt+X
         1dVKEMPWT16862HoxOyDij5JBRxqU92raR2ljbtklHYPx4rTG3DEXYOlAwb1CfquljQl
         MBBzOLKQfD45SIB6wchFQ5rEduwEI0EEt5RU+vokO/5ZQIMwvUXGzt7Qtplz8slbpRYS
         eZk/8lF1Zt2/gEjglnrxRt4zWTyP/7ZQK6L6OgHBoHeOakpLiXlTO2Sho/78FQo+J6QZ
         GLvRJ/BmcIxNL3VwZoECbE10QowE+gdgXOoAim/Cshqc3qaT+9EDk7OZEdnKOexK230L
         Pf8A==
X-Forwarded-Encrypted: i=1; AJvYcCUw4dBDYEzkRzxn2QXJTXeH+b/IaWldBBbyGEzRjcO+uGRQZjTALkVx+jJjf0NAdLKEmYHv60psVbiva9M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG9U8Wy7Odi9fMSHk9NUcDJDqO4Ox20+56QjwfUSQTiRQjsih8
	TuwTcOYYd6BqETwU7NeREjw6XmdvOr9lWm9unXg3X5O+4/4HIZACASwBraho8Ltk+8Y=
X-Gm-Gg: AY/fxX6wMQyCtwiebmit7qJT7qGgZntC/idhmOfXgh4T3x81MaIYwSFAj4Iz30gZxx5
	FSSnUDYdqQy11E7WhI3IDQt61ICzPaQuFX5Clz7KaC1drCLII8erWUhbQ3IuCznukR9fzQ5aKOB
	sW5BP4Rj2BEoZjYiHvkg5BiibsfCbPaEhB4oa1sfFNh2K9F8OKI8kvKiZSkwakwEwKo4BsvosKp
	//1NsCtvkJMgk8BWBC3SfUnjRpk/ZryusT3XxOBGPtogHCP8p2Tq59yHsnhwafxbp0279XJXqrT
	A2EZxG2dyn2f0P4dH4zKJLHM1s7o+eW4+hPb9HKkj4JiZMzOLAffvCZvQLuXBMe9hp8BRto+Ypx
	Bv38mLuCAZgWwpqIirDyLCJw1TQQ8P6wg8nSs4pcpDXOKs+qY7BEd3Gep4itsnegHjOWbdLmCmt
	xHYvVd2dygc87dUTT07h8cb1mWDt0jf9MspcECI4LrJuWz
X-Google-Smtp-Source: AGHT+IHVHrhWHHd5t7v+NK+1xDZQB9RPKOfbhSwk160Kp7+0yxWrCigeVebl1Gn8PfXk1Ze7IDyXTw==
X-Received: by 2002:a05:600c:64c5:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47a8f915607mr114002895e9.32.1765816721213;
        Mon, 15 Dec 2025 08:38:41 -0800 (PST)
Received: from fedora (cpezg-94-253-146-254-cbl.xnet.hr. [94.253.146.254])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm192209725e9.3.2025.12.15.08.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:38:40 -0800 (PST)
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
Subject: [PATCH v2 06/19] dt-bindings: mfd: atmel,sama5d2-flexcom: add microchip,lan9691-flexcom
Date: Mon, 15 Dec 2025 17:35:23 +0100
Message-ID: <20251215163820.1584926-6-robert.marko@sartura.hr>
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

Add binding documentation for Microchip LAN969x.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml b/Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml
index c7d6cf96796c..5e5dec2f6564 100644
--- a/Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml
+++ b/Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml
@@ -20,6 +20,7 @@ properties:
       - const: atmel,sama5d2-flexcom
       - items:
           - enum:
+              - microchip,lan9691-flexcom
               - microchip,sam9x7-flexcom
               - microchip,sama7d65-flexcom
               - microchip,sama7g5-flexcom
-- 
2.52.0

