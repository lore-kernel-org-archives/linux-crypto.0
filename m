Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA432E62D4
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 11:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749814934; cv=none; b=IcEV8cOxEjU6e5O712L8R716dqVZHkFEil3ieTEOi5PcBMRxpPZwbQL7P0u5QoXKts7qM0pcUZesGDOnyOS1BbKRLYYSb//UvFELlx0JgdrdFqcVQdqMOlA6Bq3ofdltTVhl45mhxzkx0R2w7WMyNnqA/+yFZvQuDt1V4MXSx5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749814934; c=relaxed/simple;
	bh=NeAtc85pNHGt2Bai6eksDz8QG2jTguYaO2Sb/fwRluw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ytue+XD4pU3Zp00435y53Mj4uRY/E8T+V7zsG4dgzvqjVH5MHQycQC6gXSj2iBOTnTkDTh0ewiXbjty16CQ4ZdAduCsBlf4y8jQEDMB1rI7BkMHcSQWl5AKO1zgkrg7VEzXqX4XmGR0Kb6QzrEwfogPJGHl5vYnFtHNWxj36208=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=rS089sCC; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="rS089sCC"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4a58e0b26c4so35607831cf.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 04:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1749814932; x=1750419732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hP34e2q5Xb/n9epu9K3/GerhfTkPidCRzY+znM8yDWs=;
        b=rS089sCCi7q9xklN7ra53x1njs+9nCw8pf1r+Zu0GXeLIgkFtWC3a32IswDYXj7DAT
         bjiBjlsBhREhb/0VbNe6x+uC0vDQn+5bd/Wyc9f0THQTkUm2Y+ZmhfOGrWdqsuOiQKph
         cH22pL4cCUVl/90jYWSp+rrtB+QdqE3BzvXPIVs7c8xIWKygA63uV99M9CE1xntGRMOG
         9daASeLc4cH4AyAUofnGXi2EQRObXsITNqeK+gDSsYCpFLJcHzZ5wR0ET3fPqZ7EjaA3
         HFwkL/N39MH45MD8+KUoCQ1YgAi+tMjdrv+hhVBJsOV0GZElAyOp0Q0GGfcmvVebm3vG
         JojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749814932; x=1750419732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hP34e2q5Xb/n9epu9K3/GerhfTkPidCRzY+znM8yDWs=;
        b=Eda3ylEevvayRXsGHgueCTrGOUGq4wRUoclllvD+3U6P7Lqs1CnjjuQeYnM+XpA9o4
         4qPIC+fjvGzB9CBxrk00fMR/A6J8eOa4b1HWDBEeKe1lgpVfSO8CugvKr8Pz2S36WJPi
         DlffH6ED6x3/VBhzbpPRig/feMbgLuoXo22aW9aJihQuR28FRIBN2dPK5X8wWDb6WNzm
         9gdnPDLj23fCiN/sMWZ29Ko0zQVrYv2wfDE/+YAmCr1kR1TNN+it2SPXAGR6KhfU69ER
         2fKXE8lYNFY8V+g0uLVXFNXUZGSR55ANALcc2ZDZeQ9XMmSgJaoBlnpzndDLsbhotS3/
         rD3g==
X-Forwarded-Encrypted: i=1; AJvYcCUERWcjUNjWWKZmDcmF8GIr6qWTgw2No7sUCi3jhSkSTW9kzIiln4klVIEKqiPWs71oWTh8yXJsXE7QyuU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZuWagz6eC2xGg+l2rk2C55191uUdXqjMdGXL7Q/lxAcW7SZA/
	0jGCPxlKzQT2KD60CbSd+fKoc4yUPcdIggj7DW0i0mGIfU4tBG76IEeywMTVaBB2UNw=
X-Gm-Gg: ASbGnctI+CQGDscxGaSNV5Ps7oQk5eMH0j7e364y+sc8Z72TkuV8XwqCOaX58aMRqmW
	tkhXspc2ap1AMfo9mwtloc2+0FUDj/HXhf0O3bm7vltOcQ9GNTX/f8MboaAW7+w/ovwvS0viVEX
	pea80fbiBgc/bB5MGbrHzD08n6SAYJ/UrlrqrNTVU1zM2jh7zdblFQxijtyy4ss6QWn8A08fo14
	O3W377ca/C9+PPofADKWu7nSnwk52UHZhX3kclcro+Ns+hRQElBzFIjeoUOwbwqcl8L0Y5Amqcu
	O1gbrxxudrxSmzmK6rH1Za8sEhoVjJ/THJ+3ffyxfQUO5Jf4Ov3iXmCf2uu5Vu0KOKIOE9KQI0i
	XgDaGK+vnoQm4On7D5mXzng==
X-Google-Smtp-Source: AGHT+IEvwSeOVrcJVMZPPA8Mgajhh3j4DaXHPn6mHw+5/rNyArLRJaLGgxD9f3JE53WDOm92ws1YcA==
X-Received: by 2002:a05:622a:4807:b0:494:a447:5bbb with SMTP id d75a77b69052e-4a72fec2119mr49140131cf.16.1749814931845;
        Fri, 13 Jun 2025 04:42:11 -0700 (PDT)
Received: from fedora.. (cpe-109-60-82-18.zg3.cable.xnet.hr. [109.60.82.18])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6fb35b3058fsm20558206d6.37.2025.06.13.04.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 04:42:11 -0700 (PDT)
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
Subject: [PATCH v7 5/6] char: hw_random: atmel: make it selectable for ARCH_LAN969X
Date: Fri, 13 Jun 2025 13:39:40 +0200
Message-ID: <20250613114148.1943267-6-robert.marko@sartura.hr>
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

LAN969x uses Atmel HWRNG driver, so make it selectable for ARCH_LAN969X.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index c85827843447..8e1b4c515956 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -77,7 +77,7 @@ config HW_RANDOM_AIROHA
 
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
-	depends on (ARCH_AT91 || COMPILE_TEST)
+	depends on (ARCH_AT91 || ARCH_LAN969X ||COMPILE_TEST)
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.49.0

