Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ACE81728;
	Thu, 26 Dec 2024 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735242282; cv=none; b=kWldrrxmWoKztxQKgoOSw6f9qdhY6Zg6W50TpKoNT2vWPUfrAo4fKqVTFNuBU3DAelK3sg9zejzVzCnbSrVdxgB0dPSi1Jxxo2dMy186I3Z9kkv4b6QW5ClTFiYv3urir/W8yIl56Jgzolio12XKbJCINPCthh57bDDSIfAPWm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735242282; c=relaxed/simple;
	bh=RNtKjHmG1cxO5fSmWFpQyJmZ7B6xIEvmSJhPL7o8me8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=axc3lUvx5EOQBWBUvOMmtOh9onUM3DpSYFVJnSY8h3gsqm8eEdkpuwymb4mwrbufSuFLddqlKKx1NIQEC44YFWVBE/67QiwUqu58AHDiHTmA84DLwferraJZRQaZENjjqQbdgTSqBKauIbf7zWd4oUCD3AV8dhZ/QUwJOon1kvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUHqjKcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUHqjKcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FB5C4CED1;
	Thu, 26 Dec 2024 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735242281;
	bh=RNtKjHmG1cxO5fSmWFpQyJmZ7B6xIEvmSJhPL7o8me8=;
	h=From:To:Cc:Subject:Date:From;
	b=nUHqjKcZ/ONYM46qGFwae1H2DObbqeMGu0bpNu7H5g1e7C/Uk3+bF5RNjuy/ep0sN
	 a6kG8VspsbzOOS2OL+uWedYB2uWvQFzSOKTrNjOf99zUnOKT8DDfZeB4hTaQx7arf1
	 50h68gqv2YhmC0pdh8RrAE8b7ZsMhjtepgQsvwdxT+bAmh2UcavWhvEI5ePlz6f8mz
	 MB4M743D/M2PVG+jhliI9jzK7GJol4QXAGjk5ShaudUttQKxO3MJEt86Fi5g2BB3rV
	 o/oiU27H8ei7YFo6r6HYN58+EWXtrVAjKlTNKARn+WQn2PschzxpvGqTd1IfKruS+Y
	 CgPGyUMaPYf8Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Atharva Tiwari <evepolonium@gmail.com>,
	Shane Wang <shane.wang@intel.com>
