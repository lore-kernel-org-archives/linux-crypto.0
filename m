Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D12B372688;
	Thu, 12 Mar 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773288288; cv=none; b=pIFiazbcHvHfLPsT7KWL7ysEjmragXuEie7Fi1RTsQCtrErEIXHp86x1t0s9P9tYDNFizrQmZ8rDXm+LecQfWnW47638jmKF/mj9JVtsWgUqm2XmMPwa5mK4envef9ol596CrNWL7pkVvdZ/TVoYGak3fItenirtjOlll8uC8WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773288288; c=relaxed/simple;
	bh=EulB49Da/eLcg7YntZkGmDinTs7N0Nveg8iyBicF1Lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LB9rI0q2eGAlSayyxXICi22iAXXtADBqNINPZcaA31UBEn0V2rbexTCyEzxtKkDFEDmEcpe5Q94lUwwOeblkMxsSLuC0ZSRCHYirURTgCKNbUhFwUI74DyIIS9VRaO0ZFAGi3uh7GfxNuenq1s3CQJuILvjP8L9bgjwN6gBH+aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXuzmb2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXuzmb2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88890C4CEF7;
	Thu, 12 Mar 2026 04:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773288288;
	bh=EulB49Da/eLcg7YntZkGmDinTs7N0Nveg8iyBicF1Lw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JXuzmb2x51lMynnhCYjjTfavlcdg/uy9H3JTcQLiH/b2NZjb81VTwUfTXeqvdbEBU
	 hCODPfSOjgHpK+3hgTBsOXAGVHWeNnTxtaKbGwTT+DfFx4EtYVNgLcpbjpfPlbqIwX
	 x60hwNQuofg0+Eoel3pboDAjRS0odMYNE+9j/o83MeCQRHqu/RiSwMmxXlCEdQUjY5
	 HhxIgaXeh/11UsKBln57hdzFRHIWeN9ClA+0/hC9HHRuxkKOVtTv/nSVdxdf2vA2tf
	 bCvnCcBvtmeNnCubdqe0HLpQlngY3Ee7fyA43Bvtpm2dzr7AZx/ZwMbFIjn6mD1AoB
	 0nBI7+I7LYQ2A==
Date: Wed, 11 Mar 2026 21:03:49 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com,
	ardb@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, LeoLiu@zhaoxin.com, HansHu@zhaoxin.com
Subject: Re: [PATCH v3 2/3] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
Message-ID: <20260312040349.GA2359@sol>
References: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
 <20260116071513.12134-3-AlanSong-oc@zhaoxin.com>
 <20260118003120.GF74518@quark>
 <220d9651-3edc-4dc1-9086-e3482d2d5da3@zhaoxin.com>
 <20260305191848.GE2796@quark>
 <5fe5b47d-5065-4e74-b2b3-4685e74a1130@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fe5b47d-5065-4e74-b2b3-4685e74a1130@zhaoxin.com>

On Wed, Mar 11, 2026 at 07:37:39PM +0800, AlanSong-oc wrote:
> > I also have to ask: are you sure you need SHA-1 to be optimized at all?
> > SHA-1 has been deprecated for a long time.  Most users have moved to
> > SHA-256 and other stronger algorithms, and those that haven't need to
> > move very soon.  There's little value in adding new optimized code for
> > SHA-1.
> > 
> > How about simplifying your patch to just SHA-256?  Then we can focus on
> > the one that's actually important and not on the deprecated SHA-1.
> 
> It is true that SHA-1 is rarely used by most users today. However, it
> may still be needed in certain scenarios. For those cases, we would like
> to add support for the XHSA1 instruction to accelerate SHA-1.
> 
> Does the crypto community have any plans to remove SHA-1 support in
> recent kernel versions?

It's already possible to build a kernel without SHA-1 support.  SHA-1
has been cryptographically broken and is considered obsolete.
Performance-critical hashing in the kernel already tends to use SHA-256.

These patches already feel marginal, as they are being pushed without
QEMU support, so the community will be unable to test them.  The only
reason I would consider accepting them without QEMU support is because
there was already code in drivers/crypto/ that used these instructions.

It also helps that they are just single instructions.  Though, even with
that I still found a bug in the proposed code as well as errors in the
CPU documentation, as mentioned.  And the drivers/crypto/ implementation
that uses these instructions is broken too, as you're aware of.

Overall, it's clear that platform-specific routines like this are very
risky to maintain without adequate testing.  Yet, correctness is the
first priority in cryptographic code.

So I would suggest that to reduce the risk, we focus on just one
algorithm, SHA-256.  Note that this makes your job easier, as well.

- Eric
