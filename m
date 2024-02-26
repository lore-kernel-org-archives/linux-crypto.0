Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE901DA3A
	for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 11:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708948353; cv=none; b=SS6tO+veudCZalrybpLmijbozuLBb2LoAGieOejNEgmVmiqI4QptX4/YtpISAYvQ4dBm3ANvh3ibnZbIg963HqRIL1N+YCRRO4OnvSCUbhEbma1yesApTyogehNe9JLY2RqgpnasgVUv85HpypTOvL+rwGdrIgXYDBPlF12/1ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708948353; c=relaxed/simple;
	bh=BCspbtwrDy65BB7rOp5vz3y81XTaY6XHQSQGB8e5Fo0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UVg30nqY4+Uwe2xhkVngwfsolcC4NHbCvs1C8Bnrjbk1cXz2w3WgPQvmuH3lJTkUhNyUby3IjUqGqVNYLWcOEjbbUfpQI07MlK1rzMk8QGvUA9OAjOBf5Hmj8OOCP00LDlBua8fpyZ1YzLfehwwx2smzNheToIYwpUPmM+TAzN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mUnRJzQy; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mUnRJzQy"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a3e891b5e4eso339303866b.0
        for <linux-crypto@vger.kernel.org>; Mon, 26 Feb 2024 03:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708948349; x=1709553149; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qB8hWXSvkZbqLJ31D8l/uDsLKWgY2404VtdI5HHKIEY=;
        b=mUnRJzQyF1iolYW3eAIgAd0R/F/Jus4C48XGCR4njOqJXNK9janRL+hPcTTFw8sG8C
         /znvoGKpMx/mY9jLqPguJqiADZPoPqvIldi9T3/Y0ty09AJJaQvG3zFw+JNKkpGfhhXi
         Qkxe78m8axVtcoq02K78EuHT/LoyDfqudiUAGj4rRfgG4NhWb6ofEW1dEOFPK3zBmRUp
         ggPVpeqb107+ctWQui23CSORaV8SNkrq5Thr5yYf8/AZIdKsEl9kidEwyaQo7sQILOf/
         Uc0HMC6ytwtlPLunYAQV5qTs6ZzHtXsoc+yeIE9Vfgwf7MPzjDu5J9AcPhmPMBIP6cOX
         Me9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708948349; x=1709553149;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qB8hWXSvkZbqLJ31D8l/uDsLKWgY2404VtdI5HHKIEY=;
        b=WAjk7g4024T4di/oAHVDQ7tfb8ONZeP8wrW5lAkyQpDOjMtRZBShqySvOPo9cGwFI2
         b95CA7TTgL+r8NqhQpCOZBM5ducjajLqQnbbGJu/pAEqSVcQe0sRL9vAtBy5sVvknVt4
         Vyq3G0p1Rh7vFVb85Jxz0hPm3Xt3c0TWG26Y9Tnva7ygN60aTCc9Y7dZI16hnF509G2l
         Mevu2Fd4gqTEUCwZoBQTx8aTwSzvPTf2MDHRmPLQurgnerahfbBQ1ikCaCeqjMmACM2w
         PXKl9aKxnSAXV38d5QDs8SPJK4hyQvL22NSNi7q2PwOVCCALP2/0/Qh7jJq+RfbL9Baa
         fvHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlu5Mpp0u6ChhQ9JqDWC1RXOJj9+okvV7h83YdiARQgT4G725OAIFxsPksCh1Xq/r/DaXBfWjVK13481Au+k5AeXXI/+xlsmA0vzpD
X-Gm-Message-State: AOJu0YzCOenr97GcXjXm730Tet8ev58jBUT7Zf0u4TOpZSxkTEY2TRSI
	5GbHbJpH33h/dRKG4e48DLCAknI1XRqSRViVwVn5YWPdw1DPOazeW8CfJwOjMvA=
