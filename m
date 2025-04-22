Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904E328FFE9;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745335336; cv=none; b=X2mMBJBwIYr81RACnvzX4QJcwKIlooplFWVYTV30JReD7h6lypBJJlmDJcHLMg4kMOCQZNcJZ22KXuxOvY+shovyNiEkdhu5Cp9QuVxd83N+iF+LMwSkSMDdTjbdGNwSAyJoWh37LV69TlHvjtyawA5QfDDTOaeWuxzFrTUQ0gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745335336; c=relaxed/simple;
	bh=PI6fmE6hac82ilGM4ofOMzTeHSz3ca6buYYzlQ8KByI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4X9uEapzM9YUiW4OkOBFqGuRegqfB+4Xg9EtkeqCamCCPnBtV51XmfHjIdIifkriozBM5zK0VHDKVAxF3ZHzNe9BabSjuGPJlH/2y4LtTWnZaJh0K9zigb6Ix0mWqJ6v6glZnPK5jkN6h9IHQqAetPLy1C8WRuaFT0ZMg76JGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjf/wxrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjf/wxrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1C4C4CEED;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745335335;
	bh=PI6fmE6hac82ilGM4ofOMzTeHSz3ca6buYYzlQ8KByI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjf/wxrPKEIxTrjzeRktRZncd0aNH/p9DQVUumGx8/0APP/inoMMZ9XJ810AWOMAz
	 Bnkngp+Kfd89PAqwaEzbkar+XF5Lza4iH41uIKxmItpbbH/GzEPBXm+i9mNXqg29Cf
	 aUZHSXj/Lr+A+G1MVKFkdPQQ36j1cLOz7aQfp9kn5Htm0Tu8l61AEBATswP3OYP63y
	 5JoylL4WieQKDp7fAMZ5CdtyjmKn0OzyFtOpy9n8vZte4+xNf+Xn7tmR5ydDBZDkFQ
	 4UeuxCFFZZ6C0PdtBsKi542ikZQdcB0ItoJlTtBD+rN03Ysb3sTpSqU9dlV1pSQunF
	 /GGzt0wJ5c4Aw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/9] crypto: testmgr - remove CRYPTO_MANAGER_DISABLE_TESTS from defconfigs
Date: Tue, 22 Apr 2025 08:21:45 -0700
Message-ID: <20250422152151.3691-4-ebiggers@kernel.org>
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
index acd16204f8d7f..2741c08e93dbc 100644
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
index 90f21dfe22b13..3f588ad2071e2 100644
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
index 0216a6f508016..d4781acad45f0 100644
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
index c0528f791ecf9..732452c41f446 100644
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

