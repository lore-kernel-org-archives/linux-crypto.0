Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6013358CC
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033621; cv=none; b=IbiNu9lzcv4iPic1gPimR4cjN4SGjVDIo6lT4IuEpJQhVCm7DTiNCT5YTAQ0f52aCHJsQk1Ryhh/t5ycvywrfSpdvr9xfPrd63BEaQPTwUU5s+1oCR0tzFm06See1D/SobQOebAR7pLqqAcrdqmiLaiUDp5tC+iEObc2AlLbml4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033621; c=relaxed/simple;
	bh=lnkhvIt3TrOEyzf6TQ1BG1hfakQAvNrAup7QLQoickg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1ZrAvitOCbMYqgKITm/KDXOS8kzDopnKYFAWKlxMFNCUFCXl6E6J3WnTMGK3VcaF8zCZjkpp4ECcIp3Y1vutuO6JJhlLE9Jmup5ldTdX/+L08mpNk9h3DyJBRVlw7NtDE2dSEgvnYdmoDx73NJvLkaA61XSvDteM66guuMOppI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=EtboB3HH; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="EtboB3HH"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so68341995e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033617; x=1767638417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=akmDQhsi4smXKOu+AQ0134jZY6Y2uyR0jebUNjrF2nI=;
        b=EtboB3HHe08w0XqyvQc3lIhAD3Wrb3A+jSxyRDBnGZHNNGsDYTpopftjz07wgCqGTg
         wVeB0SBg0sYtcFqQU94CuwWFrINZ8JOPcHYxaQ6Eqrk7RF9dttwfVjkFrtKvAte42QKe
         r+FYs+x/gVWoMwshb1deUAAslnK41Cwlqc6VYn9NzC9sJc0HbsKoDjg1tHFyEjsIuV1E
         ATaaF/DfSISmFUI6qUXqycxRqvEHQLBI94pKcPYVDNRLhHS4veRqPGH7ev44aJH8hGtb
         2pYEvIocOndgsPPLrTFgpsyOh5/kaYmScXGx3p7T8JaO6Sc3tDW4z8sPJigQKU51gN30
         qWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033617; x=1767638417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=akmDQhsi4smXKOu+AQ0134jZY6Y2uyR0jebUNjrF2nI=;
        b=TtaDqBk3JIX74Q13TfdSM1r8wG8cAXzxU9sVoi4jfUY3qFaVxDsNFzNLkMO8xPosj9
         qGkwGcoLd84clrgKvE8dV9y26xg3N1VkjG5LRDnALe2v3apsdqtD0t5cijv1PZDm+Vs7
         aumSvCkaM3smgNDykTtjtIzwPLg3FS5VQ5K+Ij8yyWA8rn/FG1TcbXUq6JeY+51apLqF
         +hORBo3PT7ZpLjIiBJCKlhG4rsEKNiTiDFEKaiBk5rsFEJyLCNjhRz9s1OJ3fGIV/9Iq
         yRDOMoVmjQd8k2e3bLegrr8IOKMIR08JQj1u6t2ca0lWsCZtCwtVI8IKjwXM3JcNlc2M
         VxSw==
X-Forwarded-Encrypted: i=1; AJvYcCXmWN6oQlav3YhBv+Wq4VfBzpkL9hp+mYChlyPUEevgO1c94UglEgMeahPNLV3FS+PFuNU1N1XUc9G8I90=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy33DARutmMa6u9qXHpFxymeLSzavYaAIRMzoO2Ktvpe0lvmEUq
	QJzCD1QYkF05EjM4/Klxs+dq5I8ZH6uJhaaXJ4xW796Pd3wJ3/00GbnRvwIXBK2Rtms=
X-Gm-Gg: AY/fxX7kQktw1bSJejIl6ZuyCUk/qg1qVMDvtlFsbQ/BPdeEJ1T+OGPHpg3DC7RZdCG
	K0tWn5A/rWW7+C1pG9lNY3NsV2/g1sb9dWNYP+GMIxLFPGhPNQhjZcMBksTOeW4kh4wA/rvPWtp
	8hyYpAojZjWOJpDZd2NeANvHfIAgqOveO5WdcMV7RZLFyhwZ583dw9j6+DiQ9+eOTMnsCcsQ5pt
	vmTqWVMx+iJa3K0JoHhWm2VCrYuU8uE0tiQsMOTldNSnQzP0HtezYZbpk3ab8InvvWzgOAj/iI1
	Amt+O3Wuu3Cg41aDQLsCA9nvORF9CNW+D/ldT3O+WV3enR+Xcl3gW1LtezYbrcFzRHPSXr1Y9ne
	4C6XiO1BAHR5iirQCnDSh9JQqxvLFRN1O0NYaCE4hGZbAqU3IBVeaVp40BKvuGh/sYsU3+eTWrL
	E/+jnkTdo/CiDyuk1on66TCmW0mf3Ge+2xj11csWFwFIAX7CCZyjglxdkyna0nlXFXn02B0pdpq
	gD7mxWfteHtPYKTslMJ8H7ob8DtZuECpLiWel4=
X-Google-Smtp-Source: AGHT+IGjzQS21rGuoSBITpTDpuhXFeVyR+ePrw+9us1bVyog91e0BDAjrgenQhgGZwBix2fL5K0wjw==
X-Received: by 2002:a05:600c:1d0a:b0:477:79c7:8994 with SMTP id 5b1f17b1804b1-47d1959f72amr367970555e9.30.1767033617043;
        Mon, 29 Dec 2025 10:40:17 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:16 -0800 (PST)
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
Subject: [PATCH v4 02/15] dt-bindings: mfd: atmel,sama5d2-flexcom: add microchip,lan9691-flexcom
Date: Mon, 29 Dec 2025 19:37:43 +0100
Message-ID: <20251229184004.571837-3-robert.marko@sartura.hr>
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

Add binding documentation for Microchip LAN969x.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

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

