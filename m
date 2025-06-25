Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14D619E97A;
	Wed, 25 Jun 2025 03:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750822394; cv=none; b=jr3UiSKp3WNwdfDfnTKKcxm9MGUVTgXiRpjFSg9p+BAU86lk6cNF5cKMTvQrdLl7IVYLkBti9k0qArjPZJ5Bi9dEDHVD3Qu233/r/6y/shlgKrKmpyvtFFwiO3yQ2CiZjeHPTdbs/ssehfzNqhH39oW5q1g3qmsxQ1KCCdyBN4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750822394; c=relaxed/simple;
	bh=S+zg+bDlCpe9lZBLnDQTYS3NMqzgftreSFsZWS6275U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCjhiNdctDtiuNVFFJQlRTpCgXA2GycDvOV49Os/VBzqLzVoDcKAb9HFdKdhJaIE6PNb1SgLX3IIjuBktZO9DQmwgz1lz/ifuxFBvzP0F1GKywUAdGXQjVCM95FzobX9YusYtwb5u+NIBNzwJuwRZH8J/MQeIaJWlhid/B/cQhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rA6JgHpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rA6JgHpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367C2C4CEE3;
	Wed, 25 Jun 2025 03:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750822393;
	bh=S+zg+bDlCpe9lZBLnDQTYS3NMqzgftreSFsZWS6275U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rA6JgHpWauA80ED/D0iBM35ETh5YQCVIJAVCd4ZmH05hGpM/zJPRyn0QezCvWOkLv
	 tGegv6/Z5RsrdrRX1xzibmSQP4sgiAuiUrxgl5eY/uyNFcvjS3QC5Kpn9hkx9ulIV3
	 kYadut0+Nl9zkVXi9yd4vqaJdc3W7IA89t6BQZmNsZcg7jPSzeLzD+17uXp4pOAvBu
	 MYeswK3aPHcyoC3Aey+bahq5GhzEjEVAPZnz7d6RMswdDDRgoUvbRm15SshgXCJris
	 J/UdA9JQE3vXUU6Ua9HU0Tak4dIRIjFEhMzK+KDUeIhSxyONGYhzohzlghw2Lztcjy
	 Oxxf2EjIixOiw==
Date: Tue, 24 Jun 2025 20:32:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <20250625033238.GB8962@sol>
References: <aFtidDP6MLX1V2A6@gondor.apana.org.au>
 <20250625030404.GA8962@sol>
 <aFtpj5y4HtzVDChg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFtpj5y4HtzVDChg@gondor.apana.org.au>

On Wed, Jun 25, 2025 at 11:14:23AM +0800, Herbert Xu wrote:
> On Tue, Jun 24, 2025 at 08:04:04PM -0700, Eric Biggers wrote:
> >
> > Wouldn't it make more sense to revert the "Crypto API partial block handling"
> > stuff?  It's been causing a huge number of problems, and it's been getting
> > superseded by the librarification changes anyway.
> 
> The partial block handling simplifies the implementation of both
> software and hardware hash algorithms.  Just look at the diffstat.

Not software, since the library functions have to handle partial blocks anyway.
There will be a negative diffstat for algorithms that haven't been converted to
have a library API yet, but it will go away once they are.

> > Indeed, I just found that a lot of drivers in drivers/crypto/ haven't been
> > updated to be aware of the extra byte that comes back from
> > crypto_shash_export().  So there are a bunch of buffer overflows there too.
> > (Not like drivers/crypto/ actually matters, but apparently your changes are for
> > its benefit?  So it's interesting that it was actually broken by them.)
> 
> If anything this proves that enforcing a consistent hash format
> is the right thing to do.  All those buggy code paths were assuming
> that the export format is fixed which was not the case prior to the
> partial blocks work.
> 
> But thanks for pointing me to these buggy drivers and I will send
> out fixes for them.

Well, they (reasonably enough) assume the format that all the CPU-based code
previously used.  So they weren't really broken until your changes.

Of course, the lack of type safety here is an artificial problem created by the
generic crypto API which uses a 'void *' state.  The library functions simply
use the C type system, so they just work and do not have this sort of silly
issue where different places disagree about what struct a 'void *' points to...

These legacy drivers should just use the library functions.

- Eric
