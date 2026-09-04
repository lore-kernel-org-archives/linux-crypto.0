Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A6B443E5E;
	Fri,  4 Sep 2026 10:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516123; cv=none; b=Oz+FcqEHkHkPpS23LsKzTy4UfLN4VEHBAWHMgtQetGpIAcxRRbAYg1n21zxJWWkb96Jj1B0RjSaeCUsIgqZAeJBQ478+71jJl5SXco4eLQOcoWgVkXU6xHXgwGcYJhwLg9yAnE5lIeMIPkhejFjYDsQx9o+7TyykZK6HUd5b2DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516123; c=relaxed/simple;
	bh=G5ixVIiLRNUJN5wkzxhFpUXio0IlDCix8AFEp8RA7qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8flA/p2IbyjHTCR7vr6cJS1pFZatvE/Hwc959KELDqizTE2S/xUnvdSx/BIm6wigtwjHDJ80lYWk9ylT70aoYp4EdiOVYHqDH4KmcY8rUYnYRODoAE7HKMTVe2vvMygpG5PmC6rCphcF/GaaX/oBTlxKB+xtvZM+wMSthsr16Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aKinaFIP; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aKinaFIP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=EUEhdTEFDBYUOmmsgEMSQS1UmtlzPuBLsbkWY6ZToKo=; 
	b=aKinaFIPfMgYYiw363YhbwNtKrYg335dlSic3+k8Ba49WuSgLyI20hELeqq6RCIeTb6vcSy4kZK
	kEM04Ak1crJepFEMRORNK9QY0ZZWuDZeLX1WkMFhlDuFa8VYZMEMGa17W2nlUF8YLhK/LPPc65lF/
	tab7I+t4ZqM6MseGyvysUlzvmkolAUoyweAyUX70sTKHCS7N/bJd6d6lXukzI7nxH4566svfIWdzz
	nNnByidTEsjGFxXfKHuynqar0Md1a/aoP/9J/5fj998zTBtIzZfEMSdoU9nFjn/quhjEeeZzQXao5
	YYssRCN+2JXWD1ZfQ1GZsArTEu7P0LhZbsdw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Qk8-0000000AnLs-48mZ;
	Fri, 04 Sep 2026 18:01:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 20:01:56 +1000
Date: Fri, 4 Sep 2026 20:01:56 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH] crypto: octeontx - use crypto_memneq() to check HMAC
Message-ID: <apqXFFGJJlIRjopg@gondor.apana.org.au>
References: <aoCdOiyhQZZsFm5S@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoCdOiyhQZZsFm5S@david.gall>

On Sat, Aug 15, 2026 at 07:09:14PM +0200, David C.C.M. Gall wrote:
> validate_hmac_cipher_null() compares the computed and received HMAC
> with memcmp(), which short-circuits on the first differing byte and
> leaks tag-match length via timing. Use crypto_memneq() instead.
> 
> Because for cipher_null the validated payload is un-encrypted, this
> valid prefix leak allows for authenticated message forgery.
> 
> Assisted-by: gregkh_clanker_t1000
> Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
> ---
>  drivers/crypto/marvell/octeontx/otx_cptvf_algs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
