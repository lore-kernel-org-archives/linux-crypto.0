Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8158322A1CD;
	Fri, 23 May 2025 11:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748000821; cv=none; b=QYXM45F07d+feXe0uVU5Sr8vXASaMxmkjyMT/ELWrmtLbPZ6t4Ff5kOG4DyBcOWQvqRDyfyBm1UTAbvjgIoZQWDgnyxA3+qGMk9LHRR3gXkQKAUKI/gnLxoeZ19CTvmvputilYgtN2Rp6y/J0V+3gVoCSdjKrZgIGY+PzoJcehA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748000821; c=relaxed/simple;
	bh=iilGz8MoBUyc28UMKp9IgK8+RSi7l9OI2Zl2mfOWTP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2/8JCbZ7e9r0E424VHV6waWGibWjwBAcnlLZ4H07dJSEJyPxUPJKm/NVX8Bl3jUWcbrTaRwYzjF4+UeIAmIqmA0620oWDLgEd/ENBpvZI36y3wFyGczEIRDUjcHXm8DMDL9brVGNuawOYlXDklAXNuRGtaojx5FXOGN+Wj8W4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XYwOxyyT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XYwOxyyT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wIdXErGXsrFY4QCEB5L0jrLHlVOWgstSIRw8ZMVvmkQ=; b=XYwOxyyTjoGBsZ7b1kq8f2s14X
	p3SbovIInZiMptWY2VglCKGYbGAv9SH85wSeBHb15eroAfg8uhh9KCqjAkC4Ps237MBqhkMbP19x7
	cDYRYTCwSgRajpZibzU9IvMueCKNoOS5To6GMjnzsNkbSHv+tdAfgqmvij+vSTdCPwCxXQUAw5NrP
	CGt4b7HCv0T/v4sG4Tm9OqI3SYUwusV3aNqQKHypRw6Jx6zj8ekk3iWReKIjxMaAkQYo904cCMwAc
	TgjuMdZ/dBN/+DGsCJVrQn7cM5rQjDAR9FV/hf39kg207lpP4sRibrpyMDrEpEMbx+hy0fMMpnOIj
	k1AUM7Ow==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIQrV-008LEG-2h;
	Fri, 23 May 2025 19:46:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 19:46:53 +0800
Date: Fri, 23 May 2025 19:46:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@bootlin.com>,
	Christoph Hellwig <hch@infradead.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: crypto: marvell/cesa - dma_alloc_coherent broken but kmalloc +
 dma_map_single works
Message-ID: <aDBgLT7NsMaG6ylh@gondor.apana.org.au>
References: <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
 <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
 <aC3cF0-bWb-Jiz4i@Red>
 <aC6TkPM6mOuFwvkD@gondor.apana.org.au>
 <aC7UbAIDA46olNJL@gondor.apana.org.au>
 <aC-EGr50MIVJqwVn@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC-EGr50MIVJqwVn@Red>

On Thu, May 22, 2025 at 10:07:54PM +0200, Corentin Labbe wrote:
>
> Here is the result:
> http://kernel.montjoie.ovh/479404.log

So the corruptions have come back, although somewhat less than
before as one algorithm managed to pass all the tests.

At least we've proven that adding the printk's makes the errors
a lot more frequent :)

> I have built by adding also your "crypto: marvell/cesa - Fix engine load inaccuracy"

That shouldn't affect things either way.

So now all the corruptions are all on the final hash.

Can you boot this a few times to see if the errors are always
the same? I'm particularly interested to see if we've managed
to crush the errors on the partial hashes or was it just pure
luck.

Intriguingly the one error that went away (sha256) was actually
a partial hash corruption, and sha256 now passes all the tests.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
