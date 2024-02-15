Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CA2DDD1
	for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2024 07:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707983852; cv=none; b=d9ag/RgtMH5b9CooaYc2C4o3Ua+SNeeGHoJEZM0MByVH8XVndFxIDZpYtK0NPaEK1ZufAdesVJYM3ky5Me6TbH5JPnkDiq79iqdPiApBY7L6WL+auiyZ+imcZ8zlEVIUoesZcZD/1reSzCdWCxw8J8iU2FrJHVRkE0MB9DZ5pas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707983852; c=relaxed/simple;
	bh=KIg42TbGbh0NfpfLij0mzr4rIY1wKc4aSNIDjzY0sHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdWswrjv1P9WqlM53rpZBYi6AfTV1pe9Yz1zEgU1k+ULZH2vpcoq8CE/3GVOr2UMiD/QJ6j/puwiajlfvioLymTW8VRAGQI8tXssTY4l3NS8nDA1+lP5Tfce393UePv3+y5a8Yvpb8NqBGIlT8XxCPaa3RacgrRu5uY5NTYa+Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1raWcW-00Dr2B-KG; Thu, 15 Feb 2024 15:57:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Feb 2024 15:57:38 +0800
Date: Thu, 15 Feb 2024 15:57:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 13/15] crypto: cts,xts - Update parameters
 blocksize/chunksize/tailsize
Message-ID: <Zc3D8kwfZXiCagOL@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <b149e8743355be694c96da02ced0811963298373.1707815065.git.herbert@gondor.apana.org.au>
 <20240214230021.GC1638@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214230021.GC1638@sol.localdomain>

On Wed, Feb 14, 2024 at 03:00:21PM -0800, Eric Biggers wrote:
>
> Before messing around with cra_blocksize, it needs to be decided what it
> actually means, and document it appropriately.  According to the current
> specification, AES_BLOCK_SIZE is correct here, not 1:

Block size should always be set to 1 unless the algorithm is only
capable of handling input data that is a multiple of block size.

>  * @cra_blocksize: Minimum block size of this transformation. The size in bytes
>  *		   of the smallest possible unit which can be transformed with
>  *		   this algorithm. The users must respect this value.
>  *		   In case of HASH transformation, it is possible for a smaller
>  *		   block than @cra_blocksize to be passed to the crypto API for
>  *		   transformation, in case of any other transformation type, an
>  * 		   error will be returned upon any attempt to transform smaller
>  *		   than @cra_blocksize chunks.

OK this is wrong.  We should fix it.  For skciphers, the input
length must be a multiple of blocksize.

We should probably replace this comment with one that refers to
each algorithm type and then document the meaning there.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
