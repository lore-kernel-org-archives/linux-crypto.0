Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33A133C1B3
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033640; cv=none; b=aJ8tDRlhuWsawzb90pp5GAc9bAqatCBD09lRYUolN0hf15/ghegndu/E0qsS9C2TqW4D7RlDQSSkmuRYqsSvdDrpE4DgTxoki2K1KLsmAv8VUzLJmDVyjwfHIVq0IhvshJxwHQKIy/YGw8Y9lzdM/JMhCXdeLOD65UuvjYfvYx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033640; c=relaxed/simple;
	bh=Z8OJ5bdxrmCLAokdEoL8lVJhhIUEVgrT5u6lQIEOB74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flXng7X/6gm5iFKKX5ESM++9d6ijcozrhGrOOiVtlRxjENiyxJGUSV12GaG3sSprriANdG/6fTMcbq8Fwxkdr3v5125VCx/0ovAOo2zjq4kW9Za3Ui/xNhVAysdmtZjVzuxlkTemyZqVWS8VlzIiPlC0pLpNzwtQL0Byqdb0W18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=zriXdG88; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="zriXdG88"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47d3ffa5f33so15524435e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033636; x=1767638436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2nPBwlmLC+wGQo+kGghgS2CarqCL9CUUT5DieeAoVE=;
        b=zriXdG88QoOcQsYbK/ainLz4uYpAXqPirBhe/Vii0V6qvwil0Wg9iMzV7JfKNMHnfY
         dOPQ5h0U9oqLLDhfnBPo76emrgl7VN5I7XiMirXA6WtFwqttaCA6IEXvOk/3+SrWHIir
         biWX58bGKQU8zUL+zDBVhPxJLVqCimzFdWc24GLdfOVOqPoVhRz77gvJT2+nEtRkwvRi
         NM7T4JaV/zNmzjfh8mIoWL9MDE1HOOdxcNXaraBE8+IxgI7dHfGszq1UEb+ewN/SwY15
         RS2g2496f/S6rgf9PdF2LVDU5DtEiJnA3MC93CkS8Q+JUn9j4Uxm6GAHKe3advLwW1zc
         bNnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033636; x=1767638436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H2nPBwlmLC+wGQo+kGghgS2CarqCL9CUUT5DieeAoVE=;
        b=pL2IXhUecZQM1UsHHknjJIC8e/J4/UNJRv4xFFkxaK4XLXHpn6Zcww5LzMHwk3i8kt
         oFgmSsrKyMggDM0PvFMjGM9KeLmKR7A7tXKsVYEQELd9bFJyArkTUAA+b1jC6somWsQe
         L6pBherflx/aXF0aI+MQ+2BXvBGccWrZeA4+IH+0r7PPeGRoLOwJJMTAAQ5uQclnXJWh
         4FuSRaexmD5CwQyJ7xpxJBgMRCrsB6rIGD7UpklEco4x5iyruz9QAk+sItTdCfxgQ2nM
         3wjrUMfrvbWTXHj+3AFGX13v76D0sI309PJJt9xxe3In54J9tmF2dXlvdZMDJtHTSpy0
         fETQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQOx+EAd6ui2c192jIY1CMThm58m1fL/sweIxTISsFrmJwziXM4WOc+145KbsSMFfqIoo4Sm+npYZrj2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkYYQsD27yc8cbdUVJhG7E+QBd6lmY9rL5kNPq49nsgXblmxqK
	OEUM3SxQAW8Xysu2ag+AXpMhcEPiE4evnF4KU/atkFkdZkoV3UdOO1Y8S1tE/vLkO70=
X-Gm-Gg: AY/fxX48h6yrvd32S1Oh7G49319RU5PrXVQC0IzzANCASuqcdrD6EgxO0kg78kiSfen
	oomXgePRQ57O7NL7u3NCLqvgJrPTz6wBjh4qXqvsy0gb1faNAy6IIp78ndaLCQOr5ef3HuTSE55
	ETbi2tumPkezAscBByJ5q8+dKvCKvEupaXs/n41a777eLkDRxFljJmchl5LhxEju/E5gWLCnkeT
	/HZ/d8ZdVdnoUFy4oidrQRK9WSpkKN7vcHqxXrFKV8ol/mB7RyhogxkPXRUA1fUlE/Tqjgk7mli
	3hThUN69hK388+jIer0QO1Wchr4PqN/dEF2ITPWhLJ6sb0H38Nu8H0nTOuQox+DfuzKpUihn9Vj
	+GAUOVziw2xrWvChtVffyjGSvlFwbON+MZ71wLCsxccWAL+o4D2p31g9v+dmX9e5Q+DhkoFcUJG
	rZwaFBhPOu95kG0AGb8HJlYZQmC0K5Fbmb056Djt9CPVBlKxkilYRVi6PeppVjAqRpoqeFqgrHn
	XpWYU79iLyA0+fAfM5FpHqJ+y++OB0LW+iPR5A=
X-Google-Smtp-Source: AGHT+IGJqflA/fWcbFGlt7I8QSG/W3Ym/AA8gFbH72KL6IAeQS+P/elQOb7uOHAEgNrEusVQwY5q5w==
X-Received: by 2002:a05:600c:3b87:b0:477:aed0:f3fd with SMTP id 5b1f17b1804b1-47d1953b7b0mr395881215e9.8.1767033636235;
        Mon, 29 Dec 2025 10:40:36 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:35 -0800 (PST)
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
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v4 12/15] arm64: dts: microchip: add LAN969x clock header file
Date: Mon, 29 Dec 2025 19:37:53 +0100
Message-ID: <20251229184004.571837-13-robert.marko@sartura.hr>
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

LAN969x uses hardware clock indexes, so document theses in a header to make
them humanly readable.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v4:
* Move clock indexes from dt-bindings to a DTS header

Changes in v2:
* Rename file to microchip,lan9691.h

 arch/arm64/boot/dts/microchip/clk-lan9691.h | 24 +++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 arch/arm64/boot/dts/microchip/clk-lan9691.h

diff --git a/arch/arm64/boot/dts/microchip/clk-lan9691.h b/arch/arm64/boot/dts/microchip/clk-lan9691.h
new file mode 100644
index 000000000000..f0006a603747
--- /dev/null
+++ b/arch/arm64/boot/dts/microchip/clk-lan9691.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+
+#ifndef _DTS_CLK_LAN9691_H
+#define _DTS_CLK_LAN9691_H
+
+#define GCK_ID_QSPI0		0
+#define GCK_ID_QSPI2		1
+#define GCK_ID_SDMMC0		2
+#define GCK_ID_SDMMC1		3
+#define GCK_ID_MCAN0		4
+#define GCK_ID_MCAN1		5
+#define GCK_ID_FLEXCOM0		6
+#define GCK_ID_FLEXCOM1		7
+#define GCK_ID_FLEXCOM2		8
+#define GCK_ID_FLEXCOM3		9
+#define GCK_ID_TIMER		10
+#define GCK_ID_USB_REFCLK	11
+
+/* Gate clocks */
+#define GCK_GATE_USB_DRD	12
+#define GCK_GATE_MCRAMC		13
+#define GCK_GATE_HMATRIX	14
+
+#endif
-- 
2.52.0

