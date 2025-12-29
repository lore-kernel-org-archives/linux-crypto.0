Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB153385B8
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033627; cv=none; b=S/+R75hnuCdNKMJSJpsqGodS1I6GBmEUGY4I6akUaPpBWqGJh+ZZp4NUZdblCKdyN07q3RdYACafzDt88mTpkkyOhtN3yyFq97YpltKMnEv56bGVf5360fzC+WPLpgej3wWXbKhw2sVjY3xaIw6gER7O9mq8Wc1zui/2HcKUmOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033627; c=relaxed/simple;
	bh=Y4t8u2qiojJWvI6jSs6aku7/F91jF6sH7EKzFpxgIB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOB+NbieOS1EXpIoyj8SrmjQ2T/jaPhyaTLUQMDfZX91XQN7jMeyk217kjYjn1sjqmE3IldyEHGRpnYclTMUH55h7jvw8bFMgbXXRkXzfxgPvglDpspIZ5tyobkYCr2WtzcLOd1cJQvzyoedV9dCmCBJVEhoFItlVR6pIdN1Ag8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=DTGNbyn1; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="DTGNbyn1"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47774d3536dso74514635e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033623; x=1767638423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSHOwUHbn+hH9B++ik+7Uc56KzBi+PoNlqJWxebInus=;
        b=DTGNbyn1RSBQrO0sxPeaM9ygJowJFoE/5rjCT21ixYEfmXuifBUDxBFEdbW710F9r7
         BzGQ0ds/Z99A+mHYr9XZSfY1ZqWHUgMzKIKU42UbJHATo25po45+0UrhGJrNOdvu+FnN
         zHyjWWkiPuJl4Zb15uDtY7Nb9KIuYtpsGspxS9NbgSXVoWgTKBsb/jNYe31Ezz30gGsi
         I6pb/O4Q6dGSnlbH6PsJJhy1rYr8KKVRjxy/T3M3BSyE9xpciJlHvWpQI353EV+Dzisk
         YHPNIBv5qfw8Bx18a9eXJf79fy5nyXJyYv+zmS3RcfsH+ZVIgaAexO6xlnIVT2cEXaM2
         rBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033623; x=1767638423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oSHOwUHbn+hH9B++ik+7Uc56KzBi+PoNlqJWxebInus=;
        b=sfvFRqR4u3x+oLQVqre+TF0wNqYuwA8Fl5z4tvs1QKqH/ZL5zFz89WvTvRp0llA+7F
         kZqCv/LQ3kAb+Hx5PA5i8m7DUJsgwFN4gw3YUur9eTE5+0P3Dqpda0Qpf2O1ZMlf8Zuu
         1crqSXOTgTeyjPLd71R4I2/GCWBhmn4YqfjEXa/2T4AxJaILqmvLlKSZSf3qFMoqkdTN
         Vf7hU/X/1iZhA+2ffgWETiZd1c6YV+vmOycrcRb7jAL7ueD/atxaJ24Y4ao7wcI9sndB
         Mixv+OdYOkTUfreT8/KzUyUb05yW9059jtySXwyhM3YgGyS7eqGdBgpv1do9Hiulq+zJ
         zmww==
X-Forwarded-Encrypted: i=1; AJvYcCXoCQgLPdFJXMVHg2ZB+Ezl254Z67OtkhyMssn87eYjG69lW6/3kOmLLN0zNvWy0wSnbygbLYD8vFXzxQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGKDxpErl41g+TQdOuk8GZElBt9iVKk7zG6NVxRsNIGzfoQVgt
	B106w+kaNxNqnl+g0iS4T0YQ8vNiBFxyZCeCPT3yn1ArsMs3qeCKKdl7uHWTDB+V1uk=
X-Gm-Gg: AY/fxX5jvkOjO9r9b6iBE45Zc14HvnkF3zLxj/xizhxb9LGHFl+XeswAu/YDSrNRfaW
	FZ0/phWtlPJ2elTb3W4sdza8optrjnAt57zPHi+qXbRq3A5lDHABgaU9P4cuZtf9oNVem25CWN+
	CjOrgYV/4mIjDeQKu1NjFLHqY8nlXhOpo3ZttWxWFZffWIJajg+v83AR7vs6Ol+DCAlrDqgOs4e
	8xojzq7F5QNXDXhe5po3/f7yUKDcNbmYdyae+EIDyb0GDnhSSVDRnbDEa5CWj3G2RSeQvIYOmV0
	8zYA1tlCYnc3kJru8gT6tZdo9ngxmhmkESO63/HAk9UegKXjhorqLabrWR5lnKjqqY6zXs/lmAM
	86k6ao9K70TJMkUCLaGOBvP1EFWE1sKrL4Nk0efVHd44j1ItMvu1ALDfv1tc39uYd7o1FJ/oz0q
	Qivx2lKcsEp5Uv6xwk4pN88wH2SHaX29TgmxK5EesF6ZTaykN8cCOhWFbiRQi35sUnBTREEy2Vt
	kAg3iuI1hv7JcaFexEKi38lfPYAfRH9bqDhx8g=
X-Google-Smtp-Source: AGHT+IFdXHJQRkzLbrbudz/rrSLgg0wPVHDz1vodIiRpC++haL2go1AcyrpRC3xryHs5U31bxn6MLw==
X-Received: by 2002:a05:600c:6749:b0:471:665:e688 with SMTP id 5b1f17b1804b1-47d18be89d5mr452022195e9.17.1767033622859;
        Mon, 29 Dec 2025 10:40:22 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:22 -0800 (PST)
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
Subject: [PATCH v4 05/15] dt-bindings: i2c: atmel,at91sam: add microchip,lan9691-i2c
Date: Mon, 29 Dec 2025 19:37:46 +0100
Message-ID: <20251229184004.571837-6-robert.marko@sartura.hr>
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

Document Microchip LAN969x I2C compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Andi Shyti <andi.shyti@kernel.org>
---
Changes in v4:
* Pick Acked-by from Andi

Changes in v3:
* Pick Acked-by from Conor

 Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
index e61cdb5b16ef..c83674c3183b 100644
--- a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
@@ -26,6 +26,7 @@ properties:
               - microchip,sam9x60-i2c
       - items:
           - enum:
+              - microchip,lan9691-i2c
               - microchip,sama7d65-i2c
               - microchip,sama7g5-i2c
               - microchip,sam9x7-i2c
-- 
2.52.0

