Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B01279333
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746529572; cv=none; b=UHrmqF9redhK9e4nMaG9KH2hlUP6C3UC7Vpzak31CXaPHjrBnxO8KssZJX5pkJKZZw6qaxyHYVQXrf9OFzfckvYgrWH/HswxElxN/rmPzmh9u26GS9mQ9g2WADj6oGJNTX5nSHkKPwIf1ujaNPLQp4MSDWuZUiA8a7CxfPbSxTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746529572; c=relaxed/simple;
	bh=JLL7XSt2/kSxLivW/0sqbw4xgb0spqwjzUd2i8MgT84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdXCL/CPHBDGIuqwNXO/3o1491l2AfzXrfWjUDMnJWpeU6snro+UT0hemUjnTM1LOLbWQfT4/fVUAFpHj5Ix9PG8Ym/UFCnwXbYzd7IymJyN2Y5RkZx2pngxNQUNAkxmwPGc9KAxN/VpsXslAc8RmGYfrGAKcj/9e12KIRhcPRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=M39dlLiG; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="M39dlLiG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/3LsdobJ3D/oJRqqmWSHn1FhY8R4O61YcZVHLjbLeOM=; b=M39dlLiGa/JjhhsIX0WKg3O/gC
	vivO8NU4ZU3SizfbJeC+5DSepJLTQsBoa+5Oa1sFgdkCeqMNyEH8dXfOY+PUWobqfkwywyzIFMrLZ
	5nQsa4LTFMx4CivHj3EJrcRy8MDt5gF5esBmlZ35ENO9OSgCSH4HCbbnZ27nQkh0P/AaK+/Irasvt
	I+Vinqm/9h/eumBeF1pe5fP50P/D9U9nkw7OmdF1IVh+JzNQcWXUzuIvFCWi0jjd8UIIK0/Vh4vc9
	558pxAVNsPnRjiRQYDgMLdarXEqmNsot4EJl6Jw5sVfRpyYEdb3RkXcGxpNBlKi1J7WFq8erCT7Uq
	N0PL0y+A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCG7a-003w0a-2L;
	Tue, 06 May 2025 19:05:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 May 2025 19:05:58 +0800
Date: Tue, 6 May 2025 19:05:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [v2 PATCH] crypto: lib/poly1305 - Build main library on LIB_POLY1305
 and split generic code out
Message-ID: <aBntFsNuZ3m-gR7p@gondor.apana.org.au>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
 <0babdb56d14256b44249dc2bf3190ec200d9d738.1745815528.git.herbert@gondor.apana.org.au>
 <aBjAFG4+PXbPgqFw@gcabiddu-mobl.ger.corp.intel.com>
 <aBluBfXCtOoGrPKW@gondor.apana.org.au>
 <aBluVB9Xg2hbNlKX@gondor.apana.org.au>
 <aBnqw2PCznYO6lPB@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBnqw2PCznYO6lPB@gcabiddu-mobl.ger.corp.intel.com>

On Tue, May 06, 2025 at 11:56:03AM +0100, Cabiddu, Giovanni wrote:
>
> With this patch the build fails reporting a missing MODULE_LICENSE() and
> MODULE_DESCRIPTION():

Oops, I messed up the Makefile:

---8<---
Split the lib poly1305 code just as was done with sha256.  Make
the main library code conditional on LIB_POLY1305 instead of
LIB_POLY1305_GENERIC.

Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Fixes: 10a6d72ea355 ("crypto: lib/poly1305 - Use block-only interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 lib/crypto/Makefile           |  9 ++++++---
 lib/crypto/poly1305-generic.c | 24 ++++++++++++++++++++++++
 lib/crypto/poly1305.c         |  8 --------
 3 files changed, 30 insertions(+), 11 deletions(-)
 create mode 100644 lib/crypto/poly1305-generic.c

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 71d3d05d666a..ff4aa22e5ccc 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -40,11 +40,14 @@ libcurve25519-y					+= curve25519.o
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
+libpoly1305-generic-y				+= poly1305-generic.o
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
2.39.5

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
