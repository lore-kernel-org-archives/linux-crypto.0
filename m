Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512F133A6E5
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033632; cv=none; b=TSWSX1rWQa6i3MF4SC35I8Y6jdKN4mX8ujKqr7I0F0VhSuYZ24VTA13XyIbaN4tqlEgoRW34gGc7fzWUGQxzdfOjCpMCnKDV4k0cWPXoxw5uBGpnGjhOBfVqH8ftDW2h6bD0iUquFv160yQQhJSevzqYwQLflI+OwTS9HvXFe2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033632; c=relaxed/simple;
	bh=7hKH5EzmH1tw2QTQXNXPEJl0sVHK/le/PcpUxmqe6fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7p+i/+ppnJehU3eB03RTPcl4oPQonsjEK41UFb0D0EGFQU+j12lF4zbtBCvSRg9bgG0UygdtrZiUQFqPBpGPKwvZU8WkW0aOlHjuNkc+FIXBMxpFK8oM1YHQm89PKkCr38O/+XB/qg9bC0HUyJFjyNVEhxGVAFgigkDYMEmfQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=u+C/t36R; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="u+C/t36R"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477632d9326so57773135e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033628; x=1767638428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MElNA+evLW3q9gh9PLqoqAuYhUoiUgxuy1qDVWGw3Ao=;
        b=u+C/t36RxL2h1deDF2NgdB+V/8PFIJNoVWYqFiBvqPNfeDhDg8nP4BHIkKa+gcW6Kz
         oZyl4BCY1ZY0UlTWbp3WqvUDh1jCR0nluG0nE8iXrs7pjzmjBbQHIbIPL+8dTif2iApy
         49ONVh5e7r1p1beaG0DMCImekdmaXwxCCIx94h6Iy5ESduLUfRYjQji8QXQDkAohfmk4
         FFH7obpel1rzxwvDQjHUy+5M6GtE/DPaAt1uTJE0l+zC7cPSxPsPuUtaftvHqc0L54Uw
         F9IFWNLp3CuSTGSt/Oey3Exa3OKO39cdnJXeJo/5uJiqKIWjp4l6/JJxmT9Pm8bsytkv
         193w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033628; x=1767638428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MElNA+evLW3q9gh9PLqoqAuYhUoiUgxuy1qDVWGw3Ao=;
        b=m/ZVriCZtVaYUmz4yCT4aoBrrzXSB5H/GO7IiGJVRSGxuVErzzhwmk1+EE7Uzcpr6q
         lXWjc9QMDGKXJdZVPdpOvkh/pK2Sxi848qA18nB1bBtcxALAa8mwx+BoUVzM4jKJ1dqf
         j1NxBW6vNpUYxTmchM8/kX6aDeQtmT3bxBFUDTCXdbO/odkhqgdjaXmc/bTn/CiyFedv
         uBMu679iFmnJKlh2xTHMEdFAhCuzSTcDaKQOOnZO0dTm2kDjSBsRQ2oFGuCMZhw4/lOj
         4NGWcnw/sdQtCLyXom+Htm9PkWqFTMdbtBh1QJuIX2LDiJutcJm15id3lYVttaqFxcFG
         3CTw==
X-Forwarded-Encrypted: i=1; AJvYcCXKAMunSyR45cFKtaxHAgG9xM2L+Guhd5cRUqhnzemu9bOVof1kUaCA0YiAAc8O/jZauVC5USr9tSKJn0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJi9a09fYYKsbFEnarstxObtxKvqX7h8NOqoUgo75sPLj6aQ+G
	5fcYcvIy99qJg0VrQWO7YiLvfx5R/oALqiRZskpRUx9wNx5TDqEmw2oxyqEvNiM/l9o=
X-Gm-Gg: AY/fxX4km87kFwRDESNQqDE2XG81ur8nkYHJ3H78pgh2wCfj8ME4tWnSZST1ZO3QAaq
	HqcscZ9gC1h8HVFE0+S+SEJ8pYHwz/0A2A0+VJJiid57tmzQ6jLO2sbEzbZu4NkhWsaQ+02itFM
	JKAMdfgNAIVmsHaM5KWDUi+rGPYCBKVy7dnlUxZT8p2UJgK+KCXTzSJEqn7Qb+lZ8TxNd15WCax
	mQX1p/LFdUJ/AjYbTG7wm/cmfR+Z3b9chzR3e0gIGqCleJRVarjbA39UMOBh6ouWA99uwNLkHOy
	VAq7qMAxbsbRLKPYs70+GrjJ0Jpv6Ed8yayXLzMJFawsNOcpaHjGzeWjDl1nMMVHhC/WckFSwDm
	9Ts4njxU6kLND3qLwT/I9uqGFUPi7hnAQn+cTJt66DGIwz1N2y0XzabO9jdnoZAq4XNOMAAeGlB
	PXqEX2hDNtOqgpCxYmIM4TNOnFg1oDE6fokNdBiMfUwfq5p8gQvjDCDpopenrVpC9mm0UbirioM
	nYCO9+ruYqd206ziBwyXtuNJndY
X-Google-Smtp-Source: AGHT+IFilbmrX7qgCmCad3pYK4YkE2820iFvJcnWl298VhAC/QPnRoMoqJ3XAnKO9WPGPH+NwyaEYQ==
X-Received: by 2002:a05:600c:468b:b0:477:b734:8c52 with SMTP id 5b1f17b1804b1-47d195670b9mr338260535e9.14.1767033628587;
        Mon, 29 Dec 2025 10:40:28 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:28 -0800 (PST)
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
Subject: [PATCH v4 08/15] dt-bindings: crypto: atmel,at91sam9g46-sha: add microchip,lan9691-sha
Date: Mon, 29 Dec 2025 19:37:49 +0100
Message-ID: <20251229184004.571837-9-robert.marko@sartura.hr>
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

Document Microchip LAN969x SHA compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

 .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml        | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
index 39e076b275b3..16704ff0dd7f 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
@@ -16,6 +16,7 @@ properties:
       - const: atmel,at91sam9g46-sha
       - items:
           - enum:
+              - microchip,lan9691-sha
               - microchip,sam9x7-sha
               - microchip,sama7d65-sha
           - const: atmel,at91sam9g46-sha
-- 
2.52.0

