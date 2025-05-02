Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841011B0416
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 05:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163875; cv=none; b=nR5a+8gfcPeYjEzrqheD85pd2FFqJ0HmnXBkGbXtkvPoBzMC7qe9PTOWs4V8Odg4HaRdq3lNroob8b5bGeBrrRf5Z5MDksjLZoZjHwNmqDPbOdDKJkPUT0Yss15LicFN16K/eql2YAKF+aRRr3DT8uShGBx3HvJax4oQo4xMBtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163875; c=relaxed/simple;
	bh=vmgmzfRWGEGByiQQm3hpvhfSwzko/ZQ6lcklw73Egb0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=BOiDOvoVfBvYiK0/QFzKd0NDlVY1qPc/8bZeGvXmIvxoQyMmlolh/vLkekRXLFwwlzmV4cPRz6LoJuPwDG7t5Si4BGfEIKtOH970EKYBRh5y9av2sqdg1otg98l2cegCcPXG0A8yIlbrzP92jvpBe6T1q0fj1HiWzafGSZzKx68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=onN6zVgS; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="onN6zVgS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SWB5pEmKDu9CcQkOgQ8jregz2Lo7MK74+7YYJloUfxs=; b=onN6zVgSugPVPaXVzCh7zLUTDb
	ubSRXRf2Tml9IADC1doxpcEJ4jdo/Ml1j8/jgQXhfujigTEP0muTfpMRBxJLcigzKiLX4e+yCtZfV
	xy+1Y52F9Jlm2dpWPN4Hqk25dJ5rQhmiIuxlSbEf/dvtHYpkPm+50TGBIohhAfmM5hnHgePrrNXRy
	tR2j2hEqZhPyrjDNrNzvOSTPzylPdhZ7fY30ig6+jUdDwZ7vqQRwCLDSAH6WZaGdDeT11Zvijs5ay
	KQhoNUb1iT7C9sFFAjvNaBstTutVIvBzEB112BTNERqPq1PWCWIzJJ/GZH4YuIauK5rseRphiLWnO
	LBFbSdhw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAizO-002lLU-00;
	Fri, 02 May 2025 13:31:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 13:31:09 +0800
Date: Fri, 02 May 2025 13:31:09 +0800
Message-Id: <d173b89a1d359d26b7324ea14828ef40d455dfa3.1746162259.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746162259.git.herbert@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 8/9] crypto: lib/sha256 - Use generic block helper
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the BLOCK_HASH_UPDATE_BLOCKS helper instead of duplicating
partial block handling.

Also remove the unused lib/sha256 force-generic interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/internal/sha2.h |  7 ----
 lib/crypto/sha256.c            | 75 ++++++----------------------------
 2 files changed, 12 insertions(+), 70 deletions(-)

diff --git a/include/crypto/internal/sha2.h b/include/crypto/internal/sha2.h
index fff156f66edc..b9bccd3ff57f 100644
--- a/include/crypto/internal/sha2.h
+++ b/include/crypto/internal/sha2.h
@@ -10,13 +10,6 @@
 #include <linux/types.h>
 #include <linux/unaligned.h>
 
-void sha256_update_generic(struct sha256_state *sctx,
-			   const u8 *data, size_t len);
-void sha256_final_generic(struct sha256_state *sctx,
-			  u8 out[SHA256_DIGEST_SIZE]);
-void sha224_final_generic(struct sha256_state *sctx,
-			  u8 out[SHA224_DIGEST_SIZE]);
-
 #if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256)
 bool sha256_is_arch_optimized(void);
 #else
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 2ced29efa181..107e5162507a 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -11,6 +11,7 @@
  * Copyright (c) 2014 Red Hat Inc.
  */
 
