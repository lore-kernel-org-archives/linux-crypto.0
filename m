Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097F9270EA4;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746477437; cv=none; b=KY6k9OIsysMedaOfwBaOVMqSiswldijzOl7CNgCpg4Hm2MF6p9G8SD/7qrFzc2qAxdXOKCYgVDjN8iGdAMNnDUICSGX70tVrnEB8VzIvjXXwpv4gLzuIj7COURJl4i57D2BjPKZi8x2Ljrc8SX4Y/lZxM+Ic6REq7ZJ9BdiV9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746477437; c=relaxed/simple;
	bh=cllZGXSYE+1mv0E8H6N1+pAGeSY+cx5+GxtxNH2Atjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbV1F4o9vxrpYAx/1cSJmh2ktihJKMMvLPFgXcI8zHb8MGX/jnde0YcJWZ/R3SwFU58bv8HbTFDAgc+DXWhmYUDfSSr2F+scErNAAZIlTaiPYO+tB+0Vszrq13bYdfzEhSI9pC5MlkKlKfXkeyuyMG9ZWPzpqjhOA83ZBcBnq0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jundvq8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jundvq8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B70C4CEF2;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746477436;
	bh=cllZGXSYE+1mv0E8H6N1+pAGeSY+cx5+GxtxNH2Atjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jundvq8n+gWMBBFomfjvYmEP149BbIEF6+jTLsqpVtWoeP2+Bh36UA9v6d5Wm7qsS
	 kDDFt19bKjIXZtAbPHmfNyvMHinbNeVpPtrJm3cpR0LgD1LOeGKsuo+afb4ND4jaP0
	 TxjFmPv2Vftd6MMqL1Paps7DNgL/mvFCc03mi2arJi7l0LSlzZhX6UcaiUl0xKZ6fa
	 wzviqAj0sV8r4+XhTDAsbZ/TdE6wK1hyTOLJ2hqXdjM+UKrWtkJ9H6kcqozAhh1JIJ
	 8zwRU+Z/3ZIkXdkx2kNUR+8oTAjXUubN0pvltG3jzSLc4EsujqiQHZPt/7xzeDq5yt
	 ugAXB3Rn0MlxQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/7] crypto: Kconfig - make CRYPTO_MANAGER a hidden symbol
Date: Mon,  5 May 2025 13:33:44 -0700
Message-ID: <20250505203345.802740-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505203345.802740-1-ebiggers@kernel.org>
References: <20250505203345.802740-1-ebiggers@kernel.org>
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
index 9dd47e1d90bb..242e7d5a3f68 100644
--- a/arch/arm/configs/milbeaut_m10v_defconfig
+++ b/arch/arm/configs/milbeaut_m10v_defconfig
@@ -91,11 +91,10 @@ CONFIG_CONFIGFS_FS=y
 # CONFIG_MISC_FILESYSTEMS is not set
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_KEYS=y
-CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_SELFTESTS=y
 # CONFIG_CRYPTO_ECHAINIV is not set
 CONFIG_CRYPTO_AES=y
 CONFIG_CRYPTO_SEQIV=m
 CONFIG_CRYPTO_GHASH_ARM_CE=m
diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index edc5b4d17f77..ded4b9a5accf 100644
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
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 9655567614aa..85a4472cb058 100644
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
index 1539fe8eb34d..a3b2c8da2dde 100644
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
index 58c36720c94a..a476717b8a6a 100644
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
index e0040110a3ee..6db21e498faa 100644
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
index ecc9ffcc11cd..d8cd7f858b2a 100644
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
index fc2010c241fb..31dbd8888aaa 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -85,8 +85,7 @@ CONFIG_UIO_PDRV_GENIRQ=y
 CONFIG_PROC_KCORE=y
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_DEBUG_FS=y
-CONFIG_CRYPTO_MANAGER=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRYPTO_HW is not set
diff --git a/crypto/Kconfig b/crypto/Kconfig
index bbe9cc408927..f160537a5550 100644
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

