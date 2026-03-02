Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE353624D5
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 11:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450529; cv=none; b=iMUCzIWIXcHWbQoY8xzPO0QKKDfTd+ZsLmtMF90FGLMQJtq1UmQd3JTz8U8pYXlAAYPtFwS4HvrAXCwsIvX0vCoehYjJcaMiT9ffJei7iyjCQRO/u5QsCiBjuavivnQwNbH3aqCgfk0L+9PohAhGKXIpv3u4zaRSlHWjOpJBfXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450529; c=relaxed/simple;
	bh=to/yxjGiw472A4w/ZG9L65B9irkFq8+kpamX0PwYXGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6EooMvIQYYzSKiVfDTj/BPJ9+hJoJMoiGZ9Z0Rp8ElCoJIAekLj0BEGEh7HhJRnjLMkL64a8vEBoh6ur0BqSIJMz3PhG4FYN3IX37gE69kw4eGiwBCYiXW2+gN5+CxHGFVdMvEAuq8bs7pjZRJ9ONkxHP7cfb6jSVn3Fhx6RV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=hA/l9mY9; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="hA/l9mY9"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48371119eacso54168945e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 03:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1772450526; x=1773055326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QOxR18o2+9ulYS4r73qXsZYgHJUpIGAEfbN7mi92aLE=;
        b=hA/l9mY9+sPJtrOeUv4fy4/o0mHnE5p/ulkXMbzB6jYdBNjEkROdCVi0Mx1p0bxAUS
         4GGvk/wlxvYP3/Ym6XEZYzGwN5ez0E27/AcIDCOay/KA/9uWJZuyTiwX56cGiHulakdE
         arZSRh//NnI0479BIEXTbiwYUUcagWai2wW0+F0baQgCwAeeSIO8yonEl/FAkmejimVh
         ljQqCJ+spXhLAyky3GTJNfaYhs+kjSEvbnv3KqfTKn1xxmu22yJAiF98/JoJDmUzHZoc
         MOV2CNLkorlzlvb0OALEa5nReobkDHldQoRpEiDBhNn3Dhd60XlyBVgRSbVWkFg/Dkhr
         Fixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450526; x=1773055326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QOxR18o2+9ulYS4r73qXsZYgHJUpIGAEfbN7mi92aLE=;
        b=mtV7DyTsHC1OoaN9L/Tvtl3ut8BFaa7xdM11DZwWC6F1mUgk6ge65IqV/JepvyXvuf
         jZcbs42EKHsxh/6YwPSd+jM0nZ/k+AZF1w7ZsFWO3UiY0zHN9HD0N6+OrcXoA0odWRMF
         2Cj4ImtWCKd8dDNBjNca7AKVv0TmL5vacrY6mnYVCbWudAMxiOY3jPpgngYMY4tT3SJP
         PkRVuL9jn5aoFVW0aJw97Ad8CGGGw3Nt8kurXJueaIWy21hRMy6am0V5ZI4CyF6bT0Cx
         AefxpcApxJ/H10gGsddvnCv3aJYdIRgIvfLxZyvi1ldzmytYwuBFjWYvMr2PkZB1UcBf
         XTvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNnxlB97A+rA9WZwNL6CJWRB+8akA+4Uv1XlkeDUo6OI8iCkCs3S4jcOQgRoRiic04kF8frEJFfnD8yY8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt7HtnCypYjQ5fVzq3ahB/0zwQ3llzkHAvB8grMhcy53J20E//
	g05ZjV8DJN4Y0spkwoosMoK/OWg5kvLpwJ5/UgA1R/vBVpNF/6B3npW4VA9LvpQm7A0=
X-Gm-Gg: ATEYQzxdoZIqjjJD7vqxwYuRSItotkln0MuSNJLRg4sZOXMlpKH+ONvQTPAb1/QYu5G
	Iu/EynNyQ3Q7uW/AJDOsplP4udgdUbD+/UwQxqqO0S/aVeeYOs9YPpzn/v3E2xduZqmQbzxZrq2
	Z0lB7QyWBvwPObZ8EjgMldA0ru7KFlpvaIxACYL1YBw+Bdq/wf/e+PMtEDmBuLctarnp44bkX5X
	DzGNVG0uhSnUrs4YHuiF36ODNYk2KO6Eho8V6+ZHWUDF8vJKw4/UfAzU1WAokpf4/167rRBJi7L
	jR7d+Do93OUnAaLS8PXvX+TlUP7ngkxOuDCplDj7kSCWHFqwJA+v/PVJs7PlNnHbadmyc59UUmu
	HQ9d/RLlxV69q/Dn3111X+XHsACdGHqbayhN+cHZXc4V3xlQx/35KKu95702PnN4ECgFf1xc0dV
	xtHC+/AHEKORC3ZLw3Cz5xh4I7jl6P75aBMlxffnnQ9KMXq1VKZVS6xWKfP5/qL6jmT1ZNZLLPv
	vnkyccnYQg7LrCWFf8ph6FxXAwIjSRy1ksb6SoSAI8=
X-Received: by 2002:a05:600c:8b53:b0:47e:e91d:73c0 with SMTP id 5b1f17b1804b1-483c9c0bce5mr211979425e9.19.1772450525627;
        Mon, 02 Mar 2026 03:22:05 -0800 (PST)
Received: from fedora (cpe-109-60-83-135.zg3.cable.xnet.hr. [109.60.83.135])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-483bfbb465bsm292493035e9.3.2026.03.02.03.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:22:05 -0800 (PST)
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
Subject: [PATCH v6 2/6] dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng
Date: Mon,  2 Mar 2026 12:20:10 +0100
Message-ID: <20260302112153.464422-3-robert.marko@sartura.hr>
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
2.53.0

