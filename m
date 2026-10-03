Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E1965192;
	Sat,  3 Oct 2026 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045063; cv=none; b=jMaOM6sWyqodnh/K6OqkH4VE+8vvKD/kfenktubBPgwOpFuaLLlEbaaK2vVMh8dXam3WNPV2dMZhpPsZnlhwccChHRjeSyc8Z0EBqCFzqsT2a4GXswBF19dXelFJdXcEx1TegpVwPBIUSm40UrLfXoj7L1MsfGd3FWEkYzQe9Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045063; c=relaxed/simple;
	bh=YPmEGG5Sd41sh89NUd8OuU1stTU5iv9Xe/NShG87Jyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BRyMKJ94+1RA4SawtLIG3d1XgFBN/MgSJ+59LpKUNNr5cHpfghbaugwX/n1OxjimbPQiW3+P9ZglrasV61NONcOr/CZcnN5+itNwvVRKShubhmwsV2phNy8gQi3o6Qm+Erbk+WUgE5CWyyNphL6OxjsAFYEoDJZHNJLIYkkNeG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWsIA3tn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWsIA3tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE701F0089B;
	Sat,  3 Oct 2026 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045062;
	bh=u83Npcs12V9xe5DFKbQG28qTCorDUyuwsdlQcZhBX4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aWsIA3tnJ17x2NoLrot1atVKD0A3DktUxR8sptxqFjmK97um2Nor8qfSRkGzTHQHc
	 m+M3aMqi1jZVUHIeMRCmkLk8LoJUAnH3Lw+JOLPIekoRqQMAiWw12S2bQcmS5cTz3b
	 TF0W1xcYdsWtyvHPQeXhf73Iogexwv0ZM1eQbuyLz8bidnP9BNspfE0TiliLBWmKjf
	 5qjsJpd9ZnuhDVYP8QFhYs+OhIaMBDEpjLEG+S+8r2H22S1jr5cKgbDAwE6Y1KoOhP
	 n7PlL7wQszhxMKjxG+VZUDx3mAY3Oi2b8NcfT+oMz5PFCg7XLGVYk+KV4Ewt/LPzIy
	 g1YLJtf0Il3NQ==
Date: Sat, 3 Oct 2026 18:30:56 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: Move SipHash into lib/crypto/
Message-ID: <20261003163056.GB152469@quark>
References: <20261002223708.39183-1-ebiggers@kernel.org>
 <asB7QVFMlgKgbje2@zx2c4.com>
 <019c709e-9513-44c1-bbb0-82cb16040709@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <019c709e-9513-44c1-bbb0-82cb16040709@app.fastmail.com>

On Sat, Oct 03, 2026 at 09:31:39AM +0200, Ard Biesheuvel wrote:
> 
> On Sat, 3 Oct 2026, at 05:49, Jason A. Donenfeld wrote:
> > On Fri, Oct 02, 2026 at 03:37:08PM -0700, Eric Biggers wrote:
> >> The addition of SipHash to lib/ predated the existence of the
> >> lib/crypto/ directory.  Since it's a cryptographic algorithm, move it
> >> from the top-level lib/ directory to lib/crypto/.
> >> 
> >> Specifically:
> >> 
> >> - Move both siphash.c and siphash_kunit.c.  Keep the header
> >>   <linux/siphash.h> as-is for now.
> >> 
> >> - Keep the dedicated MAINTAINERS entry for SipHash.  Just update the
> >>   file paths it references.
> >
> > Given that I'm also listed in the crypto section, I think we may as well
> > delete the whole separate entry.
> >
> > The only downside of this change is that those hsiphash functions are,
> > erm, a bit less than cryptographic-strength. But maybe such concerns
> > don't really matter any more at this stage, and we might as well group
> > it all in lib/crypto/ where it all belonged originally anyway.
> >
> > Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >
> 
> Either works for me.
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Makes sense.  v2 removes the separate MAINTAINERS entry.

- Eric
