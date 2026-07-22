Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7137B25B08A;
	Wed, 22 Jul 2026 15:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733388; cv=none; b=qitQCLTDEM3Sj+skNgJ8bjLMwybY8cFBOR85TJHo35MtVrwasI1lGsfgb/o/R7fjjBUWcQ40L9D8cGerhOOE54HCZwASRPaEXJT7Si7FKINJnYdJWiQwEBu9/0kKygdkk8EZnQf4ucc5IQoFaJf8KPXJaSacwLurg2rTmtQMsC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733388; c=relaxed/simple;
	bh=vFYT7bBmwqmlRKIXepWSLkoiwumHsnOZ5zLuNkt9ST0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MruAMyr1ZWQ8nihSl+IxPRC2Pg872EmNyBlHmlLqAphGY/rKSelSs8+HS4tgkcn2osadYTMJkgS5aFNCk8T0q8SvtLSjQMWBBMafbjm7xmojSEvd5DvCj1tE9282uz2R/Kd17OSndcpRigcjvHsCvmceiVAL0F1C/icJAJC+8hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzR9V0S2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzR9V0S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB39B1F000E9;
	Wed, 22 Jul 2026 15:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784733387;
	bh=nelWQwUFUGudlxlX4vqnxo5+21WcsgVO25XRh70gr9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kzR9V0S2skaNcJ0wme0//B2db1ZEZY+EmXz/jZoxhMWipGJFYWMhIgMS4qFmTQDNz
	 ejswwwIc7RQe0vUtOC6Q4XOQPnXsSueYw0R1uOwOdWBKOD4B9A6+F6URTZalAqTmF/
	 K6Sss3geXGXjvsKITy8qsMmQkzvqgzl1mjrzI6dyDERJn/X37YKK6lVFlhfARpztSo
	 RfZU4modWrzXCxbG2fAIetppWhj+2EZtlALAiiEEshKrwq6kJ0uGvFAWfJzZBRVOd/
	 Dpaoy4adnWuW4cO03GwuNJOPjmXTyv2SvVlsel5Ac+VOKcSoPDqyO+oMwk1vA7aERX
	 sjzQtEeFtdugQ==
Date: Wed, 22 Jul 2026 15:16:25 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Carlos =?iso-8859-1?Q?L=F3pez?= <clopez@suse.de>,
	Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH 2/3] x86/sev: Remove obsolete virtual address check
Message-ID: <20260722151625.GB2794619@google.com>
References: <20260722025338.33354-1-ebiggers@kernel.org>
 <20260722025338.33354-3-ebiggers@kernel.org>
 <6ecb06b9-2543-4155-8ddf-4d58861a1cea@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ecb06b9-2543-4155-8ddf-4d58861a1cea@app.fastmail.com>

On Wed, Jul 22, 2026 at 12:01:43PM +0200, Ard Biesheuvel wrote:
> 
> 
> On Wed, 22 Jul 2026, at 04:53, Eric Biggers wrote:
> > Virtual addresses used with the AES-GCM library don't have to be in the
> > linear mapping.  Remove the virt_addr_valid() checks from
> > snp_send_guest_request(), which were a workaround left over from when
> > this code used crypto_aead, which required scatterlists.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  arch/x86/coco/sev/core.c | 9 ---------
> >  1 file changed, 9 deletions(-)
> >
> 
> Link: https://lore.kernel.org/all/20251010151036.42241-2-ardb+git@google.com/
> 

Thanks, I completely missed that.  Looks like the usual issue where
people were attached to workarounds even after the underlying problem
was fixed.  In the end, Alexey gave Reviewed-by and Tested-by on the
exact same diff, just it never got applied.  Alexey, would you mind if I
add those tags to this patch too?  Thanks!

- Eric
