Received: from abb.hmeau.com (unknown [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7F2701AE;
	Fri, 25 Apr 2025 03:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745550339; cv=none; b=BMSPFUYM0PwBGqNBc1WyANj5F8MTmbxVicdvAh3J6FQeDOCfaQY5ONi0y+cL4f/ujZRD4k7laMSaOPYkwwILoIf81RPc0ObNkCxeZ2AuK/3VlZ8utBde2z4h+NmdVFuzBaj6+yqNJIS3gnV/9JzmnZfG/+9+kNqbBRtm2GK5xzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745550339; c=relaxed/simple;
	bh=EAIPXcBr045ylHqagc+spm6TZnPc/96juZdruQACpac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BvufnJF+RE3z4ewQiJDsO9Eq4Ddx8wOjtpJ15+EjaL4tzjy6PpuYzCWbs9gO0vgIXayfn3/07y7DlYDL1aCIx0gOMbC5N1Li8LnSVY2QPuIiGg3B+VQy10tSa7mh5JMXk//aol9DBINohRHeSMMjhsGSv7nFL2eY9ztFLqjbqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lvnRD8aR; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lvnRD8aR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e846YCCO6X9RjoPjL6Dopm3drTY4y1ZAAQxPLagWosM=; b=lvnRD8aRVbQTdvq78ulM+B1ae5
	VyuXeGnv/+uiGk9DGB3WQFyHUuG6Jnnrp2hrL9C0AvKeR3FjufD7YIhGRoesgA9hTildXuw79S7jw
	oAKlo6J+LfUkaNLPlFm5jxVPcQ4FUuyWE2/Uh12O2pwXRkoLYMTT5wMLyieKe2IXBv0fk0SXBfZsY
	Ryuv2eADPv8leRxlo0fG/70WriWuGY+ywW7NQiYY8CmZ9WeyKUmmmDKfNL6nu8IsoROQY7NOze5u+
	Ert+QtRS27adWcgwTv7mK2gfhnGSzXkX74K1mXvhY/ixApQ8IEl/7oXv3hLuQ++blhUVv4gN+yl2P
	C4q/tADA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u89NZ-000rjw-0K;
	Fri, 25 Apr 2025 11:05:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 11:05:29 +0800
Date: Fri, 25 Apr 2025 11:05:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: api - Add crypto_stack_request_init and initialise
 flags fully
Message-ID: <aAr7-Qdi369VtPBS@gondor.apana.org.au>
References: <202504250751.mdy28Ibr-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202504250751.mdy28Ibr-lkp@intel.com>

On Fri, Apr 25, 2025 at 07:23:49AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   393d0c54cae31317deaa9043320c5fd9454deabc
> commit: 04bfa4c7d5119ca38f8133bfdae7957a60c8b221 [3678/6092] crypto: hash - Add HASH_REQUEST_ON_STACK
> config: um-randconfig-r063-20250425 (https://download.01.org/0day-ci/archive/20250425/202504250751.mdy28Ibr-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250425/202504250751.mdy28Ibr-lkp@intel.com/reproduce)

---8<---
Add a helper to initialise crypto stack requests and use it for
ahash and acomp.  Make sure that the flags field is initialised
fully in the helper to silence false-positive warnings from the
compiler.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504250751.mdy28Ibr-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 1b30290d6380..50849c4de0dc 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -548,8 +548,7 @@ static inline struct acomp_req *acomp_request_on_stack_init(
 {
 	struct acomp_req *req = (void *)buf;
 
-	acomp_request_set_tfm(req, tfm);
-	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+	crypto_stack_request_init(&req->base, crypto_acomp_tfm(tfm));
 	return req;
 }
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 5f87d1040a7c..bf0c4c441ee4 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -1030,8 +1030,7 @@ static inline struct ahash_request *ahash_request_on_stack_init(
 {
 	struct ahash_request *req = (void *)buf;
 
-	ahash_request_set_tfm(req, tfm);
-	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+	crypto_stack_request_init(&req->base, crypto_ahash_tfm(tfm));
 	return req;
 }
 
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 7eda32619024..8a5b116abaa3 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -226,8 +226,7 @@ static inline struct acomp_req *acomp_fbreq_on_stack_init(
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(old);
 	struct acomp_req *req = (void *)buf;
 
-	acomp_request_set_tfm(req, tfm->fb);
-	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+	crypto_stack_request_init(&req->base, crypto_acomp_tfm(tfm->fb));
 	acomp_request_set_callback(req, acomp_request_flags(old), NULL, NULL);
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_PRIVATE;
 	req->base.flags |= old->base.flags & CRYPTO_ACOMP_REQ_PRIVATE;
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 1e80dd084a23..bba3ed3459a1 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -278,8 +278,7 @@ static inline struct ahash_request *ahash_fbreq_on_stack_init(
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(old);
 	struct ahash_request *req = (void *)buf;
 
-	ahash_request_set_tfm(req, tfm->fb);
-	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+	crypto_stack_request_init(&req->base, crypto_ahash_tfm(tfm->fb));
 	ahash_request_set_callback(req, ahash_request_flags(old), NULL, NULL);
 	req->base.flags &= ~CRYPTO_AHASH_REQ_PRIVATE;
 	req->base.flags |= old->base.flags & CRYPTO_AHASH_REQ_PRIVATE;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index f691ce01745e..a17b980c4dd3 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -509,5 +509,13 @@ static inline void crypto_request_set_tfm(struct crypto_async_request *req,
 	req->flags &= ~CRYPTO_TFM_REQ_ON_STACK;
 }
 
+static inline void crypto_stack_request_init(struct crypto_async_request *req,
+					     struct crypto_tfm *tfm)
+{
+	req->flags = 0;
+	crypto_request_set_tfm(req, tfm);
+	req->flags |= CRYPTO_TFM_REQ_ON_STACK;
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
