Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C3F2F6FB0
	for <linux-crypto@vger.kernel.org>; Wed,  2 Jul 2025 18:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751481608; cv=none; b=XrcMUYCTxPkBbBY00gpWBNOQb+f3johDeOVriM5ypqCBCr8BxkhlDpZcfRY9MNylHyHttNYhELt4m2LK4/VOvkYCit0/zkLa1wJ5jyCVN2IA99ao5YxkEWxq/TlaNARVTsv2l+gjiigcnAMRJVEIgbAJOB75YxQOCy6HHW2mcss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751481608; c=relaxed/simple;
	bh=F6mJ3voGjUkQtf+0vAv2Qcihci6oK1DMUpz/FxyVtPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQBOsFdOg/u3Hoj9u16KefRbqCN/8rHsgXdAgwYca/g+RLbnq8TPhwSL5YejKMfkMfQHiroz5d4IgvxX9XGLtKl607tI5ADXXtR1bUbn1EuNTILad3bedl1zLNIMe5aqZ142az6ZubRUy1jUL13un6ZBQwxfo29XCUscJgOxFck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=ecBqhTYv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="ecBqhTYv"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23636167afeso46193385ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jul 2025 11:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1751481607; x=1752086407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbC/GH7strBGwb0IdiVA7md1jfacDKOVYkS3o8tcID0=;
        b=ecBqhTYv0hRooOBvI24/4iP/zgUK2IigwYvfFYISQFRMloFFOaQHLu0va/BSmYQgA+
         1TL6cbtR7PX3ubrW0AQUqOJGN+kieja0LvdoauASfFdYsX0LXn4Ty556aEtUxiwefdOp
         2kk+nvcF0TNNB7sQgDRsnI+vAyAE75IQI4zVvR9sYCEIKRlDRZ5EE0xu4wERBZisz0JA
         axhw7QLczIqIh5aSnS/dNCpSrvzu8OKZWxg5XIRb/ix4Qsw9a1XZShq99HmWiIxbldU1
         s4uTAqhECBVgFKBmNnGrky3yiMmjH0z53yaP1B0G6n11MLChfbyGG3ZqF5vsEcIpg2ua
         AlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751481607; x=1752086407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbC/GH7strBGwb0IdiVA7md1jfacDKOVYkS3o8tcID0=;
        b=chlN0Ckkfem7yLyraDLLeoZTbPZWHVIBRML6G8HdcsqfJKAGjdCPAV4VMkNLt03SVL
         508WhMdeJqaMXYy5BeBmesZquLZ1bQAw3Gt1tmDEFqEMKU8Wa/EXnx9WhNGsB23mRP6e
         /UIaelSPQ8ltbBF8K46AhiJ2vzw8AidJO65kWDiue/R9rxFi24Xsd1krxEiDA2SW7w2a
         hFcfA2gTOann9wIz4sw5tlVNjgc63NJdYME11I19/wkfBJumG9se75xt2V1l4Lwg/RWR
         lvJKda63mm8cIvM5OnUVURHCfRSCjgkvJoiObvICnKH3kmGSPx3gVUVbd91BLyGznmuM
         USsg==
X-Forwarded-Encrypted: i=1; AJvYcCUvCpXInjJXuHlmbPERyzrNOu3aOPgFe1oI4y7aD3PK2y50k0BDCTA0bDLp7+8jWJEQ3kbeqGGy6p4BIV4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxew99/BPRkj/OqFLi1Ze/rbJQUtLk808TWgcwC4R7NBtbWr2fB
	6NAChKfNDBgUjfloKHuUsVzOiTHep/6ukl+XNCN2seRuAgOegfD3ZNFMNqXVG/dCKhs=
X-Gm-Gg: ASbGncu7LMRG8esh9dz7NKn8tA8oCFBUWmH/DCzv86K6YwpHu05rl9H3cEAHMU/BxXc
	SLv7Md/zSnhmsXzguOfzRfeQjQNlh+luwpO84bs9or5QdUgvIAGO3qzpe5vZrViXA7Ez2WVXAtW
	Q453LDV9NuHs0q80TBVtNGws0sC7/TwZKGLIkHqi4ZgR50qjPFrW4a4FKMA0hvMDsxIV1bQx00y
	K1x6XCSGcWFtgmqHCGbAxfqAUPg8C1bXrYIN0EWLoiFFzAYXiNDKxMxqYJLC+5danhnyQ2Seme6
	mBMsKfJSJ24bjKSQ2Nh7Sfoanj4AGF9NP5j/LfK/tJGd0cfzv+b0gnK1XuIBQXE/dmq98OHBzUX
	YyegvX04G0vFYUx1B0PbFens=
X-Google-Smtp-Source: AGHT+IFr57CoKx0dtGw3L8LbGIOnkIEZXLju9E0LUunBcEwcIBFNROCo+7NEiDnUKvwkV1U4hmG4cA==
X-Received: by 2002:a17:903:2f8a:b0:234:dd3f:80fd with SMTP id d9443c01a7336-23c6e4dbafcmr49910685ad.2.1751481606631;
        Wed, 02 Jul 2025 11:40:06 -0700 (PDT)
Received: from fedora (cpe-94-253-164-144.zg.cable.xnet.hr. [94.253.164.144])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-23acb2f39bdsm143034195ad.80.2025.07.02.11.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 11:40:06 -0700 (PDT)
From: Robert Marko <robert.marko@sartura.hr>
To: linux@armlinux.org.uk,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	catalin.marinas@arm.com,
	will@kernel.org,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	andi.shyti@kernel.org,
	lee@kernel.org,
	broonie@kernel.org,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	arnd@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	o.rempel@pengutronix.de,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v8 08/10] dma: xdmac: make it selectable for ARCH_MICROCHIP
Date: Wed,  2 Jul 2025 20:36:06 +0200
Message-ID: <20250702183856.1727275-9-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250702183856.1727275-1-robert.marko@sartura.hr>
References: <20250702183856.1727275-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAN969x uses the Atmel XDMAC, so make it selectable for ARCH_MICROCHIP to
avoid needing to update depends in future if other Microchip SoC-s use it
as well.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v8:
* Use ARCH_MICROCHIP for depends as its now selected by both ARM and ARM64
Microchip SoC-s

 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 3bc79f320540..05c7c7d9e5a4 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -110,7 +110,7 @@ config AT_HDMAC
 
 config AT_XDMAC
 	tristate "Atmel XDMA support"
-	depends on ARCH_AT91
+	depends on ARCH_MICROCHIP
 	select DMA_ENGINE
 	help
 	  Support the Atmel XDMA controller.
-- 
2.50.0

