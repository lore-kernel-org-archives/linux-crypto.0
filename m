Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4670237B41D
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477264; cv=none; b=Ctf7t0xB6nmWMFaNGso28AP/exzRWIsICnsMJwKa6Tvy3PY6gVFNU7zuwztfVQHKQCW9mBxPMZhWYY6fDMEm2bMSICppWpx8UEt6GhODq8iy9CWQ0rUnBRcYSEBl1eI3QvUVkGum2h6MZzGphH7EwtKORvNoO9DGv4mVqI77B+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477264; c=relaxed/simple;
	bh=duZt8ClU+VlM+r6OEAYG4uNskSnrTgaQSTmGeRNkhp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkpfOFS+j1BSanMS62KjdUQLWkJPyS4KZ81XwWPpgCgLjm8nvSYpoqjr7AR5vUyiJwExrxyqe45Fzr0R418UaSYASwXhEQ5ppVCtAAU/spNmS2o+GmVfqJSh4jOtCJ3VGGxC5/QYGfFaTokC+2BqpV7gCdLZtpwrlrbzlwXBH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=nKo4jwJp; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="nKo4jwJp"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-121a0bcd376so2134717c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 03:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768477262; x=1769082062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYThfrCqrT00LXV0OTAO8hRxDqFU2JdJDLnv+fTCySs=;
        b=nKo4jwJpMnc4Vk0Ox8Q6P8HgOkyIt7RA3SGsOkDD/t/5UYaonkGKrfEOmFfvso2+y/
         Ddn+Z4sVa4c2JpWnMSgyX9reJAkW/cGFScBU8vOjaivnM037CYI8EBlQzhc+Qtzi86iJ
         UNljlu4EIFyalv9hFGxHJmEO2WbSkxMU0kdKyffPzcUdAplNOWmSp59ancih/1AqtHzC
         OOE1V9SXAU0rOCvTnhNxGRVkZ6fIhOYp+C4Yg9iT0DkyZrvpnwRC5vS3iGCoMygMW7ev
         jq2QTwA3WiPq41HEAZOZk0J5z0vlNzB4V2+oHt9iISFciWMdNkunGhmHovIHc80BP3Ue
         ZaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477262; x=1769082062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cYThfrCqrT00LXV0OTAO8hRxDqFU2JdJDLnv+fTCySs=;
        b=INLgI0Ok8Om0rH26g1gDOcoO12d4CigkDFzSgX3GNU+0H72nxCgBTL5luH5m1mCUR8
         0Pvedqp18GBDTb1QBKIS77SEVgYbWJyxYxyhvqh6lyAhQ+4OZtQUaQ5yYdtrzGKiJ+Mu
         oZz0T0LGdgLdGrv+lqP6jr0OUGS3hCzaLwrx/0SpCDXW00vTpIA9WXlLyEWY2e1CPOJw
         NOmjlMFS3F2BfXVgvAlQgHsSg2oT6GV9qXBXU9gDsJxHuaOMi8ytAqKDHHx17Ypf7gyL
         NbjWzGZ9EmQDuzKinQrmjrqTJ76X/hS1cpRgsOanv5jTRN+a1co5XSCgwaMvkNtIFdj2
         lSpw==
X-Forwarded-Encrypted: i=1; AJvYcCWDyPgcGBISyA4t1STfJvFUc4qXixl7pFWsXJNDHFvbINmtBufSYjH54A+pNZXTVULbtYeX0Um1jb2B8Tk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo/KjFlsv6i5gD95j9vM1b12PhLCPGDxVZrGVmettdoltqJfQl
	CaxQjpVpInBi7q8kuGosnG0fUMP6FKFpdd7ManhA3HQClDTVRIUUUwD/w8OxP+IOJCk=
X-Gm-Gg: AY/fxX65nGruincos06W2/424GhvkjDQGF3KnVCy/UazcV8C5RfDIwKaIx3nUY6Oeej
	8o6dWzgifEsFz0P93xezPNIJF0iDxOsC7h1Sehu435nJ/SMyBeGSOX/Yh+PVO93Mg+rUf68oo6l
	7wvZRkqaCwx1oqvA+6SXfz6TCoh8KjG+xPSFROdOSQu8Wm6qxM2knkkhdhZ0+1WfLeImYe4Jhr0
	eZKOtJ2W+swIpbMBxwkWsZAOHyoV5pIgru+B9Qpp5BsH48gvuu4rlMaVh7fYoIOfAlpalcicavx
	AZ9LwlJXdk3Awg0VbIIxaZX4mC4V7n6fhcabtg3qTDIHDUXgrvXWLH4dxX/zBL8DGNbzVDTiV8S
	ogUkHjYD+hAvBYfE4lVMgU86uWK3BE0Y5ZCSSg4Uj+nXk1ot9SshhkTTgKAgbiYpRkFkc1zuDZX
	Wgea4EtTrSI6rJvRQev7kBgaIWrcKn6K7cWKsy8jtAVBevAXsui0jx12UErL4BBOiLa2jLiEwZH
	3VOcTRo
X-Received: by 2002:a05:7022:1101:b0:11e:353:57b0 with SMTP id a92af1059eb24-12336aabde5mr4547440c88.50.1768477262077;
        Thu, 15 Jan 2026 03:41:02 -0800 (PST)
Received: from fedora (dh207-14-52.xnet.hr. [88.207.14.52])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-123370a051esm4875347c88.15.2026.01.15.03.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:41:01 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	linusw@kernel.org,
	olivia@selenic.com,
	richard.genoud@bootlin.com,
	radu_nicolae.pirea@upb.ro,
	gregkh@linuxfoundation.org,
	richardcochran@gmail.com,
	horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com,
	tudor.ambarus@linaro.org,
	kavyasree.kotagiri@microchip.com,
	lars.povlsen@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v5 03/11] dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng
Date: Thu, 15 Jan 2026 12:37:28 +0100
Message-ID: <20260115114021.111324-4-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115114021.111324-1-robert.marko@sartura.hr>
References: <20260115114021.111324-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document Microchip LAN969X TRNG compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v5:
* Pick Reviewed-by from Claudiu

Changes in v3:
* Pick Acked-by from Conor

 Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
index f78614100ea8..3628251b8c51 100644
--- a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
@@ -19,6 +19,7 @@ properties:
           - microchip,sam9x60-trng
       - items:
           - enum:
+              - microchip,lan9691-trng
               - microchip,sama7g5-trng
           - const: atmel,at91sam9g45-trng
       - items:
-- 
2.52.0

