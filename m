Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CEA1E1E12;
	Sat, 19 Apr 2025 16:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745079455; cv=none; b=s5Y00kjcHUtrs4k2ySMyqzetLX2TdZZWNCG43bNlcB5A9xtyDMX1D5Sxbx6PzHuIa91iOkOYCuwToFD16Oh2/B2w1C3VXxuhJJjzT2WC0UdM9GDqLh8R1qeP8TiytXd9h+LKKvLWHq5sFugGwwP2uEAi5JDHCSWMYZNgGfeNdo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745079455; c=relaxed/simple;
	bh=+zx2Cjb+gLCq+K8saN7p6/cUJdOWOHiUYKHSH4y/2CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoqJwN3IAyfzVavzcYpavlqvJzihauOzwp172H7t5DsIY7QK6iahRYo909IAEs8A+IjLYv1Qn6g5rBI0maxA0KXPk5oX3xWSRrv04HVt9cygXyHiQE5IJ0VHptBqccLf0KdRSzbib/7aFcqsy76TnEuI+GOXGtki3p2fIe4EIwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDL9cFSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDL9cFSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E806C4CEF7;
	Sat, 19 Apr 2025 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745079454;
	bh=+zx2Cjb+gLCq+K8saN7p6/cUJdOWOHiUYKHSH4y/2CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDL9cFSXzeuwGtWtALjOITo5j5uPVBuNiycudpQ/vBSOE7xWzuFCDsZnnV+kkTVk+
	 P08Imqo6lwR8bObni47+vR0GF1m0eBQ+Ys/I8f+EqRwhYYc9BOUAlAw/Iky2JN8tUz
	 cUJzA4CYxWXr81lrQrntgSrRBX9DgL9NpAojkvuy8hRcD2YzKKaDidWaT/J2Jqy5a6
	 PXXxwPYdFk/wGOrLmiy9tKxXpgXkLy4xewZBzPcGyt9eS9ZvSGChFOpSSOxAZjL4CS
	 fRHqUzgrUdOyl2cl0iLXwcQZLMmqLDzhqM4+YYqxIiOh3RcYAmSw4tfnZL0jAcvA8i
	 Rw6dwNhRfmCnw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] crypto: Kconfig - make CRYPTO_MANAGER a hidden symbol
Date: Sat, 19 Apr 2025 09:15:42 -0700
Message-ID: <20250419161543.139344-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250419161543.139344-1-ebiggers@kernel.org>
References: <20250419161543.139344-1-ebiggers@kernel.org>
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
index 2741c08e93db..263e966fad82 100644
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
index 821c670dd687..7bd7eff7f612 100644
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
index 2487765b7be3..d9778c9bef4a 100644
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
index 2d1e65cad239..4d06a4d844dd 100644
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
index 538a874262fc..fa354b54d09b 100644
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

