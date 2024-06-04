Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B571411F9
	for <linux-crypto@vger.kernel.org>; Tue,  4 Jun 2024 08:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717490931; cv=none; b=Melk+sUFRO12Xxl9kl6hoJBIPlebYMNX8l/Gqo8FwvxRwISRYh8wTr3UUR/uSEirTR3ntj3wjCRr8+ou9lgCZgedNMKWRhZQKQ8D4BUfT063d/unk7fbwg6oOx429Zm1MFt6QkBYBu/pMA1+0xZpCpmN2UStpRroVxwfZXlkxDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717490931; c=relaxed/simple;
	bh=gIfTKS354CLxsZLz8MUGOPrLtCotTlfs7yjg5K5uU7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pg82dCB1PpQxQqpsLqJDfkqVV8r4fJw1Ns6S5K9RRzxNYAVoSJTzm+gEAIIwHv5lS6qXVi4ZOOSbXPVtXsdn7xUafn/rcB2ZsorvcmZYSotXFx0u199bNnzBNWXHpBijWlZtEoV8uXrBLfYL+GkUgKbO9ZCX28yK0U+4pvQUrVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sEPqO-005Rcr-24;
	Tue, 04 Jun 2024 16:48:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Jun 2024 16:48:38 +0800
Date: Tue, 4 Jun 2024 16:48:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <Zl7U5tKwYgky_s47@gondor.apana.org.au>
References: <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
 <20240531063444.GG8400@google.com>
 <ZlmKX4dD1EcstVmN@gondor.apana.org.au>
 <20240601002415.GH8400@google.com>
 <ZlqbcKUTa5e3rOtH@gondor.apana.org.au>
 <20240603023447.GI8400@google.com>
 <20240603082856.GJ8400@google.com>
 <Zl2ABxcUmNYD1DoF@gondor.apana.org.au>
 <20240604050915.GA11718@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604050915.GA11718@google.com>

On Tue, Jun 04, 2024 at 02:09:15PM +0900, Sergey Senozhatsky wrote:
> 
> Alright, so this means
> 
> 1) zram needs to be converted to acomp interface

Oops, somehow I was thinking of zswap rather than zram.

> 2) scomp drivers that zram is using needs to become acomp compatible
>    (for example, I don't think I see acomp support in crypto/zstd.c)

I think you're still confusing scomp with the legacy compress
interface that zram uses.  Any algorithm marked as scomp is using
the new acomp interface.  So zstd is fully available through acomp.

> 3) zram needs to support setparam
> 4) zram needs to support tfm sharing, so that setparam can be called
>    once
> 5) crypto comp drivers need to start support setparam
> 
> That's quite a bit of work, I should admit.

At least we won't be duplicating the compression algorithms.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
