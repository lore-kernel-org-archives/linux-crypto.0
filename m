Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4395929992E
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 17:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755107267; cv=none; b=i3CJVjg3Eo7vCwqxSiflo71uhoN47zM/8BrPYqVSuIkIvBuNKvQmfvjSHBwbMH9PxCyrlczz3x2YQ9BK7Ud7VCMzleKRF7nnGXN6xuXnqH6oApLfKb/udxXVmg14HUHbR4ySFcFuTzxDXyFRU/KNOgO7RdmpsNQDWeNRlm0Tp7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755107267; c=relaxed/simple;
	bh=gPMtN6w+Ex6/DTpmDnipaDUce4Mx3+FsbyqPZQrCYoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkMm4n3IbF49WxyKJ44F/W9O6k4ipGcIe+EeSv0pW8Sco6A+YY4QcIpkJ1dcsAgUGX9MbCOuNoI2h/E6+Kogh1Jcv+/2EPacycekUB+4oJ+heTJf8twzQ9Av7sXteWhprWqfBaUirhkJspzNYm/Mrq+NL/gzp33jyV9kceazJzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=QZAmmWeL; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="QZAmmWeL"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7e870689dedso4240085a.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 10:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1755107264; x=1755712064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOqtWGRnguTuSIsC5EGTanl0XgtE1XRc/qnGhyYka2w=;
        b=QZAmmWeLRLMQhIuqHu/KvJDEJNjLk1Uhjp9KNU6Rv48HTqXR9Gi19PZdaAXnUSCUnd
         7nFtowisJIqJ/XLwX4ozYgLg/AS3OvJFFct8eTAPJIBvcy+kLgSwSKARMITt1GuRzOsE
         9gMEfS8p0PbnGIBvapoZMPO4IeDf2iDCvNs3zZ0G9FxVvIbL/EnE2JMCwMZhgcDqUNli
         VkepSqY5ARwJS9Ev9IbMI62wlC8Wd29ao7jcFAkulBHCA3cIoxRrDEwe8dAG72wh5KTX
         VpTkmOjUfXsoaYHn0xGWTVTe+k/HfAuyikK1SqdX0xgq0Ts/Ss/a3V0ikJpyzN6QTyMt
         W6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755107264; x=1755712064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BOqtWGRnguTuSIsC5EGTanl0XgtE1XRc/qnGhyYka2w=;
        b=f8hStzqoc9FbVj2ga3lDl4Y5WRWTCZkcTvAHr3uyz1PwN06VEIP/ZR2Cmkfwd30s7q
         xf+nT1OXZhJ3ASiBFIuCC6OLiM6hJSYjqnYr7BwZwneOESc7lcLojOdKrO+LWbQCSsKR
         G2YU9nB6NL7jH0hn7lS98AGpjkS9TGbXAE92J5RggRD3AWxw1AUgLwtu5uVcV7KpGdMm
         GRoS4EXjRN1nBgRs7ZcwkfffXkaa8tiingOFEj46c31kYY3Ff/DN6QcnERbftl3u4GcU
         LMl1SFd4vPXQw7z43CjBFatMCG1slc/qM1PTP16VSratE3FnXXrBfOaI8eU9Gd4r6er6
         y+fg==
X-Forwarded-Encrypted: i=1; AJvYcCXWjSMHFRvmtD2gZQcbf5gNER3DJl5IUqfcCtcPGv2UZD+z5tt1vlVJeYgnD1b9Labw6ztHJuPYCQn/xZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL1Nluwn//zvbuasIZ1iNFdBOH172e2zpozHrulac+IC7mSI9c
	LEz1cGmZ3EcotzdBqx3AWWvZY2Y0gN8hVfEGIlzD9tON+NMfPf4mmiZuHu5A+ver7Uc=
X-Gm-Gg: ASbGncu7UZrWauhi9ltvb3vVQThSfMlFBFlRVA/HwFpa5KbT7PrzKxk0T6mxrQUSGUe
	dp3RwQI20+x4lLYCJ9yoNa4hA2b+IAMkFB+0H/iq92ZfIs1EfMibjgn8lhpq0lRBPTrC9GZWYA+
	/8+n+aEN1ZsOsMnZcQg6TjWASI86ot2SKJ2pgglWCiWiHlQdKggC5H+f05r9cjRViJXMsrF9R4u
	4deAumOQzRcomsDzQKa26kI5ZgZfqbdzZ9in7dCEXSa19V77yCNY6TmOlO4RXeDHg/ptGav2ZxP
	nZkxw104wEfMqZoZ85WqUdExY1Vrl8BFuTp6hiEX3MUC5CJUPWcR9dEwyfYX4b6+obtVBTpzB41
	KY/V6uUNKLld8z+Lp9lZkQqeagZE7STxK/UQhYgBoIw==
X-Google-Smtp-Source: AGHT+IHM8gqvwU0dp99AsCx2aJSW6E+YiETEDgm//P8elY9qJZZswfVzec82j6i0ynh7rzsSjnHxBQ==
X-Received: by 2002:a05:620a:31a:b0:7e8:20cc:64a2 with SMTP id af79cd13be357-7e87035636bmr30883285a.26.1755107264026;
        Wed, 13 Aug 2025 10:47:44 -0700 (PDT)
Received: from fedora (d-zg2-251.globalnet.hr. [213.149.37.251])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7e7fa87e7d0sm1627122385a.82.2025.08.13.10.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 10:47:43 -0700 (PDT)
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
Subject: [PATCH v9 3/9] arm64: lan969x: Add support for Microchip LAN969x SoC
Date: Wed, 13 Aug 2025 19:44:39 +0200
Message-ID: <20250813174720.540015-4-robert.marko@sartura.hr>
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

This adds support for the Microchip LAN969x ARMv8-based SoC switch family.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v9:
* Select ARCH_MICROCHIP when ARCH_LAN969X is selected as its now hidden

Changes in v8:
* Place LAN969x under ARCH_MICROCHIP as suggested by Arnd and drop review
tags due to this

 arch/arm64/Kconfig.platforms | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index bfea380100a6..31bddd1a17de 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -177,6 +177,21 @@ menu "Microchip SoC support"
 config ARCH_MICROCHIP
 	bool
 
+config ARCH_LAN969X
+	bool "Microchip LAN969X SoC family"
+	select PINCTRL
+	select DW_APB_TIMER_OF
+	select ARCH_MICROCHIP
+	help
+	  This enables support for the Microchip LAN969X ARMv8-based
+	  SoC family of TSN-capable gigabit switches.
+
+	  The LAN969X Ethernet switch family provides a rich set of
+	  switching features such as advanced TCAM-based VLAN and QoS
+	  processing enabling delivery of differentiated services, and
+	  security through TCAM-based frame processing using versatile
+	  content aware processor (VCAP).
+
 config ARCH_SPARX5
 	bool "Microchip Sparx5 SoC family"
 	select PINCTRL
-- 
2.50.1

