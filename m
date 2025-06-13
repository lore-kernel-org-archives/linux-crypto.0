Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1962E62A0
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 11:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749814931; cv=none; b=Ki1HHmnN8BiacayXVQMHJKY4ZpRNeS8xNLxBmJVT64kis3zSn3wG29BhBMPWcv16wbRst/Woj6zl8gw6b45cLRPOd1be2CnbRKDurjcolaknzVIB8WGZf5sv1LRozr1KKqbBy4umJxkRNqxce5FdPq7FWweEKVB55HyHtONMfBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749814931; c=relaxed/simple;
	bh=UjOVwgtEo33Ysf1DyH6d5ldmTFzYDqKUhAyLQVB9wK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tg999t277mOgG9CQjF5l0lGJ+sueBXvM3ik9lMEOb0u2ypjpByhZiVf3N/xF3D1Zzvi5NY2SxSGyf6ReOaPLKlUGIy7iANnNo0nkT+8qOtqxP132cnLxvIk17wE0h7Rwa6jmFNql2xZ9H+YHJZLU50tw1Gnyebux8Pr63LtKx08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=plC9ULUn; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="plC9ULUn"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4a58c2430edso21389951cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 04:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1749814928; x=1750419728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WlKCQdBK9LWxBVakFnX+t2/73xtUBtXu9i2PrxiazI=;
        b=plC9ULUnylGNLltJ/YPUOz5o61tneqDQCbYUViWc8yRcJPbUutA6Wh91Nks0pGLaRf
         U4qg6GhJ7CdVGxJ61wwfrMgPl+Uim6usuvApWZXRXE7eIDHJfsnoRUIStFDxnv3bLLyH
         XE8XCoNTQ8G3ivf1V+3FwUh0Ru9V4giBSI2c/69kHiqgVwM2hNzL+8lEkRWWVEmZYKHr
         BuJDBHycreZiGgXiTAQMuO9ZOAWIofniBOkiLCZPn6c0C8USAc75ectbFb0iyNEREENB
         IZVZxKnNkiYbvyxMRcBnD0Igmgmkr4mjbCZia+NHjd381jTdr8OgVywYSAEvF7iD5hGD
         MZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749814928; x=1750419728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6WlKCQdBK9LWxBVakFnX+t2/73xtUBtXu9i2PrxiazI=;
        b=p9YmdXi4/UYv09J9TEfd8vkY8xYSOYfMVWb66n6pTeLB3RXroDlzybJbqmaafRjOOJ
         /TjzcSiXSXqIPVT7nVMCma7eUWylrEiEE7pRYEwKRqc+NYIMU8N5rsFkn0obXlNaXILA
         HUlC1E6C66A/TMEjVOomCb9tHVNtWbEsi8m7mbA9cAP6m63yV55eRkPm46kcOtg/kWNV
         ty8163wjBCGS12KJOr5jpHOaS14aBjAyi4fxyREMsq+k9iRvSUmf0HineNCiAVnDXWeZ
         Vl2QnyxzNX0XKcl+whmTYvcnvVGgwu+0GpZMKwrYmkQ4woWop4UBlPd8q2R33KuDcEOR
         6Veg==
X-Forwarded-Encrypted: i=1; AJvYcCW+0yR861mgCagUe+5G6g8k223o4by88w0JfHifr0Hopt/rwGYwLIEqPdoHlGI0C9AAfXH+tZVCizxrW00=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgM3ww8zfBywAEPDfM8q3BB6gme+GdqixHbjdhX9X8mqG0IPVJ
	ONBkiRCuD2zO73b5A6jwznoSORvNWTxiL9VTmq4r+56dK2Y6j0XX+LVM6DJ0tyWCy40=
X-Gm-Gg: ASbGncuiCEEa4Cs5sktQnCyPTvduBsm0K31BEq4lZVdWh7z+Ue0116nSxJbxC1KaOlW
	EQPdhxP4a5C2N59mQWrau2LC0bF2KuIKZt1p1yL7B58gB6uqvW0RPsGz2Jk95RBZzhH7vkvN2kZ
	zxKY6V7I5jPK5P4qv2bqJUxoJp0QMh75J2VHXT11w/4OyiuSTgspZ40DO51Hoai+60fDgsnBJiE
	83KAqODDdjlXZo6hMI+U+NIBIxAk1ETttW5TwGFBM63QuIwgac9+q3YRcozfMi0cJ3jzIGK+8He
	fx36mg4q/VJnOeliKDQxlbhze0HgIoX/fPQiVe9CPCPv24DtyvSRW6vIQ4w2H7vsF0EoWFYXqzK
	+wxBEDl2ggLc7j2uV2E2brg==
X-Google-Smtp-Source: AGHT+IGoxDxx9zyPnLwBJu/HgiS6b9JD+b3qfzp8/xdsORghv63P60xiRPkYDDUy+K9jds0kDneIzQ==
X-Received: by 2002:ac8:7dc2:0:b0:4a4:310b:7f0a with SMTP id d75a77b69052e-4a739328f1bmr4762501cf.10.1749814928381;
        Fri, 13 Jun 2025 04:42:08 -0700 (PDT)
Received: from fedora.. (cpe-109-60-82-18.zg3.cable.xnet.hr. [109.60.82.18])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6fb35b3058fsm20558206d6.37.2025.06.13.04.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 04:42:08 -0700 (PDT)
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
Subject: [PATCH v7 4/6] dma: xdmac: make it selectable for ARCH_LAN969X
Date: Fri, 13 Jun 2025 13:39:39 +0200
Message-ID: <20250613114148.1943267-5-robert.marko@sartura.hr>
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

LAN969x uses the Atmel XDMAC, so make it selectable for ARCH_LAN969X.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index db87dd2a07f7..0c3f14ab569f 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -111,7 +111,7 @@ config AT_HDMAC
 
 config AT_XDMAC
 	tristate "Atmel XDMA support"
-	depends on ARCH_AT91
+	depends on ARCH_AT91 || ARCH_LAN969X
 	select DMA_ENGINE
 	help
 	  Support the Atmel XDMA controller.
-- 
2.49.0

