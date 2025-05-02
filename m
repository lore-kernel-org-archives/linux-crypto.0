Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED5192B8C
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 05:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163867; cv=none; b=tXtA4dzTvAZ9p9b7kdNNrgZ20wTH8t61LozffnOxpiQMSBD4k7FuTbhuOioUG9CopUHlTGkh9QkqzM7KUEtcp/1iLXJmPEpDpvhcDZo1GJKmvT6zCwuBK+QNk6I4VqVguRBsjo+rZAYX3YIa8UozaafC179oz3oY4I9/8oHQNwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163867; c=relaxed/simple;
	bh=xljTx5BUoKFr1IaQQHdWdANgLINRwS5YVReiSr/62jM=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=okSOP3paz7b+K8RzrakJrFM+8zwFhJn3ao6mTf/XaKmOi9kP7iI0MVgdjG9s28OcxQocAcTD+f0LZyc+4cL7kaMkQKq//ppKT+pMLLfvXRLUH4yLRaqm3UhNfhE9s7Y7HIpfI81LhNsE8peknfnCYp7WwcBOT7DPb8yfMRxF1JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SgTfsoMO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SgTfsoMO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eQwG2BIa1mdwDPsYUReawdulSsEKfX8i5jt2M53PTsE=; b=SgTfsoMOs4re9XrDet5quS6Tox
	QfwBaJ349rVZ8LAQS726Ga06x2og3bAbpQkPFajH3i66mFh5DbhYfzM4RcytdJLgDt1XA4IXBoyk5
	8PdatPfYGPLMxlaPOPcrUdIvgb9y+LAVXOslIXnL+Tn8sG7oGowYM3RB9hkQBhWsuUi7l6n+DU5QL
	Tru2WsU9AmoPR7y3UxKoyMJ7DJ5/vtSeutavwV1MSeHbCkKipsX+0wJ+dF7QKZ4Dk66q7Pa6fNcYL
	m38LHrfOFWVXcKetttefu9uCadi4ruLnuY5OjHewrbi25b9qzqhSY8ij3wZjMVp7KPoin2Ihhe5KZ
	TmZzhShw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAizC-002lKa-1g;
	Fri, 02 May 2025 13:30:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 13:30:58 +0800
Date: Fri, 02 May 2025 13:30:58 +0800
Message-Id: <3f9c55263754eda2968b5fe319666fa00c2c46e2.1746162259.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746162259.git.herbert@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 3/9] crypto: arch/sha256 - Export block functions as GPL
 only
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Export the block functions as GPL only, there is no reason
to let arbitrary modules use these internal functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/lib/crypto/sha256.c                   | 4 ++--
 arch/arm64/lib/crypto/sha256.c                 | 4 ++--
 arch/mips/cavium-octeon/crypto/octeon-sha256.c | 4 ++--
 arch/powerpc/lib/crypto/sha256.c               | 4 ++--
 arch/riscv/lib/crypto/sha256.c                 | 4 ++--
 arch/s390/lib/crypto/sha256.c                  | 4 ++--
 arch/sparc/lib/crypto/sha256.c                 | 4 ++--
 arch/x86/lib/crypto/sha256.c                   | 4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/lib/crypto/sha256.c b/arch/arm/lib/crypto/sha256.c
index 3a8dfc304807..e2fae3664428 100644
--- a/arch/arm/lib/crypto/sha256.c
+++ b/arch/arm/lib/crypto/sha256.c
@@ -35,14 +35,14 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 		sha256_block_data_order(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	/* We always can use at least the ARM scalar implementation. */
 	return true;
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_arm_mod_init(void)
 {
diff --git a/arch/arm64/lib/crypto/sha256.c b/arch/arm64/lib/crypto/sha256.c
index 2bd413c586d2..91c7ca727992 100644
--- a/arch/arm64/lib/crypto/sha256.c
+++ b/arch/arm64/lib/crypto/sha256.c
@@ -45,14 +45,14 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 		sha256_block_data_order(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	/* We always can use at least the ARM64 scalar implementation. */
 	return true;
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_arm64_mod_init(void)
 {
diff --git a/arch/mips/cavium-octeon/crypto/octeon-sha256.c b/arch/mips/cavium-octeon/crypto/octeon-sha256.c
index f169054852bc..f93faaf1f4af 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-sha256.c
+++ b/arch/mips/cavium-octeon/crypto/octeon-sha256.c
@@ -60,13 +60,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 	state64[3] = read_octeon_64bit_hash_dword(3);
 	octeon_crypto_disable(&cop2_state, flags);
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return octeon_has_crypto();
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-256 Secure Hash Algorithm (OCTEON)");
diff --git a/arch/powerpc/lib/crypto/sha256.c b/arch/powerpc/lib/crypto/sha256.c
index c05023c5acdd..6b0f079587eb 100644
--- a/arch/powerpc/lib/crypto/sha256.c
+++ b/arch/powerpc/lib/crypto/sha256.c
@@ -58,13 +58,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 		nblocks -= unit;
 	} while (nblocks);
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return true;
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-256 Secure Hash Algorithm, SPE optimized");
diff --git a/arch/riscv/lib/crypto/sha256.c b/arch/riscv/lib/crypto/sha256.c
index 18b84030f0b3..2905a6dbb485 100644
--- a/arch/riscv/lib/crypto/sha256.c
+++ b/arch/riscv/lib/crypto/sha256.c
@@ -32,13 +32,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 		sha256_blocks_generic(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_extensions);
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init riscv64_sha256_mod_init(void)
 {
diff --git a/arch/s390/lib/crypto/sha256.c b/arch/s390/lib/crypto/sha256.c
index 50c592ce7a5d..fcfa2706a7f9 100644
--- a/arch/s390/lib/crypto/sha256.c
+++ b/arch/s390/lib/crypto/sha256.c
@@ -21,13 +21,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 	else
 		sha256_blocks_generic(state, data, nblocks);
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_cpacf_sha256);
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_s390_mod_init(void)
 {
diff --git a/arch/sparc/lib/crypto/sha256.c b/arch/sparc/lib/crypto/sha256.c
index 6f118a23d210..b4fc475dcc40 100644
--- a/arch/sparc/lib/crypto/sha256.c
+++ b/arch/sparc/lib/crypto/sha256.c
@@ -30,13 +30,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 	else
 		sha256_blocks_generic(state, data, nblocks);
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_sha256_opcodes);
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_sparc64_mod_init(void)
 {
diff --git a/arch/x86/lib/crypto/sha256.c b/arch/x86/lib/crypto/sha256.c
index 47865b5cd94b..8735ec871f86 100644
--- a/arch/x86/lib/crypto/sha256.c
+++ b/arch/x86/lib/crypto/sha256.c
@@ -35,13 +35,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 		sha256_blocks_generic(state, data, nblocks);
 	}
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_sha256_x86);
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_x86_mod_init(void)
 {
-- 
2.39.5

