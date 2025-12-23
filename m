Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1A834CFD3
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 20:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521209; cv=none; b=V6KFELRdVEp4+Wle2UuOsBJNbjeiw4Su4AC2mKpMosldFu8zUo1f7S6b7gMukEATDpg76gIEFhLaQFsH5LMu+GHMG2FMACbNNxu8H1PRJw3lrrYKu7VqEHESSAtF0KzDH17eTIcKDGPAaqg0Fz4JCKRZeBQyAb1l7KRf08QV+iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521209; c=relaxed/simple;
	bh=lnkhvIt3TrOEyzf6TQ1BG1hfakQAvNrAup7QLQoickg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cl4E2iGokw+aRB+pKcKwibew+z2vxJT+JHXbjxaAmmDCjihIgPJozPgn/9al6z87W6PU8kKFDp60+LaD08H0i7hyel2zH6HRGbU0sSs+I4pouxy8YL5gNPaI4x0tXIVMKa40NQYj80xdgwlrcTqnjchxjuhzHfajB3vgFt6Cyo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=UajBDKTY; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="UajBDKTY"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7b9387df58cso8586520b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 12:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766521206; x=1767126006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=akmDQhsi4smXKOu+AQ0134jZY6Y2uyR0jebUNjrF2nI=;
        b=UajBDKTYlKcruvSkRnlFr8tjHgo7vqKYdeF6g6i2LgrtBlAxi/x6/j2FzFA7aa8IFJ
         zCbk+kIU9UJjaY8OIT95qG20Y9itoXB0IHgRnrBEMTEvoYeZOBFiUZ+FDnpmRXib51JM
         VlieXBhkKajYtWxLUzmgiSHsdXHz3zT/Iqy7FF7c8goVaCwQ7p9fsGuBegWYWqK+Jb8n
         9jJK6EEPqAU5wS6uLrfhFlUXf2YYvHGfb6tTbrFyqsIqLuSPy6BdmhvfuxR/0v/GvHPn
         PnUCBlucC/3gAqVgR3ks06eKS/hQ6am0E1QuYjf8Chz+G9uMrPAlcGrBGz7oOlpk1iTI
         ZzLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521206; x=1767126006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=akmDQhsi4smXKOu+AQ0134jZY6Y2uyR0jebUNjrF2nI=;
        b=Zfup9in0IA6K0VkJ5CGbvb1YdGU/r0y2+C13+qw0DbAiM/Bo2/phnDyKmFfOdxIyRM
         YpPgVRbOdBjq165kXSWlzMTxTT9Ljy7zy/ZAlndFqyf5fQiL7kk12Ols631uUypT2kZP
         C9AxmlVF1rR4gx6R72hcThNBS+A+oNK3OKWEywhyriQ57n/1iDOYzb3Yh1zgMD0IGHdQ
         qfa6Cf14g4asTOwiBqn9kGqbkefhZ8vZ0jMUSxAp+3UGVBt4K5nr7KbhdNLSDSBwXX9C
         zvKL62Jz9AdHZjx9A1jOCmIGEHk8I2ke2X73bkIhv4519UZO2Tanh44JFiFT3G7KuJOf
         654Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2Zp5QZ0aILZD1Xdswxvzxwu/bcayC6seacAJbRYV2OyeuqObWW2mnKpogO5SWCRKEK3EsxpJt2QryOT0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxAdiPqrSixeBmsInOzBQB4HbcHSbgYn8SSHYQeUTeLNqcBE8a
	Gz72rNW9dLnRtpoGvLCY5qXJkKiOXnHmUPG8xu8NH95abF5q9O/mZLe1Ocj/q8KuG90=
X-Gm-Gg: AY/fxX6oR/+KdOm89/JEu5be3muhNq1xXKSsq7cmt/oFDdqxDFgPMmH7fFn1K0FoBsU
	82Bu1jH4GkTwch0W9B5r6hKYzwd49elvpqEuN9oIrlpOwEroRJV9tWpTssQ5XLHe1toZqTtLW9F
	y7awsJS9WRVRP1ekyIDWdUFkdjmz1F7bx/XDu7tMSOoo7qhxMCILW6oibNpqgt5k07g8bz1ztM7
	nrXdvWiFXX1JjgcBMVRTRVqbYb/PtOtUqOZ3vUasiC7V67Ow4vApYFxO7Cx0hrotLeSin0jwp1E
	CcPj+CmkwHp7OEej48Y6jlJVZc9nnSjdIWSjZAhEgFR85ywcqD5L5SvUjubcN3E10lUowQ6kAg6
	t10iWJBNrLJLinViVs/tcsUhH9PrBOiwx8X0AITsCDxJXNobYbprHfS9a7371AmjX6Lnt4tuz9Q
	0srjQsLnUdk1w3uGQNLgTtUk75hgjc9f6LJpky8KMThu3xqG9VRrLG1UXB9PUzF8VNutMLOX+Pu
	/x99ZxF
X-Google-Smtp-Source: AGHT+IEAtWdhcWPCbENBvZFgr3c7IxJWeT0r5R2X+lgPN+f3cgKBnmk37uhjXoH7niVY6cpG/hJphA==
X-Received: by 2002:a05:6a20:9146:b0:34e:959d:e144 with SMTP id adf61e73a8af0-376aabf97b6mr15698314637.54.1766521205797;
        Tue, 23 Dec 2025 12:20:05 -0800 (PST)
Received: from fedora (dh207-15-53.xnet.hr. [88.207.15.53])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1e7cbfa619sm12567549a12.36.2025.12.23.12.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:20:05 -0800 (PST)
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
Subject: [PATCH v3 03/15] dt-bindings: mfd: atmel,sama5d2-flexcom: add microchip,lan9691-flexcom
Date: Tue, 23 Dec 2025 21:16:14 +0100
Message-ID: <20251223201921.1332786-4-robert.marko@sartura.hr>
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

