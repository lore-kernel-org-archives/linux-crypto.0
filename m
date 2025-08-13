Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA7429B226
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 17:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107274; cv=none; b=pi2JQ0RZS45LptUIMBt4lRfNdMg8C6CvgFMoJDycDOvWLZCBFlydaFG8PZ27pKoVTZ246O6O/Pp280t61QNigFNoN4mVxWkiREjSgi/y0RtPhuiAla2juPPj2HMjpLSsbIhQUcYaLQk+u6cFQQ7ujTmCkTbZJ6+2B9n4FMl4UaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107274; c=relaxed/simple;
	bh=/+oZqZHI1h9WgghpCqBvJzy9LGRR42vTOm/KVnlDk38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgsJS6wSxrglLBUqE7dMwBWF91hjER8WI9BDC4Juzxx0Se0z4hkebJ5enUpVaMj7Y+K4FnDgiWkq/tuALOyRBl4t6OTxuURaV4/keTtQk+WePgouIH2jQMWSDvxRTVQ5fUizSN7OOMrnKttB41QUPe7jkelsPrGx0ncsAte/QE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=kFW7/Cap; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="kFW7/Cap"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7e8706ac44eso8366185a.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 10:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1755107272; x=1755712072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHeBX+bcrAsO9afYXWyPr7+HVV+gOxB4ZyOYt9ZHb8s=;
        b=kFW7/CapgBjqXy0radKy0GWHUNIVOiivw2/rsDNMRsE3FQ8/ZQsZgmwWXPi+eTFNES
         x659WxQMaAe1C6C7XMajkIdnQEU8QWR/cR++KYKluRQxkNqwpR3PxG2WFSLzDsdphcP7
         6jxGxViOSo7w0vwxP3U+GEjPpK1m0NfSD/0huhESrALNBYcLgAmp5DRelfFTwVp4VwsX
         dUsrv6C52NWSNFQjopefpKwbANhUU4nzRUmnyOu0XlmWV6BQYqQGmuYDGwykI3VKOcWU
         uJzqCWcGbGnZQ94hNMtn8+8cetmvqgMPKJEX+yCX4Ftt/SUxA1RFdsbDEklI4ILZ3nQZ
         eP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755107272; x=1755712072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KHeBX+bcrAsO9afYXWyPr7+HVV+gOxB4ZyOYt9ZHb8s=;
        b=lb7A9y1SOLxMXoS7JaHYK/G6xuapInTbBEZ7iGGTHBsHEyzm1BVc1QR2hbt4kq8Gn/
         vDRg7aTVOEnrgznxJaFcEdz/28QayJV9hSGUsC651gtewJjW5fMJpUBUAhhZ8DIyQPT3
         eW3BztyJnDIQhr7Aeiec4jwBYJzrn/G+6mjiNOPSKeXGsmvFkx3Mn7xXQaiI5HBOrJSe
         ku0n//u4DkDa2l51/h0O5I1i1Ix92TE/954CQ91Lm0cHtqeKizUQq3dtSBcuMi8MQZ8T
         GyKubD5ebJM2RyMCoPYqoWtFuCS3hsPUCuLPQJu2CS1VuuFVLcZYiFp7fTQBvkrnWh3a
         VYlA==
X-Forwarded-Encrypted: i=1; AJvYcCWaJiIJ0KVc8ISy6bxkFFJbPU+SSszGlgtXnpBTfxYcjC08aoSi87RMw32KQ6WoN2l+uDRqQc+T0bFd22c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtA4MJLoEpD/DEbWU4va3dtMxsXz+2Cvl4VuVi9tlhG7p1AgY+
	4d1bnlc8G+3tk5GrypZ5rcUugL+/0Ln6ETl0p55QtLaacRknomlp3anCO371Lcw6tmI=
X-Gm-Gg: ASbGncted/ATMzt8Tl9ZMMPrI4HWz35O9A1Jyc8mHur69AL6+AYXChSHRIZtfbPb7Qr
	DIbM3Zx6CjrVljO8QqQCQzVaoXgLCHDK8FfBSm+8pY4V1C5Mh4U7yd5Tjxr1mWx0DjYaIxKjQnR
	GuBAmGIHslav5gEee+nGkLKCC6NbssxlJbsj77K01DxQuZELXnLZW64Fg8qfWWYF/AK7HQufbKy
	F2VCF/tnavw3Mdbk5doJR0PCw3mlYRd9TprA0zUEjYQKuHkhpQlWa+REYS6flzHYZTWnGfa0o+W
	nHadwbAR0rt9ErY0FKg2+no63R/JC2xVmGjZss5btpheIcSnxfKum4qh3cRfXlE1HylwU+stvVn
	KM90fMUoS5F6gmjKi3CnzCh10U/yRIXC57l0AWm2dOECNHPpiPbVrgNw45tE51/g=
X-Google-Smtp-Source: AGHT+IFBbRD05COD+4uOC97ucvpHyx0jBQqfnQDIsz8+GmCzNdE1TPU770o9CrOuegUdmCbSDq2ITA==
X-Received: by 2002:a37:f50d:0:b0:7e6:5ef5:c7e4 with SMTP id af79cd13be357-7e8705d2e04mr26126585a.64.1755107272247;
        Wed, 13 Aug 2025 10:47:52 -0700 (PDT)
Received: from fedora (d-zg2-251.globalnet.hr. [213.149.37.251])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e7fa87e7d0sm1627122385a.82.2025.08.13.10.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 10:47:51 -0700 (PDT)
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
Subject: [PATCH v9 5/9] tty: serial: atmel: make it selectable for ARCH_MICROCHIP
Date: Wed, 13 Aug 2025 19:44:41 +0200
Message-ID: <20250813174720.540015-6-robert.marko@sartura.hr>
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

LAN969x uses the Atmel USART serial, so make it selectable for
ARCH_MICROCHIP to avoid needing to update depends in future if other
Microchip SoC-s use it as well.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 44427415a80d..724ad4f3cbee 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -128,7 +128,7 @@ config SERIAL_SB1250_DUART_CONSOLE
 config SERIAL_ATMEL
 	bool "AT91 on-chip serial port support"
 	depends on COMMON_CLK
-	depends on ARCH_AT91 || ARCH_LAN969X || COMPILE_TEST
+	depends on ARCH_MICROCHIP || COMPILE_TEST
 	select SERIAL_CORE
 	select SERIAL_MCTRL_GPIO if GPIOLIB
 	select MFD_AT91_USART
-- 
2.50.1

