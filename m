Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B85F383
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2024 04:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722226478; cv=none; b=K28PZRMz0Ke1GCB83lhKQubdhb2k467DxUD/unQRNuQZ06ofdf03iiK+QEAEAhCsaUfz4on/fprPTOjdWKjacMLE6wUVL0uUuh/Mi3MzTmtAYLsbe4XgnkyERB6n6pm/upQqm+W4luukflT0LQ3TFGxRilZBUUES+yvTA3lLa00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722226478; c=relaxed/simple;
	bh=03Or/FiYd0/nl0Pewsikw0aSkjgcfqdZV+GhUY8nJPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q2zvoTqEmKttYpZTic5uTFDaoDnObEyGYBv1Q6hUWU726IVY3VfZnLZc0k+70m6iriD79lszcras0B0me+ZA11rfIipBLG82dRMBR7wjdEZtLG+uUY2oEYYihrFF781AS1m5HYLjpkKgQexEbkEloMwgDNRGTq3D8qvWzvmjZa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=L2t9jOrN; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="L2t9jOrN"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-70936061d0dso1567375a34.2
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jul 2024 21:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1722226476; x=1722831276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6rOVwxl67M1ho00LCXthXQkqBxCB3HpfniWe3LKqEs=;
        b=L2t9jOrNeyYS8qBWDqVhiC8d4RgPICg8MM0b386O1srh0BUNrx2BFupWrRcp6rJawU
         NsotaJifv5aSDEhEGeFPsA6xfH7Tca7Py97XjevB2X41vqwsIw4CJ07047udSRnekoZ1
         YDiruThhmMh71HiHGQ0Ns9TwGDig+g9wcAj9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722226476; x=1722831276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z6rOVwxl67M1ho00LCXthXQkqBxCB3HpfniWe3LKqEs=;
        b=GhmxjIVnpRRhxM+cIioqjl0tz7bVn4gwpBXHLZFXl/h16dxbNfajhlyBCN2ftlyRkD
         12e7NvoofszM8wUx5IzctKMAzHesl1bzAfQl+VBIOLAuCANaELr8zxlq/VMGTqOkC9w5
         FFOS9waznYFocObAwq9zuee+Ftn7SJ5eBcR/Z5r7Hv5pNpNCkLSb0ylZCbAO+w739w4O
         N0vM0c3D77aac9kCrbRBWP/WHemXxPNbhRRruweHFNsLM7EY028Vpan9xOrjo81qqNcd
         TeuXQ+1IrKfuVkjyA3XByXz7a4TJrg4Dhcuj37p3aXsTcy3iRiPC69tRqZe2TCZ4ep0t
         s+6w==
X-Forwarded-Encrypted: i=1; AJvYcCVF8gGYePBr9VToBC6hQR9p4SgLnwaRH3L8uJlh08yOtot0TjkebWTcntVNI2ksapeaKM6uYxoVgnInamNe0yNzZdyS+hxLeZrtXYel
X-Gm-Message-State: AOJu0YwVnchrrlEv4RvuRDeBNHATxE3+UGqcCKgKdzpDkdVVWV+mXWEa
	VXtCXpOz1tmYotoN7E4+9bcCyTcUvZGqr3BE6j7HfWATnQe0O3CQJ/tx2Sw8iY4=
X-Google-Smtp-Source: AGHT+IFXh/BqzKqN/+SrgjNSmUCZDg7/xUbSfhVlVHEMRxQwWys9I1YIchHsQnPayK2S17yvmkyTUA==
X-Received: by 2002:a05:6830:40c2:b0:709:4279:8347 with SMTP id 46e09a7af769-70942798512mr4242448a34.8.1722226476130;
        Sun, 28 Jul 2024 21:14:36 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead71228dsm5932141b3a.47.2024.07.28.21.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 21:14:35 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v7 6/6] Enable Driver compilation in crypto Kconfig and Makefile
Date: Mon, 29 Jul 2024 09:43:50 +0530
Message-Id: <20240729041350.380633-7-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
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

