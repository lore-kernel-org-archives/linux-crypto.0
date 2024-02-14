Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B33E1420BD
	for <linux-crypto@vger.kernel.org>; Wed, 14 Feb 2024 23:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953719; cv=none; b=ACiQdss4GyckchDuiqMmKM7mEyJd/2HwQBpvKH4ZRz5HnAkh2zi3qCbRsavqWgtRabQNvGQG4Gw5Kdn2BwT7ZUZN2DRTutvNJPkiXXhkNYL6PXuMSsvLTqiLSRhqxXdUXbus9Fvo6kx444eAcOl2y6ltRGCwIEvD0odwv3hXjv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953719; c=relaxed/simple;
	bh=lAxBWrdhb4LJ6Gw3eRCtWSu9qxq/Tlk/O6tFLzdiXmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qm5mNK5VnGyGIPWECCMdBVt444EOFL2HgRtwPgL/ueJXZAL+2vCVdN+aQKrtnZAI8MHU21tyZ3QsmLKF4uTbej/pbnkyjEp9hvI20HFOKVT8V5NRpunH2nblGgMPKsbakNijUsJlV7HSIzevWnL3jhC8xufhoVj0BIjXagmEhNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cv08SZH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cv08SZH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E31CC43390;
	Wed, 14 Feb 2024 23:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707953719;
	bh=lAxBWrdhb4LJ6Gw3eRCtWSu9qxq/Tlk/O6tFLzdiXmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cv08SZH+0LzNmqUTDqs4yUs+TEQFuEZUMQvtvaiscbb9IfskZEnT85sCF2b7YaLy3
	 PCnCXxlakKp9V+o7er57UOtBEh4Bjdl9JuykO13tmujiAo2DbdMX2OO1ZbCKrB8Ymg
	 JoisG4ScIycSSo8pPDqkT5G9GQO14VCAD7yz62WXYQbFp9Pi2M7h3si4JxQuDsj8c3
	 XGael73XY1IFqt0bF3AVZUfxfUUWGsMktF1kjMLQDTjKgBOJENTDqgJtrJ4UL0+hjU
	 130O0W3OOk0joLYFp+yzlVENR5sU8fwV/H/QQOmXBH08oCb9OBRDVB/erO/AbfgACa
	 hdcFpNsBS2pNA==
Date: Wed, 14 Feb 2024 15:35:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 00/15] crypto: Add twopass lskcipher for adiantum
Message-ID: <20240214233517.GD1638@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>

On Tue, Feb 13, 2024 at 05:04:25PM +0800, Herbert Xu wrote:
> [PATCH 00/15] crypto: Add twopass lskcipher for adiantum

Thanks.  Can you include an explanation of the high-level context and goals for
this work?  It's still not clear to me.  I'm guessing that the main goal is to
get rid of the vaddr => scatterlist => vaddr round trip for software
encryption/decryption, which hopefully will improve performance and make the API
easier to use?  And to do that, all software algorithms need to be converted to
"lskcipher"?  Will skcipher API users actually be able to convert to lskcipher,
or will they be blocked by people expecting to be able to use hardware crypto
accelerators?  Would you accept lskcipher being used alongside skcipher?
Previously you had said you don't want shash being used alongside ahash.

I'd prefer there was a clear plan before merging a bunch of patches that leave
everything in a half-finished state.

By the way, note that hctr2 requires two passes too, as it's an SPRP like
Adiantum.  Also note that SPRPs in general may require more than two passes,
though Adiantum and HCTR2 were designed to only need two (technically they have
three passes, but two are combinable).  It's fine to support only two passes if
that's what's needed now; I just thought I'd mention that there's no guarantee
that two passes will be enough forever.

> In addition to converting adiantum, the underlying chacha algorithm
> is also converted over to lskcipher.
> 
> The algorithms cts + xts have been converted too to ensure that the
> tailsize mechanism works properly for them.  While doing this the
> parameters for cts + xts have been modified so that blocksize is now
> 1.  This entails changing the paramters of all drivers that support
> cts and/or xts.

cts and xts have nothing to do with adiantum.  So this further indicates that
the scope of this work is broader than just "crypto: Add twopass lskcipher for
adiantum" as suggested by the title.

It would be good to have a sense for the direction of this work.  What will be
coming next?

- Eric
