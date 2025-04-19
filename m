Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1721DF747;
	Sat, 19 Apr 2025 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745079454; cv=none; b=b3XeG6boTD+hXJs3phFH/EM+A1qcEfkHyOSsXN/LstGrNZsVlrWw+glbrRmp/F57qsXPftjyCLEZLRP/89Wen8O5snZXIpUOWBrMFLQzcHTBAC+Hqn6iERkZ9Fv/fRnA4K6bcWvCvlfxeaJFdDMSjGZF4mP56lYt59E4yLCZ8/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745079454; c=relaxed/simple;
	bh=I42QJF1Eu44xNBr4N3XRIXMmtD3KqHQdmwg+Z6Q8kY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XA0Mh3uzPK5uG+E7F/86fFIrkp4RZ4S+RBQfxg+Tcb9vE9KXE4mi4r2KM+7jHDJQzOaK5q265yYGeJoYWUuuOd83FvJSLZMU5qdX+HFCWe6NFT3ZqhNovUJBu2rcHACEKgbIF0U3dUpP4Ieo9GbRfz0e+Jz+A0NkYdGME9UPSA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pPxhXdVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPxhXdVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D1EC4CEEE;
	Sat, 19 Apr 2025 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745079453;
	bh=I42QJF1Eu44xNBr4N3XRIXMmtD3KqHQdmwg+Z6Q8kY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPxhXdVv38d/1iJc/XJ5EMmL/prKGfR/aa80QW9dKUHLV3OU8WTU4cAS0HStmYvJi
	 8CAn4XvP4v6I7IZcjnzZNLHoIWc33fZgVAz9FVKJ4bvA/PcIP9dM30oCH5f725SIFL
	 jUoh3TPA8MaPEAQmhmtvevIxCuj9JfyNDw3IxaIUBhSw5sjp0mHAyz/Ao/ROOIIZlN
	 3gTP2la+TRVF5bgyXjMaE8ShmmW0BK0vY9KiROtagUDeFD9Fsow9i6+0rykMo/isHi
	 nY2awpV28jtEWgq19h0Cx5rMwfRJIe48AwYRQnqxMZYOsL5qjCCWi/4wgZj5WhPTIx
	 dOrSQmUDwnM/g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] crypto: testmgr - remove CRYPTO_MANAGER_DISABLE_TESTS from defconfigs
Date: Sat, 19 Apr 2025 09:15:37 -0700
Message-ID: <20250419161543.139344-4-ebiggers@kernel.org>
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

Unsetting CONFIG_CRYPTO_MANAGER_DISABLE_TESTS enables the crypto
self-tests, which are only really useful for developers working on the
crypto subsystem.  Some defconfigs did this.  But as with most of the
other crypto options that tend to be randomly set in defconfigs, it is
unlikely that much thought was put into these, especially when placed in
"production" defconfigs.  Clear it out of the defconfigs for now.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/configs/milbeaut_m10v_defconfig   | 1 -
 arch/loongarch/configs/loongson3_defconfig | 1 -
 arch/s390/configs/debug_defconfig          | 1 -
 arch/s390/configs/defconfig                | 1 -
 4 files changed, 4 deletions(-)

diff --git a/arch/arm/configs/milbeaut_m10v_defconfig b/arch/arm/configs/milbeaut_m10v_defconfig
index acd16204f8d7..2741c08e93db 100644
--- a/arch/arm/configs/milbeaut_m10v_defconfig
+++ b/arch/arm/configs/milbeaut_m10v_defconfig
@@ -92,11 +92,10 @@ CONFIG_CONFIGFS_FS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_NLS_UTF8=y
 CONFIG_KEYS=y
 CONFIG_CRYPTO_MANAGER=y
-# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 # CONFIG_CRYPTO_ECHAINIV is not set
 CONFIG_CRYPTO_AES=y
 CONFIG_CRYPTO_SEQIV=m
 CONFIG_CRYPTO_GHASH_ARM_CE=m
 CONFIG_CRYPTO_SHA1_ARM_NEON=m
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index 90f21dfe22b1..3f588ad2071e 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -1024,11 +1024,10 @@ CONFIG_SECURITY_SELINUX=y
 CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_APPARMOR=y
 CONFIG_SECURITY_YAMA=y
 CONFIG_DEFAULT_SECURITY_DAC=y
 CONFIG_CRYPTO_USER=m
-# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 0216a6f50801..d4781acad45f 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -741,11 +741,10 @@ CONFIG_IMA=y
 CONFIG_IMA_DEFAULT_HASH_SHA256=y
 CONFIG_IMA_WRITE_POLICY=y
 CONFIG_IMA_APPRAISE=y
 CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_CRYPTO_USER=m
-# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index c0528f791ecf..732452c41f44 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -727,11 +727,10 @@ CONFIG_IMA_DEFAULT_HASH_SHA256=y
 CONFIG_IMA_WRITE_POLICY=y
 CONFIG_IMA_APPRAISE=y
 CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_CRYPTO_FIPS=y
 CONFIG_CRYPTO_USER=m
-# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_DH=m
 CONFIG_CRYPTO_ECDH=m
 CONFIG_CRYPTO_ECDSA=m
-- 
2.49.0

