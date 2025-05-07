Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89406149C64
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2025 02:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746584466; cv=none; b=FfARt7TsEd/7pFkffzukkQUl6ZGAZShD966tAr0FazPioKsh2vejsF0qIRg9hrLwtl4L7PVmBlUhfXd4phHGxtOF50dZfaoP0Fix1EYZ4ECVjrJct12v/QDBNVzmGmstsnqtJR+XqKxOvWaTPGNrYuMdwfhNfkUEzOa5j8ZJjXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746584466; c=relaxed/simple;
	bh=fGSHuib2SZyqjEX7OYUNHY+MDtNrZizWAQ0h28EZY1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EK0E+bw8TJS0pwDSGCVmmN7bFW336evAEKGCKVq0/f/hQxpY+auUjXe62tW8KE3+Dinhz+p0BIRTmsPHZlkNQrQvZPBQUuMykkxhpmCBdE4hZ2HYtk34tLVUDbZQqk7vZG1bposZEqx2C8ivt8MstKuLN6fMtXD3Zp3ID/PzTKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iXptVaTb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iXptVaTb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LRrx6OJt8/yegg/9sfEOTknx1NeSN+1nPzWCJ1Bfph0=; b=iXptVaTb6FgpUrqowPJmCVFOTi
	Djgf/cxbMDyt1kP7wQYfeGNhQ+spQBzgMkG+JpbXPQtr5gTjEEAQgw967RR/7CPRbK6jomXEi2v86
	XmCldJLOWzgq+rinrmMroYXGCu+Bb8Q2cFZGwturFVxEOC5lDe8K01rNjNnoRjf8mB48/F5TUJOKJ
	KrFqpjNhqmtLKQoOXNvN+PmWt/2bNFtvVNQBhSUnHpmb6vV//ObC/y8rMaNaclz6TT3SakBk7+FUf
	5ZcWrIC152lIiAW5nxK30V9ATMdKSR8ArBwGLh8HpYaHWi4phkRy3DI3nO1HsvOKUp/PH+4ounSF+
	S8yay04g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCUP4-00471I-03;
	Wed, 07 May 2025 10:20:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 May 2025 10:20:58 +0800
Date: Wed, 7 May 2025 10:20:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 2/3] crypto: acomp - Add setparam interface
Message-ID: <aBrDihaynGkKIFj8@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <74c13ddb46cb0a779f93542f96b7cdb1a20db3d4.1716202860.git.herbert@gondor.apana.org.au>
 <aBoyV37Biar4zHkW@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBoyV37Biar4zHkW@gcabiddu-mobl.ger.corp.intel.com>

On Tue, May 06, 2025 at 05:01:27PM +0100, Cabiddu, Giovanni wrote:
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index 6fdf0ff9f3c0..cf37243a2a3c 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> ...
> > +int crypto_acomp_setparam(struct crypto_acomp *tfm, const u8 *param,
> > +			  unsigned int len)
> Is the intent here to use strings to identify parameters? In such case,
> `len` should be called `value`.
> Or, is `param` a pointer to a structure?

param is just an arbitrary buffer with a length.  It's up to each
algorithm to put an interpretation on param.

But I would recommend going with the existing Crypto API norm of
using rtnl serialisation.

For example the existing struct zcomp_params (for zstd) would then
look like this under rtnl (copied from authenc):

	struct rtattr *rta = (struct rtattr *)param;
	struct crypto_zstd_param {
		__le32 dictlen;
		__le32 level;
	};

	struct crypto_zstd_param *zstd_param;

	if (!RTA_OK(rta, keylen))
		return -EINVAL;
	if (rta->rta_type != CRYPTO_AUTHENC_ZSTD_PARAM)
		return -EINVAL;

	if (RTA_PAYLOAD(rta) != sizeof(*param))
		return -EINVAL;

	zstd_param = RTA_DATA(rta);
	dictlen = le32_to_cpu(zstd_param->dictlen);
	level = le32_to_cpu(zstd_param->level);

	param += rta->rta_len;
	len -= rta->rta_len;

	if (len < dictlen)
		return -EINVAL;

	dict = param;

BTW Sergey said that he was going to work on this.  So you should
check in with him to see if he has any progress on this front.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
