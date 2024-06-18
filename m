Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3859D37165
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 04:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718684910; cv=none; b=CgwvSMo1FL3JnCNBdpPxsgdI3AMDqQz24miLcdRqqgcT0Ue1hZcl12lPBI/utZiUaPiUAm9z5E0ZXGlnG+9jJRW0dUpYjt3fwFfjU579uYEqnwP3gzO/7WS4j304w7WzyNevtZ7q2P5n18ndDioN6udG8Mj6xyVaHs0U5llPdIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718684910; c=relaxed/simple;
	bh=03Or/FiYd0/nl0Pewsikw0aSkjgcfqdZV+GhUY8nJPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TdFVFysV+bsQgMUUydOhZDWJlxLlVgZ7ybruiunEagaeEdxjH51Kz/QBKjf3K+hvQsj9yVynOZtzwThRSRoqHTMlu+B+QahPQloSQ2Ea/LA4QVFte4bWnqkHJLGc8QlmK8q3uzQCd18O7hku5FD1TuYnWoMHeuzi1Z0+7M0A7UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=F6ekEOe0; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="F6ekEOe0"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f7028196f2so41042225ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 21:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718684908; x=1719289708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6rOVwxl67M1ho00LCXthXQkqBxCB3HpfniWe3LKqEs=;
        b=F6ekEOe0r7RiqaVZuC3mWF2MDLX47uV5bxUFc1XXYaIO4F3nsP1CrV3eXOmHtzPGhN
         revkPd2tWpMiD+HzO1tmBDwhATxZ565SAZVDjYLLgHrCMwZE6cvOUipHNKFOoYc3Fu7r
         2OSkn4pHSKxwPnWEe2w/nbBR3STfDa9yb9Fjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718684908; x=1719289708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z6rOVwxl67M1ho00LCXthXQkqBxCB3HpfniWe3LKqEs=;
        b=YIZMFgbkCRPVU1oRRWRUCqjz0QkfHdT3/KMVjejOTcuDC8wNeas5KIQww7yYTI+kSX
         sP027Zm3CiaDMg4qJ/ZWqJXraCRlNwnn+qyfnyZQmvK53wWvYk7LQf1pjjSaVnSV18MY
         yx5dQRh/BegNJwFoeapxrOyhAIW4ZCbs/fD5fZ0MYrmc8vlgz/+lN8wMgznOy58NDvep
         vZaGdUHzh3zYx3wO5rKNTe9OI7RdLk32lxi7vbE/oDZM13mlFewkMh+aHSCqj6HdsgvA
         IhaWRiFrjnbOuSyJfLGijo75IKTBITb7mZuFLLsSvL9VcnzXbSRKkLFb9/LvcuI27/qL
         2SaQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+yT9EFJJUOsjFouvvdQzgmw5vn0bEpWwzctYhat1fJSTuDh+c7tNDWFot2EffLViskqHlk48JD1zMaGvLZIJprLc2ghe+d4kzde5E
X-Gm-Message-State: AOJu0YwPWWr/A2xvJ9X7unqOGGLNsLPJ20nLha3s8rF7Vs3x/JnG78zA
	doGc4havii4IgjUR9dOZ3+Ux41f8DsNsfwo8ve4LO+PQpbVYQq7PK82xCWu23cw=
X-Google-Smtp-Source: AGHT+IHohusEp6xGXzrxdHN4VoPy0oyH7/AJb94iYQ+D0sFjeIZW8dNHEgc4c5+eY0Hvy84kUWT+Xw==
X-Received: by 2002:a17:903:22c6:b0:1f8:66fb:169d with SMTP id d9443c01a7336-1f866fb1db3mr114816175ad.3.1718684908594;
        Mon, 17 Jun 2024 21:28:28 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f1770csm87912405ad.230.2024.06.17.21.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 21:28:28 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v4 7/7] Enable Driver compilation in crypto Kconfig and Makefile
Date: Tue, 18 Jun 2024 09:57:50 +0530
Message-Id: <20240618042750.485720-8-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
References: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
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