+#include <crypto/internal/blockhash.h>
 #include <crypto/internal/sha2.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -31,71 +32,40 @@ static inline bool sha256_purgatory(void)
 }
 
 static inline void sha256_blocks(u32 state[SHA256_STATE_WORDS], const u8 *data,
-				 size_t nblocks, bool force_generic)
+				 size_t nblocks)
 {
-	sha256_choose_blocks(state, data, nblocks,
-			     force_generic || sha256_purgatory(), false);
-}
-
-static inline void __sha256_update(struct sha256_state *sctx, const u8 *data,
-				   size_t len, bool force_generic)
-{
-	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
-
-	sctx->count += len;
-
-	if (partial + len >= SHA256_BLOCK_SIZE) {
-		size_t nblocks;
-
-		if (partial) {
-			size_t l = SHA256_BLOCK_SIZE - partial;
-
-			memcpy(&sctx->buf[partial], data, l);
-			data += l;
-			len -= l;
-
-			sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
-		}
-
-		nblocks = len / SHA256_BLOCK_SIZE;
-		len %= SHA256_BLOCK_SIZE;
-
-		if (nblocks) {
-			sha256_blocks(sctx->state, data, nblocks,
-				      force_generic);
-			data += nblocks * SHA256_BLOCK_SIZE;
-		}
-		partial = 0;
-	}
-	if (len)
-		memcpy(&sctx->buf[partial], data, len);
+	sha256_choose_blocks(state, data, nblocks, sha256_purgatory(), false);
 }
 
 void sha256_update(struct sha256_state *sctx, const u8 *data, size_t len)
 {
-	__sha256_update(sctx, data, len, false);
+	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
+
+	sctx->count += len;
+	BLOCK_HASH_UPDATE_BLOCKS(sha256_blocks, sctx->ctx.state, data, len,
+				 SHA256_BLOCK_SIZE, sctx->buf, partial);
 }
 EXPORT_SYMBOL(sha256_update);
 
 static inline void __sha256_final(struct sha256_state *sctx, u8 *out,
-				  size_t digest_size, bool force_generic)
+				  size_t digest_size)
 {
 	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
 
 	sha256_finup(&sctx->ctx, sctx->buf, partial, out, digest_size,
-		     force_generic || sha256_purgatory(), false);
+		     sha256_purgatory(), false);
 	memzero_explicit(sctx, sizeof(*sctx));
 }
 
 void sha256_final(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE])
 {
-	__sha256_final(sctx, out, SHA256_DIGEST_SIZE, false);
+	__sha256_final(sctx, out, SHA256_DIGEST_SIZE);
 }
 EXPORT_SYMBOL(sha256_final);
 
 void sha224_final(struct sha256_state *sctx, u8 out[SHA224_DIGEST_SIZE])
 {
-	__sha256_final(sctx, out, SHA224_DIGEST_SIZE, false);
+	__sha256_final(sctx, out, SHA224_DIGEST_SIZE);
 }
 EXPORT_SYMBOL(sha224_final);
 
@@ -109,26 +79,5 @@ void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
 }
 EXPORT_SYMBOL(sha256);
 
-#if IS_ENABLED(CONFIG_CRYPTO_SHA256) && !defined(__DISABLE_EXPORTS)
-void sha256_update_generic(struct sha256_state *sctx,
-			   const u8 *data, size_t len)
-{
-	__sha256_update(sctx, data, len, true);
-}
-EXPORT_SYMBOL(sha256_update_generic);
-
-void sha256_final_generic(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE])
-{
-	__sha256_final(sctx, out, SHA256_DIGEST_SIZE, true);
-}
-EXPORT_SYMBOL(sha256_final_generic);
-
-void sha224_final_generic(struct sha256_state *sctx, u8 out[SHA224_DIGEST_SIZE])
-{
-	__sha256_final(sctx, out, SHA224_DIGEST_SIZE, true);
-}
-EXPORT_SYMBOL(sha224_final_generic);
-#endif
-
 MODULE_DESCRIPTION("SHA-256 Algorithm");
 MODULE_LICENSE("GPL");
-- 
2.39.5

