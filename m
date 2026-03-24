Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624E8241695;
	Tue, 24 Mar 2026 05:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774328582; cv=none; b=jZYf6ib3jgNDG6eFX1COCIbnOk5gGzjjkwZP04/zAYUJIjwBqgkbvL0o6t5ju8ONIMZsd4BMs75IDXvTt4UMSXAGxPvYczgliIlDQAzQG/n8TUDihhCK87hPmzXX0XWnLNcyQKx1cEi/Mx+9SKv7ZtYDUVthhfd8cDJc219jBZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774328582; c=relaxed/simple;
	bh=GhqcGpirhy4jbJ58MG+ih1mZ1/57Ie8Ght53AJiBHPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c0L1/lC8kkLzSx3vQd3esFGsgcLy1QU0oPU8QrSY+JriiIi7zH3obhtfrpRQ1EqBk6FOtKzVI/jWjY7LLCP7Zo6tLOWRdTeRLgdDekyehNSMBI3S+Z4ecfUCcTRrPlBXTTZtG0ZfqpVohBk5SQdyV0tF1/c2PkOHStso3jeRtdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcxYH+ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcxYH+ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FDAC19424;
	Tue, 24 Mar 2026 05:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774328582;
	bh=GhqcGpirhy4jbJ58MG+ih1mZ1/57Ie8Ght53AJiBHPM=;
	h=From:To:Cc:Subject:Date:From;
	b=lcxYH+ir6Zktp/AhVJBsgWH1Ljbh2m41Avtj+lID393ZB98brkO2mdEmMQeDx7kdd
	 XSsfNsKJaXHgGkh1YfKSHGdGTzD8jXQCQMIpZdkHJsAcp1XrF+13tL8H+faDr/QVnF
	 pl+94/Q6nXvSjz2JXOdbNEciPZsRK9mhEexEyfVrvYQH/ZXZVchIMkIuTpEfGI5mK8
	 xsJGF06gpn/QeoNzLil6/jI/p8imJ7xmRx0i35r0OBsnGqpMCKZOe1fzPlFoheWJBr
	 4xLRRIzAu9WC/3DlndUMkGRL5wrXtD2t5nqcUGhZRz5r7kLTASyNebCfLlUEXxc8e7
	 deGRo4c8naSxw==
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] crypto: cryptomgr - Select algorithm types only when CRYPTO_SELFTESTS
Date: Mon, 23 Mar 2026 22:01:23 -0700
Message-ID: <20260324050123.9494-1-ebiggers@kernel.org>
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

v2: add selections to options that were relying on transitive selection

 crypto/Kconfig | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e2b4106ac961..209a040c74bf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -155,18 +155,18 @@ config CRYPTO_MANAGER
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
@@ -222,10 +222,11 @@ config CRYPTO_PCRYPT
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
@@ -255,24 +256,33 @@ config CRYPTO_KRB5ENC
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
 
base-commit: f9bbd547cfb98b1c5e535aab9b0671a2ff22453a
-- 
2.53.0

