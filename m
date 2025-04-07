Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9270231A3B
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021274; cv=none; b=ORT/Co0uaENxOppZ20p/eI9+oTlQa0yHwbP30wiiHibYPLGbesOwxjQweyqeruLsyfkuIFuf8m66FAe9gXWLMDyMcaeb5HRJBc6bDdhnTbXEjfdW5iIeENQOb/wMgh39J2V/a831qFHn8bq+kw+Lc4UV2ZLyaIxngxzy3te+0bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021274; c=relaxed/simple;
	bh=oNVG1RkSNqvKjVNR4ga0UehmJVnwSNEj9hm9NS09ric=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=KGDmSp+gvnGd0X3hRe56oijj3Gbpu8dXuvOrH9mEOomVHdEaE/vnYdMMpYlZHYx2k5lX/C4tz04KM+UhTkLzFi9d48hswbMx+jQ+MNx79+YOQKQRXwKZU1jdd0lsNkaDxAK2A4kbIDpTxXk1IjAki+Bxfo/5uuhqz/NY3jTiFug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FSUIgK1v; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FSUIgK1v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+mKvYSqxW+5mI2F/5cqyswHgDklFO4XaahKYpPbCEKE=; b=FSUIgK1v7FzIPqsD66remmrpdt
	0Q63SdIhBMvROBQu2k0IrdrI/3PVZfU17pfdr0EzF+OZCu3NRa0jAdWjX+cVW2JL12TSqI19MHdFS
	QWDQwkV19mHb2gF0S/ZGT4+Qd4/qYCdHRBKkMNKz4+Y5EkYU/oRXROI34eEfi/mzPmrfA68+hwjDa
	ufO0LYJYsoyI04d3c2tx12NULjw4WAo+YYgbhDi22EsWjHKeQ6aV/EbjQC+7f26UNXutyWW/HTMSg
	Tn2Y0b4hSJeF3qniERobAfmJmgMmXkhlBt3cQ/SrNjKM0FA+cofJxiHzm/bcC1fE9SuYcYtmCG9YP
	0KvWFmBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jbJ-00DTZw-0E;
	Mon, 07 Apr 2025 18:21:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:21:09 +0800
Date: Mon, 07 Apr 2025 18:21:09 +0800
Message-Id: <f9ca529efa20aee6fa82998725eb94d561e6162d.1744021074.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744021074.git.herbert@gondor.apana.org.au>
References: <cover.1744021074.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/7] crypto: acomp - Remove reqsize field
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the type-specific reqsize field in favour of the common one.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 2 +-
 include/crypto/internal/acompress.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index e9406eb8fcf4..dbf647810e50 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -109,7 +109,7 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
-	acomp->reqsize = alg->base.cra_reqsize ?: alg->reqsize;
+	acomp->reqsize = alg->base.cra_reqsize;
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
 
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index d6d53c7696fd..0f3ad65be2d9 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -40,7 +40,6 @@
  *		counterpart to @init, used to remove various changes set in
  *		@init.
  *
- * @reqsize:	Context size for (de)compression requests
  * @base:	Common crypto API algorithm data structure
  * @calg:	Cmonn algorithm data structure shared with scomp
  */
@@ -50,8 +49,6 @@ struct acomp_alg {
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-	unsigned int reqsize;
-
 	union {
 		struct COMP_ALG_COMMON;
 		struct comp_alg_common calg;
-- 
2.39.5

