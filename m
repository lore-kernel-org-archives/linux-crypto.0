Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED75126AC3;
	Fri, 27 Mar 2026 23:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652933; cv=none; b=LOod/c8PqagkbKqxTK7MUiMJMo9YmEQ+wL9Fi7ozFM//lrsaK0d5Q1mj+wGTcvJdungoBwqyxstgCuS7lQB/E2DkR5rvAEc5LsYeCEu9TdBwgi4G91otDWBHMrFG9St+3xJyKws9xb1G0S+y0sYhLnsrN1ZZfcwDdE3lQbdJxh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652933; c=relaxed/simple;
	bh=rdghAj6XcfWAiAV2ZnkdfSUFtvopbno1P04OVzBlC8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CdK/RTi4zWxw6ZpFgj2iI/0KZLSDdt53py9HDtVZH+5X+7gxCQIFL36Xj/Dp4OykWCAo0XgnZOAUsULo0B4jW4txVf252FAsnR4nFRYTkiZkv67gBOSUm592TcneMLSdFKXsfq9WHvKK9mNTVrEtPX1bYbCwoBXIWBAKgjs4rgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZDJqZxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZDJqZxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B03CC19423;
	Fri, 27 Mar 2026 23:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774652932;
	bh=rdghAj6XcfWAiAV2ZnkdfSUFtvopbno1P04OVzBlC8k=;
	h=From:To:Cc:Subject:Date:From;
	b=hZDJqZxmclujf5uH4guOJqtd3qglB/LIxB5y3nooG6X+53f7qqbUw2BnINYU2fSBv
	 GW8HmIbmpZeZmFM7aSfxZylappNUKI+CMqKPWn5G2FsZPD//jFhIgw8gFjeZeP2uYd
	 tTmSC9snkMQkrXPjFAxsOXqMKNl1m3U8FOI7DIj/vyTinEnCZUNgicPjn5oVWGxA5X
	 QcU6PqPR86fwNyDarqhbnWYuh8krziFlEhR1llq8YIPt573dr9hp0dxtyNdqmjse4n
	 iD2PDNNyElW7pP5IzsQ/LPoc81t4srePMjEzHzIfvMOkuqeVCd2429gTVHL9wrDdC0
	 9Yhv03hWBVoEA==
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4] crypto: cryptomgr - Select algorithm types only when CRYPTO_SELFTESTS
Date: Fri, 27 Mar 2026 16:08:18 -0700
Message-ID: <20260327230818.140264-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enabling any template selects CRYPTO_MANAGER, which causes
CRYPTO_MANAGER2 to enable itself, which selects every algorithm type
option.  However, pulling in all algorithm types is needed only when the
self-tests are enabled.  So condition the selections accordingly.

To make this possible, also add the missing selections to various
symbols that were relying on transitive selections via CRYPTO_MANAGER.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting cryptodev/master

v4: addressed yet another transitive selection
v3: addressed more transitive selections
v2: add selections to options that were relying on transitive selection

 crypto/Kconfig                   | 27 +++++++++++++++++++--------
 drivers/crypto/Kconfig           |  1 +
 drivers/crypto/allwinner/Kconfig |  2 ++
 drivers/crypto/intel/qat/Kconfig |  1 +
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e2b4106ac961..7099f0bf2c31 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -155,23 +155,24 @@ config CRYPTO_MANAGER
 	  This provides the support for instantiating templates such as
 	  cbc(aes), and the support for the crypto self-tests.
 
 config CRYPTO_MANAGER2
 	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
-	select CRYPTO_ACOMP2
-	select CRYPTO_AEAD2
-	select CRYPTO_AKCIPHER2
-	select CRYPTO_SIG2
-	select CRYPTO_HASH2
-	select CRYPTO_KPP2
-	select CRYPTO_RNG2
-	select CRYPTO_SKCIPHER2
+	select CRYPTO_ACOMP2 if CRYPTO_SELFTESTS
+	select CRYPTO_AEAD2 if CRYPTO_SELFTESTS
+	select CRYPTO_AKCIPHER2 if CRYPTO_SELFTESTS
+	select CRYPTO_SIG2 if CRYPTO_SELFTESTS
+	select CRYPTO_HASH2 if CRYPTO_SELFTESTS
+	select CRYPTO_KPP2 if CRYPTO_SELFTESTS
+	select CRYPTO_RNG2 if CRYPTO_SELFTESTS
+	select CRYPTO_SKCIPHER2 if CRYPTO_SELFTESTS
 
 config CRYPTO_USER
 	tristate "Userspace cryptographic algorithm configuration"
 	depends on NET
 	select CRYPTO_MANAGER
