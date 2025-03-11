Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07F44207F
	for <linux-crypto@vger.kernel.org>; Tue, 11 Mar 2025 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741688439; cv=none; b=IL5vcqvv7XwKg+UnZuQn93qdIVy0RAH6RUQrUJs7ysibbXF5xH5+ue0IuSPh4JhF66y6gK1usQBzX+Pkk/gcvQ06X4vM4pR+jGcFyvwkOeHWmNEgSe5GX7zqPRx//FAV0lr16sDfAbatgeUWEhJ4+muh5IFl5bvi+F0XZGrBb7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741688439; c=relaxed/simple;
	bh=kdURDEdeEy+5KeMNaX8S+HzRkkfI/ZGF3wxYBQdoQ0o=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=kTKvdXVpQzbYedSiqI5tNdJrvAxqr1SiHxp6S+htiKygNzLD+dh3M7+hB7g3HYJvQUoY58GZ+EMJ0isafKpNYkggFVTPhSKjqyWdF3ElmY4FAmQ9yl5Iq4kPzv+vfV18KGaYDkx+VLeHgSZHgrXUj4VXFHJ7eZAxOL+HOZgtob0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Np4FPyRd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Np4FPyRd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Q2LLHXzy/ME0OPakJtAPC2GB4Fh3b+rwahOGpRc6qyI=; b=Np4FPyRdsEvkksdFxS0oWvN27a
	k3ScyboMYksdP12JOjVekWXEZO2i7NC9yZTStVFoqWUFJWVXdxwEY4Q7m9bj/3HCRCq1AD75lkXBg
	quxch7uLaSHfjUSduhlDY/VNj1+I9MwWNg3X0lZlcIJSVCuEf0mXaxZRlB6oNO6FHkXnif4B+uGYs
	iQUlsDE7T89StjQIlpn604f4l2/2JKoOwhl6e8jm6dtsCeVysuS0RmS7L2zS0yWU8PDDzMY8REE1F
	9bf0Dm+SS5oidIk0NPkfszqp92OkkWdYFpo1Iicqd5oiMi1Y49Frvfami+2xqDqQtvdA/dJCJaU7I
	fj3HcOOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1trwiv-005YUy-2o;
	Tue, 11 Mar 2025 18:20:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Mar 2025 18:20:33 +0800
Date: Tue, 11 Mar 2025 18:20:33 +0800
Message-Id: <916cf41713840b1a9eae230e3001a31d488bdcba.1741688305.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741688305.git.herbert@gondor.apana.org.au>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: krb5 - Use SG miter instead of doing it by hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The function crypto_shash_update_sg iterates through an SG by
hand.  It fails to handle corner cases such as SG entries longer
than a page.  Fix this by using the SG iterator.

Fixes: 348f5669d1f6 ("crypto/krb5: Implement the Kerberos5 rfc3961 get_mic and verify_mic")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/krb5/rfc3961_simplified.c | 34 ++++++++++++++------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/crypto/krb5/rfc3961_simplified.c b/crypto/krb5/rfc3961_simplified.c
index c1dcb0dd3a00..d9cf1bfa11a5 100644
--- a/crypto/krb5/rfc3961_simplified.c
+++ b/crypto/krb5/rfc3961_simplified.c
@@ -67,6 +67,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/random.h>
+#include <linux/scatterlist.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -83,26 +84,21 @@
 int crypto_shash_update_sg(struct shash_desc *desc, struct scatterlist *sg,
 			   size_t offset, size_t len)
 {
-	do {
-		int ret;
+	struct sg_mapping_iter miter;
+	size_t i, n;
+	int ret;
 
-		if (offset < sg->length) {
-			struct page *page = sg_page(sg);
-			void *p = kmap_local_page(page);
-			void *q = p + sg->offset + offset;
-			size_t seg = min_t(size_t, len, sg->length - offset);
-
-			ret = crypto_shash_update(desc, q, seg);
-			kunmap_local(p);
-			if (ret < 0)
-				return ret;
-			len -= seg;
-			offset = 0;
-		} else {
-			offset -= sg->length;
-		}
-	} while (len > 0 && (sg = sg_next(sg)));
-	return 0;
+	sg_miter_start(&miter, sg, sg_nents(sg),
+		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+	for (i = 0; i < len; i += n) {
+		sg_miter_next(&miter);
+		n = min(miter.length, len - i);
+		ret = crypto_shash_update(desc, miter.addr, n);
+		if (ret < 0)
+			break;
+	}
+	sg_miter_stop(&miter);
+	return ret;
 }
 
 static int rfc3961_do_encrypt(struct crypto_sync_skcipher *tfm, void *iv,
-- 
2.39.5

