Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95B856452
	for <linux-crypto@vger.kernel.org>; Tue,  5 Mar 2024 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638148; cv=none; b=VgGVtbKR2cWNTqEDdrWze7muK2TGRPPreytGjNKbpDoXej9Zb4544jVpAgdTVtKIp8b8vLwAe2/vSkBebLhTRibznQzCzy7iCf5trb1CnTm7oDy/4siZ/LGDqMpuCfb3EpqIatsv4H9vgsG2yPydNiqT9ZnPyNf42yOgenFzABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638148; c=relaxed/simple;
	bh=TmQ01O8f2BZc947ilvuoz0cIFN7jT34RVi/K0/99LXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KM8w/108xeUW/BZa3Xn8X1ABXR7njwhnVkCStUzxJ2Hm8lL02T4NXaqaauyBuXBvWNwhjOWN5q7WhSAceeSOJmFdQ72BUoeFWR11ad8Jq/U6y2RJH1pgsHsSiy03m0hZ5nw0QVf7oXxtESXMcZNjSr7PeE1IDc9/tTo4LZmykP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Rs51GbvC; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Rs51GbvC"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dd01ea35b5so15720985ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2024 03:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1709638146; x=1710242946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2EoSCzy/147CxL4roqHZsmcuqQUEW9KZKt7o+RAWoU=;
        b=Rs51GbvCwMAWEs/CH1h0ZdkrM4y/JpZqGxrO7aXUs3sw9EzygP+42mcJgRbFlzJMXi
         DIKneYID8CNhYK1r+2A9FbWVqbIEDq74lUWsl0FTmr86o9nnbrAqHFurwe0ph3ujEZzA
         2+4J8irNOyQXplM93Ru+frQgr50py2HIaYD0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709638146; x=1710242946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2EoSCzy/147CxL4roqHZsmcuqQUEW9KZKt7o+RAWoU=;
        b=eXvMGZtH0kayvXbqI07xyX8mFzsW14VghWquh2gLTh+yCB/pSIb9MEp/PYDGW6LSRO
         oDzH3JlpOeGMrCaA2BOTaquI9xtsYUaZnSLKaqKtW6ywJXhtIpt8rgqPQGe+DZERQhK5
         QbIVKyVMPTkg/jPBBIgmd5jMiakda/cOQz+4pwlkl1wJMAAjqAWMkxJcxEAmJnJDDnF/
         cRX3aAAGjBZWi6HVWTHl33wLizYjEwaWf/cM8Odfm1SffL4w9rNGNnJyIMx2r6xX42kw
         UVwvOypBBvcOydE3A+FKXbIw42zzy+7E4jBAcV7CWIiP38TljKlA00jKEICO2eC1O1me
         Cpig==
X-Forwarded-Encrypted: i=1; AJvYcCWQipkI6XOBmFhCN2SwX1f6mt3QCHz1TaibRL4CWILltFT7QEIcMD3W6siIVDY3wkt8oTUewemnAYwS4PDxDosljd1k6GkWj8eCScdm
X-Gm-Message-State: AOJu0YxlIhd/hRIjNfWKq837I9GF8WIqRaOwOb6SKCCcZnVTCYyuziKF
	sAYvo/ko5FyDhZBSRrw5/UW/hA643UX6jDUMwaQIAMSV9pTif9vl3HRK7VC/D+s=
X-Google-Smtp-Source: AGHT+IE1VLqRAjoQxeM4yGTSOs8xACpKPjOhXHY4GIE+hsH/6c2Rygi26uhOpyD59fxxx+O8eYtsdQ==
X-Received: by 2002:a17:903:595:b0:1dc:b531:82c with SMTP id jv21-20020a170903059500b001dcb531082cmr1034133plb.52.1709638146270;
        Tue, 05 Mar 2024 03:29:06 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id mp16-20020a170902fd1000b001db7e461d8asm10287212plb.130.2024.03.05.03.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 03:29:05 -0800 (PST)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
Date: Tue,  5 Mar 2024 16:58:31 +0530
Message-Id: <20240305112831.3380896-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/Kconfig  | 1 +
 drivers/crypto/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3d02702456a5..aa384d138ae1 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -704,6 +704,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 95331bc6456b..4408927a5a0c 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
-- 
2.25.1

