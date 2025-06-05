Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9CE12B93
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749134137; cv=none; b=PYvxiYPMZr8rrNI99PmSyk7EUFr4qoRdsOFFDjlvJGoS/HT0T4StFcSlD/PI2ilrJ0N2mRVPVi3kSc4sEgOjSJZBQr2GyI1Wj7cuxJQuFUkXPR+BXpOoZhCFJpxBzqejSeCGON7UH/k0+kirGbdY+RsxljK3FhXPDaaiWe1T1eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749134137; c=relaxed/simple;
	bh=OlfyT7QOAGZbPhpZHm4m2Her75B9jBRFNYXfZJNiRFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNivIWLICPuJxGpfRiQmnb/NGSjWp5IZ6g2KaTqPWfr1DEtgCRbfRAmp20mfjiVxSBVqXQDto4dQZ3mARlyWX7RnLimu+jV2cgUG0WDl0UqECud9uZeoqgfml1cvdUuyolW9Fy7a4JV7hmWYjI75uMXMP5m5RXwb6ELpIGeFE1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id A32502C06844;
	Thu,  5 Jun 2025 16:29:36 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 8B94820D6D9; Thu,  5 Jun 2025 16:29:36 +0200 (CEST)
Date: Thu, 5 Jun 2025 16:29:36 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [v2 PATCH] Revert "crypto: run initcalls for generic
 implementations earlier"
Message-ID: <aEGp0MahOepfGpsm@wunner.de>
References: <aBBoqm4u6ufapUXK@gondor.apana.org.au>
 <aBHcftWYX1Pe9Ogh@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBHcftWYX1Pe9Ogh@gondor.apana.org.au>

On Wed, Apr 30, 2025 at 04:17:02PM +0800, Herbert Xu wrote:
> This reverts commit c4741b23059794bd99beef0f700103b0d983b3fd.
> 
> Crypto API self-tests no longer run at registration time and now
> occur either at late_initcall or upon the first use.
> 
> Therefore the premise of the above commit no longer exists.  Revert
> it and subsequent additions of subsys_initcall and arch_initcall.
> 
> Note that lib/crypto calls will stay at subsys_initcall (or rather
> downgraded from arch_initcall) because they may need to occur
> before Crypto API registration.

The above is now commit ef93f1562803 in Linus' tree.

For SHA3, the initcall change ended up in a different, unrelated commit,
0d474be2676d.

These changes break authentication of PCI devices upon their enumeration
because it happens in a subsys_initcall, whereas the generic asymmetric
and hash algorithms are now registered in a device_initcall, i.e. later.

PCI device authentication is not yet in mainline.  I've provisionally
added the patch below to my development branch and can include it in
the next submission of the patches.  The development branch is at:

https://github.com/l1k/linux/commits/doe

I just wanted to provide a heads-up and an opportunity for early feedback
to this patch.

Thanks!

Lukas

-- >8 --

Subject: [PATCH] crypto: Allow use of ECDSA, RSA, SHA2, SHA3 in
 subsys_initcall

Commit ef93f1562803 ("Revert "crypto: run initcalls for generic
implementations earlier"") downgraded generic ECDSA, RSA, SHA2
to a device_initcall when built into the kernel proper.

Commit 0d474be2676d ("crypto: sha3-generic - Use API partial block
handling") did the same for generic SHA3.

To be able to authenticate PCI devices upon enumeration, move them back
to subsys_initcall level (which is when PCI device enumeration happens).

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 crypto/algboss.c        | 2 +-
 crypto/ecdsa.c          | 2 +-
 crypto/rsa.c            | 2 +-
 crypto/sha256.c         | 2 +-
 crypto/sha3_generic.c   | 2 +-
 crypto/sha512_generic.c | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 846f586..74517f2 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -247,7 +247,7 @@ static void __exit cryptomgr_exit(void)
 	BUG_ON(err);
 }
 
-module_init(cryptomgr_init);
+subsys_initcall(cryptomgr_init);
 module_exit(cryptomgr_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
index ce8e4364..a70b60a 100644
--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -334,7 +334,7 @@ static void __exit ecdsa_exit(void)
 	crypto_unregister_sig(&ecdsa_nist_p521);
 }
 
-module_init(ecdsa_init);
+subsys_initcall(ecdsa_init);
 module_exit(ecdsa_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/rsa.c b/crypto/rsa.c
index 6c77340..b7d2152 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -430,7 +430,7 @@ static void __exit rsa_exit(void)
 	crypto_unregister_akcipher(&rsa);
 }
 
-module_init(rsa_init);
+subsys_initcall(rsa_init);
 module_exit(rsa_exit);
 MODULE_ALIAS_CRYPTO("rsa");
 MODULE_LICENSE("GPL");
diff --git a/crypto/sha256.c b/crypto/sha256.c
index 4aeb213..a20c920 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -264,7 +264,7 @@ static int __init crypto_sha256_mod_init(void)
 		num_algs -= 2;
 	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
-module_init(crypto_sha256_mod_init);
+subsys_initcall(crypto_sha256_mod_init);
 
 static void __exit crypto_sha256_mod_exit(void)
 {
diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 41d1e50..47f5240 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -274,7 +274,7 @@ static void __exit sha3_generic_mod_fini(void)
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-module_init(sha3_generic_mod_init);
+subsys_initcall(sha3_generic_mod_init);
 module_exit(sha3_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 7368173..bfea65f 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -205,7 +205,7 @@ static void __exit sha512_generic_mod_fini(void)
 	crypto_unregister_shashes(sha512_algs, ARRAY_SIZE(sha512_algs));
 }
 
-module_init(sha512_generic_mod_init);
+subsys_initcall(sha512_generic_mod_init);
 module_exit(sha512_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
-- 
2.47.2

