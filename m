Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFDC363083
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 11:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450534; cv=none; b=lGce7idDgRN/IvZj/VdJZxUIkf3Sq430Qb6jrho2hgF+hd+PCkEwDXtdZoC+h244htwQZaKzaCBtd1h+4zLzO2y7v7SqqOKZQsH95aYtrVCqk4/ffpuXPvdSuOrhsocMOiQdjOgfWX5ffBXdrCg5q22NGQpwSXASHZ3dpfUv+fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450534; c=relaxed/simple;
	bh=5YXoza1npYaJ9tc4xJEPvhZRjZCxh9QfUM1VALrscjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr1j9uc7OR6b0J0TQrUK0d5xQAVTZfIp5aYmKEwmZMR33MHas/z+DHEH12U2WpJ8V5r2OUqHYr9yTBLxVd6cjxl234+GXl3ShJghEHtk5AOkJcyk33aD3yU57ZvMdtCkn5Z2ZBkSjzl0Fjuyezw3JQCvFzSfULI/WXZiwZogQBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=lTTzIgpT; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="lTTzIgpT"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4807068eacbso35649555e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 03:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1772450531; x=1773055331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ESgBMDji8rov6yYhnHGaS+/+l3/SjDdxdOhefVJEU4=;
        b=lTTzIgpTiNx0t+9SMh3MlGQYkXFZy15WCA27C9rEH091hqDRqfkh8C0o/9AE5HcYe/
         dDpN4OL6ea6MDTatMK5gxWagxQNrHP1qKpvK2Q/0EWHM8aYDLPheH6h8lnZfWL3q0Q6v
         LPlUAlkFznXbOzlro0zXoOl3xcBIVDgAkdk18UU/gMmwXDzAlAUsTXSWDTHDEY/5RuCD
         x9pOz/iUN59iKNG9DV54hfNS6AKu1IDBMrtgSIaA785Y7m95k2CVQMeXm37evukqRP3E
         Lm/djHE9I+YubkAcxBkHKSBhMbIvQai3cm1gyxHtbnLcpnNfmtkCwaiBrvQar4vFV2rF
         AwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450531; x=1773055331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ESgBMDji8rov6yYhnHGaS+/+l3/SjDdxdOhefVJEU4=;
        b=O+D9v+/kNihobS8BoY/14kp0mAKQEEJgBV45xDaC3kVULr33eKkt6OnvXUfW0Ll1ae
         vIn1fMEe/CipOt7moOKtQjgw7ZjG31V6OwEHBQyM4TubMMvQhPjETFc7tY9tevscu6eO
         DshUN0Mklx69wSR5QVNMbowWl4obVij38DfYH/yrL3bPmgUXvHAGjWpmXf0fhnddoTRG
         D72wAosQ81t5Tm8ArrCxvApfiNurR3MbsqD1qpQWR49p0Y6ISD7MbmQCBmHJUEd3ViKQ
         mz/ulI92dNP080v5b88ub+SdHUvmUk75kCJLVSJD1/FQ5IZcba8B/zrBO9bxa7yo+2Ty
         +mKg==
X-Forwarded-Encrypted: i=1; AJvYcCUJl3+JXswsDOF17+vAMEuTo1ueNTRYcDGPjbUEqSmj/dqtP3ysvqRCyr+LbN59YgJ3207EJqx79NLPzo4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8uk9R3p4rEJ9q147xWuHoYfpHSzM4rQ/IDl/bQQSOyiebxTsh
	GsRhUlPMYCnb+wN11jXtClk7XKHfCx4ecdhFZ9a1fnGUnAo8ZelldYw3BgvMYj/dTHE=
X-Gm-Gg: ATEYQzxWS7hQ714iCLum8bcg64EI310c05RNAyKNnwHvvga3wqvl4oYn0KtAU6UGXru
	9j1KKueYtpuDxCY9fXQvhe5NIL3jFJqlLizu/cHwBSAayI8ov/niWIlSbwWdnpPfvmS0CXxYzoG
	gCedB3WXcWOSUwhxIr8Kne/S4gxkc7NhFCrPbtXfykS7TjFzKRzfZUeNwcdn8sodNhEZCR3J+/a
	c1i2YAVGdT+u1td+g75tiy79rrcEAuuJkd+0FQky3yIG67z7mleKmDOQfb55LzqDOhTPZJ8Jxy9
	e9vMnwa9B7UEUsBwypZEYKVyR0vPxqckWFecckCWUDsX/apkuDwAxxoNv0C6/TaE43nDjzFl8tR
	6ANUp7ibsh8BjlUvIoPbbIpkAsN+JQHIzuAXWykmUHjcqOly1mV4jhK8AU2bvBF+GIeUr980BQ8
	mbOjspp4cMz+mNkj+AklQ8AZY0UE8jw8OKqLWQLbxsyHphITD8q9YY/SEdQwXsAmCLw+BMx5VWc
	VxpYHT8nu1EmZZON7cRFrwspSNlVG44Vubc3DnNh/c=
X-Received: by 2002:a05:600c:4fc8:b0:47b:e2a9:2bd7 with SMTP id 5b1f17b1804b1-483c9beaca0mr247748075e9.19.1772450530729;
        Mon, 02 Mar 2026 03:22:10 -0800 (PST)
Received: from fedora (cpe-109-60-83-135.zg3.cable.xnet.hr. [109.60.83.135])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-483bfbb465bsm292493035e9.3.2026.03.02.03.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:22:10 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v6 5/6] dt-bindings: arm: AT91: document EV23X71A board
Date: Mon,  2 Mar 2026 12:20:13 +0100
Message-ID: <20260302112153.464422-6-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302112153.464422-1-robert.marko@sartura.hr>
References: <20260302112153.464422-1-robert.marko@sartura.hr>
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
2.53.0

