Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4E4374CB;
	Tue, 11 Jun 2024 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718121097; cv=none; b=rH0q3iPH8rxfAlgR6uypthpvPbbmiHnplsGjnYl5f7qCwXhdMSXHo06GBhWaiUGB4AnCYbjP+S9q2Dwh5GVvGS4G+TUyx7NuPpAHn2AvdTOO34IQjU4UYzJ6aKilMTkqpC3pE7nV7er1QHEYanl4PmCp4OdU5yS88C5rHd1q1ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718121097; c=relaxed/simple;
	bh=XckmIxxwagAL+OLUx/2jzd5T78QbSt3kFnzccEHytl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhx0bdB0gmeEuPwGSXciR3SQxWZCayqa+A4RhNNbWaZ1N9Gzyky6ulY9Imsn1mI5zMxvrLfpJCC5pwoX9xQPKjGIkeIkOdFS21Dtou6tsX0ODc6Ah8/fYTbRgaWL9ES0zJtM6uKgiwE8RAm/8CrwYu/M9VbjGXFOvFCwIXW6H0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sH3mS-0088Mw-0u;
	Tue, 11 Jun 2024 23:51:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jun 2024 23:51:31 +0800
Date: Tue, 11 Jun 2024 23:51:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <Zmhygz_0bJZ52ljd@gondor.apana.org.au>
References: <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
 <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au>
 <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
 <ZmFucW37DI6P6iYL@gondor.apana.org.au>
 <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
 <ZmF-JHxCfMRuR05G@gondor.apana.org.au>
 <20240610164258.GA3269@sol.localdomain>
 <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>
 <CAMj1kXEwmHqKbde4_erjmdi=+nO13Qwu3nSbkU_77C3xcjxAjQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEwmHqKbde4_erjmdi=+nO13Qwu3nSbkU_77C3xcjxAjQ@mail.gmail.com>

On Tue, Jun 11, 2024 at 05:46:01PM +0200, Ard Biesheuvel wrote:
>
> The issue here is that the CPU based multibuffer approach has rather
> tight constraints in terms of input length and the shared prefix, and
> so designing a more generic API based on ahash doesn't help at all.
> The intel multibuffer code went off into the weeds entirely attempting
> to apply this parallel scheme to arbitrary combinations of inputs, so
> this is something we know we should avoid.

The sha-mb approach failed because it failed to aggregate the data
properly.  By driving this from the data sink, it was doomed to fail.

The correct way to aggregate data is to do it at the source.  The
user (of the Crypto API) knows exactlty how much data they want to
hash and how it's structured.  They should be supplying that info
to the API so it can use multi-buffer where applicable.  Even where
multi-buffer isn't available, they would at least benefit from making
a single indirect call into the Crypto stack instead of N calls.
When N is large (which is almost always the case for TCP) this
produces a non-trivial saving.

Sure I understand that you guys are more than happy with N=2 but
please let me at least try this out and see if we could make this
work for a large value of N.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
