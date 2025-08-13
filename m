Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB6B2BDC32
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 17:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107290; cv=none; b=KXTD13Yu1F8XKWRVx5gs9SY8K0u9JcMKZisZmscLki3A3Of6STgO4z4XZpRj+bqKdnYlcIK9OwPtF7XqN5fDyNZ/JJH9hwDmjOxyj3YHVojLaQSxvdBE2qht1aQX0MbwMjOB9J3tsXJO/GFAd2u/7raIs6cb51O3a/sa+meWnEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107290; c=relaxed/simple;
	bh=wVsDz7PLWcqLuNDyAizM/2yV2YynzKGFnsWWEvqGeqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9cpvNBXqoAiP7MKqD/i0fiL+Uz6pADcPNpBmTp3J/EuOkdC/9hGotmTJqyq+06J39wQLLCW1yEPUGMXLlFiq3VF/fH0LalsHOZE6NuiASVMd26DBUpfmyiRkPSsebCLgCw7rhQ1zJR2nxPUiBBw2LyIS/LvxKoia4Gd/Mbnifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=uCEjxzL9; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="uCEjxzL9"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7e87068760bso6729185a.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 10:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1755107288; x=1755712088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NR9O5hej1zVdBrSrvTEY2n8cN8r/rUR8l5graqaiob8=;
        b=uCEjxzL9d6OxCyOhmQi3vdf6Zth+dnpTgzkFmF62rxI5lmbr9a7I3BT+Aqjv0s6LUV
         U9DBnlwEVGCAp/MeK/dxdFk1den0Y1v99dvqjj1SN+h1nI7sWIoVXEVfUNysmXYHEEiK
         fNLCmV5VNMAeiuRdQwa41npfs5rCwwEgsK5qqWlA30Kz4rvpyVWvqUgeNELha7yacjbq
         L2I/M3nup5RK+UmDwy5nsMUiczXNqhWxVz/yBQE2AySs8JD0jsnD1lMR24wMQDsdyedN
         pazjC5kLX5m1eILw5+jAU3+e+g6pW+2vy3F3PMPrZ+gaznpdDOQAyEdU3pLTcvYy4NcM
         5nPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755107288; x=1755712088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NR9O5hej1zVdBrSrvTEY2n8cN8r/rUR8l5graqaiob8=;
        b=w8xXwkg2JURspk+O89nLkY3vUQARuihh3A4g7cPM3I/RqpiTCD+G8J+qWlUHqaJi4B
         JPgakdeoOtEX76wkQzzhRQx8RAPB8472AOrhyxyZ7tz/1ZmDh/RAgAHsTAaRMTlsGbU/
         jiNHN+0wFqeizWt88nQt6J1PiwJMXiKRk/dXEQk1uCzlEAazM7mhh3P4JKtMUZvCobUH
         6A+lNojZowl10vlXSJr3T+6RWsijXRaOdZUyX1YmNhlrrA9vrAnyeYVOBe9D5lzWP/dW
         UmhorMprfVG6w3f8b/9dic3TKvj84OaK8JHq8bTiTgzzcvDNd/kwyA77dyXB/bWqvzMf
         x6EA==
X-Forwarded-Encrypted: i=1; AJvYcCWHqp8AiEiorTwkr0Ws7LqrtEEnFWtmLcBUyEAn2eJbZzulz7AWuqnTIZwaEWK6Q/5n+6bOEBGXYsSCvKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWjw1FAOyq8rPyJgDbQdF6SRjAWj/FJzcRfKxjkC0Hk2u6KwFn
	90anqpNT2WVdtPoHSUp5VHRtuHMaMqHLvBEhrgA190ZbGo7WxIxqEwG0TWeudRe2wLM=
X-Gm-Gg: ASbGncuw1bJvYF5aoS9G9ev3oWqpf0nB1lyBOnARsZv2QTc/MVc9nUjMeQv3Sp9CYQ7
	IOSBdOW4PnKT3cBKaRaunHgOXY9TDJSMPQDt9KLHYP3TKv6txpwAG10XUBtTkijn788u2TmaLcI
	v1PQLui36qeeZxJNxEXU/XDAKn1bP/k+e2H+wD3129RSgoshLIPVRkATR0etVT0U6cB0nTcapbF
	l/MRjZY0YqC/SBGIcQ4Zstt0RkgQYSiVhcStaIkGMXNCbYUgtCWEqpza4JO0dVJdXYEJuGybF9d
	sgMT25GuGbzDMr3eAq/HC3KAHw+sezw2KQftHlsUUjW15bSr2dj4B6K0bMJrDnR4o2n/4ZRryJV
	8mbTJhLqtb+bQC3ufzpy22SU0rwAXZ+kKlOwrhjAbLA==
X-Google-Smtp-Source: AGHT+IFRs83sDqTRyEN7DfReHLOYn68Vpzc0LCiQZFoDgh8bJ2M9bgboNPmgbUyMB+oLX7FeYNZzXA==
X-Received: by 2002:a05:620a:1724:b0:7e7:12c1:8f93 with SMTP id af79cd13be357-7e870600b91mr33016285a.63.1755107288221;
        Wed, 13 Aug 2025 10:48:08 -0700 (PDT)
Received: from fedora (d-zg2-251.globalnet.hr. [213.149.37.251])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e7fa87e7d0sm1627122385a.82.2025.08.13.10.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 10:48:07 -0700 (PDT)
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
Subject: [PATCH v9 9/9] crypto: atmel-aes: make it selectable for ARCH_MICROCHIP
Date: Wed, 13 Aug 2025 19:44:45 +0200
Message-ID: <20250813174720.540015-10-robert.marko@sartura.hr>
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

LAN969x uses the Atmel crypto, so make it selectable for ARCH_MICROCHIP to
avoid needing to update depends in future if other Microchip SoC-s use it
as well.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v8:
* Use ARCH_MICROCHIP for depends as its now selected by both ARM and ARM64
Microchip SoC-s

 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 04b4c43b6bae..7c1717c35b76 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -439,7 +439,7 @@ config CRYPTO_DEV_ATMEL_AUTHENC
 
 config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
-	depends on ARCH_AT91 || COMPILE_TEST
+	depends on ARCH_MICROCHIP || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
-- 
2.50.1

