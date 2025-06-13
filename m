Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8392E62D9
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 11:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749814934; cv=none; b=Nt4K40u8+NuigZXkb1VFj63OFgeq92HHw5cNRGoKK9p5sfYvC2Cgpy2ST15Dte7QjjWNNumA6UAune83SGppgtlRwjPnZ2V1HUMv0QY3C/0dfcAtcpKyjWBuTMfk8Dq+4RPKwe45idlxkP2B7puAtO1iYoIyQ3G4RA2wXOMOe3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749814934; c=relaxed/simple;
	bh=Nl0M0mtMMwH3HQiDa6E6C3fv9pPm34SWpTCcbO9Pcds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpxFiAiyg9ZueDW6YGpQfWkQ7v+ZWBkEYMV3THKfr5Jy75Xcy8qjnb5r0GVi81bz7UNl1hMqpUW1P0z7XAvPUYQZr9Sm53wv7iw3CPj++ddV93nkoJHW9lKR90sWewgYOfklSRuAZkPkRO429mYkA+QVsWu2HKUhK1fUDXtbGNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=y6ceaVp2; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="y6ceaVp2"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7306482f958so1356271a34.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 04:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1749814932; x=1750419732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PE5/rsY41g/vAp/0hcg6OhOgOrChXE3RFe9mIYZZ5WM=;
        b=y6ceaVp2CQcBou9Cp4Y5oNH0xtPtDgIeDv9QAP0Sn/WJFUywu4fOWBXjGxAIl2nvcg
         QktQReL8/JROek6VZ1O7cDxCPThbPChtqnvE3xoJ+eF4DM5rI4NYWczLBafDWsl2UVWp
         Ugr/oqG+VpiO6NA4GwSlMBAajYAN5g1O1/vSAGnfCMoBieaCfpCTDhWEBLJU9jsUJVpe
         /xQfBdY3ol5KNbnfB0kgis6qGHrtePEuePTjrVKg9uNXvzQ2aMcRzFaVYYF2fMBuvtyP
         /dZ2TCswCfssYbQ34tClHs4/tRVpE8R+7APjPZu/7RzqX9oAzPPx0my9Q9Unrv+Lp627
         AFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749814932; x=1750419732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PE5/rsY41g/vAp/0hcg6OhOgOrChXE3RFe9mIYZZ5WM=;
        b=qnfMNPSRsIc8rmZ71Se/nrAMwQfHQVNDkrkHTqj/WCyXsRPjFgxk84R63OYHUgfY4Z
         0SblcaBfK1qam3ThdlF1dB1Os/QX1kH0ovzQhJ6NHjH9RMl2ykpE8z6Kh35BHrNrD8CN
         5nRb1hTfGPlaLkGHOAcgNzbPjgR0n7DMmN4WUz0sSnUhTHQu8FRKyZZ/Im+j4qG+53wR
         A0bWNRpPWaUs7SUeTf3BGRimuXzFT8TC/5n2ze6Z3SwJsqdxOgsv1U61NbuG/mWXVb4B
         HQnkhjztxXfDdF5sRDvcO/84y/kApXc/tmXC0bfIDTYF2Mqs6nRX7B5bcQITVxN1zCiw
         fJNg==
X-Forwarded-Encrypted: i=1; AJvYcCWzn7Df9pk/5jvOYA3pw3dHgzzYaR3bDpn35BcA84vnBVyFOhzzJ24FksnkB9SJpAQS6hSsLQgY+LexPJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGvGnhoDt0gazFqfc95KixntEmDvjPYGzqvQDuMGdeTl7ghe3p
	CnS3Emf+mvrMNxgC42c1JA/qlALT00CbRJ1ZyTJYIK9VF1pWuCsDB55xVp/ISXIiOlLjv9rG20h
	gKmuS
X-Gm-Gg: ASbGncsYnjkATVWb2MRE/h9RZH018dPr+7MbF9lciDq+Gcj8WwX4reMmuLQKk9rz38R
	hLQRtBnBduljOnWLBNAuTb0c2zubiNhEQLT9HjBm8MQwBS/QBcFHbnPfTA4hsPZ+dsrx1rJL4Qg
	1oJI/bolcu2GF9cwYxetn7BQfIdk/SppMK/3fzRbUEhtTQgoflkWMahF23qMk7HT79A3PAflx3E
	GMZN3l/PzbkuHrKd7yGG7Co+daQs4IZgCuEfN3koXJINj6RxnS8s5HLeDtmZFXJqblZp/qQJI5M
	ebzN0HmaJ12q3YPXNEfXXxUaOtU+WqagukuCWK3hBM1bLVHCogR6iC37kvSGUMgwq283m8k/Fvz
	T0MXz6AI6gWbwD/wmE8fFuQ==
X-Google-Smtp-Source: AGHT+IF3wVYZI/s3wM1PNe5izmwye5C2dxIzh460VAl75DrcM6tXXLw5OFqnGApeHtjQqkaMBAsXNA==
X-Received: by 2002:ad4:5ce1:0:b0:6fa:eaf9:89f1 with SMTP id 6a1803df08f44-6fb3e685f23mr33483696d6.44.1749814921454;
        Fri, 13 Jun 2025 04:42:01 -0700 (PDT)
Received: from fedora.. (cpe-109-60-82-18.zg3.cable.xnet.hr. [109.60.82.18])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6fb35b3058fsm20558206d6.37.2025.06.13.04.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 04:42:01 -0700 (PDT)
From: Robert Marko <robert.marko@sartura.hr>
To: catalin.marinas@arm.com,
	will@kernel.org,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	andi.shyti@kernel.org,
	broonie@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org,
	kernel@pengutronix.de,
	ore@pengutronix.de,
	luka.perkov@sartura.hr,
	arnd@arndb.de,
	daniel.machon@microchip.com
Cc: Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v7 2/6] spi: atmel: make it selectable for ARCH_LAN969X
Date: Fri, 13 Jun 2025 13:39:37 +0200
Message-ID: <20250613114148.1943267-3-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613114148.1943267-1-robert.marko@sartura.hr>
References: <20250613114148.1943267-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAN969x uses the Atmel SPI, so make it selectable for ARCH_LAN969X.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 60eb65c927b1..3b0ee0f6cb6a 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -145,7 +145,7 @@ config SPI_ASPEED_SMC
 
 config SPI_ATMEL
 	tristate "Atmel SPI Controller"
-	depends on ARCH_AT91 || COMPILE_TEST
+	depends on ARCH_AT91 || ARCH_LAN969X || COMPILE_TEST
 	depends on OF
 	help
 	  This selects a driver for the Atmel SPI Controller, present on
-- 
2.49.0

