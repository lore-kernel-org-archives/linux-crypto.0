Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5773244694;
	Thu, 30 Jul 2026 07:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785398067; cv=none; b=G4oLR5Y4hRoG0NFuHSdluJJ1GSk8Pfb1rfJcKxJHx9AEQ1DGmsqsqbqa8b+yurHgTQ6hgWm8Sh4DvsioRAceuVrPd2yYB4yARm1TZA7ij/woWmhSJrMMynEILgKj76XJgwglwSE6t1RnXg3a/O+KFwZT4bkmB6+ZuDUt7rqg6GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785398067; c=relaxed/simple;
	bh=6XIR9OD/y5ta1HNQfF9xFxl2GFuHYB+e1y6uN9cGWp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CtmXkJYe2XLYh9Iyf2XIYvCdjdpjzfs9xJCYr+YfLYFstV6MWOSNijsr4n5ie2jkF3HyFfgtfIFVEely6/tBvsl5O98WvmLNeWJuWIfB3WGEaeAMZflhbvTwAspolJmMDU7tSHgWnpJkuVzvn0NXTjKP0+2bTQS3qx4Tkf+1P4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=m/7gT63t; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="m/7gT63t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=E+VvNN1CRffJOl+seFeor25RNyXOnzzyvKXroxsKtsE=; 
	b=m/7gT63tu+8pwC5x6nYNF0phm0kkGm4jdHXkBIgT1ylXLjpu2VtoyYoECgGGrVaR3d3VLrfa8sD
	CWDt/D9l4TwhkDn4ecC9KJU7BfJFxvt4r3DwQ5BG7ctKiF+d/dG8aMMPHQDN6qJcNNZ5nZJVvJKfc
	fg1P0pp6BfcqAAsHE+thcx8OK37ZLF5xtSU/KMPSN8FJhAsSpWOnj1BOMrOfEU+KfH5UpgqEbuv06
	b0igSl/VV7FIutDEOIQBuY1Ks4a0q2GkSyUSRzU6uUumQniiotuiLCf6oa8iIIUFh8mmf7iJZ2Joi
	QeY6b2/nE0xDbPDd5vns9d8OKs9CwxT99jLw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpLav-00000000S9a-056E;
	Thu, 30 Jul 2026 15:54:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:54:21 +1000
Date: Thu, 30 Jul 2026 17:54:21 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Richard Weinberger <richard@sigma-star.at>
Cc: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	demiobenour@gmail.com, davem@davemloft.net, ebiggers@kernel.org,
	upstream+linux@sigma-star.at
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Message-ID: <amsDLRticYiBYeVP@gondor.apana.org.au>
References: <20260726192716.2351505-1-richard@nod.at>
 <5372653.jyWNHgNrjM@nailgun>
 <amsCPXNkPr4dYd6F@gondor.apana.org.au>
 <5915345.sfYGdeWWPf@nailgun>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5915345.sfYGdeWWPf@nailgun>

On Thu, Jul 30, 2026 at 09:52:44AM +0200, Richard Weinberger wrote:
>
> Eric asked me to wait a bit before I send a patch for next:
> https://lore.kernel.org/linux-crypto/20260727172004.GA877700@google.com/

Well if I'm going to apply your patch I need to know what you want
this to do in next.

Are you happy to leave it as denied for next?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
