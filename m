Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81500290BA1;
	Tue, 22 Apr 2025 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745335337; cv=none; b=BWaxwpClWh5/rjFPc4s3Nw/hMmUk4MH3lINrMIZXHLsTL3X5DV9jVtaoUcciJPCRFnM7AyJf4hf5dQAD544926QYg2LCchg28ALCr7AQ1cYzeLWHvA02FnByOVRhO323gQBBEEXgc+TDW1XYA59MXQxiv5+40xwRffdSUB7QIDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745335337; c=relaxed/simple;
	bh=GWAAmyXmfW9WCHfO06f6Q6TX+D2TqheNvg6AW8lmdn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm/xiBmkUwAK53FnAMF6cnGcfYU4R3DmlAqcnk6d9AAwrzL4RpE/z4zh8PwysVf2XpFa065LYDp41THppLgZPqvDx8RJ7nBn8RA070jqi/I8JJOcBZgOvOBKy/CtJg6FBbHL5/W9c9XsdZOSsbSkRZ24M11jSCR89yrpCStiloQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJpPZpPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJpPZpPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA1EC4CEE9;
	Tue, 22 Apr 2025 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745335337;
	bh=GWAAmyXmfW9WCHfO06f6Q6TX+D2TqheNvg6AW8lmdn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJpPZpPzBXuzsuOw7C422dF+6JGs5E2txYMtowMfXqicri6Cb3VL1suXQ+SjT7MQ5
	 Oum9czdZURjP2Ce4SZGBUu6jbqQYvKOgEK9nIWt83nIrBmJD2aheB2aGCfk2CEtLY5
	 HJvYwFHhNqLkKrfH3ps+jc8FZz1H43z0SyRRKKyvqYi3+ttaCiUGm55MhIF0uzW4Jx
	 YX7IYPY58AabKgjVgB8hUxAAv6Ccw9G6+0WwFrpSJdn/npEBlZTRf+ZpYkD2pvbiHg
	 J6/0CIKkXsnmgFOBBKZcVOVl45Ygtp7o9PIWRTUIz8/PlP/4jSL3u+kzW3cZCoizB+
	 yxzDMngDmgWTA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/9] crypto: Kconfig - make CRYPTO_MANAGER a hidden symbol
Date: Tue, 22 Apr 2025 08:21:50 -0700
Message-ID: <20250422152151.3691-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422152151.3691-1-ebiggers@kernel.org>
References: <20250422152151.3691-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

There is no reason for people configuring the kernel to be asked about
CRYPTO_MANAGER, so make it a hidden symbol.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/milbeaut_m10v_defconfig    | 1 -
 arch/arm/configs/pxa_defconfig              | 1 -
 arch/mips/configs/decstation_64_defconfig   | 1 -
 arch/mips/configs/decstation_defconfig      | 1 -
 arch/mips/configs/decstation_r4k_defconfig  | 1 -
 arch/mips/configs/ip28_defconfig            | 1 -
 arch/parisc/configs/generic-64bit_defconfig | 1 -
 arch/sh/configs/migor_defconfig             | 1 -
 crypto/Kconfig                              | 2 +-
 9 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/arm/configs/milbeaut_m10v_defconfig b/arch/arm/configs/milbeaut_m10v_defconfig
index 2741c08e93dbc..263e966fad822 100644
--- a/arch/arm/configs/milbeaut_m10v_defconfig
+++ b/arch/arm/configs/milbeaut_m10v_defconfig
@@ -91,11 +91,10 @@ CONFIG_CONFIGFS_FS=y
 # CONFIG_MISC_FILESYSTEMS is not set
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_KEYS=y
-CONFIG_CRYPTO_MANAGER=y
 # CONFIG_CRYPTO_ECHAINIV is not set
 CONFIG_CRYPTO_AES=y
 CONFIG_CRYPTO_SEQIV=m
 CONFIG_CRYPTO_GHASH_ARM_CE=m
 CONFIG_CRYPTO_SHA1_ARM_NEON=m
diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index 821c670dd6877..7bd7eff7f6122 100644
--- a/arch/arm/configs/pxa_defconfig
+++ b/arch/arm/configs/pxa_defconfig
@@ -634,11 +634,10 @@ CONFIG_NLS_ASCII=m
 CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
 CONFIG_TIMER_STATS=y
 CONFIG_SECURITY=y
-CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_AUTHENC=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 9655567614aa2..85a4472cb0582 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -166,11 +166,10 @@ CONFIG_NLS_ISO8859_9=m
 CONFIG_NLS_ISO8859_13=m
 CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
 CONFIG_CRYPTO_RSA=m
-CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index 1539fe8eb34d0..a3b2c8da2ddef 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -161,11 +161,10 @@ CONFIG_NLS_ISO8859_9=m
 CONFIG_NLS_ISO8859_13=m
 CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
 CONFIG_CRYPTO_RSA=m
-CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index 58c36720c94a4..a476717b8a6ad 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -161,11 +161,10 @@ CONFIG_NLS_ISO8859_9=m
 CONFIG_NLS_ISO8859_13=m
 CONFIG_NLS_ISO8859_14=m
 CONFIG_NLS_ISO8859_15=m
 CONFIG_NLS_UTF8=m
 CONFIG_CRYPTO_RSA=m
-CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_CCM=m
 CONFIG_CRYPTO_GCM=m
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
diff --git a/arch/mips/configs/ip28_defconfig b/arch/mips/configs/ip28_defconfig
index e0040110a3eeb..6db21e498faa9 100644
--- a/arch/mips/configs/ip28_defconfig
+++ b/arch/mips/configs/ip28_defconfig
@@ -58,8 +58,7 @@ CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_ROOT_NFS=y
-CONFIG_CRYPTO_MANAGER=y
 # CONFIG_CRYPTO_HW is not set
 CONFIG_MAGIC_SYSRQ=y
diff --git a/arch/parisc/configs/generic-64bit_defconfig b/arch/parisc/configs/generic-64bit_defconfig
index 2487765b7be36..d9778c9bef4ae 100644
--- a/arch/parisc/configs/generic-64bit_defconfig
+++ b/arch/parisc/configs/generic-64bit_defconfig
@@ -281,11 +281,10 @@ CONFIG_NLS_CODEPAGE_1250=m
 CONFIG_NLS_CODEPAGE_1251=m
 CONFIG_NLS_ASCII=m
 CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_2=m
 CONFIG_NLS_UTF8=m
-CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
diff --git a/arch/sh/configs/migor_defconfig b/arch/sh/configs/migor_defconfig
index 2d1e65cad2398..4d06a4d844dd9 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -85,9 +85,8 @@ CONFIG_UIO_PDRV_GENIRQ=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_FS=y
-CONFIG_CRYPTO_MANAGER=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
 CONFIG_CRC_T10DIF=y
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 538a874262fc5..fa354b54d09b1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -146,11 +146,11 @@ config CRYPTO_HKDF
 	select CRYPTO_SHA256 if CRYPTO_SELFTESTS
 	select CRYPTO_SHA512 if CRYPTO_SELFTESTS
 	select CRYPTO_HASH2
 
 config CRYPTO_MANAGER
-	tristate "Cryptographic algorithm manager"
+	tristate
 	select CRYPTO_MANAGER2
 	help
 	  Create default cryptographic template instantiations such as
 	  cbc(aes).
 
-- 
2.49.0

