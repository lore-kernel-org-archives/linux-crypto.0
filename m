Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF941DACA1;
	Tue, 15 Apr 2025 09:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744709013; cv=none; b=V30cEPPDgvP7d+eU1Ze1KyCXZrlIHfQ1kXUbW6Ix03IS8lq8qDQQlJUPRmoyb9od2RnlilV6mG9xoQzBp0UZhBIPm0Ay99iVOAzgBGXHELBAhFBKMegrrXl+Nxygf0SmGKy+xAKGlclePwBB3/Y2JYEnrx/13DQXhOnjhGGvJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744709013; c=relaxed/simple;
	bh=PEcLK7Gl5XkhRIWEICekKaJk+h+mklaCR1FS0NFjhgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cqocrl3YiJ4vP2h5atM5m/Lv6BfmqTyZuCobeabZQTlPvmJaEOIJU4tI/TEv2uf5iRdWrWbBqR3420RSoX6Ft5GpJJxdOhZJpZGRFZYL4ssFkia6twSNasMBmCWdpx54C0w1Q58o2e/nhmvoVStjklmf0RzCwlo/9OmTbmj0++c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eBam/HlY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eBam/HlY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BF1mvQsRh8rLuu4T79aF7GcZt0sUaJl5Hw6xLO7MqjY=; b=eBam/HlY7YGM0qUhpAr4Lq2IBf
	2BDCYMplNVAaPNI3Y399RvQXF2FN2xb9MfC9B9WvMGJxMjY7pyUjJmJz+AvdLgmvb+X+xkV0UYNB9
	MFCVqP+wK5v4WiheZqMrgnC3XkDSIFFQLTmrDFsVcDr4OKOxwhEXt0icQgzyqooLQQ3GD4wsVqlxe
	PTOrK0++c3pcEtn/dZGXyv84nQwVTRS9jQ/e/zqVOuh+ZdfoA9TFOBpP7YO2tXJEyVl9s8fRdwO1S
	mbZIkc1WO8AOsOpZSlyapec6VflGrEeCm4mzXQOyt6Ln3EF8nKnUtigRbvx7sw9S5IjZNChILzbFZ
	WiwsXQ/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4cVj-00FmXy-2D;
	Tue, 15 Apr 2025 17:23:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 15 Apr 2025 17:23:19 +0800
Date: Tue, 15 Apr 2025 17:23:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: deflate - Make the acomp walk atomic
Message-ID: <Z_4lh9uixqXsoXWr@gondor.apana.org.au>
References: <202504151654.4c3b6393-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202504151654.4c3b6393-lkp@intel.com>

On Tue, Apr 15, 2025 at 04:43:51PM +0800, kernel test robot wrote:
>
> +-------------------------------------------------------------------------+------------+------------+
> |                                                                         | 9c8cf58262 | 08cabc7d3c |
> +-------------------------------------------------------------------------+------------+------------+
> | BUG:sleeping_function_called_from_invalid_context_at_crypto/acompress.c | 0          | 18         |
> +-------------------------------------------------------------------------+------------+------------+

Thanks for the report.  This patch should fix it:

---8<---
Add an atomic flag to the acomp walk and use that in deflate.
Due to the use of a per-cpu context, it is impossible to sleep
during the walk in deflate.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202504151654.4c3b6393-lkp@intel.com
Fixes: 08cabc7d3c86 ("crypto: deflate - Convert to acomp")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 5d0b8b8b84f6..33c9c1af7407 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -622,7 +622,7 @@ int acomp_walk_next_dst(struct acomp_walk *walk)
 EXPORT_SYMBOL_GPL(acomp_walk_next_dst);
 
 int acomp_walk_virt(struct acomp_walk *__restrict walk,
-		    struct acomp_req *__restrict req)
+		    struct acomp_req *__restrict req, bool atomic)
 {
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
@@ -634,7 +634,7 @@ int acomp_walk_virt(struct acomp_walk *__restrict walk,
 		return -EINVAL;
 
 	walk->flags = 0;
-	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP))
+	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
 		walk->flags |= ACOMP_WALK_SLEEP;
 	if ((req->base.flags & CRYPTO_ACOMP_REQ_SRC_VIRT))
 		walk->flags |= ACOMP_WALK_SRC_LINEAR;
diff --git a/crypto/deflate.c b/crypto/deflate.c
index bc76c343a0cf..dee2cf4e0d03 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -60,7 +60,7 @@ static int deflate_compress_one(struct acomp_req *req,
 	struct acomp_walk walk;
 	int ret;
 
-	ret = acomp_walk_virt(&walk, req);
+	ret = acomp_walk_virt(&walk, req, true);
 	if (ret)
 		return ret;
 
@@ -147,7 +147,7 @@ static int deflate_decompress_one(struct acomp_req *req,
 	struct acomp_walk walk;
 	int ret;
 
-	ret = acomp_walk_virt(&walk, req);
+	ret = acomp_walk_virt(&walk, req, true);
 	if (ret)
 		return ret;
 
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index fbbff9a8a2d9..2c461e16d238 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -228,7 +228,7 @@ void acomp_walk_done_dst(struct acomp_walk *walk, int used);
 int acomp_walk_next_src(struct acomp_walk *walk);
 int acomp_walk_next_dst(struct acomp_walk *walk);
 int acomp_walk_virt(struct acomp_walk *__restrict walk,
-		    struct acomp_req *__restrict req);
+		    struct acomp_req *__restrict req, bool atomic);
 
 static inline bool acomp_walk_more_src(const struct acomp_walk *walk, int cur)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
