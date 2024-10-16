Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645681885A0;
	Wed, 16 Oct 2024 04:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729052859; cv=none; b=DnYvBWnjC2txetsHARXQ3HcXxvPFAYd9BaFc7O8mCN1pLn6BXQGHOi8gf8D9zXS7ciz+viedMGbgKnW3bmJWR0LmSl6IoK1Qb7v95Ta9j579zKsX+z4gRnif+jyj9aQE9a91yGPMWRZz5BO+XPOvPCU49+jyjLtUHJjckD/w7TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729052859; c=relaxed/simple;
	bh=hVLTmQoIR4NnPP/Mi71p3DtZcSEuUiBYU5Kz9KmXAhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pzld0DGWNb3/GfaSgPz4uZ6t4sHxZVDgPLGxpU9hNruMbfaOwpJRoLJo+pHvCyUqkR1Ncb6mwArclPE7ShStcmieB1kcbTMEXAm18C5kCSQkmZegmYVwkd2vhHINJQX0dwFpzU2D22ifvxO43BIwXvxKdW8Db8R/BeoIrKYJQjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=W2RmBfMV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="W2RmBfMV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NW9YDCtZFYicQcANZrspiKTFqONICzgJfERuIxJwwNk=; b=W2RmBfMVuKF8/X6cU1pFP4vbbb
	m5RHycH82wjxokH01lOZgqBFHEhKONi0FdfoEJK+01FFvXf//SUdl92CaDJPeCoWtj3PhcoaypIXV
	LyF73HIlP6Q/dyECLqlm043QnjiOeC0DmpewYgvQ3mRZQm8/n4k+vJi9An9kHyPMGe9ADvgJsRvAt
	qcHMWZmUshTbNOloHXs7ek80fDS9ZCxPwsU+buExbS4NJ7uPG3Kf5geu7/+27yr7iqe5K6njSqrpq
	0ypVFFtu/u21DI9SQWnss/ETObnxzOI1s4pmeKEctoNJ5ovnm5uDUGFUuOkcr5iHssc1RpEYT0Gev
	Y68j3kvA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t0vTI-009jQQ-2p;
	Wed, 16 Oct 2024 12:27:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Oct 2024 12:27:30 +0800
Date: Wed, 16 Oct 2024 12:27:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [REGRESSION] alg: ahash: Several tests fail during boot on
 Turris Omnia
Message-ID: <Zw9AsgqKHJfySScx@gondor.apana.org.au>
References: <1fc4db6269245de4c626f029a46efef246ee7232.camel@gmail.com>
 <ZwObXYVHJlBaKuj2@gondor.apana.org.au>
 <38a275a4e0224266ceb9ce822e3860fe9209d50c.camel@gmail.com>
 <ZwZAExmK52txvHE8@gondor.apana.org.au>
 <7e38e34adddb14d0a23a13cf738b6b7cccbfce6f.camel@gmail.com>
 <ZwduxHxQtHdzz-kl@gondor.apana.org.au>
 <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>

On Tue, Oct 15, 2024 at 07:38:27PM +0200, Klaus Kudielka wrote:
>
> So, I applied the TDMA-disable patch, and I saw the same errors.
> Then, I applied the printk patch on top of that, and here is the result.
> 
> Not sure, whether this makes any sense...

Interesting, I think this shows that the non-TDMA path doesn't
work at all :)

Can you apply the TDMA-disable patch, and revert the asynchronous
self-test patch? If it still fails, then we'll know for sure that
the non-TDMA path is simply broken.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
