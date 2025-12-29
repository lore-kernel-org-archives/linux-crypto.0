Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA1633B6C6
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033636; cv=none; b=Y3KrRrzg/o2qxRtwywe5TJ/YggH7K3vUw55wCWkGEiti83L8YvbA7XOuT2gxkNb8gmqQMmIcifbzeGADCIbm63WqR1xPaOkUbd2mFsdYy1FlRHjJeQ/rXko0CzJDGU2Ji+uY5f6LiXqn7qisjvsils+J78kObNguiQ5Pf0+wMnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033636; c=relaxed/simple;
	bh=omWUVkHfDgWK8/wVYsqR1gmKx3uRcWW/S7wsFlqvQZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSm5aG1M65CIF2TglJviYynsxC74UwOzPEl6bMuJTtAWvBUVskx8/ty87HlVj/SQfogj1P4dmAUyZ8vmEq7sJhCnNo5oe/b5XlRU1u36/IE/WaCcYuiDnEEa/fJGV5RTYM+DpCKAvizMncApiyRNgOamQTqYSsk74eYjIQ1g9+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=js20qBKl; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="js20qBKl"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so71189065e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033632; x=1767638432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pe7/bfwW61qpTH+JIS3AKR1VkqKbIoFXot2V67cYu6g=;
        b=js20qBKlOIc8p7LAg3ojQzBrDVa9hnJ3iwdqCsfn32yFz3aInQM6QoNK5N/ROzBK2F
         7GGCtwcKHJrg81RR8yBIoLsUREQkvIHNvhSZ1Uyooa1SkWmuCNLxf1fM7yTIF/tSA5xd
         VFlGqY3EMA41aCFoQleCr+F/kX/Bxmhq53oqbmeTatA6OX82TeqOt3nsr2uNqBEqrl0k
         nBsY0OfjmzG0AqlPzNx6ENwwoGPvY0sYVSF5LPWB3Vob0xzKohW7DvCBZ7tTFFYgAJ6C
         HU5bjhYy+qoTsm16Nc5dGsdDMwZMnkSPDCi/zwej+DFJ6pcf+YNfvG9ROfUQuUhCz1pP
         LuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033632; x=1767638432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pe7/bfwW61qpTH+JIS3AKR1VkqKbIoFXot2V67cYu6g=;
        b=qNdqnzIBKvm5RTSePr5i6z8uVRzXR3xfnQGUFlLp9tPn8VOFJ2EEhuuHpRNPs5WsXb
         aakio3jNm2TshpCrppUJAkkMF7RVhXZYZwCz9UPawvwNw1JZylzTC0hJaxBBxhDhzasr
         DogzKfs+twdp3KjxiAg2GeAgzXFP+YSl1+MdFmFHd3YMd2nGvPeEkK6+x/q+b5iVbNth
         k/iQ2Wy+V029/iCFi2ODB2iCKGXTE3puGdt+ZDXYaZ5CuGF3y9OSh9gIi8MpnikXB6T4
         lHlC/clzA7q7ajRGwgOR/SMESRMjET8IovCWyU1HnxQq5r9kgKvd4xZSbY6syhFTAPjY
         pK+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVP81BrxhgYzsjcEP3pWO2+SaNeSyc53Q5VmxnAzmX9/nBIRbaxz8ciwyH2F4wtAahl1MrAg0MftiXMnIM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2uWAEYyjSh6Kmrb3GIReN7bUgQIXQMlq6D18VU9ume3QOeDw0
	XiJ0TNTEqOgfrKVmk5gqPZHTYRI88yapcBNmdYwt00CKzEFoLwhULUKCS+bxQUuPCio=
X-Gm-Gg: AY/fxX4HSAjpWF8Fi7PdTma4s8mQV2qR5QwC1jAuy6gYt9r7GJBsUPgYEcufP7G3NGG
	8orUE44I+g/L9cVS8P3xMxt2F0jsOLDbRGnIoxx6c3ulaPuQK4Oie9ypjtj/ZRUrHWeW9LZ7hAD
	uLb+UVoYRtcSsnfFU8UKFPItQhFDAx75+j/XanS36B3ZI8X+iC981TTrnwR1XbWYY0tgjdbBA6U
	Y70CvoNErMvt5ikRScQVhvtJk+z3brNKm8DZb00tUvE0gsxT89k3SCzpSRpefolvPfMuozHCiad
	IRRXRVo0IWCAKRJbTHTgF3zt/WcVdhWCputyCDKzmFay2IQULICor5KhN/ZHid8wmLgTgKplo74
	BpSjhZQ8Ce7JJmc/3tgPZL+e43zymPYCUgnnGxrACU35lUe7/TQYc/ymUfLHQYyDbfLAa2EhCrv
	Bj+w1TKNgta95YgQXsBHV+j2I/9NynaTz1nSjk/fVN2IVbz5qP7MVYiM+ee5MJ0MVuqNF0VrASl
	pWSmFNd5h2Nm6wdxfXOrraV2WHK
X-Google-Smtp-Source: AGHT+IHMeEPdVuxCEsr3HbzwXW9O9zK0z+wZ0vfJLANR2lbSoc703JFfFuycpKgytpooUs272ghcDw==
X-Received: by 2002:a05:600d:108:20b0:477:9986:5e6b with SMTP id 5b1f17b1804b1-47d1c038664mr255232695e9.28.1767033632356;
        Mon, 29 Dec 2025 10:40:32 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:32 -0800 (PST)
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
Subject: [PATCH v4 10/15] dt-bindings: net: mscc-miim: add microchip,lan9691-miim
Date: Mon, 29 Dec 2025 19:37:51 +0100
Message-ID: <20251229184004.571837-11-robert.marko@sartura.hr>
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

Document Microchip LAN969x MIIM compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

 Documentation/devicetree/bindings/net/mscc,miim.yaml | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mscc,miim.yaml b/Documentation/devicetree/bindings/net/mscc,miim.yaml
index 792f26b06b06..2207b33aee76 100644
--- a/Documentation/devicetree/bindings/net/mscc,miim.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,miim.yaml
@@ -14,9 +14,14 @@ allOf:
 
 properties:
   compatible:
-    enum:
-      - mscc,ocelot-miim
-      - microchip,lan966x-miim
+    oneOf:
+      - enum:
+          - mscc,ocelot-miim
+          - microchip,lan966x-miim
+      - items:
+          - enum:
+              - microchip,lan9691-miim
+          - const: mscc,ocelot-miim
 
   "#address-cells":
     const: 1
-- 
2.52.0

