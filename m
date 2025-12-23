Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA063570A1
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 20:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521290; cv=none; b=MBrsgxsVjBq2Xe3eONindABA/O7+ISjGSXgCmq40xM8iwK5u2ZRRgD9YA84Qi116/+uCEzpyU1kmPITytZl6G3MzPX2UwaNki4wgg/G159zhRCn94HghQjt2a9XaoB+fesNUrzIc3teFufu8/H3+foUlD6kaVz3A68ZUjQrzK8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521290; c=relaxed/simple;
	bh=Q1obzpbb74AZt0ukfBT7/Xcte4bERP/uv0lOi/h0us8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixlFSzOmDXPI571CrLoKatWPm7s0DljkaAByw1S7T1+pgcrKXFQjwzQDGp/BeOvkwjTPac1mFBaKFuHXEZj7INEhoU9yy2LpzgMR6mP7h8rFqvq/jNdmT7d6IwA/6V1s95OVq/buMU6Sz6VHtOemswD4Ns0Y2eCcNpIQaceLO58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=vAEdXO3r; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="vAEdXO3r"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so5324532b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 12:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766521286; x=1767126086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fD3TOo20gfVbUTTrRVEjhVDMuAvx6I5y/UndE2JGgIM=;
        b=vAEdXO3ra/1bm20X8T+iXv1DGUZqKx6guXdgGYlEe09deRwfl5bXIa86Eb9PSV+d1g
         89yhFC4l5+p3HDHL9B4t3HraCiFP2Abre+g5OOymalREUL4ViCVjaMatLcQOi73KgoaO
         su9Z87NmLUKhMW1Z4N3LrDbyJ/2M/2Y3Ff4tCAv8WODcWixujph097B2TZm09bAiaL+z
         5RusNCbtacBZhsJzqltsEvBQ/ROehlt9LNDXxG8a0iqZnYUEOZo/smkMaGNsonZqVIvW
         oB5htBh9H/x4y6/cNqzQFEF9xiV9o1T5FsZ+snE4miTlvCzGO78Af/4SYd4c74sDMOq0
         AwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521286; x=1767126086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fD3TOo20gfVbUTTrRVEjhVDMuAvx6I5y/UndE2JGgIM=;
        b=Jjg1JViR36EMVymo/6NsnW8khAUQRlnj5mmvRIaNeMjIU9OtIqb4C9eOU3j3jggWj2
         R1todmF81aV39FrONyKA7LbXS+On6PjPAfC9adKj+scqD4ZQW5I4cD/DgSsjzLzXLnhB
         LFhVKZJGm6VEH0bDAAMikkUa/Eu7xP32UY6lrOavvz0hKtKYKU/b4wyEjkjcTZISXZCc
         DRKGQ8xo/9aUCslR8sV9ZB+04ahoi/s7Scf7NptnHITWT+cVh+vgdfFY0s1TSU8wuFZk
         bRecF6Wh5DfNn2xY9hs2h47jH5EfjRU3684ERRGNKPHLnpjxyjrcfN4BHu8mX1dcScxM
         i/lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH3ihlpk93rDk8Rn0E5W2TMxyuVBSDPJkR0ojYJ6zs0eX19TuiCwkjgC7nwMmNKAH8gtf1DRF+ny9HIMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsiUa3tX+EMp3nlo6dv+taeX0vfX7LvWkEVuNkp0+irLWImimh
	rScLp20qX8zFJvlBRUjcKSk2UZmPQ4C/uhuwf2vrA1yBBwkLpZ/FtWly69gGltGtwPI=
X-Gm-Gg: AY/fxX58dc5jERgr4s1uvYVEzctxQprjSCqaOQnB8Ab/dM1/3HWp+LWix93vx7UsYxB
	kMuLpLWnTvXmQz7k/i6MpZaEFTJWvmSrMIztz1ECHpozbii7Oo/+MfwG27N8I9GA7eSPAUWwiYv
	xtxj0Uv2inUl9uHX0omHItIW4WNeqrx0yd2rMRYCgmcyXnNyMqjI1pxfZzl/7Jmy3oi+27ODDtS
	TmcAy6ogD79/EwWiX4Zsn3u8dNRES4UDszLZhWAMCqWS2JwA0fc0mWxd7esQj3nqlvb2CfTRVpr
	2OAupVaV8lOlbzy0iJRRc4vI8k35C1YPLuaxodNYDvT5XHnW7x/WPD3P8sZ75JDM8s4R2W+No59
	ZOfmCLwctKRhXlMvQgtrcKHPl6VwocvFvf52DpXkDTa9wF18unyzWH21Xvl0f2OIOAdVpq8TkiZ
	hyCVkAD/tmY6fvgZZtJR21ftQ4rXELFTA1K9Fyy+R3L75R1j5U+2w1leaKGOqmnE0S1+eDOdvy5
	3I5jmykC7igqbNKRuM=
X-Google-Smtp-Source: AGHT+IGKTAqrl4PGe4SFW7qu0192lJdQVYEzpdtaZXHZbcUYB4ioIiqnmVp7I/qce4lXwOMNJA61Eg==
X-Received: by 2002:a05:6a20:e293:b0:341:d5f3:f1ac with SMTP id adf61e73a8af0-376a9de5b1fmr15092285637.41.1766521286558;
        Tue, 23 Dec 2025 12:21:26 -0800 (PST)
Received: from fedora (dh207-15-53.xnet.hr. [88.207.15.53])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1e7cbfa619sm12567549a12.36.2025.12.23.12.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:21:26 -0800 (PST)
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
Subject: [PATCH v3 12/15] dt-bindings: pinctrl: pinctrl-microchip-sgpio: add LAN969x
Date: Tue, 23 Dec 2025 21:16:23 +0100
Message-ID: <20251223201921.1332786-13-robert.marko@sartura.hr>
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

