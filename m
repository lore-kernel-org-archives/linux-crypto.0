Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384B38BE7
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 01:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745718065; cv=none; b=F0eiH8rreNkjL0ubSZ9QXACjM1Dr9mDcMsUk8UNJ7pn9xmUvZDE3+PHbrb4erH8PCS3crC7PiVZB1IywnAfRLk7khIsKHDGncKFKq45IlEwxzRMH6fED90tqQolyFUVBBZAayARuvIJuJyXmkuLqaMXXqX/RBKvrqKg3h1MBkGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745718065; c=relaxed/simple;
	bh=B/NtxoCpLKtw/AnjS1zqa5N0a1B8kE/k8561EEarol4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNGBLuzkB7dgVHOZXp/XDHB/hrrEaaBCKsBv6DkQLJamuxED18qtzZ/T+PZFRwt9tTMOlb0NK9568cxhryjs+SzR9N7DM+/mGT3gtPlx7yi9+QlSm2AnUy+OxINtQKR1HObrLUj44d3xzrcqAMCozU6p2LjcNuKz2A2KiZGSp48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFwGC3jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFwGC3jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842ECC4CEE2;
	Sun, 27 Apr 2025 01:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745718064;
	bh=B/NtxoCpLKtw/AnjS1zqa5N0a1B8kE/k8561EEarol4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UFwGC3jl3NMNHAIYo06nHOdHalb2VNtlJ6CzXl243f2NbMBQ2pLhzvZdmZqaDA30X
	 PXuibMfwqwZmCv9AV5+PSduQKYH230U3dDHkWOpC5g/Ubj08J+z0BpR9+iIt3QDdl2
	 76h3bRHzpp+XZEXfhAMT4Mlhxpk7W3YPC2C2WOs/7WQ5uxMD4//MXVvKNFXO72MQbm
	 SpFWfP6pu/mKhw5zfXbQIx1cYwUikVRZy0CrpjDtVTPVdOKEC4sOUPgJUS6xII1bH2
	 DuY51Dx3MivLMberJMpafg+SF7rkNK4x7lxB3W93AUDA8F/Iqi1hFuGWk3lDqpDeQ7
	 uExlfuAj5ebPw==
Date: Sat, 26 Apr 2025 18:41:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 02/15] crypto: lib/poly1305 - Add block-only interface
Message-ID: <20250427014108.GE68006@quark>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <7c55da6f6310d4830360b088a5cc947e1da9b38f.1745490652.git.herbert@gondor.apana.org.au>
 <20250424161431.GE2427@sol.localdomain>
 <aAt21pphcto2Cjxa@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAt21pphcto2Cjxa@gondor.apana.org.au>

On Fri, Apr 25, 2025 at 07:49:42PM +0800, Herbert Xu wrote:
> On Thu, Apr 24, 2025 at 09:14:31AM -0700, Eric Biggers wrote:
> > 
> > Use 'raw_key' instead of 'key' when referring to the 16-byte polynomial hash key
> > which is the first half of the full 32-byte Poly1305 one-time key.
> 
> OK I'll change that.
> 
> > > +	desc->buflen = BLOCK_HASH_UPDATE(&poly1305_block, &desc->state,
> > > +					 src, nbytes, POLY1305_BLOCK_SIZE,
> > > +					 desc->buf, desc->buflen);
> > >  }
> > >  EXPORT_SYMBOL_GPL(poly1305_update_generic);
> > 
> > Again, should just write this out without the weird macro, which is also being
> > used incorrectly here.
> 
> If you have a better way of abstracting out the partial block
> handling, please let me know.

It doesn't seem to be worth abstracting out further.  Especially with the slight
variations in different algorithms and APIs which are hard to handle correctly
in a shared macro.

> As to using it incorrectly, could you please be more specific?

You're assigning desc->buflen to itself.  Which presumably you missed since the
macro obfuscates what is going on.

- Eric
