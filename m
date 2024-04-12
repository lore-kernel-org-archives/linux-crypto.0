Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8509017C6A
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 03:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712894069; cv=none; b=BBiXrahIsVt+eo//SHAuKgSdFISvwE3CgYSZNzzB7M+a8yTsn3wL8VVQyQcGM50odmpyT2Z/xACOTxaCT1qJ+2H20y1p3lxA0Ro8T3lB5KTd2JOVRDCPa42pSZX/YqIm0O+p4BMEg+y5byIQP79hi02E56rOA/zCIY5a7s1PmZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712894069; c=relaxed/simple;
	bh=TmQ01O8f2BZc947ilvuoz0cIFN7jT34RVi/K0/99LXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uh1OR0YX6/lr7hVsvf+BhfHT90Re/4IOuDInWolu0V6AfioaFjAD0kPVoyT1YUbFaZ1gsvYT9qRiwFABC5e3pXtnuEDIsMrK4cBSufnMnr1CxdVG7BdKPgLafaGyJCFkzsdNR7G3D5spv+iNG3DkizF9DbStXF32cqM4SpUCiVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=g3eRH2km; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="g3eRH2km"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5aa318db8a0so319385eaf.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2024 20:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1712894067; x=1713498867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2EoSCzy/147CxL4roqHZsmcuqQUEW9KZKt7o+RAWoU=;
        b=g3eRH2kmlzTpAadLBuBXGxg5/oExAI9DZQwKVQfDyYmYypjMwMO48fZehAsFMOwFOt
         v4u4slclmHlIUb1DLP0t97o/0Vik26SNJKXTgwwvtq7kDxfJxv85i5IVWWJ85EDKgWSA
         yL99DO3RjzfEoAKmMEDnwULqMQgev8jCWUOmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712894067; x=1713498867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2EoSCzy/147CxL4roqHZsmcuqQUEW9KZKt7o+RAWoU=;
        b=VrNps25HnBVkC0cosfwqcDJWD4TMVnJmw6bG3ZkLHCBOCg6iikVFXBmdC36SDpZBzb
         ECIaPlq4Y7BnJprhVQqcZm/RbpcXKmj+UXfqvG9gZy+SfRjC7t2W/wMLcPEKNjygiwgu
         BsI+fNcaw4YMd2fUUGXRldOZv6AQsYn+mZyk74S5OYnI/VygY4GNWbxtO3cilEUGPWrS
         k57mPLAZ+Y3HfqnF40781Guv2BHSGpyRAm2ZsnWju4QwKaRK1DYqdzKTi4tFKdYYWRpx
         G1F3SsGoZOurz1vrey4yH2J6a5d8Sm2qN9L/ZnLZ4EbN5X6qhl8vZXKcKjfT+ei5gfxL
         WGVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWw46a9y+Xk4y6GN4CEze8wp7GPNCVS74dTbELQeZOsykPA4vKlu5uNiJkeXoMvsYkT+1wwTkDyTFtVlMjD+fDvzGljxxckznoj9+PO
X-Gm-Message-State: AOJu0Yw1vpzHYe6ebVG2dFEt3Y3c97/X/mU/RldfGoQKv3bYyszxbC4w
	YSiGG3oTXDzrbSWjG+ZTO9o4WC9IffbjC5ygC36DCSAJSlKdEVbPgoKWZRId7SY=
X-Google-Smtp-Source: AGHT+IGhM+zoB0QbF+0CC7aIHEPcb871TqZzcRIQNHJWvVZWrJ7CAG4Nvvr9vbX9qUVTItINmTHL+A==
X-Received: by 2002:a05:6358:170f:b0:184:c60:2bc6 with SMTP id d15-20020a056358170f00b001840c602bc6mr1376797rwj.26.1712894067630;
        Thu, 11 Apr 2024 20:54:27 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a193-20020a6390ca000000b005dc120fa3b2sm1842910pge.18.2024.04.11.20.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 20:54:27 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v2 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
Date: Fri, 12 Apr 2024 09:23:42 +0530
Message-Id: <20240412035342.1233930-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
References: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
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

