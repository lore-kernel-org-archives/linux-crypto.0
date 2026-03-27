Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236D1350D4F;
	Fri, 27 Mar 2026 10:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606169; cv=none; b=H09vtiROvmcH0T8f7WkcMr8C6ZRDbuz45kM4Q9nhZvJTpriS81gfWJDz+PH1n7h1gbA8dF0W7N0LS3CTsXRIRg1qkWvbs4sWkJAQO9suHmCeEv3ufmwRh3qOm8TWffzrqcIQAb7G+EIFRK5zRLTgI2nh7B1TNuJ0vLEs4KDUiaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606169; c=relaxed/simple;
	bh=nJMecpFDmr1nEwjf9nsDebwkgmIp8QrVPqoYrLKPgak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWH2XFdrbSpIB4KlSnEPn8vpA/l5wudQ54HqoqBhyFzXJ4Mn9OCLlwZvvo9//v5VXsFhAjGeYuJ7ZwwkNykcMNvGieROkiVNjpd7oTPG8UNiE7hvoDyv6sXV2LR5zTKoz0l1gf8zWfDsCC7dNzNObhg+1yUFNg5plDh6oqdMMrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gRDmpvho; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gRDmpvho"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=T5aJ4McUQ00hr6syx7eYy96Q12PQ2wa+0kJQK6dAqVg=; 
	b=gRDmpvhoYrQZvR0FT5thM7UVFBjxjQXE3k+N0uKXHNrkyECREs0QighkSQXZVSLXaNZj/nvInhk
	nsJGXepISxn6hv0Pyx4cjncqFAKJnGzPtnI+JkRA9WL0kIsBW6A6vNIlI0tSMA62lRqVFk+gbjiKM
	8BB9dsfRTjv+7iw7TDba0LOQo5P9Atttu4yl+dM+MmKs7Ec8D9r+qjG9cS6D1DwSQ+STA4lPlzb90
	VSxBe6yt96rCeTIGaa2Td8rTAnt7ty1sApK5sI8Dg7Jp4Q7po0BSGox7oPg7WT5YDKdq4VoCuT68/
	wu82QPptiNQLpyD42yVpZgrUhjIoT5O1rFhA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63iN-001bqz-2T;
	Fri, 27 Mar 2026 18:09:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:09:10 +0900
Date: Fri, 27 Mar 2026 19:09:10 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: naseefkm@gmail.com, cjd@cjdns.fr, ansuelsmth@gmail.com,
	atenart@kernel.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - make it selectable for
 ECONET
Message-ID: <acZXRpT5cFOuWF2Z@gondor.apana.org.au>
References: <20260320211931.829476-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320211931.829476-1-olek2@wp.pl>

On Fri, Mar 20, 2026 at 10:19:23PM +0100, Aleksander Jan Bajkowski wrote:
> Econet SoCs feature an integrated EIP93 in revision 3.0p1. It is identical
> to the one used by the Airoha AN7581 and the MediaTek MT7621. Ahmed reports
> that the EN7528 passes testmgr's self-tests. This driver should also work
> on other little endian Econet SoCs.
> 
> CC: Ahmed Naseef <naseefkm@gmail.com>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/eip93/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
