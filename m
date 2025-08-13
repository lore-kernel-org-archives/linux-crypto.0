Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1267128C2BC
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 17:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107262; cv=none; b=ipMdy8HumOfymePmeEbVbmdkpwnkb7aPYZ6tziaDqVZURLOpLI9vGPjmTPQJTx76ZlmljgvLCkAqJs/Nacqsov6I7DW4+3NRAojBISqLDK9qjWPFNS0npLuouX0pbA26Sq01MebXa6iTeEymqdy4v860ElxFN5KkZLARgnUPKgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107262; c=relaxed/simple;
	bh=RL3Rsz0aJlOWFxlh2UakRKpVFid+fQ5BHQzpFq6zABI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r04TUQSuM0zg0mKMF9gwS56tmF6fvfQobkMFVjSEpilcLEmdpOLWx5M+cUwPD4D98f34NRtUhcApqRSu2v1R7IyYFJKrg7sGmA4yRUV1rWdPGUQlNPi2MMS7GZ/QIizPl3V0ef5tzNlTBMszduVkAVb7aMHfcvoOR/F+dV9zMcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=fw7/ZPTF; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="fw7/ZPTF"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7e87030df79so8940585a.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 10:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1755107260; x=1755712060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtMzSO7UPmjR47X20+ZqBD1uhyLdG+1s/Zrtcgs7erg=;
        b=fw7/ZPTF6jxg1uaCEZj4Aq29AqS+wxQkqaLK6z57NRPX2Jkxw6qzH8icX8ROKctnTO
         YHRR50dsGuEO1nkXZhGbWBFX5XoDqZXabtWFi7m6eKgl6a43mz5J5yHsMPvA2sRUOU2S
         tXblc2C4heR+M9IKeVxDBaljPVUYF7x/NYNpNl3HSGQISa9Xd7rVTbbMuoiGZzkI06Wr
         TEf2I0eP2jZ9CiRgIp/hmYufKsv9v/HeWlfCW27vFuPD4objIAhvi3ZJJ+LZyQKgLusb
         P2GwwiX9qeu4ZjYZrwIDEnjNb0CTR12lJr9bA+kqTfY9YJNykzYZSSe+NZPf5CDU57k8
         ctRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755107260; x=1755712060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtMzSO7UPmjR47X20+ZqBD1uhyLdG+1s/Zrtcgs7erg=;
        b=U0rKK/VBEHJtRjl7UXBLGN4oCSOQIHXYvwP9DbQrIXlyElvceVxORhMUJZG3bbNToz
         i2vwXGVfLoosTzCxotI07u932fwATzLLl8X6l/jg9WyGkCWVyb6cZvM4AmLG3/y4f4d5
         vyyLsH/IBjDJ4IppcxLC1d8sr42unxwkul+7jL8ghuDjIQK1k2WLMgZ2q82RZ2p25ktN
         fM6ju+RST+FzKH3dfYXUfzFtgtmjGY5CfCw3EGcpAKKZyTjSPIXv3BrXQ+CGVPFbfXTG
         ujP4JmNXmc713ujXGmnCULnuLFyRF7bGue8wG3LT3W8wGtjWQPzQilC1X8wJl9Uqze8c
         IiGA==
X-Forwarded-Encrypted: i=1; AJvYcCU1Csuj/tqlL5rvOBhosdFeAezO7aP3u6nqCfBhfTLoc2+4EXbMmqM3UVmDr2n4Oy8XnlOmaoHgqsWVz3A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi9D8pjDSunp+J9rL9pMbg5GJ9FAnsSJZ/tElm8YMFhT3WHHWr
	Gl6lwFMwpRLDft6ah2ZwM0Rq3JR+SttrUQopKlLPSWHGLuyrksfelIWyvgI0EGQOqvc=
X-Gm-Gg: ASbGnctuc9YsqKkroJuqvE5VQl3i62/v+u9XLLyDnEvZOciqpoloK0StiTkJnRXuY0g
	pjEFqqAdYGi7e1NH0ULMqhE8eNZ9iuO1Ddc5PhCh3r9fMQxsG6E+Jk7eOu8BjBPaEyJ392JcB3M
	Wux+UZ5518hmakDs0qE85UZF0SQB+C/cz7z7pKgwmo+kpcKwmSe7enBhY3Wp1KXx7CZKsf9mMS1
	dC+ZgQgF6fSiwG0TcasnQU9Z9PLY32BysIwPi16KEf8knKhNPL/lq8vNMs8SfKE0iTl8wGsJcSb
	o7fOiOTPpTjKp8B//VjuByZkdJw7rOSJG/lxLnt7HN08e0gmtJbXalo3hz2AAZ5Secmek/EpmK8
	qwFBU7EPdDpJsltorxw8cYfkxAO7xQWPiAHqekp8oXPqtTycKj+zr
X-Google-Smtp-Source: AGHT+IEOA4KVOCs5eFfidLnPllBwbdP8If2rCIZC+fPOPK1dPvbgpwik/9+siLqevJw3jKgUeh5nYA==
X-Received: by 2002:a05:620a:bc3:b0:7e3:60cf:c037 with SMTP id af79cd13be357-7e870593e0amr23464085a.34.1755107260046;
        Wed, 13 Aug 2025 10:47:40 -0700 (PDT)
Received: from fedora (d-zg2-251.globalnet.hr. [213.149.37.251])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e7fa87e7d0sm1627122385a.82.2025.08.13.10.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 10:47:39 -0700 (PDT)
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
	andi.shyti@kernel.org,
	lee@kernel.org,
	broonie@kernel.org,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	arnd@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	o.rempel@pengutronix.de,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v9 2/9] ARM: at91: select ARCH_MICROCHIP
Date: Wed, 13 Aug 2025 19:44:38 +0200
Message-ID: <20250813174720.540015-3-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813174720.540015-1-robert.marko@sartura.hr>
References: <20250813174720.540015-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like with the ARM64 Microchip platforms, lets add a generic ARCH_MICROCHIP
symbol and select it so that drivers that are reused for multiple product
generation or lines, can just depend on it instead of adding each SoC
symbol as their dependencies.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 arch/arm/mach-at91/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 04bd91c72521..c5ef27e3cd8f 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+config ARCH_MICROCHIP
+	bool
+
 menuconfig ARCH_AT91
 	bool "AT91/Microchip SoCs"
 	depends on (CPU_LITTLE_ENDIAN && (ARCH_MULTI_V4T || ARCH_MULTI_V5)) || \
@@ -8,6 +11,7 @@ menuconfig ARCH_AT91
 	select GPIOLIB
 	select PINCTRL
 	select SOC_BUS
+	select ARCH_MICROCHIP
 
 if ARCH_AT91
 config SOC_SAMV7
-- 
2.50.1

