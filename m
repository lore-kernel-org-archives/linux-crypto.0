Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3992E62D3
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 11:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749814938; cv=none; b=fEAmmHMKdS5FMib10JD2vKGx+FAuwHbRU4iru1c1mYqP3OU2ZAoGqUxlt3qTcXHWwYDyQKoYTH03nkPgYoYc49OzAnPES6yIHFJxTfg9XqQoc6hFraX8VHcNu7xqmeammydUsIMnQFTWqAePxy7sE3JhxYHRZrnki8TnACffbn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749814938; c=relaxed/simple;
	bh=9oxZLiMqxg04N22sji4gyuqoa02gKr5691CGYVnCg7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb32C0NyuhD0GX2JqofT65gpvlUDw7Z85kf/AR+J4rz2J/eDwoTznoi5VKZFkDq/bCFIARsL9U4b8Y1H43eyfJh/eOgjBIyw/8aseSzo+2OSAcNcOSh5MYuNrftetLo0oPCDWY6+lxD8m36FjZWwxY6T37yIGUkxxLVAQJxQt8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=YNHl7knK; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="YNHl7knK"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6fb01566184so17750916d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 04:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1749814935; x=1750419735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FOxOys3zo2Dw07T/mQvOuXgGCEKYh0s2Uiw4mKVmQs=;
        b=YNHl7knKNDVKvypJcJhcGlGu8DrU5PyO+LN2J08UyFVzU+7XAZzimNTzhNeyR93302
         XJ2LMdkOO9R9gmdzW4xyjI6FTXvDlg8705pU5im7roRIDXChZYjgtdxTkBuIUAGCYyHF
         ZbIdAVJvz9EM2HpsG6FFia8QAVyoGD2TVmrlHDAjvnyST/jNSkF5eNqv8V491uqwnZyo
         Y0TN4hgljgTL6kYYObEddKdoAV8ixSTl1imVfV3yCIhUrsVizO3P0xsW5HEwWlWJh2GF
         o7ohjQ470K0gVZ/EUPROnnF9f9fdL+9J34FgR6gZ43GJt2vvpweBo1JzK0ocdiitTB06
         sNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749814935; x=1750419735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3FOxOys3zo2Dw07T/mQvOuXgGCEKYh0s2Uiw4mKVmQs=;
        b=iWDN2YWNKNlKmEFZ2/J3L3g/8443MMnUVVhj2dJTOkmjMN1T0nG4KSPOGa1hsFywUW
         Hw6SSe654Ij+d74e5cgRlS+AEMF8Qh0oBRdJp7Ca3vCetmMllRvtoQ4MkxEwEbrZFktn
         lyP57lY454UAiHILpS28T8vwomqOTzzkoZXAIGKE6YrJ9DM1ebPPGVwQ0ZHRSAawgJx5
         vDJBAyP5YHaapfImQKbG2GJK8L66qlsJhVNdUpEysr5b40Q3Cr1OU1NPjhJLldwKak3n
         WaMhtHOC+HuDEgr1FeIfzZmZ5RJJhvn7rZQVm56f5fzBmZeS2bSZ7ODqMHGXUWyDqk7n
         2Jmg==
X-Forwarded-Encrypted: i=1; AJvYcCVp8Ci+r8rfvg/95v999K5lQ8N8NnQwK4H775ljyq2gRdXo0706OmN8KYEBwx3utGbf3TfURNXXR8oI2d4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiCTZdWmMZp4TgD0kbVIZ6L1if91iyjlcU0Z5KjT20Difs02es
	GcPHZ6kURD0jfdbiwJ6US31tFzdHh2jTcFUypszrp866BVXTjGq6U17DUVw+euhmZY8=
X-Gm-Gg: ASbGncs77zFG22zEbh8pEEk/wGL7FmxiO8srFJV9po9olEu8mdRiF/7uNaNHXcwj+Wd
	+eKIS1CtTPR6DgTI0GnKok/ozA3b2kdZLskpAvpeWpiDp12UT+hWiBm4LCfHDVQDCFtigW6rpuR
	Chi6Ox9gzjBvC6aBiZH7hQ0frmy7MB/CoR1i1SLDZ7kfD8iTxbQdOwVdRwf+0w0LgzFLVwjkVm9
	KDzjrW5JFASygEw7bgXL3UvjZDgtfXBSj17D3nVQF20JIysVEeqtRrszS9ATuxfzKAmzZq3QURD
	GYCqG4+/wCPtNLwzOWVdSx9PqntvaUpobZt4PeSR4PMTzIFOVamNb+0nC+UPxRURybqDq60Iof8
	Rdk1UKPipjKD/i3wPI6vPOQ==
X-Google-Smtp-Source: AGHT+IHILIH9TTHUNXKE2SXsO/39QmE4PBt4ZlHa7MSBEM/sfhXbd9DkCQeEuqozVECdWauUoscyHw==
X-Received: by 2002:a05:6214:29c1:b0:6fa:f94e:6e79 with SMTP id 6a1803df08f44-6fb3e59a197mr39514346d6.9.1749814935402;
        Fri, 13 Jun 2025 04:42:15 -0700 (PDT)
Received: from fedora.. (cpe-109-60-82-18.zg3.cable.xnet.hr. [109.60.82.18])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6fb35b3058fsm20558206d6.37.2025.06.13.04.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 04:42:14 -0700 (PDT)
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
Subject: [PATCH v7 6/6] crypto: atmel-aes: make it selectable for ARCH_LAN969X
Date: Fri, 13 Jun 2025 13:39:41 +0200
Message-ID: <20250613114148.1943267-7-robert.marko@sartura.hr>
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

LAN969x uses the same crypto engine, make it selectable for ARCH_LAN969X.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 9f8a3a5bed7e..b82881e345b3 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -426,7 +426,7 @@ config CRYPTO_DEV_ATMEL_AUTHENC
 
 config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
-	depends on ARCH_AT91 || COMPILE_TEST
+	depends on ARCH_AT91 || ARCH_LAN969X || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
-- 
2.49.0

