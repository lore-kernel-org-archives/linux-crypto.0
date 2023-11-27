Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="HmNx+yUn"
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4F6133
	for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:19 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cfc2bcffc7so5507205ad.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Nov 2023 23:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701068839; x=1701673639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMA+62ieF0dHRmbCC9GfwETOr1r4110ste5ly+nBz6U=;
        b=HmNx+yUnvgnQUx0mmcJDl6+/jcRjbWZTVcZkbiTQihU3fwI9ZVC+RNwaJxXO6r85XR
         9cfSYPzXj9ZIk9kOZ93aTwXGEK84mjROA5r+oSUWqtGGOM9zFRKqoc1mK02zW6q1wwrF
         x2iQRCavZJKOsP66zjln2HFTjRqKS8ZSNGxaQm52t38Pswhb74W6J3HV3lYcuRNgvhS1
         DYBvZpyKboPF4S9kPSZEqyi+/rn1Ji7KjBAzmghLYY19iPttqGkq1RAPvVBeRBPVRtH6
         NesvgqyiyeqfwhPmfH/y2+jUX/FIcD1/40PwW3YcDRPDCqdF1QfLb8HuEsA1vLCqxlJ1
         zAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701068839; x=1701673639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WMA+62ieF0dHRmbCC9GfwETOr1r4110ste5ly+nBz6U=;
        b=YriXgusoqMnJ1k3eIh1nixGo3atknwbeixhUYrJlGOhZBs76lANYjSmicGpjT8gEtT
         XUGOpWbtsdjT01V/w9oYR84bMjB/PHRy1F07/JDMYHNCUV+lmnb96oDwAgM7yZcADdyL
         /lvApwmX890j2lz+kV1Qe+vVvWt4DBBsvGx7qwmGkgIJFLGHv397WulrlTFUYHcWCNC2
         eu5S+8LGmcEkPNxPT4sLGry9ByDt1F4PZyVIfYfeZd3btSrcXWSs+hxiJKsEmawTRPsl
         Dhx1e0/R8zSGQiyNH1iYxg7ZilRI3v+LKwt03erGhNvOW+c9VFfOKY9VKMx0fnwKIorX
         U1LQ==
X-Gm-Message-State: AOJu0YwlVUT5m0uLpvfqBDE5feLxKMjmX4rPXdrGAy3wfUzne1v/TAd/
	/3+UYoacvUd/og/QgwYGt+PMXg==
X-Google-Smtp-Source: AGHT+IGuXY7hovfUUFK918N8FOS5pzp5Ne429WLs/7kFsDgC+8/3HusV0OnDurXW0gspNvwdh6EGhA==
X-Received: by 2002:a17:903:1205:b0:1cc:5589:7dba with SMTP id l5-20020a170903120500b001cc55897dbamr10929394plh.43.1701068839357;
        Sun, 26 Nov 2023 23:07:19 -0800 (PST)
Received: from localhost.localdomain ([101.10.45.230])
        by smtp.gmail.com with ESMTPSA id jh15-20020a170903328f00b001cfcd3a764esm1340134plb.77.2023.11.26.23.07.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Nov 2023 23:07:19 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 02/13] RISC-V: hook new crypto subdir into build-system
Date: Mon, 27 Nov 2023 15:06:52 +0800
Message-Id: <20231127070703.1697-3-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231127070703.1697-1-jerry.shih@sifive.com>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

Create a crypto subdirectory for added accelerated cryptography routines
and hook it into the riscv Kbuild and the main crypto Kconfig.

Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
---
 arch/riscv/Kbuild          | 1 +
 arch/riscv/crypto/Kconfig  | 5 +++++
 arch/riscv/crypto/Makefile | 4 ++++
 crypto/Kconfig             | 3 +++
 4 files changed, 13 insertions(+)
 create mode 100644 arch/riscv/crypto/Kconfig
 create mode 100644 arch/riscv/crypto/Makefile

diff --git a/arch/riscv/Kbuild b/arch/riscv/Kbuild
index d25ad1c19f88..2c585f7a0b6e 100644
--- a/arch/riscv/Kbuild
+++ b/arch/riscv/Kbuild
@@ -2,6 +2,7 @@
 
 obj-y += kernel/ mm/ net/
 obj-$(CONFIG_BUILTIN_DTB) += boot/dts/
+obj-$(CONFIG_CRYPTO) += crypto/
 obj-y += errata/
 obj-$(CONFIG_KVM) += kvm/
 
diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
new file mode 100644
index 000000000000..10d60edc0110
--- /dev/null
+++ b/arch/riscv/crypto/Kconfig
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
+
+endmenu
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
new file mode 100644
index 000000000000..b3b6332c9f6d
--- /dev/null
+++ b/arch/riscv/crypto/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# linux/arch/riscv/crypto/Makefile
+#
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 650b1b3620d8..c7b23d2c58e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1436,6 +1436,9 @@ endif
 if PPC
 source "arch/powerpc/crypto/Kconfig"
 endif
+if RISCV
+source "arch/riscv/crypto/Kconfig"
+endif
 if S390
 source "arch/s390/crypto/Kconfig"
 endif
-- 
2.28.0

