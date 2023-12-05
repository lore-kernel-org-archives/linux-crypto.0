Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="WQd4Rz90"
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D22F98
	for <linux-crypto@vger.kernel.org>; Tue,  5 Dec 2023 01:28:18 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6cbd24d9557so4314180b3a.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 Dec 2023 01:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1701768498; x=1702373298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Ww+t+x4EF+o8Iz1q4xD0rNSq2UgrGpxhIva2EbXP3U=;
        b=WQd4Rz90XOrJAD0wvBSaA0RZETBsG2VzReNSLplzy+/P//EiOtHblYd5upcyeQGq+w
         J3RoD5OHQT8q+3IHewwRRnD5NsFhPnXAiWCYw4Hs5QGNUIgeFZV+YGAt/hbooNuds0mz
         iF8+iJFXWbuAlWLgYTrG7qFTpy17EzpT5j5JHGfoUEhHAn/VIPFUCrjJrBE5jHMh6rX7
         ikfq9/TQ3lXm/euJj2cHnIS8RHs0KssxBX8Cqzl20QRecoURA6MxVhI8K4UrrH+j2eja
         mLN14jt+13Z5S93TIrAEjS8kgKhJBd+V1jI/PaI7odB+Hn0W3ZPU7OF378Y7zldLizw8
         eW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701768498; x=1702373298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Ww+t+x4EF+o8Iz1q4xD0rNSq2UgrGpxhIva2EbXP3U=;
        b=o5XYv13bW+2gzWcGP/swAGfUmhwmWAX4HULGAYryJ46vkTyYcpCcRmvP+Ob85/AChz
         GKe4TllxEZwj7PvDJ5VyUVYfwRJqtGiuC7VCpuchEksTJxAYZfp5yvex8TuOSDYCQ5qC
         rnbGkm2qdJrzsQiYNXQA92Fzu/NmuubvtpZ3PjPFgXU2DLal9lI1aAtCNDQdd1UdKHRX
         lb0SW9OLqoDGbWi/J6R8PggUR3fBgNhOdK9Db9/o2PzkPqKA6K79rBjsPtCHeC0v+NzD
         BrUA36Nxa/X/rK5ioNDVb8mXowS0pcqglPhfYbTDutBYW4gUv786DFUXfFI2MZX+uALW
         pDSw==
X-Gm-Message-State: AOJu0YxdGhISeWvCx03PLRcXTQv2aQwXckDLZByhg+DNYhH0JB1XBrHL
	bWpUPuQJJP5YWu2fETAY5HG7NA==
X-Google-Smtp-Source: AGHT+IFaWRkKbZw7DstMCEBheFGlYTaPcp/3Zi4NlnL96zF+Y1cISDdKfBWTpwQP+FRgk8CWXY1DdQ==
X-Received: by 2002:a05:6a00:893:b0:6ce:2757:7866 with SMTP id q19-20020a056a00089300b006ce27577866mr1216195pfj.33.1701768498058;
        Tue, 05 Dec 2023 01:28:18 -0800 (PST)
Received: from localhost.localdomain ([101.10.93.135])
        by smtp.gmail.com with ESMTPSA id l6-20020a056a00140600b006cdd723bb6fsm8858788pfu.115.2023.12.05.01.28.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Dec 2023 01:28:17 -0800 (PST)
From: Jerry Shih <jerry.shih@sifive.com>
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	conor.dooley@microchip.com,
	ebiggers@kernel.org,
	ardb@kernel.org,
	conor@kernel.org
Cc: heiko@sntech.de,
	phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v3 02/12] RISC-V: hook new crypto subdir into build-system
Date: Tue,  5 Dec 2023 17:27:51 +0800
Message-Id: <20231205092801.1335-3-jerry.shih@sifive.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20231205092801.1335-1-jerry.shih@sifive.com>
References: <20231205092801.1335-1-jerry.shih@sifive.com>
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
Reviewed-by: Eric Biggers <ebiggers@google.com>
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

