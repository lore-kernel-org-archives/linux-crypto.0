Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB8E8C0E
	for <linux-crypto@vger.kernel.org>; Sat, 17 May 2025 01:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747444634; cv=none; b=iXRLBK+O/+sBtCwkSOVWrozZ/XbVv0RTL7hZIPdaLOTDN4vSVXgiTJ1yMuWdxQF/kD/5+RzI0Gt9MxjoVG6mRiTgGHKbltL9WGlcNi+HO2kGsPquAQ5t+MltFxryilofjCnK+GQ7kGY+4Fznh+kfB6YXQcf1BFzWL8XQGtcWq6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747444634; c=relaxed/simple;
	bh=kiinpC5kfQKcTeXASw0svNL4pcIQk+Lr4reZ1GLUNYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=do38GaAwxU8tZwDCUepvt4Z7ui2ZMxMHMTQOfFGuor36uJF3O+Jl4sGE4OaDuyG+pu2/cTAg+JvYDwj49Al2RZh7Zz4uIlhssNZzudJMILaArP4wx2aVd2N70THQRJkjb+gmbNaL36+1qs8USpG3H1kXDqSiyaBdYhZ29wbbm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuV2zdt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuV2zdt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CD9C4CEE4;
	Sat, 17 May 2025 01:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747444634;
	bh=kiinpC5kfQKcTeXASw0svNL4pcIQk+Lr4reZ1GLUNYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UuV2zdt9iD7QlmGNrsGk9b6qwjC6nE/Y6v8ajtpqel17XwbPD2gd2QbkRMzIgg0EC
	 Jt3q8RImc3kBdwepjWyXi/nmTgAS4qSUP1pKF/kC9bNWqaIzSgZu300sbw+b7+igRA
	 VU+FHdK2A8nGbExCQ5PtRllOPEZXs/kQurVPy9mKmef7/cVlbAA0OBzbyxbroaRJo+
	 HurVrEWAfrmDrWyK8jW1QQoo9h/XG5Nnz091+eTdJP52KSOz4TWzxF6HMUQXuMh0OS
	 TTVp/emxQ/8sphOzUylgCvl29sSYw6M48szK44MKKUQFzfFdJH4tY5p6BQX0rl1F3/
	 ChzozSNmkSlCQ==
Date: Fri, 16 May 2025 18:17:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 00/11] crypto: Add partial block API and hmac to ahash
Message-ID: <20250517011704.GA1220@sol>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
 <20250515193529.GJ1411@quark>
 <aCcD92EWd_8oxlEU@gondor.apana.org.au>
 <20250516164326.GB1241@sol>
 <aCfcDJX5XRUwnx-a@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCfcDJX5XRUwnx-a@gondor.apana.org.au>

On Sat, May 17, 2025 at 08:45:00AM +0800, Herbert Xu wrote:
> On Fri, May 16, 2025 at 09:43:26AM -0700, Eric Biggers wrote:
> >
> > So how come this hasn't been a problem until now?
> 
> It is the key to getting rid of the ban on memory allocation
> for ahash drivers.  Small memory allocations fail very rarely,
> yet we're banning the use of all drivers doing any memory allocations
> because they may fail.

Does anyone really care?  The fact that dm-crypt hasn't been able to use most of
the hardware drivers for years just further emphasizes that those drivers don't
really even matter.  I remember seeing one complaint and that was it.

> With a consistent export format, we could simply fallback to
> software when the rare OOM strikes, thus getting rid of the
> ban on memory allocations.

There's already a huge quality problem with the drivers.  The last thing they
need is to have special code that runs only when an OOM condition occurs, which
won't be tested.

Can they really not just use mempools?

I'll also note that the whole concept of fallback ciphers is kind of broken, as
was established earlier.  The correct thing to do would be to fall back to
lib/crypto/, not to call into the legacy crypto API recursively.

- Eric
