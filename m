Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1111333BBA7
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033638; cv=none; b=daU609U/Ok+jXaUxIyebBbdDYQoc4/h9FKxS0N4rNj3B1VvdcEVCvgLh9Iq0fMMkI+y3Q9/sK5p7xnUx6NJwa/N3qP8ZrAf6JiaRTN5ztckP82ASnGm8vCxfv2Ud8nhiqMlwMHH59B8Zgejc9udLaWllcYwHtRNVK2QPCzl7DtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033638; c=relaxed/simple;
	bh=Q1obzpbb74AZt0ukfBT7/Xcte4bERP/uv0lOi/h0us8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6WP/2VowfyLdBxsL5xEtetv4KBOf4NCsHTw136kA9l1oXeF/NxUtJrjLGTeQHx3diexkgJ5/YlrhF6mYDkBH8B9zGdXi2wHdbPXfgVKg34Pt6jQFSpz3oNmS3sMb2dTwlz8jGKcMPJHfuZ5yx5MKy0eYj090QwfHGFHwu13KD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=LyRSbbrq; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="LyRSbbrq"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so71141265e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033634; x=1767638434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fD3TOo20gfVbUTTrRVEjhVDMuAvx6I5y/UndE2JGgIM=;
        b=LyRSbbrqhsYCVMar6TnbNq5OwUK6vM5vLOubw24DS+DHtGNV+bJd9Ws4YLFLcIaAk7
         HWPCtBIRseMv3/cnK5UmboWJt/jYxd0RuJWmcbt2Yc58+DpXPQwFcYmx5ERXgyz/VGnj
         V9qPrIkX8CwYabWmv/ku38VSqUqR3RGC4o789At+xV4gIlr9J+R+B5MA6mEnjByrB5D9
         6AGB6F9TcKy1iuVMGebdlKSCHbuE+vyg+Q01p4WIc/CbgEApewqay4CiCCRYEI2Eypo0
         a4p8Uo/of/KtQ63rWWRF9/G+a3GHxhBtDB30wW9cC//iynv4tt2gWEPfDR5IAzePQaxD
         wR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033634; x=1767638434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fD3TOo20gfVbUTTrRVEjhVDMuAvx6I5y/UndE2JGgIM=;
        b=Gkl0pyggINBG6hjpz39JbnxiUFupFL8tD5N41K/M04CyMO7wN1QyzrVHWrxnOGLGEK
         zx2wObfKxeJ9alMIZLbrTSXwlDL6dKxPFBx80aSVNDOoHmHvdQBmBLqKMy9S+g83hgVz
         wM6SJtcVkqPj0d3r/3Mit7tyre9DGNB+OoHDrAmAtxOmlI3IgkV44yf4lf5FjWOAL47k
         zdrrohciHBFxRQ17Kfl61mCDz8+6BQMWQzhNEz+TEW8L7KNfg/pD/7Sf0zwx+OSv2UN9
         BfMi4zL3yterugV8AaU/PPZl6ikgM3oGz1N42QYBhYLk6fW5tNGicKfKhTwC/r9g7MKE
         7LSA==
X-Forwarded-Encrypted: i=1; AJvYcCU9jzJnBESDzNZCnn8n33iATxBhEhNe5vmcKC+Pp4bhcX5wqSgIKplT1CsrtGf7slljBbwCcZt7+gXcxKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJGRYlbOk9KYBtkhzgk9xbvYBhyXKeCckWonMbYfGuqEqvSvG4
	LX5pvvPrvSnAdhKQA8PH+tFY7PHhJ59h3SCWlyscYo7nBwqyAfXes94oYUHajU9Jed0=
X-Gm-Gg: AY/fxX5jwgA3TfPxmwqe2Bf29OO00u5wXUcfxPsGsPjBwV5Cx6bGPHueHwunbl4pJza
	CSecWOg9+atExbvoQWTmb2UI7c5CBH1PQFXB4follEcQ1NuVsNkyZvRL4Lu2mCte4UAYM5IT7Uj
	md4hM0j6sf9UU7JQ66jiuJk+p5SJBScZ4SWAMKXo9k14uq7fpLI13Cp32Grml3TNZ45AXr+XnuX
	/dNIoiXcvOFgrXL2si0pS7NCaBctfXY91h7r8hWLqiGoy/TR7xU+u7WidGKi/CDgV9sqCq4CPwy
	8Rz+s0ZeyNabSAl34fkC5lZAtLC65V2jMzx87Ejbu/BS0nEAaWPisBPPbE1eTGevY5VEJMoW7eA
	rfVFwKa65+rRpgXWKekJ3M/SjQIRjSgGcQVtNkKwqj9JQtnPEyd3MH64xcGiADO6U9LF9o2y0df
	y1pMi/WNnWak124LElnyslQG9bY2ME/iUW0AhbwyxHQIkL3iw4ns/vdPJiu4vY4JHRg4gtmagUx
	nZAlsRdKolw3vW2iCGNVar7fggl
X-Google-Smtp-Source: AGHT+IEOW1WMqA9XyyxJdu/NN+RbiiVAdkX9+5SQ+X2Sm6Ndg4Ati/iuxawV+Wvcj48RXpcfvKGVGw==
X-Received: by 2002:a05:600c:c115:b0:47d:3ead:7439 with SMTP id 5b1f17b1804b1-47d3ead7574mr139091495e9.37.1767033634253;
        Mon, 29 Dec 2025 10:40:34 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:33 -0800 (PST)
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
Subject: [PATCH v4 11/15] dt-bindings: pinctrl: pinctrl-microchip-sgpio: add LAN969x
Date: Mon, 29 Dec 2025 19:37:52 +0100
Message-ID: <20251229184004.571837-12-robert.marko@sartura.hr>
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

Document LAN969x compatibles for SGPIO.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

 .../pinctrl/microchip,sparx5-sgpio.yaml       | 20 ++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml b/Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml
index fa47732d7cef..9fbbafcdc063 100644
--- a/Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/microchip,sparx5-sgpio.yaml
@@ -21,10 +21,15 @@ properties:
     pattern: '^gpio@[0-9a-f]+$'
 
   compatible:
-    enum:
-      - microchip,sparx5-sgpio
-      - mscc,ocelot-sgpio
-      - mscc,luton-sgpio
+    oneOf:
+      - enum:
+          - microchip,sparx5-sgpio
+          - mscc,ocelot-sgpio
+          - mscc,luton-sgpio
+      - items:
+          - enum:
+              - microchip,lan9691-sgpio
+          - const: microchip,sparx5-sgpio
 
   '#address-cells':
     const: 1
@@ -80,7 +85,12 @@ patternProperties:
     type: object
     properties:
       compatible:
-        const: microchip,sparx5-sgpio-bank
+        oneOf:
+          - items:
+              - enum:
+                  - microchip,lan9691-sgpio-bank
+              - const: microchip,sparx5-sgpio-bank
+          - const: microchip,sparx5-sgpio-bank
 
       reg:
         description: |
-- 
2.52.0

