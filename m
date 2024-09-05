Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419EA199E88
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 11:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725535890; cv=none; b=EAfeUHrENvdIR7wo/OPPanUlHpUBbV6LP0nrQ/Qnx2/bfweVJSMTidCJ0FpWLFG7PAMIhQgZy+zDfIwQy/HGwoK1NXVGOhXetDdb3vyAThpZ/T+wGPuEleFkndJu7UgDZM198DBMLv5FEbXd0149K1r1kVpg9xQDnsqvPiHUsNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725535890; c=relaxed/simple;
	bh=I7o71rUcOlB87rZq0BuNZAAfm62a7Gi5txNcpnsvdsU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JZhskzSEkkqil9j8vHl/0Jg+5RIWAw2izkB2Gl/POmj4B83RSKCM/0hR0yni/rfIMsoda6kYn0pd6uesYYUiN0u/isv3NnZZvaAnBCYWaGnec6igUN+p4gyCVWl8odSsmVtrFz4Izx2I52NyOCYmgU9mga0871NXp/xXEu8GXt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=EYP7rJXi; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="EYP7rJXi"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20696938f86so6367305ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 04:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725535888; x=1726140688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jR8fc9Dhv/fRmL+o0+BlHj/1KVyDMPkFLzOC16U5rSk=;
        b=EYP7rJXiLKIWiTzgzKmChKp/y7v4ksle5Uh3vHZn2OsNqwnvA4aX8nas6UHHVAZA3E
         2+0tzhyX6h1Pcs22b2NPRxikGfuEcyZKuzDTrGOKiQM70lWtKCyee5Q4M7LfPDroqqnL
         /MbRtrhUlwsfnZexAEyra2AaFnjluj2uCjRUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725535888; x=1726140688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jR8fc9Dhv/fRmL+o0+BlHj/1KVyDMPkFLzOC16U5rSk=;
        b=vdAIMi+8tme3Tt58nF7aHoR1IDwP8c9sXfxkos+CutYOJmUlTPfUTR6nEi8mdQEl2l
         h4eewYy4ksKBDvoSoUWHVaWCL7aohQfFNRGBx4+91zd5w8nYgh3cKnemIVqa+4D9X1zz
         GGt9APmT9pFZAUm7bYytWeBbL3bf1jaufdgGwfi11UR6sa4DFP9a4R/hwOl9IE2V2C/C
         O9Lp+cz3sGIfsDos0RNvn414mMNbJ9AVstzNOar6MgoZXEheW+gcYcFeDgKgPvDsbXtl
         QIKdJolb1NtgZSQtjudS4b7ydvPniQomFRRGOGdVDoDZ+rljp2ALYlmVpkvcGQHewMTe
         7Vig==
X-Forwarded-Encrypted: i=1; AJvYcCXUsf7mELcgA4xLt6AqLf2DDzlEHZzuQXA7z349+3GRWEcH0DxcV2Xi88+nUhi79P0622VCgbYaGsGQKLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEonMcvwizkDVpZhNAQz921TtNliLVDEjcjhYcUO+MiXWdnGa1
	bNiqa8H6cMbRDbfmjE8WFBCZN6Us+tEEG2hzVSkFHdX8Efc9rMBimY8yY6ZYnHQ=
X-Google-Smtp-Source: AGHT+IFlM9dPl87IPu2NM1JIXBsLiOnYuflGJE/ertImDPJjOoGVnL3sMnG5yZk5k13eldC8Zprn+w==
X-Received: by 2002:a17:902:d2c2:b0:1fd:67c2:f97f with SMTP id d9443c01a7336-20544514f71mr210689805ad.28.1725535888648;
        Thu, 05 Sep 2024 04:31:28 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206e6aef432sm704085ad.177.2024.09.05.04.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 04:31:28 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v8 6/6] Add SPAcc compilation in crypto
Date: Thu,  5 Sep 2024 17:00:50 +0530
Message-Id: <20240905113050.237789-7-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240905113050.237789-1-pavitrakumarm@vayavyalabs.com>
References: <20240905113050.237789-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add SPAcc compilation to crypto subsystem.

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