+	select CRYPTO_RNG
 	help
 	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
 config CRYPTO_SELFTESTS
@@ -222,10 +223,11 @@ config CRYPTO_PCRYPT
 	  This converts an arbitrary crypto algorithm into a parallel
 	  algorithm that executes in kernel threads.
 
 config CRYPTO_CRYPTD
 	tristate "Software async crypto daemon"
+	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
 	  This is a generic software asynchronous crypto daemon that
@@ -255,24 +257,33 @@ config CRYPTO_KRB5ENC
 	  sunrpc/NFS and rxrpc/AFS.
 
 config CRYPTO_BENCHMARK
 	tristate "Crypto benchmarking module"
 	depends on m || EXPERT
+	select CRYPTO_AEAD
+	select CRYPTO_HASH
 	select CRYPTO_MANAGER
+	select CRYPTO_SKCIPHER
 	help
 	  Quick & dirty crypto benchmarking module.
 
 	  This is mainly intended for use by people developing cryptographic
 	  algorithms in the kernel.  It should not be enabled in production
 	  kernels.
 
 config CRYPTO_SIMD
 	tristate
+	select CRYPTO_AEAD
 	select CRYPTO_CRYPTD
 
 config CRYPTO_ENGINE
 	tristate
+	select CRYPTO_AEAD
+	select CRYPTO_AKCIPHER
+	select CRYPTO_HASH
+	select CRYPTO_KPP
+	select CRYPTO_SKCIPHER
 
 endmenu
 
 menu "Public-key cryptography"
 
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8d3b5d2890f8..3c52e7a1df2b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -299,10 +299,11 @@ config CRYPTO_DEV_PPC4XX
 	select CRYPTO_AES
 	select CRYPTO_LIB_AES
 	select CRYPTO_CCM
 	select CRYPTO_CTR
 	select CRYPTO_GCM
+	select CRYPTO_RNG
 	select CRYPTO_SKCIPHER
 	help
 	  This option allows you to have support for AMCC crypto acceleration.
 
 config HW_RANDOM_PPC4XX
diff --git a/drivers/crypto/allwinner/Kconfig b/drivers/crypto/allwinner/Kconfig
index b8e75210a0e3..7270e5fbc573 100644
--- a/drivers/crypto/allwinner/Kconfig
+++ b/drivers/crypto/allwinner/Kconfig
@@ -12,10 +12,11 @@ config CRYPTO_DEV_SUN4I_SS
 	depends on CRYPTO_DEV_ALLWINNER
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
 	select CRYPTO_AES
 	select CRYPTO_LIB_DES
+	select CRYPTO_RNG
 	select CRYPTO_SKCIPHER
 	help
 	  Some Allwinner SoC have a crypto accelerator named
 	  Security System. Select this if you want to use it.
 	  The Security System handle AES/DES/3DES ciphers in CBC mode
@@ -47,10 +48,11 @@ config CRYPTO_DEV_SUN8I_CE
 	select CRYPTO_ENGINE
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	select CRYPTO_AES
 	select CRYPTO_DES
+	select CRYPTO_RNG
 	depends on CRYPTO_DEV_ALLWINNER
 	depends on PM
 	help
 	  Select y here to have support for the crypto Engine available on
 	  Allwinner SoC H2+, H3, H5, H6, R40 and A64.
diff --git a/drivers/crypto/intel/qat/Kconfig b/drivers/crypto/intel/qat/Kconfig
index 4b4861460dd4..6734b746ea70 100644
--- a/drivers/crypto/intel/qat/Kconfig
+++ b/drivers/crypto/intel/qat/Kconfig
@@ -1,8 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CRYPTO_DEV_QAT
 	tristate
+	select CRYPTO_ACOMP
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AKCIPHER
 	select CRYPTO_DH

base-commit: be0240f65705b0b125de60d4fc952c013ef74e26
-- 
2.53.0

