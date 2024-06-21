Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB75D16D4D7
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 08:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718958111; cv=none; b=rCsIg7flvbi/3zvMEBgKZKQd0vG6GpijxAUbjr3/XhcNcTY65ZEwtSbvPR9dQCUmfE9dn+lUmQPwN1uabdOm8/exehZZx+d2c5hhnPJ60VfMiM/rF1TaprPwapRQnrfMzDyt41PiFbvrLo5DXUwvCxMvjWTRu2WGk1vOcIC7kuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718958111; c=relaxed/simple;
	bh=03Or/FiYd0/nl0Pewsikw0aSkjgcfqdZV+GhUY8nJPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DDuLkaqoKWUlH2Eod2MWFFxoBwg5f5WdnRA/ewttbeGwE/8CiyqneGlD/3za2DizyIRILOMTIVYGJN6iClT6vqOFzM8BV6ZhPGykh3r8wHefVd4fOXDJ9yFPQV9BwG1ehf98RMml3g6Tqag6INYR31qWj/iC1R0RE44PCP/121o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=BdpH41qT; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="BdpH41qT"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f9d9b57b90so9662725ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 01:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718958109; x=1719562909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6rOVwxl67M1ho00LCXthXQkqBxCB3HpfniWe3LKqEs=;
        b=BdpH41qTRP9DhLnkEfpL5bRmQQR0X6i56c2X1fXFwv44JcMbO5EPgXfLRwGNI2c2AV
         0gRGqAChzILeGqF2Z8sHttu16V4+m8ZvsHoVedsKOGg+/CWr761fTZ3N52doVYt/fqsK
         tuLYaXai0lv+qizqI7zTQuaaDFi+BLPaJHedo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718958109; x=1719562909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z6rOVwxl67M1ho00LCXthXQkqBxCB3HpfniWe3LKqEs=;
        b=TYr//lCSoE1KsOoJvF1AVg77MkvTTxb91xuGlnLtFkHSWf8JmYhQlYEs5bgfReBXd0
         /i/ID7BlmZ8Ki2R1GLYIcaKGS/idsES5Zddhd2o9OxDunSGpDXx615G5Ls9tHhRv7dk5
         VjXQ9pdfuhc6HiIvSMPoxO5B0zUI5ijehrjl9iSq3NXsRLFv9JOCY0n2EZbDTqVy1dJ/
         8VhROBo+QNaVJOBuOGUe7f7+EUVF0JJezxxFD56Oqxu78xPNJxhFiYGrN/vOWE1mkJPy
         Gn4INeNtF0lb6L/sCOl/ChyxGwXyRbCcNSE6cbHgszqzthbKHErsl9GA6bGj86VTfDpY
         DtzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJOyhp+3nnRc72CWsnSdZWRuInpZqREvv2pc21NqT0+KQkbuCgycqpLgBX0guMJAsv589r0ezH2G+/Usy7n/IL4J1BUiwD+NRbZmx1
X-Gm-Message-State: AOJu0Yzv0vdDbX6vpzbizVOKoqkUwzmkJl6X7/LBOTB2tz/2LFhhpiGZ
	VS/UZmf4TBbNNTAh1ks7nikqslLxOyOhG5D2MdGRk5JeuMelY2lAwXfRMnPd/28=
X-Google-Smtp-Source: AGHT+IGGSbcSun11nk1hO10EuFOhJrFXGwbkrIs9Aw/XmDG5Vli6+OP4u6IE3TrZycBNv2exrIUa1g==
X-Received: by 2002:a17:903:2349:b0:1f8:69ed:cfd5 with SMTP id d9443c01a7336-1f9aa3b09ebmr92252975ad.10.1718958109268;
        Fri, 21 Jun 2024 01:21:49 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c5c97sm8673555ad.125.2024.06.21.01.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:21:48 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v5 7/7] Enable Driver compilation in crypto Kconfig and Makefile
Date: Fri, 21 Jun 2024 13:50:53 +0530
Message-Id: <20240621082053.638952-8-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
References: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/Kconfig  | 1 +
 drivers/crypto/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 94f23c6fc93b..009cbd0e1993 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -696,6 +696,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad4ccef67d12..a937e8f5849b 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
-- 
2.25.1

