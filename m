Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9F927816D;
	Tue,  4 Mar 2025 23:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129683; cv=none; b=EL+WdIICb+PLEUwiO6ohMJvyJD4oH4WZe+f/E+Na0HCAP8edMtAj4y56Z48oTHcEKhPLYlKHFC079xLfGfIAeP129nrhSFVDaRXAq3KWv7naP0cRliNLva64czHybhPjC5asGfdQz2DBhcDYtXcRHSSx4CRoaxxxRvObLT2yVwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129683; c=relaxed/simple;
	bh=AAOQOPWRpbtrSNe0M7ArACxCVUNICd5iHY3ZzcUQSj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgVLEAdJHniWdtvUsReau1rgZ7jxLiY8TgtGujV8k3n2HPGYzjC+ojVkpmEAPzF56jKtLLykSCkpJtTUbUhq6sDJ2n+D0KiuLAl16iyCV9fCTAs1Ip+XTitjBxDIBv2b3hPFBaDQj6SgeiVpco4EiiUUfV/mcNhOzT1/94vDRn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2pJZuqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2pJZuqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586F3C4CEEA;
	Tue,  4 Mar 2025 23:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741129682;
	bh=AAOQOPWRpbtrSNe0M7ArACxCVUNICd5iHY3ZzcUQSj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2pJZuqDDr2m/rKZM48azwWf31O3jtoqQZ55zY+fl/qR2mvxNW+Br2uUJBzsfMnD2
	 WCG+cIClICcycpQmoTzChn+kasDTaqxs08oUNOuNT+o+Jrt68fO2w9PfaCZ7dUW7Nl
	 R3sKvq9bytRfY9AMZtZjAcxGe/mKzqlTD9UIH2MEtjdpUGWaODtnzoEa/sh5uX5Hac
	 mr27kTqV7OowHGAFeR+NezuDsQCotKqx+UOwDhGD0wgt5Icp5CF+VQlUeaJK4wcDvw
	 dXdR4RRVzwTLy3FZd/JPrUm/AU10Sr4omYvMWydEavyJUWq89annByIU2czhVjO+o6
	 /j1mEN1pEdKZA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/5] lib/crc: remove unnecessary prompt for CONFIG_CRC4
Date: Tue,  4 Mar 2025 15:07:08 -0800
Message-ID: <20250304230712.167600-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250304230712.167600-1-ebiggers@kernel.org>
References: <20250304230712.167600-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

All modules that need CONFIG_CRC4 already select it, so there is no need
to bother users about the option.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/s390/configs/debug_defconfig | 1 -
 arch/s390/configs/defconfig       | 1 -
 lib/Kconfig                       | 7 +------
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index d6beec5292a00..c46781f8570c1 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -813,11 +813,10 @@ CONFIG_CRYPTO_PAES_S390=m
 CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
 CONFIG_CRYPTO_LIB_CURVE25519=m
 CONFIG_CRYPTO_LIB_CHACHA20POLY1305=m
-CONFIG_CRC4=m
 CONFIG_CRC7=m
 CONFIG_CRC8=m
 CONFIG_RANDOM32_SELFTEST=y
 CONFIG_XZ_DEC_MICROLZMA=y
 CONFIG_DMA_CMA=y
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 8cfbfb10bba8c..23d8bce642aa4 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -801,11 +801,10 @@ CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
 CONFIG_PRIME_NUMBERS=m
 CONFIG_CRYPTO_LIB_CURVE25519=m
 CONFIG_CRYPTO_LIB_CHACHA20POLY1305=m
-CONFIG_CRC4=m
 CONFIG_CRC7=m
 CONFIG_CRC8=m
 CONFIG_XZ_DEC_MICROLZMA=y
 CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=0
diff --git a/lib/Kconfig b/lib/Kconfig
index 67bbf4f64dd98..e867971c97669 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -207,16 +207,11 @@ config ARCH_HAS_CRC64
 config CRC64_ARCH
 	tristate
 	default CRC64 if ARCH_HAS_CRC64 && CRC_OPTIMIZATIONS
 
 config CRC4
-	tristate "CRC4 functions"
-	help
-	  This option is provided for the case where no in-kernel-tree
-	  modules require CRC4 functions, but a module built outside
-	  the kernel tree does. Such modules that use library CRC4
-	  functions require M here.
+	tristate
 
 config CRC7
 	tristate "CRC7 functions"
 	help
 	  This option is provided for the case where no in-kernel-tree
-- 
2.48.1

