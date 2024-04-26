Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17658762FF
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 04:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714105619; cv=none; b=nKiHuyrzGoUKLuFVVB92CcnmQ0nKO/gzJGxYaVW665o1UJtiPbwuN1vO+huFKXSP8t+/d9oA8rTpLsN75Q5QJ5R940uDoPAYvjaKf4XZAYyTcKqF5DCOk/MZbXASIkHVPjquBeLUE5MiUQoGy9N0urjF2T7LWDhjdOqqz2QK+SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714105619; c=relaxed/simple;
	bh=q/RNelZuLK66XHRt4A1k9Tu1IXDwluAPPhynebR84nI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RoH8xCp/SIi7ixvAyLSHA5CB+/KJpTz/4+dYADPOu7mLFGv3cAlXBE675Q8cIhpt35e0zQdvgzZJc1W4mFtocrlD/Jwi7Dndekm6EKX74CsT0DocliwKVgswFq4FSymxWaTpd1IPOskCLPshOmwTLeR+TiZYPO3FjKxOc7Gm9WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=fPo7wVNX; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="fPo7wVNX"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ed32341906so1724022b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 21:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1714105617; x=1714710417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJVDl60ON9bD9xTW9F5m4wj2yNABuejrjrf4qtYOAvs=;
        b=fPo7wVNX0hW0gTbhgZxWzIXBsPxKAlnxcD70f0qiJt/U3JLmVkDusfd1jK+iU4vTrh
         5LxlWmjXFBi7Y84KsmF71lNjT1+g1jNREoViBHfmTtonhjyzVPdHYZFI6NGF2N394Ght
         CbyYc3b1dGYs2REeqoUZzwIJ7Zkm/qmr6HAls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714105617; x=1714710417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJVDl60ON9bD9xTW9F5m4wj2yNABuejrjrf4qtYOAvs=;
        b=GGXewMjfkcfKy+yTreyTA786wIbyFcgRenqqmPLlc1oh1LIC90mF8IahnDx6LwtuMi
         cbjFEUiKDOxRUSdtuk89qtvrO+3CFQ5OycVorAs0gdKwDiI0k99abReX65T4daZdKggs
         LVY3oCraeqbkGGjXVlCWtnA9fc8jxw2bDsd7aSDxkfm7MfUvTV39Vzywavuri7dXKnQI
         KfE1/Zgi5CCzhmyATG7lE4IT6gX990F7YCZGxjZCirwoSMoFjFVkyJIsuO21ux2HXsOi
         NIRvn5Fq2ggA6QjHR785mqgNPAPpkvfdNq8/+8zcl4RSgFCZ74aE7ftETI7U77Lr1wd+
         YWrA==
X-Forwarded-Encrypted: i=1; AJvYcCVIgC/XweUk85QJbyb3IIcrnI7vabDPf7LwWjILqHH2Qe3mWu6LCdQQPZALAcHB505SFMaDjXncsbj+yAmfVBehsMkVIHTPxP9KBvE2
X-Gm-Message-State: AOJu0YyYLEMXd/R86K4Vm5326/qSh6le98KQbDTBF4FTF82W9R8Rhbyp
	XIU1p//Q14Tps57twfTPhVl7RQXXh35+b70H2ms1gxy72NcMYJlVg/vDNUOCfjw=
X-Google-Smtp-Source: AGHT+IEZRIVYE1OPGbHic9M2K3td4PJN2sdh9NA61iboM+kZax8XG/Ks0YxhaIsrtheWo+Xty+a6Tw==
X-Received: by 2002:a05:6a20:975b:b0:1ac:de56:eed4 with SMTP id hs27-20020a056a20975b00b001acde56eed4mr1792582pzc.53.1714105617380;
        Thu, 25 Apr 2024 21:26:57 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a5d8c00b002a474e2d7d8sm15500291pji.15.2024.04.25.21.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 21:26:57 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v3 7/7] Enable Driver compilation in crypto Kconfig and Makefile
Date: Fri, 26 Apr 2024 09:55:44 +0530
Message-Id: <20240426042544.3545690-8-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 drivers/crypto/Kconfig  | 9 +--------
 drivers/crypto/Makefile | 2 +-
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index bb27690f8f7c3..aa384d138ae17 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -660,14 +660,6 @@ config CRYPTO_DEV_ROCKCHIP_DEBUG
 	  This will create /sys/kernel/debug/rk3288_crypto/stats for displaying
 	  the number of requests per algorithm and other internal stats.
 
-config CRYPTO_DEV_TEGRA
-	tristate "Enable Tegra Security Engine"
-	depends on TEGRA_HOST1X
-	select CRYPTO_ENGINE
-
-	help
-	  Select this to enable Tegra Security Engine which accelerates various
-	  AES encryption/decryption and HASH algorithms.
 
 config CRYPTO_DEV_ZYNQMP_AES
 	tristate "Support for Xilinx ZynqMP AES hw accelerator"
@@ -712,6 +704,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad4ccef67d124..4408927a5a0c5 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -41,13 +41,13 @@ obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_SL3516) += gemini/
 obj-y += stm32/
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
-obj-$(CONFIG_CRYPTO_DEV_TEGRA) += tegra/
 obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
 #obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
-- 
2.25.1

