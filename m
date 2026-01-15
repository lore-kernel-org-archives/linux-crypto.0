Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A909387366
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477320; cv=none; b=fk0m7qVQELEqWFtmJSFmK/8z/oDs9mBbWeE4FyQUtTrdRwQE8no3SIkJkp4Bq6y1Foz11fO2TxJf74NI4OHVT0IRfPMRPquUw6MHxB85wUgRKsLsEN2M1SV+3AQQpXv5P29X4XbazhX/lCNjiO4crwuzpnoM8YEX5QPtBC9YLB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477320; c=relaxed/simple;
	bh=Wp32ITHx7s2+X+835Jbu4gJ7F+S1PggViopmVDWASsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDp/ApTDIcEAeBaNs2Cy7ntRKUdEP/JHdAo/wmBCiw++V1MV5kcd3bgo1d9zv02ot7VKC+y99P0wjZtZn++l8OCTiUoam2BVQf+F2wDNh/x6gtyHjuJVHzjdIg82bxQIhbElYghq5RsyM2mwwRWZmKG97sx7xr/TgBP3Xwe7VtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=zqtLJLd5; arc=none smtp.client-ip=74.125.82.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="zqtLJLd5"
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-121a0bcd376so2136394c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 03:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768477310; x=1769082110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6BNeAKcW11oL+iAABviMYbNNLfmxyGYsliVava+u3M=;
        b=zqtLJLd52zChUvs4oYWUJHIMhxUAmPvrUA/0RxveUEHPvgdR011hU/GyGExJrIAUtw
         ovZapknkgFlI5/Zy7PYrplN8lb0nEvwlrB2bitjgOHP/9PAg1nrZA9Fj3UIvooQSj2Eb
         aOmSZy9AaiWsrmQA8A5g+8gR30/6QW10C906so7KV/BSfppbdAkUBExMMWuejC1oyg8a
         hS1eVLAVKZ6isDD7pGVC/rjV+tM4j3B2ep3BO5FIQk93c4p82HoWhGA3oGp1gXkRV+Fx
         7lVupRmwIN+TVrcbFZYu3fb4M/QxwuuB4FgD5JB2r/pXEiPUEbhi6FRsYlGJffrqypV0
         R7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477310; x=1769082110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z6BNeAKcW11oL+iAABviMYbNNLfmxyGYsliVava+u3M=;
        b=ikZjbBRnzogHg8baRz5hdK19IHGeVX8f+0KafC8P9HPnwOFRI/TBFgV10et5irTclg
         xkc1vxOHRUv7RBFehQiLmVRsNhx9GvLyEeVuU5hk7j5TQbM6BuOOZNm5lO/Z5TpxQiPA
         p3qtZbA8LnXnD8UgQpFVQSWsiCnUuBeln6TzX9RFv3RKH+jpH4cxuTihK5uw01bgVohJ
         qomOIr/ghsfgLk/RreojtbWHSdj7pGMenY9iFP/Hy5QqCtyLMI5zq3ARWTudf+7KHiMA
         NMZCVWslUEDm3ounkJmYxmGVPOvKg62qgvGVJyaX+oq2dno1vBeD4W+aw40EOrPbD+bs
         XT2A==
X-Forwarded-Encrypted: i=1; AJvYcCU1fGbCqDKeLON7RIGrQ7Nxl9oeK4XVrGZRpRYFOnTMWftH4Txx6GAtUkkaLNThUdYivbrY2WIyrUGOxpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqcllVEEDJulrhXSsU6psc+P2PBJvg32RLQHD9BLC+zKYwi28f
	pN4NpB1mHclc6E6N5A94n2IapUh6vVV1nToH5YwZHpDEJVYdX5IA6I/lDCc5tXL5gt0=
X-Gm-Gg: AY/fxX7DtIDaQdK3UCiG1FjUiHsw3TFt1NS5IzIZsmotSjFQJ65Wp53PLSRE3H5Cc3d
	WF6AWtYRoukWrWDTbeCBi90DHobSo9WvmekRsy8xxs6KWWqcgwQ5T0MDTtb8EJnfwb1Rml2efP5
	+y2w+X6uPzbh7YcM3YyEwIVHA9NRXnLMntDTTbYH3NVS40Yd5/Lhkv13/37FbThSeW+zGWtPLjL
	3wrvpOn/sIgQSlFgCdlRM6TuixlLA11Kuq4g32E2BvpSP/n9/yjnUm4xWdl+Rv9U4d+RJkqk7PN
	S6/BirXiGjr1udzanJROnTPvn6EJajUrPUou+yseJFW2zAYIVwkuN+BrCStTR1TkT0ztaZ25QMa
	IFEuoTAX2KMc/0w9+yLBxinpwnmojoanZvafFVOrJTb//df06Vj7RKIMV3U/bU+vm2oPUvMCFcg
	ea3jJhYvroyUr6uXrw4V+nLNnvHWWh7piIwFz1LRxyqaeVba5zswH6GVS4i6bODyXODx8rFMAw0
	6JZKndk
X-Received: by 2002:a05:701b:2715:b0:123:3461:99be with SMTP id a92af1059eb24-12336a38feemr6814416c88.21.1768477309977;
        Thu, 15 Jan 2026 03:41:49 -0800 (PST)
Received: from fedora (dh207-14-52.xnet.hr. [88.207.14.52])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-123370a051esm4875347c88.15.2026.01.15.03.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:41:49 -0800 (PST)
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
Subject: [PATCH v5 09/11] dt-bindings: arm: AT91: document EV23X71A board
Date: Thu, 15 Jan 2026 12:37:34 +0100
Message-ID: <20260115114021.111324-10-robert.marko@sartura.hr>
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

Microchip EV23X71A board is an LAN9696 based evaluation board.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v5:
* Pick Acked-by from Conor
* Pick Reviewed-by from Claudiu

 Documentation/devicetree/bindings/arm/atmel-at91.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.yaml b/Documentation/devicetree/bindings/arm/atmel-at91.yaml
index 68d306d17c2a..bf161e0950ea 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.yaml
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.yaml
@@ -243,6 +243,12 @@ properties:
           - const: microchip,lan9668
           - const: microchip,lan966
 
+      - description: Microchip LAN9696 EV23X71A Evaluation Board
+        items:
+          - const: microchip,ev23x71a
+          - const: microchip,lan9696
+          - const: microchip,lan9691
+
       - description: Kontron KSwitch D10 MMT series
         items:
           - enum:
-- 
2.52.0

