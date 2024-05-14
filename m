Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF96B645;
	Tue, 14 May 2024 05:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715663864; cv=none; b=q670utozfI9gH+C146wCtaj7r2dld7Uo6g2m9HwPixa2kW3S2bNbVMgK7klbMuhCMK0G/Mh3smwjGJ1/8oVJmFfaXpX2xnvLxvLyZaEXgg7XGhIsU5zhXaSCmvluq7rV8dtqJas694f+Fx5gAhg9u3oeBRzHWJiVj+kQmr/0j/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715663864; c=relaxed/simple;
	bh=BrsxgSl0pJaCcg6lV+IXDRx+9CTewYOdnegpOdb2Rzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OIfKnsFEZhUo9dWpPLy5BzPSjsz4gY/60JVG4MZqRTlBU0mX6mbr2fBUhHC3hotmK2TtLtTtY6oEStMBVBSC+csa3f3I2L1fftSwbQsbL+IKBpb9drNAp2lOnUS0waXaut/t1L/TqCPshaCC/fKQ+NqfkZF/ce6Zh2cKwBukXlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s6kXO-00EsER-37;
	Tue, 14 May 2024 13:17:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 May 2024 13:17:19 +0800
Date: Tue, 14 May 2024 13:17:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Wunner <lukas@wunner.de>, "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.10
Message-ID: <ZkLz31t6ZJmbsj3o@gondor.apana.org.au>
References: <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <CAHk-=wjmwmWv3sDCNq8c4VHWZUtZH72tDqR=TcgfpxTegL=aZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjmwmWv3sDCNq8c4VHWZUtZH72tDqR=TcgfpxTegL=aZw@mail.gmail.com>

On Mon, May 13, 2024 at 03:12:53PM -0700, Linus Torvalds wrote:
>
> Maybe somebody can teach the kernel build in *general* that
> "kmalloc()" and friends never return an error pointer, only NULL or
> success? That would not necessarily be a bad idea if the scope-based
> cleanup otherwise causes issues.

Yes he did try this out:

https://lore.kernel.org/all/20240302082751.GA25828@wunner.de/

It resulted in an increase in total vmlinux size although I don't
think anyone looked into the reason for it.

> But this kind of hacky "one random piece of kernel code uses a very
> dangerous pattern to state that some *other* piece of kernel code has
> particular return patterns" - that is not at all acceptable.

Agreed.

However, this patch still has two outstanding build defects which
have not been addressed:

https://lore.kernel.org/all/202404240904.Qi3nM37B-lkp@intel.com/
https://lore.kernel.org/all/202404252210.KJE6Uw1h-lkp@intel.com/

So I might end up just reverting it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
