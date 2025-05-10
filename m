Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCCD1E9901;
	Sat, 10 May 2025 10:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746873698; cv=none; b=NwJSgNxtk+hYquY5gzTX81EFehDeJa5UIDaMlx/P69CfHO0cVxhoneKnQbLisBKntkX51pqrEDQSvH93P8TXAgRmtHYTBWe1+dee0eiCDcjlQX9j6AaAN2+XJiia2bOMhX1FKYL+y4kgVHIrqKqFEJljIolDwbbhucEylxOfqw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746873698; c=relaxed/simple;
	bh=uf7iuBOGtRusc2qdWp7vhMMYM+W9F+pYeofabP9pcV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXL6/wDoYXZeOhfSWPeYRRfivgLgpVVVoCedFMptKfYVpUwfEObWe/V23k6Bob2FUgMb4YlnmV2eyrC9N4QANvVGG5IGtfE9sXCB5bEgNUlY3whgMno3vXqecY7J/I7ppyHnLA5v/+DkGKZxjwZ8Ymxt6Cvx8Oz4rjPfA5fz2eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nAaWaPMn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nAaWaPMn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=az+uqpLjFfXOFLmSbeAHf6lI2r7SF8nOcWYMfEc+Eao=; b=nAaWaPMnwx7YmXSEq1rXxsiFpK
	zpipxXYCUrGxAwaVPMUIjn1j+mNGNrOpnNra+jKfI83INsJU3OkZZisN5uHli7x1bjDqjUuqmlYgL
	BcYu4P/+CXdnVIgEzUKIqhBgAlI6HiQZHBtFOBriyMKPDcdLzE9Yu2MJCYEYm/JieiaHfaT60SKsc
	FgznRuyprX7O0OAhS0oswER7FE8NVypz5K9oMol4EowJJCZwYAtm/TA22RukIhHYeHt82RgUSF/15
	jwBYceheiA8po37oxw3k0ckGdOBECPgr+YlmWbg9NdrneF1m3KAMI3fX13HgYVuTQuCIG+kk+3M+p
	wZcUZSHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDhe7-0053Mc-2S;
	Sat, 10 May 2025 18:41:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 May 2025 18:41:31 +0800
Date: Sat, 10 May 2025 18:41:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] crypto: marvell/cesa - Handle zero-length skcipher requests
Message-ID: <aB8tW2PYvX70HBPH@gondor.apana.org.au>
References: <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <aBypVwhHHzmqqN5K@Red>
 <aBytNdRyd5Ywh1Pq@gondor.apana.org.au>
 <aBy06xyzh5kKC48a@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBy06xyzh5kKC48a@Red>

On Thu, May 08, 2025 at 03:43:07PM +0200, Corentin Labbe wrote:
>
> 6.14.4 boot log at http://kernel.montjoie.ovh/477911.log

This patch may fix the skcipher ENOMEM errors, since they all
seem to come from random test vectors with length 0.

---8<---
Do not access random memory for zero-length skcipher requests.
Just return 0.

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/marvell/cesa/cipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 047f3758c1d1..cbf86968d8a2 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -456,6 +456,9 @@ static int mv_cesa_skcipher_queue_req(struct skcipher_request *req,
 	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
 	struct mv_cesa_engine *engine;
 
+	if (!req->cryptlen)
+		return 0;
+
 	ret = mv_cesa_skcipher_req_init(req, tmpl);
 	if (ret)
 		return ret;
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
