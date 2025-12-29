Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618FA33A9EC
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033634; cv=none; b=Ke0lGTFo3BjBod14XM+HKnab76liTG3U9l124IW+3KZvH2Odpt3/QnqFzrIqZazCkKl2ev7+DKCukeXGoEJ9+Vn8xdWWaxh19NorrcwdXodIdJS4nhG/YAxqP0WzHawq+OxKc8sCutUYt0PdJvUc+JfP5v0nepPkfqJX9ysLyVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033634; c=relaxed/simple;
	bh=7jtkvldmPSo6tJBxZSibRZu5hmUTyLaiO8iQq/Sa4wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPtO3yFpZ/ValDVQe/OjyeGgGtmywanJLPvY1O3ezVToOIc/CDvyHlxayjjaeOBwf8ygSC/SC8qvWxGLVdatSmZpyTV1Gn9S38/AAER3eWnNFhhHLC85vtcNir/UFXYJf0vbewwdD2jmniGiSIdNimZoCEf4TjZIflZqL2s7VdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=u7HmGPkA; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="u7HmGPkA"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47774d3536dso74515515e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033630; x=1767638430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZY5t/vT8/2JoNFBpsoZEjWJnrTyKVma3HFBR0NVkIKs=;
        b=u7HmGPkAkdP3R7rcUekjuNxY1rqjuIdNyca9I/XGM9QnG+kfzr1RniY05coFnav3Ng
         RYHUu+lqU0wDiflHit52ZG0t1bmh/XBC+sQTV348FEuYagsi0eLdDABPMr2PVkaD7inJ
         smarDUYRZ7OjWsdOyQ7pkBVYoLoQKrRfREcBHdttYvdam13AsICcjYpaIixihY848NF0
         4+AVUcKCS1vvv6tkvlnLJv5CroC9pr3VorsPqY0IGKUkVt2HWY+/PhFxoJpOM5MxrRZR
         rn0bKm0ktUYeG/Ov+a8MT9JGcL8LG7NbpQ5e7zQAkwYV+aLTTb3hvAKTdGWO/w9MZ01Q
         gN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033630; x=1767638430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZY5t/vT8/2JoNFBpsoZEjWJnrTyKVma3HFBR0NVkIKs=;
        b=RQ+/yoTipb+D3xMbeL0liJDS86xn3MFw+VBE8NDepnSJPW7CSHYylTHEcX3/90MsNZ
         y0rNYz1t5cQaE5Ci1n1+6jzdZd2PzD2nhw1rAT7TV+6tEwplATPJrzmn6AfGxiNCx/wf
         K2nbpK/H5C5XR7C8pIsr6VvO/rTl8ZDMIU+wHbil2IxSQkP6NgfnfieYcr8zSkxlj1BZ
         cTDmeI9hGAgeQWf8Yen9OTe/BqSJ+pHniHR1IX96U4CfuHMFjiSVA/fXKTBWnYg8r09t
         LeihnOpuxUaxfZSmvr0eTLeTvYppD4JZ5Msav0ALRbm20NBANPD1cOYL0yN6OaxPi/0l
         htsw==
X-Forwarded-Encrypted: i=1; AJvYcCXrN8vjjDv6s+CNo7T/I5kMWLrdOKZThGsxSVAEVMXPzCx7NlQRTmIg7Fu++AhFUGaZPwv6gQGT+uVYsTA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7dm+4T1TW4FXzaJozFupDcfVW+q12EUp4ww9wqTMl59gmBo0A
	0Z8za15UJZUZeb427HXy/0zMmTCWFz2UBsFsl6nBHii3QfcbN8CKQMQWpJ1L7l9UpOQ=
X-Gm-Gg: AY/fxX5vCA+9gxbRXq74qfgNbxFkiCCPmZc2/HiSfI8OwMR7HCKvxoe7l+UIoZgx4c9
	d+DGBwSoS+vYp+Jtho1Wkkg02gS499P6Nn41fngqtEZZ4nG1mqQk90jjeF9KIzPEPjgGny3PhaK
	pWeeWn2YwVsWfLFU3bo/RSwDlyirXAoL03nY9ZcDyKgC1CVIvwjmuu1ra4jhCUSm57tqYfYk4wg
	IH/VXPaxSRXk+ciuk4PhZDJhpdaK5+gRwp2J1r8iZLei+p2dLTc0GPSJfAbd+SyueU+chh02LVF
	S2ppu+PS3YKyIxMG8UgRfL/Qw0ZpP78dk6LILZ6Y/wVVFtY+i0AWrvx8xOs7PBHCDpGrAU8iwnu
	j4aiwq/fFYgeW43+bEmb5mJwOmYogcyJupeCztPRPtlvlBCdCcDZuNUkpu+8Y/FJ8h1okGCs7DE
	ifrRwUDLabzA32zPL0JPMBSQMsC/PcO4CIXp5aHZzwLBX/Zbz8dlUAhj7Y3hPILpjHEThx7V6gq
	9DULwrDbloE1ZZ1oKwX+J2YBUS1
X-Google-Smtp-Source: AGHT+IHU5TUgf1GXiZLlNhFvhk9NZs5LXOVfATsL4H0x67DGWgTd0xHPjLFDLe/wLhfc9aOjmrDYdA==
X-Received: by 2002:a05:600c:8b11:b0:479:13e9:3d64 with SMTP id 5b1f17b1804b1-47d2d273999mr360424715e9.15.1767033630467;
        Mon, 29 Dec 2025 10:40:30 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:30 -0800 (PST)
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
Subject: [PATCH v4 09/15] dt-bindings: dma: atmel: add microchip,lan9691-dma
Date: Mon, 29 Dec 2025 19:37:50 +0100
Message-ID: <20251229184004.571837-10-robert.marko@sartura.hr>
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

Document Microchip LAN969x DMA compatible which is compatible to SAMA7G5.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v3:
* Merged with microchip,sama7d65-dma since that also falls back to
microchip,sama7g5-dma

 Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml b/Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml
index 73fc13b902b3..197efb19b07a 100644
--- a/Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/atmel,sama5d4-dma.yaml
@@ -33,7 +33,9 @@ properties:
               - microchip,sam9x7-dma
           - const: atmel,sama5d4-dma
       - items:
-          - const: microchip,sama7d65-dma
+          - enum:
+              - microchip,lan9691-dma
+              - microchip,sama7d65-dma
           - const: microchip,sama7g5-dma
 
   "#dma-cells":
-- 
2.52.0

