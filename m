Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BB51F91F6
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 05:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741842902; cv=none; b=bUC2jMHlcyAmhlWuMjVWm5lSR3bmBYxu+cuIQ/B/h+1PyEINWkNxRDP5ENR2o1igv6fIJzAz1uUbSvQa/wKQ6AFng2r9/9ImxN88OZlKl3mgIUAIIhu0VAL/a045gwREklVtRqP3KljDrAE0ku+sGrdpvVnmyFDV76sHK+D+4xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741842902; c=relaxed/simple;
	bh=bhhUrpDLaKZob1r+cwdrIcgRGWzZ0CD/X9TESTvCIek=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=kxuJkJ8Esc1s5HhY1WpoLijqjw3zRgWcxj4/HNGCmAd6hNB8SMvx0MNRKBDzRldc4FBNf2yEktdlXcZxv4ydsvlRHJSDgmSkrhM052tP23QgN9SyLanpINo299PSGr2zCzhUPAaptCLitQaHTI2HzINnpL+0H0S7MoL42cg4aj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hZjr7Kn7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hZjr7Kn7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uXib/CL4QVcbDIxcUpKqDi6MmvDlk4SxvAiHUAcGN/A=; b=hZjr7Kn7oWTulBgDqnfL7vqnvZ
	+VKNbvmp8Jz/mMxlA3eaNjdKqwfG6ScLsU1DTeTA2hroIkrSzC7ZbUdY9Qx8izbNeYGEFiWoxPKHL
	hThzQSGhczi7TIeJuL7FOsNu1Z6N+L3XbvvlOrKKzL178OAV4PvG2ypHtliUqjAWwTTYzadtdrkcu
	9+5W13lqlcemNn58hj+659Y9OiAsWPma5IEsOYQeN9+IDyCrWfmZDh3qmK7klGPO5oyZc8Y3JUXrj
	ZCxwiQ4ftFJ+f3sv41fwAC17G+UNpyuS/3kTG7ZWY8NV76299hc3Pq4p1MtWMWp7jbeYYqvh6GuLK
	OgtlWUpw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsauG-0068QJ-0w;
	Thu, 13 Mar 2025 13:14:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Mar 2025 13:14:56 +0800
Date: Thu, 13 Mar 2025 13:14:56 +0800
Message-Id: <f6a35a818d7993565ddfe4397367e7451ac63615.1741842470.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741842470.git.herbert@gondor.apana.org.au>
References: <cover.1741842470.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 2/3] crypto: krb5 - Use SG miter instead of doing it by
 hand
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
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
 crypto/krb5/rfc3961_simplified.c | 35 ++++++++++++++------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/crypto/krb5/rfc3961_simplified.c b/crypto/krb5/rfc3961_simplified.c
index c1dcb0dd3a00..79180d28baa9 100644
--- a/crypto/krb5/rfc3961_simplified.c
+++ b/crypto/krb5/rfc3961_simplified.c
@@ -67,9 +67,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/random.h>
+#include <linux/scatterlist.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
-#include <linux/highmem.h>
 #include <linux/lcm.h>
 #include <linux/rtnetlink.h>
 #include <crypto/authenc.h>
@@ -83,26 +83,21 @@
 int crypto_shash_update_sg(struct shash_desc *desc, struct scatterlist *sg,
 			   size_t offset, size_t len)
 {
-	do {
-		int ret;
+	struct sg_mapping_iter miter;
+	size_t i, n;
+	int ret = 0;
 
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
+		       SG_MITER_FROM_SG | SG_MITER_LOCAL);
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

