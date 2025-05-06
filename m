Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C192FA11D
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 02:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746497038; cv=none; b=h45dW0FLO8YDIRAb/8nUNshFy0Flo0auIxBk5DlbiMkavcxybsZABXrtqTtt3cZ0UPAm907dxVU7RnaG7iW73qrYkXbwzFwyr8uWXxyHmy5OA1Hm49b7xhg5bm53/X4gPWePLIh6Ih2jG+j1UYW77e+Z7N5IBDBY0ub1ieNfh48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746497038; c=relaxed/simple;
	bh=ASEVVBN5nOBBgKAJqtXsc0H+5KATq6Z/1yS8ll2g1YQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQLuOa2yt4j5OOpeDzcGBgW98MrKVluINqhT/30ugYB5d3KNtQSAxYzqKOo46Q1JErxf6TUyn2225onXEf2003kdnqim5v7b+AdV2N3IYu6GdlTcGu8UljarmGS1bcNIe/dpH/sEpdvTgvdui5uB0O3L7KysnNFArsfEXkIIo2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cFg3PTKi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cFg3PTKi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4m+aKX+qNM0y+mGfgIU9ALDox23GoeqtAoggu44QW84=; b=cFg3PTKiblmV+feW0LSzvRtZkz
	qGio8LXq0QpjLez2xY95TzCEnQQDAKBtkKrYP6afFV7DC2fax+aWykFHqR9Zc4tj3EUxUx59MMfEc
	C198lcOOqxueoRtirZCewo/9PTEEX/sQ0RWmXvwhdX2zJhw9Ow2muiVnyuZArqi+mKxXNRbn6TtnN
	V2fewbSnUcTQj7QRLp9E+VzR3aYGvxYj9+TuSWzwrWusZ25vmvc7HL7sYquWqmFF08a+m1xvU46Qw
	fBFJnKJWSgLWPXBk+IIzLZOa81hDXytR5Dlb2dFHJ5BS5ibYn1wop5EEj9jILqBdedgrckPe5AkT+
	jxVrTfaA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uC7ev-003kyO-0E;
	Tue, 06 May 2025 10:03:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 May 2025 10:03:49 +0800
Date: Tue, 6 May 2025 10:03:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 08/11] crypto: chacha20poly1305 - Use lib/crypto
 poly1305
Message-ID: <aBluBfXCtOoGrPKW@gondor.apana.org.au>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
 <0babdb56d14256b44249dc2bf3190ec200d9d738.1745815528.git.herbert@gondor.apana.org.au>
 <aBjAFG4+PXbPgqFw@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBjAFG4+PXbPgqFw@gcabiddu-mobl.ger.corp.intel.com>

On Mon, May 05, 2025 at 02:41:40PM +0100, Cabiddu, Giovanni wrote:
>
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index 9878286d1d68..f87e2a26d2dd 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -784,8 +784,8 @@ config CRYPTO_AEGIS128_SIMD
> >  config CRYPTO_CHACHA20POLY1305
> >  	tristate "ChaCha20-Poly1305"
> >  	select CRYPTO_CHACHA20
> > -	select CRYPTO_POLY1305
> >  	select CRYPTO_AEAD
> > +	select CRYPTO_LIB_POLY1305
>
> Should this be `select CRYPTO_LIB_POLY1305_GENERIC`, instead?

The problem is that lib/crypto/Makefile only builds poly1305 if
LIB_POLY1305_GENERIC is enabled.  That used to be OK because it
was literally just the generic implementation.

But now it's actually the overall poly1305 library code so it needs
to become LIB_POLY1305 instead.  This also brings up the cyclic
dependency seen with libsha256.  So lib/crypto/poly1305 needs to
be split up accordingly.

---8<---
Split the lib poly1305 code just as was done with sha256.  Make
the main library code conditional on LIB_POLY1305 instead of
LIB_POLY1305_GENERIC.

Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Fixes: 10a6d72ea355 ("crypto: lib/poly1305 - Use block-only interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 71d3d05d666a..c47438161ff1 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -40,11 +40,13 @@ libcurve25519-y					+= curve25519.o
 obj-$(CONFIG_CRYPTO_LIB_DES)			+= libdes.o
 libdes-y					:= des.o
 
-obj-$(CONFIG_CRYPTO_LIB_POLY1305_GENERIC)	+= libpoly1305.o
-libpoly1305-y					:= poly1305-donna32.o
-libpoly1305-$(CONFIG_ARCH_SUPPORTS_INT128)	:= poly1305-donna64.o
+obj-$(CONFIG_CRYPTO_LIB_POLY1305)		+= libpoly1305.o
 libpoly1305-y					+= poly1305.o
 
+obj-$(CONFIG_CRYPTO_LIB_POLY1305_GENERIC)	+= libpoly1305-generic.o
+libpoly1305-generic-y				:= poly1305-donna32.o
+libpoly1305-generic-$(CONFIG_ARCH_SUPPORTS_INT128) := poly1305-donna64.o
+
 obj-$(CONFIG_CRYPTO_LIB_SHA1)			+= libsha1.o
 libsha1-y					:= sha1.o
 
diff --git a/lib/crypto/poly1305-generic.c b/lib/crypto/poly1305-generic.c
new file mode 100644
index 000000000000..a73f700fa1fb
--- /dev/null
+++ b/lib/crypto/poly1305-generic.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Poly1305 authenticator algorithm, RFC7539
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * Based on public domain code by Andrew Moon and Daniel J. Bernstein.
+ */
+
+#include <crypto/internal/poly1305.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+void poly1305_block_init_generic(struct poly1305_block_state *desc,
+				 const u8 raw_key[POLY1305_BLOCK_SIZE])
+{
+	poly1305_core_init(&desc->h);
+	poly1305_core_setkey(&desc->core_r, raw_key);
+}
+EXPORT_SYMBOL_GPL(poly1305_block_init_generic);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+MODULE_DESCRIPTION("Poly1305 algorithm (generic implementation)");
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index 4c9996864090..5f2f2af3b59f 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -14,14 +14,6 @@
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
-void poly1305_block_init_generic(struct poly1305_block_state *desc,
-				 const u8 raw_key[POLY1305_BLOCK_SIZE])
-{
-	poly1305_core_init(&desc->h);
-	poly1305_core_setkey(&desc->core_r, raw_key);
-}
-EXPORT_SYMBOL_GPL(poly1305_block_init_generic);
-
 void poly1305_init(struct poly1305_desc_ctx *desc,
 		   const u8 key[POLY1305_KEY_SIZE])
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
