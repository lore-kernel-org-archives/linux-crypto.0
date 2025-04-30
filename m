Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB68BE5E
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 03:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745982985; cv=none; b=Ithxi4pMsNN9ZVRHo3ytySG/QiKVrr4k0Kgpj4Ai0l+XZXQctS4H1b/zbu8jY3WUDgoaaXebLr25vCcZFhXSCO/5EjnZNwGZkFyexiykyNrw3xlashKZ0tJEH2eQ4pFTeW6gyDsEEaBaLwlIZnBJBaMKBNKTH7v4KYeMiEN5sl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745982985; c=relaxed/simple;
	bh=6GVZZTarw8ZK8b4yJhzpQN+Hpu7IfIkI2d53RgNW/X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYrnjHGI3v1kvAb1+SilAyP9jUdLAOQFJkIVjhXBt3dPGv4VET/nmTBn7kBwgvWUPPweVtnBBqjiD/rVLUkLyr7xskYv8XbioPV9TtIFGeoXQxRQlUIzLC3thXie7uwHe+7kX6G8IErjMHBSSkIt9+4XyJvhvXNKUYj6wnqWgGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QBno4nOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QBno4nOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A8DC4CEE9;
	Wed, 30 Apr 2025 03:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745982985;
	bh=6GVZZTarw8ZK8b4yJhzpQN+Hpu7IfIkI2d53RgNW/X8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QBno4nOBKNgc9U1aMu5G1KnF5WExJLs9Ne3mWrJ6zMOJ6Yp0ApIzUXLkVNQqrB9iv
	 ym0tneuhD8NgtS0X/3+O33LG47fFQTO9im5N3Hz07E0PPLGVk9mit+cjESXD4EtlUg
	 +s5lAacUoRRuNuYCpHLfAwxx1qFni9nXnO391LI+/9VU52A+l/gvCgFpvPlOfLFopI
	 qwYYanYPG0a6hSCHh9RZsfU93wqY2ve/QtAjS9hMpmRV0vayUqU1XAx9wNj98W5TG6
	 n+YM0oUGPGKLPi7aM/1V5AsuiveNUaLu4P6eKMoanKO1tFSVUePbrxYfW5vJWs3XtW
	 Nn9iyX+VV5IqQ==
Date: Tue, 29 Apr 2025 20:16:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] Revert "crypto: run initcalls for generic
 implementations earlier"
Message-ID: <20250430031623.GA277467@sol.localdomain>
References: <aBBoqm4u6ufapUXK@gondor.apana.org.au>
 <20250429164100.GA1743@sol.localdomain>
 <aBGJR55J3hkFZvfJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBGJR55J3hkFZvfJ@gondor.apana.org.au>

On Wed, Apr 30, 2025 at 10:21:59AM +0800, Herbert Xu wrote:
> On Tue, Apr 29, 2025 at 09:41:00AM -0700, Eric Biggers wrote:
> >
> > arch/*/lib/ should be kept at arch_initcall.  It makes sense (it's arch/ code);
> > it's library code with no dependencies on any other initcalls; and it can be
> 
> There aren't any direct dependencies but if you end up executing
> the code protected by those static branches things may well break.
> 
> For example, fpu_state_size_dynamic() is only initialised at
> arch_initcall.  So if you enable these lib/crypto static branches,
> *and* someone actually calls them early enough during arch_initcall,
> they may end up hitting the FPU code before it's been properly
> initialised.
> 
> I think it's prudent to delay the initialisation of these static
> keys until later in the boot process, unless there is a demonstrated
> need for accessing them early.
> 
> > use arch_initcall.  (And FWIW I'll keep doing that arch/*/lib/crc*.c, even if
> > you decide to mess up arch/*/lib/crypto/.)
> 
> I'm not going to touch the crc stuff.

If arch is really too early for arch/*/lib/, then subsys should be used instead.
The point is that putting different algorithms at different levels would be
confusing.

- Eric
