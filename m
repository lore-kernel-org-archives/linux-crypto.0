Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0098937F0E6
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477290; cv=none; b=btFPBvbP0vp/+q/8qfM3UXDNBnAqdCtXiPVS/BvaJc733rPAITRn6UxxAWb2ovCj8PbxyclDv3TJ1P+odAPT8UoQNCPuDVWD1I3VXf4vXvBXo8ju545+MOv29qsqiRHtjNvjAA33TeArQj+04iyGvI4K291tBvtKqFKUufKwyNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477290; c=relaxed/simple;
	bh=93VOl//T1710gnGzUbrxwFAJf93hjOVK3YA9kMeokWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xv7FZGaJ+3seGGpbF6OOXcil7RMh8xT7FEE1Asx4kWZ6tgFav1KyI4TwjTauu41NU10BtZFtZrnMRZi1AAHW85mNAmdFXJJnr0WWBLwUJCL66lHoRY+8uaHXwNUIPrwnu6v73F5nQ2y5FBUADqtDGgaft9EYeLHTxELPg+Y/WGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=HH1xjzbj; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="HH1xjzbj"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1233b172f02so964597c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 03:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768477286; x=1769082086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HFCj5ztGvyCwGgMLXoFCMYjN9FIM/YL2Od2IwlkeWA=;
        b=HH1xjzbjFzEvFTuYaEQ5nW7+KnA4ufCUvTIGdO29F+2BByw6owFoSV5LFqgnJqmNP+
         PzIW/fii97DhSeFAVfcwYuCOKxpaYUsHwiQxuv+UoIrs9wLZiWaLsyIRlMwIarYpuXae
         c/whJBTFucAhJaV2k4amzhKN0SdMGQR3+1hRKwV96f5MKZPVhJGTk7oQu+n3IXxG74+x
         fP/OpGTKm5VSFF8Z0q3KjOfyokSoN65OXNkmggxmxdvt6HdVfaaiV0rPoB7Z+fuuUPNo
         S/eBQHnZ3qh9P/HhTViiSs9a3tqqOd1iDTGx7bUjTM6hGqdbtwlg95BySgWqt9GcdjNN
         kbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477286; x=1769082086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9HFCj5ztGvyCwGgMLXoFCMYjN9FIM/YL2Od2IwlkeWA=;
        b=wloUacZrqUxpj0hq5Cecri8WntZIkHFGM73pbMlS8cRHX8YubjAqkR6pETHwpBVdxb
         zi3NU9xtzeOmC28N5pIw6gxzt8cO4fvpP00pypHHFniYws6UBDYcbVZNs4m09xUHS9YK
         6v9lWjkBiaGMqhsIh3BTJea1ySk8l7nvzB8NVAvZtLWqIj36e1+61j8/MQl6rb8y1WWx
         0XbzWnzhufvRpQoWLygltVjDxQghSxTwhn3bpLgYWm77WJ+YjArXOZGy84hmt+qryKI7
         qEDS8EnX3A++1F5A+ewHfpMccPrIDeQTScMv2cbbdKekUf2gfaMMa25U1wXmfUChqH4Q
         fslQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbEno25x+BWGz5HeBxiEo/8b9a4faeMfu/yEywXsqvkSkYns6Yx0rkvDWmiyHCAA5bzrvRXm782UDwdyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxptfo37nQsRCdKCRvfRc0D1iegVWrfcVwY400WnJJ0Ndn2esbO
	5A3tUmonIgKBYf6nPfRvSwzjWLoWlA8n96EPW29uB+9I7WLBLlbZi4wMT/74A0Hu7Gs=
X-Gm-Gg: AY/fxX4zJtrwNp6K92I9XXe0ZO3WJpYOWGXAS/NW0nhuH9Kpc1kmNbFrE7TiXeCQcOX
	L/B7TjefPWMiFdyL5uY3sykRacVouLScqKO9uzoHj5KjggLHiv+TXA09qYOw+HbNQ03ln6YXq1f
	Kbh2AaV1Ak0ua0vYm58OSCfULe8MiT5+6WrtrYyqHcSstyasrzyK6EWgAGk32+z7Z3PkvRwQoKm
	zk7ErN5YgD3S3uZNe1JVXwYgPcXDbx6xN85Gi7WD889i8AWOY4BYdqmX41s9CRvkgrWUG7dxGzJ
	qpGb3PT/GtkCCQOCdqLcIPcsKsMW7ig+0igLIMbSMN0QU5pVQ6aQ4GXeE5IA20BeleBK/RMu3Nb
	UJ4G0T2j2YUUZ7LDLYN4N/hGsJi5Jh8vN4qmmxZ7xs4V8U9xJapLC16Z6fZl/dfTQaEWe2kk0Vz
	bjnTEtEv63zqdNhsmzjr6rgcLU1VwoqUFJ7YKQTCtxkiKD1JWlGJE2CKPL+8fvsjIUr6svU3p5k
	ueohgEo
X-Received: by 2002:a05:7022:1719:b0:123:35c4:f39c with SMTP id a92af1059eb24-12336a67900mr5434114c88.26.1768477286121;
        Thu, 15 Jan 2026 03:41:26 -0800 (PST)
Received: from fedora (dh207-14-52.xnet.hr. [88.207.14.52])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-123370a051esm4875347c88.15.2026.01.15.03.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:41:25 -0800 (PST)
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
Subject: [PATCH v5 06/11] dt-bindings: pinctrl: pinctrl-microchip-sgpio: add LAN969x
Date: Thu, 15 Jan 2026 12:37:31 +0100
Message-ID: <20260115114021.111324-7-robert.marko@sartura.hr>
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

Document LAN969x compatibles for SGPIO.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v5:
* Pick Reviewed-by from Claudiu

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