X-Google-Smtp-Source: AGHT+IF8nZj2AxIU8pGo453OtUaGq+NyQ4OirQx0LwfQNcLkXJfG2Vu4AamqJIoyTfiPDFE9fbm0Ig==
X-Received: by 2002:a17:906:2e89:b0:a3f:5144:ada2 with SMTP id o9-20020a1709062e8900b00a3f5144ada2mr4942148eji.2.1708948349541;
        Mon, 26 Feb 2024 03:52:29 -0800 (PST)
Received: from 1.. ([79.115.63.202])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709064a0900b00a3d153fba90sm2328999eju.220.2024.02.26.03.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 03:52:29 -0800 (PST)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
To: claudiu.beznea@tuxon.dev,
	nicolas.ferre@microchip.com
Cc: dmaengine@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH v2] MAINTAINERS: Remove T Ambarus from few mchp entries
Date: Mon, 26 Feb 2024 13:52:25 +0200
Message-Id: <20240226115225.75675-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1536; i=tudor.ambarus@linaro.org; h=from:subject; bh=BCspbtwrDy65BB7rOp5vz3y81XTaY6XHQSQGB8e5Fo0=; b=owEBbQGS/pANAwAKAUtVT0eljRTpAcsmYgBl3Ht5X/XCQnIus7mvWtg0Lsru8nzZ50DOo0DbB MejgeqpNFOJATMEAAEKAB0WIQQdQirKzw7IbV4d/t9LVU9HpY0U6QUCZdx7eQAKCRBLVU9HpY0U 6Q0OB/9/8s7uW+XXz7vgrg8wAJxmRQkx0Dkl1yCpnGHa8UxC3I8g3KZx/LyeB4cZAIDa3lyLDLI dbPlxvq+sB4jGQkzIZumZEIf/DCIbx3TcDxiTqtNl3Q6GaBMuCarpXsK7/E4g2Ho1DGAmBbuRid XtP2GTIu06CaR9ctAoPrdbr2RFiAr0nB2yOLcSjxiHmLIXop09uU4iAIlbOUziE+4cM70AbOMLX A2uMAPr+t/0ORkizGNJT8/zIvisNxpdMxTVhAHBD4y6kpENvKaShsop8mAFy8X70+TNxP+7aWtX ddrEC5AxeDtAMdNq7sfBwInmw3zlYXFw4BXbOymWMnCZlvew
X-Developer-Key: i=tudor.ambarus@linaro.org; a=openpgp; fpr=280B06FD4CAAD2980C46DDDF4DB1B079AD29CF3D
Content-Transfer-Encoding: 8bit

I have been no longer at Microchip for more than a year and I'm no
longer interested in maintaining these drivers. Let other mchp people
step up, thus remove myself. Thanks for the nice collaboration everyone!

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
Shall go through the at91 tree.

v2: make entries as orphan instead of removing them

 MAINTAINERS | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e1475ca38ff2..bce0ae12d599 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14350,7 +14350,6 @@ F:	drivers/misc/xilinx_tmr_manager.c
 
 MICROCHIP AT91 DMA DRIVERS
 M:	Ludovic Desroches <ludovic.desroches@microchip.com>
-M:	Tudor Ambarus <tudor.ambarus@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	dmaengine@vger.kernel.org
 S:	Supported
@@ -14399,9 +14398,8 @@ F:	Documentation/devicetree/bindings/media/microchip,csi2dc.yaml
 F:	drivers/media/platform/microchip/microchip-csi2dc.c
 
 MICROCHIP ECC DRIVER
-M:	Tudor Ambarus <tudor.ambarus@linaro.org>
 L:	linux-crypto@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/crypto/atmel-ecc.*
 
 MICROCHIP EIC DRIVER
@@ -14506,9 +14504,8 @@ S:	Maintained
 F:	drivers/mmc/host/atmel-mci.c
 
 MICROCHIP NAND DRIVER
-M:	Tudor Ambarus <tudor.ambarus@linaro.org>
 L:	linux-mtd@lists.infradead.org
-S:	Supported
+S:	Orphan
 F:	Documentation/devicetree/bindings/mtd/atmel-nand.txt
 F:	drivers/mtd/nand/raw/atmel/*
 
-- 
2.34.1

