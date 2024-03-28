Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003A2130E3B
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711650454; cv=none; b=D6NLBTP2+qErr85PBz5BrbuaNhVQN+VFwd/ya+euQjjC3c03qcdOEj5CIUxdawnrqm9yyyM60XffJn+BUsj5ztpwKtplp9BKDSlBLnuTNZ6EAPCd6JS/TjrFP3bJ3Tlu0FxIOCOODIxiU94CdN0bP0gIC1OLMJPuzmYLs3aSF7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711650454; c=relaxed/simple;
	bh=TmQ01O8f2BZc947ilvuoz0cIFN7jT34RVi/K0/99LXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kh89eqnsDzx2exaMmk2P1Eo8QMUw2BnWHUSgzv59xA37UxL6tfB0rU3MFMGb5ktJWVMhVoJY8mQUb3v4F5IqLVPbGN5s45wRRZbzBoMa3587kheiC+GnZBZbmZ8WZykoObkuWWM958+0NWKg4HeEh6QRW1ZpPlWZXUczcesUPYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Wqan3DS9; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Wqan3DS9"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e220e40998so5456635ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 11:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1711650452; x=1712255252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2EoSCzy/147CxL4roqHZsmcuqQUEW9KZKt7o+RAWoU=;
        b=Wqan3DS91li/CZVFpB3HdkA36AdkEDxakngTkZxjzBkiC0JO75tYCvjF45LndHpGyv
         wJ8eR0wlkvE7EwN8L+UVVYOVaxATPpaJBtI2P7zeVgGFL2+uk+a0ARmiJjQbFpBWQqmO
         0uiY7XGY7LSppkgPGl/PhO2jXIUWjLaEF1gvE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711650452; x=1712255252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2EoSCzy/147CxL4roqHZsmcuqQUEW9KZKt7o+RAWoU=;
        b=F8/COFn4WQrtLVj0KOrnv/0u3rkxmWAnDf/ogaw5pEZuDV0s1sqOEkhi9zJvBkKLmB
         MUSUreqzXr73C/x2VMXBKetdcUxVGHLa8VK/yY6dhr8bePWx3mfhhAbE8KUmZZjtHY5v
         i3pg4ltji/+pNz9Jzb4FfMJmDypnukhZRdOshGU9AjNktbaJs99cGajVRJAKzPS83Jzl
         8q/L3GTARJXO0nGmwT2n76Ov0PBp/QXFFu/5EXKT8owRkEg//RbaI8ndbn+izdesUJD/
         byM/d1vY9Uemo8Jgi6/CuOx6rkbwVj/7HhAUFGr59IoxUiAp7Lf0/zMRDWc9JyPzv4C9
         VVnA==
X-Forwarded-Encrypted: i=1; AJvYcCXPOVsEljU7Kkrn70YxSWckOD2g0cC+dYnm+tD4XAScFtuBIXYGtzkoZQj2zG2Ucf+u10fz/tUKGlKG7abLII66jE6SXuYQy8u5FIDG
X-Gm-Message-State: AOJu0YxjUGx3hjdpfwVw9WBuOl2kH/aHVNpBTt9afOkW2Mv+SX7qlfCK
	QZN6D0tp2whkH+qA4RLSejqmNuRSgmOULUlDFaSAtS79kZWr50PF6rOZPQ20UfOuSSnX1rsFEaQ
	d
X-Google-Smtp-Source: AGHT+IHN0cr0MWwkBz2pAoTf08EpvvjjZ2r8HI4Ix6jB3SKcHZpkdDhNrAYTFa9dcGGWsiuYRb+k7A==
X-Received: by 2002:a17:902:f68a:b0:1df:f859:91bd with SMTP id l10-20020a170902f68a00b001dff85991bdmr337564plg.4.1711650452186;
        Thu, 28 Mar 2024 11:27:32 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b001e223c9679asm846059pla.93.2024.03.28.11.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 11:27:31 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
Date: Thu, 28 Mar 2024 23:56:52 +0530
Message-Id: <20240328182652.3587727-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
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

