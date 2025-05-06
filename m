Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469622FAEB2
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 02:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746497115; cv=none; b=tV6hd6XxbPQqcs0f8n/7Yty9M6/BXb+LMrfcmu1oJOliezduyr3aU6klKR2OrLoYpx0lasy5Gzz8SrsF8AUfs4WUJ/DDgRjMgejCfWwW/XPsyqRz9FWYEsGappyOG16IgBtD6s7YS+kqcWhxg/Vqbrkb/E+w9or/C9Te8grF8E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746497115; c=relaxed/simple;
	bh=RyiK5mK+Q1ydkq/sAmdGcwqn006Q9VW4VRnjxr74W8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUVPysqx7diW9m06/veUV+2FB/cHV4gtz0ra5cB8lYX/6jZIFbS/0MD2ATnFyJNYRWcOBhUzV2itBFch2X/oJrcK5cmrtPkfFGrkr79b3jleUQVZguAYpk4fZZIckryd/n6WFkSlj83RJk9fj/t3FDOf8d96IJQdCTyvcbcyuhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N0kOkd6g; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N0kOkd6g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8kK9xWLyjoouoN6uk5WQfKhGImTGU9lqY0wpnep/RNA=; b=N0kOkd6gF4ZDaSyRcYUzE8djWy
	d9+KDNPqzKqXQUxwjPFPHTPmznuRPRNJAS0smswi+YcSUg2JnDSd9oH7nLBXABhP+qaa5XzsmLg/a
	fSdGq5dRvjYCuCiAKWzId3FnQfZzCth7eYeYNkAIMb9oGpVorNC5Bi8FiBa5S/iIq3U7WzdFU7ja+
	pwCr46jVcDgKkHOPZsRmUprJSJ/StOJELus5HCXCRtn115YdsXD7mY3JMV8gfcZCFyO//Kh4Q3Po2
	xP4/sHVhpOxraHo8FMPWoy9Ruf3OImifRM43pSC7/Hmz0Vfc9I4gkPDSnA6L/5o9BMahOqSkEvBag
	FGwTVefQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uC7gC-003l0R-0p;
	Tue, 06 May 2025 10:05:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 May 2025 10:05:08 +0800
Date: Tue, 6 May 2025 10:05:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: lib/poly1305 - Build main library on LIB_POLY1305
 and split generic code out
Message-ID: <aBluVB9Xg2hbNlKX@gondor.apana.org.au>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
 <0babdb56d14256b44249dc2bf3190ec200d9d738.1745815528.git.herbert@gondor.apana.org.au>
 <aBjAFG4+PXbPgqFw@gcabiddu-mobl.ger.corp.intel.com>
 <aBluBfXCtOoGrPKW@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBluBfXCtOoGrPKW@gondor.apana.org.au>

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
