Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7782B2DA746;
	Tue, 24 Jun 2025 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773211; cv=none; b=Ze9yy79z7ZI9WsI2d2tGeYjCF5/GvNn5jWvBVApF06tok2zYXjmS8HypuZbt+QrCOjuyT5QUdPDh8LHpq43wBxsxYQ2fKFBIMmL/CQvz5VIWsgvd1R3nJ77gjUusklOqpY2KpnGtdo8rk6/MRAPq1mNM6b9xGUlEQo8mmGCxgqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773211; c=relaxed/simple;
	bh=FB3vxSlu4hIcjqB99Vn0G/Ex3nRoTtJXDYzEZ35BwcI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pwk7ditGFDQMfTK3uvxc3dsuhXKfcHncU/2+/YP4SelfECIWnNddU2/9+oLLwgx5y+ZM+YVnanOy1SptFRKxDnCe+gRl7riZ2QihsjHpHBGQSsjDRi7cGVUXiyAUyL1RGt/zFV/scrMCLPOPwuuQ/owD995IctMhgfVTZ5SL3F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TGDp6VOd; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGDp6VOd"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-551fc6d4a76so422719e87.0;
        Tue, 24 Jun 2025 06:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773208; x=1751378008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrOdE+R8rQ7wb6yuGln1m7tHcIz53gAsWt13GY/qj+U=;
        b=TGDp6VOd9J2e8KqagJhMQRctDs9xZtPU0VAarRPjQmeKapwm7tO4yuZaRR41C46h5p
         v30GkyYuD5vOq100O4N9/gzP8XFtsk5DDB0uhi15Gr9Hybn9NrVp1fnYuxNHbP5HFd06
         llFeFZY01o3ieprlDHhtf5gzIDtKlEsBMAPJX4mNlh29IzKIUMhG4RvqSmH0VJgcs/eG
         fogC6Jn3t1YvizFvX/+7WJhtvE9N2JxK39CgLujQ+tMFxUZGqFARMU6iBx0TyNGdSpGJ
         k4gBo1th6CH2AF9YGOZ6BRheCIZSOn75sE7qvF0yfDoN1J0vXVrXzwUHet1WkMixL02X
         8pCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773208; x=1751378008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XrOdE+R8rQ7wb6yuGln1m7tHcIz53gAsWt13GY/qj+U=;
        b=Se0H48YtZTIs0aVBRK2wVBZq+1Gf0RQOXMQ8JQ4LH2XZvnBet73Bo+KxG2qWyxtQPK
         Im4g3R2hs7tstPfpUS9jK+XP7i1tOQJkgV/1uBX85T2BKlhNjLFbVrdsxsa09D0PqygT
         3CRz5URi8T7t+scbwUwgFfim5OIFXYqjCGjhd/BodhJJwzg1zWERU/xwJUDXHS7Qhj17
         oXHZK3sfKrA4Pzh3boQg9aP0cI3KrWOStdpXVuoZnpkw1HtZxp4y4dVyTnYskKpDKLG6
         rXTCdtEidSVKvz3miNwL+Jb3iZ/BLbqjwP84GW4Xk4DWAKbQ6v0GlYssACm4YWM7avv9
         60KQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMWd+FohRFNPuTRjsWsW+t5W7XBRR0dYI7lf6TIcbjWnsNEUgqr1DN1EOmwawOmtIlrfDf50t/UTwT@vger.kernel.org, AJvYcCUehXpcpi36gfCJELa40FEgwWog2/8ViV3v0TekaX3Ps9pncul79WhPOGJHQzNtnWsLBpKdMVJF3EB/NFcB@vger.kernel.org
X-Gm-Message-State: AOJu0YyizSQQtb6EF0+/A4OxRu3eVN1eLdzauIljqsCKfy0LmP35QV4c
	gdFF/USIdqRSLw5J9/NxIVlifr1pmqtoQHHqfXsBuqGagvhDys8EA6sS
X-Gm-Gg: ASbGncuPXdgZUljrMThfkcQJ/3sltzC/vbJq0rMy76zMGnPYITo66WZ+hNpzBNGgVzx
	/DaS0fo/pn0xvbDjLZVnvxrcEDDYfigdUuDCbsNR21FrZjdjyMYDmhizac3aaUb0Aw0uxA+XXLU
	svBLnC6lbNfWxS4gfVdnjD/ZMIxQZOG5wB+tEAbGuQN0NT3jhZw+qhRIl5sqTiM2vGHEF5HnBO2
	4I14Yy/CEQJyOa8bzpjg38FRUBTLAUSdyXBzptf6jJAdGAtw+d3A3YG/4rxAFSvzudtE5xD20oL
	QSFgLuf/Afwv06Dq0gYABgdcZrZ0hmxn0UWtUO0ZD+q4YrXKoa9yDpHzTPJ/JySApW/CJFsevFy
	whPYXuiS3RfipgE1up5IE11T/23LrBBqaf/nhggfvInNI547qVLSNwDA9ntucyQ==
X-Google-Smtp-Source: AGHT+IHafsnl4ECTZ03u9TitK28MH2CBXpSvgAgKY7MlFSCMzj5F1inb04eM/bVapqiFOJ6IXEiRzA==
X-Received: by 2002:a05:6512:3a95:b0:553:aaf1:f63d with SMTP id 2adb3069b0e04-553e3cfd76fmr4317885e87.29.1750773207460;
        Tue, 24 Jun 2025 06:53:27 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:27 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 16/22] dt-bindings: crypto: amlogic,gxl-crypto: correct clk and interrupt lines
Date: Tue, 24 Jun 2025 16:52:08 +0300
Message-Id: <20250624135214.1355051-17-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
engine is hard-wired to a clk81 (CLKID_CLK81). Drop clock-names
field from schema: name "blkmv" is invalid and "clk81" is confusing
and sounds like something global.

Also, GXL crypto IP isn't connected to the second interrupt line.
This binding is useless, there are no users of this line.
We must remove it from dt-bindings.

Fixes: 7f7d115dfb51 ("dt-bindings: crypto: Add DT bindings documentation for amlogic-crypto")
Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../devicetree/bindings/crypto/amlogic,gxl-crypto.yaml | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index 948e11ebe4ee..fdc39797a2a9 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -20,20 +20,15 @@ properties:
   interrupts:
     items:
       - description: Interrupt for flow 0
-      - description: Interrupt for flow 1
 
   clocks:
     maxItems: 1
 
-  clock-names:
-    const: blkmv
-
 required:
   - compatible
   - reg
   - interrupts
   - clocks
-  - clock-names
 
 additionalProperties: false
 
@@ -46,7 +41,6 @@ examples:
     crypto: crypto-engine@c883e000 {
         compatible = "amlogic,gxl-crypto";
         reg = <0xc883e000 0x36>;
-        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>, <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
-        clocks = <&clkc CLKID_BLKMV>;
-        clock-names = "blkmv";
+        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
+        clocks = <&clkc CLKID_CLK81>;
     };
-- 
2.34.1