Subject: [PATCH] crypto: vmac - remove unused VMAC algorithm
Date: Thu, 26 Dec 2024 11:43:08 -0800
Message-ID: <20241226194309.27733-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove the vmac64 template, as it has no known users.  It also continues
to have longstanding bugs such as alignment violations (see
https://lore.kernel.org/r/20241226134847.6690-1-evepolonium@gmail.com/).

This code was added in 2009 by commit f1939f7c5645 ("crypto: vmac - New
hash algorithm for intel_txt support").  Based on the mention of
intel_txt support in the commit title, it seems it was added as a
prerequisite for the contemporaneous patch
"intel_txt: add s3 userspace memory integrity verification"
(https://lore.kernel.org/r/4ABF2B50.6070106@intel.com/).  In the design
proposed by that patch, when an Intel Trusted Execution Technology (TXT)
enabled system resumed from suspend, the "tboot" trusted executable
launched the Linux kernel without verifying userspace memory, and then
the Linux kernel used VMAC to verify userspace memory.

However, that patch was never merged, as reviewers had objected to the
design.  It was later reworked into commit 4bd96a7a8185 ("x86, tboot:
Add support for S3 memory integrity protection") which made tboot verify
the memory instead.  Thus the VMAC support in Linux was never used.

No in-tree user has appeared since then, other than potentially the
usual components that allow specifying arbitrary hash algorithms by
name, namely AF_ALG and dm-integrity.  However there are no indications
that VMAC is being used with these components.  Debian Code Search and
web searches for "vmac64" (the actual algorithm name) do not return any
results other than the kernel itself, suggesting that it does not appear
in any other code or documentation.  Explicitly grepping the source code
of the usual suspects (libell, iwd, cryptsetup) finds no matches either.

Before 2018, the vmac code was also completely broken due to using a
hardcoded nonce and the wrong endianness for the MAC.  It was then fixed
by commit ed331adab35b ("crypto: vmac - add nonced version with big
endian digest") and commit 0917b873127c ("crypto: vmac - remove insecure
version with hardcoded nonce").  These were intentionally breaking
changes that changed all the computed MAC values as well as the
algorithm name ("vmac" to "vmac64").  No complaints were ever received
about these breaking changes, strongly suggesting the absence of users.

The reason I had put some effort into fixing this code in 2018 is
because it was used by an out-of-tree driver.  But if it is still needed
in that particular out-of-tree driver, the code can be carried in that
driver instead.  There is no need to carry it upstream.

Cc: Atharva Tiwari <evepolonium@gmail.com>
Cc: Shane Wang <shane.wang@intel.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/pxa_defconfig             |   1 -
 arch/loongarch/configs/loongson3_defconfig |   1 -
 arch/m68k/configs/amiga_defconfig          |   1 -
 arch/m68k/configs/apollo_defconfig         |   1 -
 arch/m68k/configs/atari_defconfig          |   1 -
 arch/m68k/configs/bvme6000_defconfig       |   1 -
 arch/m68k/configs/hp300_defconfig          |   1 -
 arch/m68k/configs/mac_defconfig            |   1 -
 arch/m68k/configs/multi_defconfig          |   1 -
 arch/m68k/configs/mvme147_defconfig        |   1 -
 arch/m68k/configs/mvme16x_defconfig        |   1 -
 arch/m68k/configs/q40_defconfig            |   1 -
 arch/m68k/configs/sun3_defconfig           |   1 -
 arch/m68k/configs/sun3x_defconfig          |   1 -
 arch/mips/configs/bigsur_defconfig         |   1 -
 arch/mips/configs/decstation_64_defconfig  |   1 -
 arch/mips/configs/decstation_defconfig     |   1 -
 arch/mips/configs/decstation_r4k_defconfig |   1 -
 arch/mips/configs/ip27_defconfig           |   1 -
 arch/mips/configs/ip30_defconfig           |   1 -
 arch/s390/configs/debug_defconfig          |   1 -
 arch/s390/configs/defconfig                |   1 -
 crypto/Kconfig                             |  10 -
 crypto/Makefile                            |   1 -
 crypto/tcrypt.c                            |   4 -
 crypto/testmgr.c                           |   6 -
 crypto/testmgr.h                           | 153 -----
 crypto/vmac.c                              | 696 ---------------------
 28 files changed, 892 deletions(-)
 delete mode 100644 crypto/vmac.c

diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index 38916ac4bce4..de0ac8f521d7 100644
--- a/arch/arm/configs/pxa_defconfig
+++ b/arch/arm/configs/pxa_defconfig
@@ -650,11 +650,10 @@ CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_TGR192=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_XCBC=m
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index 4dffc90192f7..6965b009e9a2 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -1027,11 +1027,10 @@ CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_DEFLATE=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index c705247e7b5b..5f9117b46867 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -587,11 +587,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 6d62b9187a58..eb8a0432f1fa 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -544,11 +544,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index c3c644df852d..8ac95c1207b1 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -564,11 +564,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 20261f819691..cf9ea62bdcbe 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -536,11 +536,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index ce4fe93a0f70..aacb040b741e 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -546,11 +546,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index 040ae75f47c3..2b0383580564 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -563,11 +563,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 20d877cb4e30..3d0b5af6bb60 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -650,11 +650,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 5e1c8d0d3da5..ee0f2fbd7fbf 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -536,11 +536,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 5d1409e6a137..cac90de4f3e7 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -537,11 +537,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index e4c30e2b9bbb..5301fc6fbd37 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -553,11 +553,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 980843a9ea1e..1002082c0b5e 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -534,11 +534,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 38681cc6b598..65c80b7188fd 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -534,11 +534,10 @@ CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index e463a9acae03..f7c4b3529a2c 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -220,11 +220,10 @@ CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 92a1d0aea38c..62b82ac05cf8 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -178,11 +178,10 @@ CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_CRCT10DIF=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index db214fcebcbe..46dc33484660 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -173,11 +173,10 @@ CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_CRCT10DIF=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index 15b769e96d5b..beec4fdb8fc6 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -173,11 +173,10 @@ CONFIG_CRYPTO_OFB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_KEYWRAP=m
 CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_CRCT10DIF=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 4714074c8bd7..b08a199767d1 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -303,11 +303,10 @@ CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_XCBC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
diff --git a/arch/mips/configs/ip30_defconfig b/arch/mips/configs/ip30_defconfig
index 178d61645cea..270181a7320a 100644
--- a/arch/mips/configs/ip30_defconfig
+++ b/arch/mips/configs/ip30_defconfig
@@ -174,10 +174,9 @@ CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_RMD160=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_LZO=m
 CONFIG_CRC_T10DIF=m
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index d8d227ab82de..885e73955d6a 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -780,11 +780,10 @@ CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 6c2f2bb4fbf8..eba7e76ccd6e 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -766,11 +766,10 @@ CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_SM3_GENERIC=m
-CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_CRC32=m
 CONFIG_CRYPTO_842=m
 CONFIG_CRYPTO_LZ4=m
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6b0bfbccac08..2b2bb679e6b6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1027,20 +1027,10 @@ config CRYPTO_STREEBOG
 
 	  References:
 	  https://tc26.ru/upload/iblock/fed/feddbb4d26b685903faa2ba11aea43f6.pdf
 	  https://tools.ietf.org/html/rfc6986
 
-config CRYPTO_VMAC
-	tristate "VMAC"
-	select CRYPTO_HASH
-	select CRYPTO_MANAGER
-	help
-	  VMAC is a message authentication algorithm designed for
-	  very high speed on 64-bit architectures.
-
-	  See https://fastcrypto.org/vmac for further information.
-
 config CRYPTO_WP512
 	tristate "Whirlpool"
 	select CRYPTO_HASH
 	help
 	  Whirlpool hash function (ISO/IEC 10118-3)
diff --git a/crypto/Makefile b/crypto/Makefile
index 77abca715445..7c8a61c61b0f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -67,11 +67,10 @@ cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
 obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
-obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
 obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e9e7dceb606e..e1a74cb2cfbe 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1736,14 +1736,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 
 	case 108:
 		ret = min(ret, tcrypt_test("hmac(rmd160)"));
 		break;
 
-	case 109:
-		ret = min(ret, tcrypt_test("vmac64(aes)"));
-		break;
-
 	case 111:
 		ret = min(ret, tcrypt_test("hmac(sha3-224)"));
 		break;
 
 	case 112:
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1f5f48ab18c7..43eda27079de 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5747,16 +5747,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "streebog512",
 		.test = alg_test_hash,
 		.suite = {
 			.hash = __VECS(streebog512_tv_template)
 		}
-	}, {
-		.alg = "vmac64(aes)",
-		.test = alg_test_hash,
-		.suite = {
-			.hash = __VECS(vmac64_aes_tv_template)
-		}
 	}, {
 		.alg = "wp256",
 		.test = alg_test_hash,
 		.suite = {
 			.hash = __VECS(wp256_tv_template)
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 430d33d9ac13..a5cd350434ac 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -8559,163 +8559,10 @@ static const struct hash_testvec aes_xcbc128_tv_template[] = {
 		.psize	= 34,
 		.ksize	= 16,
 	}
 };
 
-static const char vmac64_string1[144] = {
-	'\0',     '\0',   '\0',   '\0',   '\0',   '\0',   '\0',   '\0',
-	'\0',     '\0',   '\0',   '\0',   '\0',   '\0',   '\0',   '\0',
-	'\x01', '\x01', '\x01', '\x01', '\x02', '\x03', '\x02', '\x02',
-	'\x02', '\x04', '\x01', '\x07', '\x04', '\x01', '\x04', '\x03',
-};
-
-static const char vmac64_string2[144] = {
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	 'a',  'b',  'c',
-};
-
-static const char vmac64_string3[144] = {
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	 'a',  'b',  'c',  'a',  'b',  'c',  'a',  'b',
-	 'c',  'a',  'b',  'c',  'a',  'b',  'c',  'a',
-	 'b',  'c',  'a',  'b',  'c',  'a',  'b',  'c',
-	 'a',  'b',  'c',  'a',  'b',  'c',  'a',  'b',
-	 'c',  'a',  'b',  'c',  'a',  'b',  'c',  'a',
-	 'b',  'c',  'a',  'b',  'c',  'a',  'b',  'c',
-};
-
-static const char vmac64_string4[33] = {
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	'b',   'c',  'e',  'f',  'i',  'j',  'l',  'm',
-	'o',   'p',  'r',  's',  't',  'u',  'w',  'x',
-	'z',
-};
-
-static const char vmac64_string5[143] = {
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	 'r',  'm',  'b',  't',  'c',  'o',  'l',  'k',
-	 ']',  '%',  '9',  '2',  '7',  '!',  'A',
-};
-
-static const char vmac64_string6[145] = {
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	'\0', '\0', '\0', '\0', '\0', '\0', '\0', '\0',
-	 'p',  't',  '*',  '7',  'l',  'i',  '!',  '#',
-	 'w',  '0',  'z',  '/',  '4',  'A',  'n',
-};
-
-static const struct hash_testvec vmac64_aes_tv_template[] = {
-	{ /* draft-krovetz-vmac-01 test vector 1 */
-		.key	= "abcdefghijklmnop",
-		.ksize	= 16,
-		.plaintext = "\0\0\0\0\0\0\0\0bcdefghi",
-		.psize	= 16,
-		.digest	= "\x25\x76\xbe\x1c\x56\xd8\xb8\x1b",
-	}, { /* draft-krovetz-vmac-01 test vector 2 */
-		.key	= "abcdefghijklmnop",
-		.ksize	= 16,
-		.plaintext = "\0\0\0\0\0\0\0\0bcdefghiabc",
-		.psize	= 19,
-		.digest	= "\x2d\x37\x6c\xf5\xb1\x81\x3c\xe5",
-	}, { /* draft-krovetz-vmac-01 test vector 3 */
-		.key	= "abcdefghijklmnop",
-		.ksize	= 16,
-		.plaintext = "\0\0\0\0\0\0\0\0bcdefghi"
-			  "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc",
-		.psize	= 64,
-		.digest	= "\xe8\x42\x1f\x61\xd5\x73\xd2\x98",
-	}, { /* draft-krovetz-vmac-01 test vector 4 */
-		.key	= "abcdefghijklmnop",
-		.ksize	= 16,
-		.plaintext = "\0\0\0\0\0\0\0\0bcdefghi"
-			  "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc"
-			  "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc"
-			  "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc"
-			  "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc"
-			  "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc"
-			  "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabc",
-		.psize	= 316,
-		.digest	= "\x44\x92\xdf\x6c\x5c\xac\x1b\xbe",
-	}, {
-		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.ksize	= 16,
-		.plaintext = "\x00\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.psize	= 16,
-		.digest	= "\x54\x7b\xa4\x77\x35\x80\x58\x07",
-	}, {
-		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.ksize	= 16,
-		.plaintext = vmac64_string1,
-		.psize	= sizeof(vmac64_string1),
-		.digest	= "\xa1\x8c\x68\xae\xd3\x3c\xf5\xce",
-	}, {
-		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.ksize	= 16,
-		.plaintext = vmac64_string2,
-		.psize	= sizeof(vmac64_string2),
-		.digest	= "\x2d\x14\xbd\x81\x73\xb0\x27\xc9",
-	}, {
-		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
-			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
-		.ksize	= 16,
-		.plaintext = vmac64_string3,
-		.psize	= sizeof(vmac64_string3),
-		.digest	= "\x19\x0b\x47\x98\x8c\x95\x1a\x8d",
-	}, {
-		.key	= "abcdefghijklmnop",
-		.ksize	= 16,
-		.plaintext = "\x00\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.psize	= 16,
-		.digest	= "\x84\x8f\x55\x9e\x26\xa1\x89\x3b",
-	}, {
-		.key	= "abcdefghijklmnop",
-		.ksize	= 16,
-		.plaintext = vmac64_string1,
-		.psize	= sizeof(vmac64_string1),
-		.digest	= "\xc2\x74\x8d\xf6\xb0\xab\x5e\xab",
-	}, {
-		.key	= "abcdefghijklmnop",
-		.ksize	= 16,
-		.plaintext = vmac64_string2,
-		.psize	= sizeof(vmac64_string2),
-		.digest	= "\xdf\x09\x7b\x3d\x42\x68\x15\x11",
-	}, {
-		.key	= "abcdefghijklmnop",
-		.ksize	= 16,
-		.plaintext = vmac64_string3,
-		.psize	= sizeof(vmac64_string3),
-		.digest	= "\xd4\xfa\x8f\xed\xe1\x8f\x32\x8b",
-	}, {
-		.key	= "a09b5cd!f#07K\x00\x00\x00",
-		.ksize	= 16,
-		.plaintext = vmac64_string4,
-		.psize	= sizeof(vmac64_string4),
-		.digest	= "\x5f\xa1\x4e\x42\xea\x0f\xa5\xab",
-	}, {
-		.key	= "a09b5cd!f#07K\x00\x00\x00",
-		.ksize	= 16,
-		.plaintext = vmac64_string5,
-		.psize	= sizeof(vmac64_string5),
-		.digest	= "\x60\x67\xe8\x1d\xbc\x98\x31\x25",
-	}, {
-		.key	= "a09b5cd!f#07K\x00\x00\x00",
-		.ksize	= 16,
-		.plaintext = vmac64_string6,
-		.psize	= sizeof(vmac64_string6),
-		.digest	= "\x41\xeb\x65\x95\x47\x9b\xae\xc4",
-	},
-};
-
 /*
  * SHA384 HMAC test vectors from RFC4231
  */
 
 static const struct hash_testvec hmac_sha384_tv_template[] = {
diff --git a/crypto/vmac.c b/crypto/vmac.c
deleted file mode 100644
index 2ea384645ecf..000000000000
--- a/crypto/vmac.c
+++ /dev/null
@@ -1,696 +0,0 @@
-/*
- * VMAC: Message Authentication Code using Universal Hashing
- *
- * Reference: https://tools.ietf.org/html/draft-krovetz-vmac-01
- *
- * Copyright (c) 2009, Intel Corporation.
- * Copyright (c) 2018, Google Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- */
-
-/*
- * Derived from:
- *	VMAC and VHASH Implementation by Ted Krovetz (tdk@acm.org) and Wei Dai.
- *	This implementation is herby placed in the public domain.
- *	The authors offers no warranty. Use at your own risk.
- *	Last modified: 17 APR 08, 1700 PDT
- */
-
-#include <linux/unaligned.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
-#include <linux/module.h>
-#include <linux/scatterlist.h>
-#include <asm/byteorder.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/cipher.h>
-#include <crypto/internal/hash.h>
-
-/*
- * User definable settings.
- */
-#define VMAC_TAG_LEN	64
-#define VMAC_KEY_SIZE	128/* Must be 128, 192 or 256			*/
-#define VMAC_KEY_LEN	(VMAC_KEY_SIZE/8)
-#define VMAC_NHBYTES	128/* Must 2^i for any 3 < i < 13 Standard = 128*/
-#define VMAC_NONCEBYTES	16
-
-/* per-transform (per-key) context */
-struct vmac_tfm_ctx {
-	struct crypto_cipher *cipher;
-	u64 nhkey[(VMAC_NHBYTES/8)+2*(VMAC_TAG_LEN/64-1)];
-	u64 polykey[2*VMAC_TAG_LEN/64];
-	u64 l3key[2*VMAC_TAG_LEN/64];
-};
-
-/* per-request context */
-struct vmac_desc_ctx {
-	union {
-		u8 partial[VMAC_NHBYTES];	/* partial block */
-		__le64 partial_words[VMAC_NHBYTES / 8];
-	};
-	unsigned int partial_size;	/* size of the partial block */
-	bool first_block_processed;
-	u64 polytmp[2*VMAC_TAG_LEN/64];	/* running total of L2-hash */
-	union {
-		u8 bytes[VMAC_NONCEBYTES];
-		__be64 pads[VMAC_NONCEBYTES / 8];
-	} nonce;
-	unsigned int nonce_size; /* nonce bytes filled so far */
-};
-
-/*
- * Constants and masks
- */
-#define UINT64_C(x) x##ULL
-static const u64 p64   = UINT64_C(0xfffffffffffffeff);	/* 2^64 - 257 prime  */
-static const u64 m62   = UINT64_C(0x3fffffffffffffff);	/* 62-bit mask       */
-static const u64 m63   = UINT64_C(0x7fffffffffffffff);	/* 63-bit mask       */
-static const u64 m64   = UINT64_C(0xffffffffffffffff);	/* 64-bit mask       */
-static const u64 mpoly = UINT64_C(0x1fffffff1fffffff);	/* Poly key mask     */
-
-#define pe64_to_cpup le64_to_cpup		/* Prefer little endian */
-
-#ifdef __LITTLE_ENDIAN
-#define INDEX_HIGH 1
-#define INDEX_LOW 0
-#else
-#define INDEX_HIGH 0
-#define INDEX_LOW 1
-#endif
-
-/*
- * The following routines are used in this implementation. They are
- * written via macros to simulate zero-overhead call-by-reference.
- *
- * MUL64: 64x64->128-bit multiplication
- * PMUL64: assumes top bits cleared on inputs
- * ADD128: 128x128->128-bit addition
- */
-
-#define ADD128(rh, rl, ih, il)						\
-	do {								\
-		u64 _il = (il);						\
-		(rl) += (_il);						\
-		if ((rl) < (_il))					\
-			(rh)++;						\
-		(rh) += (ih);						\
-	} while (0)
-
-#define MUL32(i1, i2)	((u64)(u32)(i1)*(u32)(i2))
-
-#define PMUL64(rh, rl, i1, i2)	/* Assumes m doesn't overflow */	\
-	do {								\
-		u64 _i1 = (i1), _i2 = (i2);				\
-		u64 m = MUL32(_i1, _i2>>32) + MUL32(_i1>>32, _i2);	\
-		rh = MUL32(_i1>>32, _i2>>32);				\
-		rl = MUL32(_i1, _i2);					\
-		ADD128(rh, rl, (m >> 32), (m << 32));			\
-	} while (0)
-
-#define MUL64(rh, rl, i1, i2)						\
-	do {								\
-		u64 _i1 = (i1), _i2 = (i2);				\
-		u64 m1 = MUL32(_i1, _i2>>32);				\
-		u64 m2 = MUL32(_i1>>32, _i2);				\
-		rh = MUL32(_i1>>32, _i2>>32);				\
-		rl = MUL32(_i1, _i2);					\
-		ADD128(rh, rl, (m1 >> 32), (m1 << 32));			\
-		ADD128(rh, rl, (m2 >> 32), (m2 << 32));			\
-	} while (0)
-
-/*
- * For highest performance the L1 NH and L2 polynomial hashes should be
- * carefully implemented to take advantage of one's target architecture.
- * Here these two hash functions are defined multiple time; once for
- * 64-bit architectures, once for 32-bit SSE2 architectures, and once
- * for the rest (32-bit) architectures.
- * For each, nh_16 *must* be defined (works on multiples of 16 bytes).
- * Optionally, nh_vmac_nhbytes can be defined (for multiples of
- * VMAC_NHBYTES), and nh_16_2 and nh_vmac_nhbytes_2 (versions that do two
- * NH computations at once).
- */
-
-#ifdef CONFIG_64BIT
-
-#define nh_16(mp, kp, nw, rh, rl)					\
-	do {								\
-		int i; u64 th, tl;					\
-		rh = rl = 0;						\
-		for (i = 0; i < nw; i += 2) {				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
-				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
-			ADD128(rh, rl, th, tl);				\
-		}							\
-	} while (0)
-
-#define nh_16_2(mp, kp, nw, rh, rl, rh1, rl1)				\
-	do {								\
-		int i; u64 th, tl;					\
-		rh1 = rl1 = rh = rl = 0;				\
-		for (i = 0; i < nw; i += 2) {				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
-				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
-			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i+2],	\
-				pe64_to_cpup((mp)+i+1)+(kp)[i+3]);	\
-			ADD128(rh1, rl1, th, tl);			\
-		}							\
-	} while (0)
-
-#if (VMAC_NHBYTES >= 64) /* These versions do 64-bytes of message at a time */
-#define nh_vmac_nhbytes(mp, kp, nw, rh, rl)				\
-	do {								\
-		int i; u64 th, tl;					\
-		rh = rl = 0;						\
-		for (i = 0; i < nw; i += 8) {				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
-				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
-			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+2)+(kp)[i+2],	\
-				pe64_to_cpup((mp)+i+3)+(kp)[i+3]);	\
-			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+4)+(kp)[i+4],	\
-				pe64_to_cpup((mp)+i+5)+(kp)[i+5]);	\
-			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+6)+(kp)[i+6],	\
-				pe64_to_cpup((mp)+i+7)+(kp)[i+7]);	\
-			ADD128(rh, rl, th, tl);				\
-		}							\
-	} while (0)
-
-#define nh_vmac_nhbytes_2(mp, kp, nw, rh, rl, rh1, rl1)			\
-	do {								\
-		int i; u64 th, tl;					\
-		rh1 = rl1 = rh = rl = 0;				\
-		for (i = 0; i < nw; i += 8) {				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i],	\
-				pe64_to_cpup((mp)+i+1)+(kp)[i+1]);	\
-			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i)+(kp)[i+2],	\
-				pe64_to_cpup((mp)+i+1)+(kp)[i+3]);	\
-			ADD128(rh1, rl1, th, tl);			\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+2)+(kp)[i+2],	\
-				pe64_to_cpup((mp)+i+3)+(kp)[i+3]);	\
-			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+2)+(kp)[i+4],	\
-				pe64_to_cpup((mp)+i+3)+(kp)[i+5]);	\
-			ADD128(rh1, rl1, th, tl);			\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+4)+(kp)[i+4],	\
-				pe64_to_cpup((mp)+i+5)+(kp)[i+5]);	\
-			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+4)+(kp)[i+6],	\
-				pe64_to_cpup((mp)+i+5)+(kp)[i+7]);	\
-			ADD128(rh1, rl1, th, tl);			\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+6)+(kp)[i+6],	\
-				pe64_to_cpup((mp)+i+7)+(kp)[i+7]);	\
-			ADD128(rh, rl, th, tl);				\
-			MUL64(th, tl, pe64_to_cpup((mp)+i+6)+(kp)[i+8],	\
-				pe64_to_cpup((mp)+i+7)+(kp)[i+9]);	\
-			ADD128(rh1, rl1, th, tl);			\
-		}							\
-	} while (0)
-#endif
-
-#define poly_step(ah, al, kh, kl, mh, ml)				\
-	do {								\
-		u64 t1h, t1l, t2h, t2l, t3h, t3l, z = 0;		\
-		/* compute ab*cd, put bd into result registers */	\
-		PMUL64(t3h, t3l, al, kh);				\
-		PMUL64(t2h, t2l, ah, kl);				\
-		PMUL64(t1h, t1l, ah, 2*kh);				\
-		PMUL64(ah, al, al, kl);					\
-		/* add 2 * ac to result */				\
-		ADD128(ah, al, t1h, t1l);				\
-		/* add together ad + bc */				\
-		ADD128(t2h, t2l, t3h, t3l);				\
-		/* now (ah,al), (t2l,2*t2h) need summing */		\
-		/* first add the high registers, carrying into t2h */	\
-		ADD128(t2h, ah, z, t2l);				\
-		/* double t2h and add top bit of ah */			\
-		t2h = 2 * t2h + (ah >> 63);				\
-		ah &= m63;						\
-		/* now add the low registers */				\
-		ADD128(ah, al, mh, ml);					\
-		ADD128(ah, al, z, t2h);					\
-	} while (0)
-
-#else /* ! CONFIG_64BIT */
-
-#ifndef nh_16
-#define nh_16(mp, kp, nw, rh, rl)					\
-	do {								\
-		u64 t1, t2, m1, m2, t;					\
-		int i;							\
-		rh = rl = t = 0;					\
-		for (i = 0; i < nw; i += 2)  {				\
-			t1 = pe64_to_cpup(mp+i) + kp[i];		\
-			t2 = pe64_to_cpup(mp+i+1) + kp[i+1];		\
-			m2 = MUL32(t1 >> 32, t2);			\
-			m1 = MUL32(t1, t2 >> 32);			\
-			ADD128(rh, rl, MUL32(t1 >> 32, t2 >> 32),	\
-				MUL32(t1, t2));				\
-			rh += (u64)(u32)(m1 >> 32)			\
-				+ (u32)(m2 >> 32);			\
-			t += (u64)(u32)m1 + (u32)m2;			\
-		}							\
-		ADD128(rh, rl, (t >> 32), (t << 32));			\
-	} while (0)
-#endif
-
-static void poly_step_func(u64 *ahi, u64 *alo,
-			const u64 *kh, const u64 *kl,
-			const u64 *mh, const u64 *ml)
-{
-#define a0 (*(((u32 *)alo)+INDEX_LOW))
-#define a1 (*(((u32 *)alo)+INDEX_HIGH))
-#define a2 (*(((u32 *)ahi)+INDEX_LOW))
-#define a3 (*(((u32 *)ahi)+INDEX_HIGH))
-#define k0 (*(((u32 *)kl)+INDEX_LOW))
-#define k1 (*(((u32 *)kl)+INDEX_HIGH))
-#define k2 (*(((u32 *)kh)+INDEX_LOW))
-#define k3 (*(((u32 *)kh)+INDEX_HIGH))
-
-	u64 p, q, t;
-	u32 t2;
-
-	p = MUL32(a3, k3);
-	p += p;
-	p += *(u64 *)mh;
-	p += MUL32(a0, k2);
-	p += MUL32(a1, k1);
-	p += MUL32(a2, k0);
-	t = (u32)(p);
-	p >>= 32;
-	p += MUL32(a0, k3);
-	p += MUL32(a1, k2);
-	p += MUL32(a2, k1);
-	p += MUL32(a3, k0);
-	t |= ((u64)((u32)p & 0x7fffffff)) << 32;
-	p >>= 31;
-	p += (u64)(((u32 *)ml)[INDEX_LOW]);
-	p += MUL32(a0, k0);
-	q =  MUL32(a1, k3);
-	q += MUL32(a2, k2);
-	q += MUL32(a3, k1);
-	q += q;
-	p += q;
-	t2 = (u32)(p);
-	p >>= 32;
-	p += (u64)(((u32 *)ml)[INDEX_HIGH]);
-	p += MUL32(a0, k1);
-	p += MUL32(a1, k0);
-	q =  MUL32(a2, k3);
-	q += MUL32(a3, k2);
-	q += q;
-	p += q;
-	*(u64 *)(alo) = (p << 32) | t2;
-	p >>= 32;
-	*(u64 *)(ahi) = p + t;
-
-#undef a0
-#undef a1
-#undef a2
-#undef a3
-#undef k0
-#undef k1
-#undef k2
-#undef k3
-}
-
-#define poly_step(ah, al, kh, kl, mh, ml)				\
-	poly_step_func(&(ah), &(al), &(kh), &(kl), &(mh), &(ml))
-
-#endif  /* end of specialized NH and poly definitions */
-
-/* At least nh_16 is defined. Defined others as needed here */
-#ifndef nh_16_2
-#define nh_16_2(mp, kp, nw, rh, rl, rh2, rl2)				\
-	do { 								\
-		nh_16(mp, kp, nw, rh, rl);				\
-		nh_16(mp, ((kp)+2), nw, rh2, rl2);			\
-	} while (0)
-#endif
-#ifndef nh_vmac_nhbytes
-#define nh_vmac_nhbytes(mp, kp, nw, rh, rl)				\
-	nh_16(mp, kp, nw, rh, rl)
-#endif
-#ifndef nh_vmac_nhbytes_2
-#define nh_vmac_nhbytes_2(mp, kp, nw, rh, rl, rh2, rl2)			\
-	do {								\
-		nh_vmac_nhbytes(mp, kp, nw, rh, rl);			\
-		nh_vmac_nhbytes(mp, ((kp)+2), nw, rh2, rl2);		\
-	} while (0)
-#endif
-
-static u64 l3hash(u64 p1, u64 p2, u64 k1, u64 k2, u64 len)
-{
-	u64 rh, rl, t, z = 0;
-
-	/* fully reduce (p1,p2)+(len,0) mod p127 */
-	t = p1 >> 63;
-	p1 &= m63;
-	ADD128(p1, p2, len, t);
-	/* At this point, (p1,p2) is at most 2^127+(len<<64) */
-	t = (p1 > m63) + ((p1 == m63) && (p2 == m64));
-	ADD128(p1, p2, z, t);
-	p1 &= m63;
-
-	/* compute (p1,p2)/(2^64-2^32) and (p1,p2)%(2^64-2^32) */
-	t = p1 + (p2 >> 32);
-	t += (t >> 32);
-	t += (u32)t > 0xfffffffeu;
-	p1 += (t >> 32);
-	p2 += (p1 << 32);
-
-	/* compute (p1+k1)%p64 and (p2+k2)%p64 */
-	p1 += k1;
-	p1 += (0 - (p1 < k1)) & 257;
-	p2 += k2;
-	p2 += (0 - (p2 < k2)) & 257;
-
-	/* compute (p1+k1)*(p2+k2)%p64 */
-	MUL64(rh, rl, p1, p2);
-	t = rh >> 56;
-	ADD128(t, rl, z, rh);
-	rh <<= 8;
-	ADD128(t, rl, z, rh);
-	t += t << 8;
-	rl += t;
-	rl += (0 - (rl < t)) & 257;
-	rl += (0 - (rl > p64-1)) & 257;
-	return rl;
-}
-
-/* L1 and L2-hash one or more VMAC_NHBYTES-byte blocks */
-static void vhash_blocks(const struct vmac_tfm_ctx *tctx,
-			 struct vmac_desc_ctx *dctx,
-			 const __le64 *mptr, unsigned int blocks)
-{
-	const u64 *kptr = tctx->nhkey;
-	const u64 pkh = tctx->polykey[0];
-	const u64 pkl = tctx->polykey[1];
-	u64 ch = dctx->polytmp[0];
-	u64 cl = dctx->polytmp[1];
-	u64 rh, rl;
-
-	if (!dctx->first_block_processed) {
-		dctx->first_block_processed = true;
-		nh_vmac_nhbytes(mptr, kptr, VMAC_NHBYTES/8, rh, rl);
-		rh &= m62;
-		ADD128(ch, cl, rh, rl);
-		mptr += (VMAC_NHBYTES/sizeof(u64));
-		blocks--;
-	}
-
-	while (blocks--) {
-		nh_vmac_nhbytes(mptr, kptr, VMAC_NHBYTES/8, rh, rl);
-		rh &= m62;
-		poly_step(ch, cl, pkh, pkl, rh, rl);
-		mptr += (VMAC_NHBYTES/sizeof(u64));
-	}
-
-	dctx->polytmp[0] = ch;
-	dctx->polytmp[1] = cl;
-}
-
-static int vmac_setkey(struct crypto_shash *tfm,
-		       const u8 *key, unsigned int keylen)
-{
-	struct vmac_tfm_ctx *tctx = crypto_shash_ctx(tfm);
-	__be64 out[2];
-	u8 in[16] = { 0 };
-	unsigned int i;
-	int err;
-
-	if (keylen != VMAC_KEY_LEN)
-		return -EINVAL;
-
-	err = crypto_cipher_setkey(tctx->cipher, key, keylen);
-	if (err)
-		return err;
-
-	/* Fill nh key */
-	in[0] = 0x80;
-	for (i = 0; i < ARRAY_SIZE(tctx->nhkey); i += 2) {
-		crypto_cipher_encrypt_one(tctx->cipher, (u8 *)out, in);
-		tctx->nhkey[i] = be64_to_cpu(out[0]);
-		tctx->nhkey[i+1] = be64_to_cpu(out[1]);
-		in[15]++;
-	}
-
-	/* Fill poly key */
-	in[0] = 0xC0;
-	in[15] = 0;
-	for (i = 0; i < ARRAY_SIZE(tctx->polykey); i += 2) {
-		crypto_cipher_encrypt_one(tctx->cipher, (u8 *)out, in);
-		tctx->polykey[i] = be64_to_cpu(out[0]) & mpoly;
-		tctx->polykey[i+1] = be64_to_cpu(out[1]) & mpoly;
-		in[15]++;
-	}
-
-	/* Fill ip key */
-	in[0] = 0xE0;
-	in[15] = 0;
-	for (i = 0; i < ARRAY_SIZE(tctx->l3key); i += 2) {
-		do {
-			crypto_cipher_encrypt_one(tctx->cipher, (u8 *)out, in);
-			tctx->l3key[i] = be64_to_cpu(out[0]);
-			tctx->l3key[i+1] = be64_to_cpu(out[1]);
-			in[15]++;
-		} while (tctx->l3key[i] >= p64 || tctx->l3key[i+1] >= p64);
-	}
-
-	return 0;
-}
-
-static int vmac_init(struct shash_desc *desc)
-{
-	const struct vmac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct vmac_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	dctx->partial_size = 0;
-	dctx->first_block_processed = false;
-	memcpy(dctx->polytmp, tctx->polykey, sizeof(dctx->polytmp));
-	dctx->nonce_size = 0;
-	return 0;
-}
-
-static int vmac_update(struct shash_desc *desc, const u8 *p, unsigned int len)
-{
-	const struct vmac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct vmac_desc_ctx *dctx = shash_desc_ctx(desc);
-	unsigned int n;
-
-	/* Nonce is passed as first VMAC_NONCEBYTES bytes of data */
-	if (dctx->nonce_size < VMAC_NONCEBYTES) {
-		n = min(len, VMAC_NONCEBYTES - dctx->nonce_size);
-		memcpy(&dctx->nonce.bytes[dctx->nonce_size], p, n);
-		dctx->nonce_size += n;
-		p += n;
-		len -= n;
-	}
-
-	if (dctx->partial_size) {
-		n = min(len, VMAC_NHBYTES - dctx->partial_size);
-		memcpy(&dctx->partial[dctx->partial_size], p, n);
-		dctx->partial_size += n;
-		p += n;
-		len -= n;
-		if (dctx->partial_size == VMAC_NHBYTES) {
-			vhash_blocks(tctx, dctx, dctx->partial_words, 1);
-			dctx->partial_size = 0;
-		}
-	}
-
-	if (len >= VMAC_NHBYTES) {
-		n = round_down(len, VMAC_NHBYTES);
-		/* TODO: 'p' may be misaligned here */
-		vhash_blocks(tctx, dctx, (const __le64 *)p, n / VMAC_NHBYTES);
-		p += n;
-		len -= n;
-	}
-
-	if (len) {
-		memcpy(dctx->partial, p, len);
-		dctx->partial_size = len;
-	}
-
-	return 0;
-}
-
-static u64 vhash_final(const struct vmac_tfm_ctx *tctx,
-		       struct vmac_desc_ctx *dctx)
-{
-	unsigned int partial = dctx->partial_size;
-	u64 ch = dctx->polytmp[0];
-	u64 cl = dctx->polytmp[1];
-
-	/* L1 and L2-hash the final block if needed */
-	if (partial) {
-		/* Zero-pad to next 128-bit boundary */
-		unsigned int n = round_up(partial, 16);
-		u64 rh, rl;
-
-		memset(&dctx->partial[partial], 0, n - partial);
-		nh_16(dctx->partial_words, tctx->nhkey, n / 8, rh, rl);
-		rh &= m62;
-		if (dctx->first_block_processed)
-			poly_step(ch, cl, tctx->polykey[0], tctx->polykey[1],
-				  rh, rl);
-		else
-			ADD128(ch, cl, rh, rl);
-	}
-
-	/* L3-hash the 128-bit output of L2-hash */
-	return l3hash(ch, cl, tctx->l3key[0], tctx->l3key[1], partial * 8);
-}
-
-static int vmac_final(struct shash_desc *desc, u8 *out)
-{
-	const struct vmac_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct vmac_desc_ctx *dctx = shash_desc_ctx(desc);
-	int index;
-	u64 hash, pad;
-
-	if (dctx->nonce_size != VMAC_NONCEBYTES)
-		return -EINVAL;
-
-	/*
-	 * The VMAC specification requires a nonce at least 1 bit shorter than
-	 * the block cipher's block length, so we actually only accept a 127-bit
-	 * nonce.  We define the unused bit to be the first one and require that
-	 * it be 0, so the needed prepending of a 0 bit is implicit.
-	 */
-	if (dctx->nonce.bytes[0] & 0x80)
-		return -EINVAL;
-
-	/* Finish calculating the VHASH of the message */
-	hash = vhash_final(tctx, dctx);
-
-	/* Generate pseudorandom pad by encrypting the nonce */
-	BUILD_BUG_ON(VMAC_NONCEBYTES != 2 * (VMAC_TAG_LEN / 8));
-	index = dctx->nonce.bytes[VMAC_NONCEBYTES - 1] & 1;
-	dctx->nonce.bytes[VMAC_NONCEBYTES - 1] &= ~1;
-	crypto_cipher_encrypt_one(tctx->cipher, dctx->nonce.bytes,
-				  dctx->nonce.bytes);
-	pad = be64_to_cpu(dctx->nonce.pads[index]);
-
-	/* The VMAC is the sum of VHASH and the pseudorandom pad */
-	put_unaligned_be64(hash + pad, out);
-	return 0;
-}
-
-static int vmac_init_tfm(struct crypto_tfm *tfm)
-{
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct crypto_cipher_spawn *spawn = crypto_instance_ctx(inst);
-	struct vmac_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
-	struct crypto_cipher *cipher;
-
-	cipher = crypto_spawn_cipher(spawn);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	tctx->cipher = cipher;
-	return 0;
-}
-
-static void vmac_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct vmac_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_cipher(tctx->cipher);
-}
-
-static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
-{
-	struct shash_instance *inst;
-	struct crypto_cipher_spawn *spawn;
-	struct crypto_alg *alg;
-	u32 mask;
-	int err;
-
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH, &mask);
-	if (err)
-		return err;
-
-	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
-	if (!inst)
-		return -ENOMEM;
-	spawn = shash_instance_ctx(inst);
-
-	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[1]), 0, mask);
-	if (err)
-		goto err_free_inst;
-	alg = crypto_spawn_cipher_alg(spawn);
-
-	err = -EINVAL;
-	if (alg->cra_blocksize != VMAC_NONCEBYTES)
-		goto err_free_inst;
-
-	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
-	if (err)
-		goto err_free_inst;
-
-	inst->alg.base.cra_priority = alg->cra_priority;
-	inst->alg.base.cra_blocksize = alg->cra_blocksize;
-
-	inst->alg.base.cra_ctxsize = sizeof(struct vmac_tfm_ctx);
-	inst->alg.base.cra_init = vmac_init_tfm;
-	inst->alg.base.cra_exit = vmac_exit_tfm;
-
-	inst->alg.descsize = sizeof(struct vmac_desc_ctx);
-	inst->alg.digestsize = VMAC_TAG_LEN / 8;
-	inst->alg.init = vmac_init;
-	inst->alg.update = vmac_update;
-	inst->alg.final = vmac_final;
-	inst->alg.setkey = vmac_setkey;
-
-	inst->free = shash_free_singlespawn_instance;
-
-	err = shash_register_instance(tmpl, inst);
-	if (err) {
-err_free_inst:
-		shash_free_singlespawn_instance(inst);
-	}
-	return err;
-}
-
-static struct crypto_template vmac64_tmpl = {
-	.name = "vmac64",
-	.create = vmac_create,
-	.module = THIS_MODULE,
-};
-
-static int __init vmac_module_init(void)
-{
-	return crypto_register_template(&vmac64_tmpl);
-}
-
-static void __exit vmac_module_exit(void)
-{
-	crypto_unregister_template(&vmac64_tmpl);
-}
-
-subsys_initcall(vmac_module_init);
-module_exit(vmac_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("VMAC hash algorithm");
-MODULE_ALIAS_CRYPTO("vmac64");
-MODULE_IMPORT_NS("CRYPTO_INTERNAL");

base-commit: 7b6092ee7a4ce2d03dc65b87537889e8e1e0ab95
-- 
2.47.1

