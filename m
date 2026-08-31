Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210FE466B00;
	Mon, 31 Aug 2026 17:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195950; cv=none; b=Iq/8PRLL4YXX5rv+C0hddz1XicqUHsrG5GT5rKn+Q67BKB1DKnpMp7CHPhwB2Hua3oMHT6rXgfXnseBAr8+KMPMKebhWu2RAOU+Z7XvdpS9DFgPvkK91w33LM6subvGAUZ3+c7qwo+Ovwu2JCMNVi+e6Pn3ulrffQZmW6inCbp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195950; c=relaxed/simple;
	bh=23TVYtXz9DUrq81waur/pDcgYSxDdtMk9pTtCKh2xxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNbIIPgnWn1hwwHjNd+9Ea5J3u2vcQLHWa2ygiL/uUFhxQzPc2swqfuLj9k5muL3Vizwmg4UqH2swGPzQXDu1Riiavbhj/iXgS3ehPVH31a9YeF/bKp1ggXV0eCGcf3PabgVhpwbFjDdd+541ZrrMbw74ZArVgQcNG3AHe02gIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UiqvVI9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UiqvVI9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94121F00A3D;
	Mon, 31 Aug 2026 17:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788195948;
	bh=mDeGMTuTeIOak7dNePW62WNQP+qahVHWgMeeCMlfYG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UiqvVI9L4Y9HRsjEoyJxzA0/xHTIW+bhkiRVhgaapn9Px8HKKFcbCBfASz1IjzoTC
	 dLRdZ4LnxDzuq0PMVIsBEQVql8yyX5Zg0fDd7fRYw3yguTVX5TpbY7rtzWnPprTr2z
	 FJ+Yh72UG9fTwOWqCdUAoWrGEcI3Q63U7p2SR7wSf3RaxMPicjA2QIFaWQbCJS2vic
	 v3qz/HgnPSpbwuiEzUSTO32DTIYSXpvoy9LEeuv8q+49DrV/pFGZIqzjd9tI+cA3Gu
	 8I5yVB3EDQy1/S4Tp4VYiEKem0fQJNhs3sfMaJekP8M6D5JPxHIidKPXwjsoTai50O
	 bX24m2Hv1+mKA==
Date: Mon, 31 Aug 2026 17:05:46 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mike Lothian <mike@fireburn.co.uk>
Cc: linux-crypto@vger.kernel.org, ojeda@kernel.org, boqun@kernel.org,
	gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org,
	a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu,
	dakr@kernel.org, daniel.almeida@collabora.com, tamird@kernel.org,
	acourbot@nvidia.com, work@onurozkan.dev, lyude@redhat.com,
	gregkh@linuxfoundation.org, lina+kernel@asahilina.net,
	mmaurer@google.com, ljs@kernel.org, joelagnelf@nvidia.com,
	bqe@google.com, linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 1/2] rust: crypto: add AES-128, AES-CMAC, SHA-256, and
 HMAC bindings
Message-ID: <20260831170546.GA239479@google.com>
References: <20260826163004.3365-1-mike@fireburn.co.uk>
 <20260826163004.3365-2-mike@fireburn.co.uk>
 <20260826220918.GB3382628@google.com>
 <CAHbf0-H-nZzg=kGkN-yrUdfUUrruyN0x2inQjhXxOy4RAauDOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbf0-H-nZzg=kGkN-yrUdfUUrruyN0x2inQjhXxOy4RAauDOg@mail.gmail.com>

On Mon, Aug 31, 2026 at 05:51:11PM +0100, Mike Lothian wrote:
> On Wed, 26 Aug 2026, Eric Biggers wrote:
> > There's an aes_ctr() function now.
> >
> > With that, is bare AES still needed?
> 
> Not for the CTR, no. It is not in the tree this was based on --
> drm-rust-next as of 2026-08-06, where lib/crypto has aes.c, aescfb.c and
> aesgcm.c and no CTR at all -- which is why I built it out of a prepared
> key schedule instead.
> 
> The driver's two CTR sites are plain SP 800-38A: a 64-bit nonce, four
> zero bytes, and a 32-bit big-endian block counter. aes_ctr() replaces
> both loops outright, and the key-schedule reuse that this patch was
> partly justifying stops mattering.
> 
> That leaves exactly one caller of the bare block cipher: the HDCP 2.2
> dKey derivation, which is a single AES-128 ECB block encrypt. So the
> question I would put back to you is whether lib/crypto is willing to
> expose a one-shot single-block encrypt for that, or whether you would
> rather that one caller kept using aes_prepareenckey() and aes_encrypt()
> directly. Either way I will cut the rest of the AES from this patch.
> 
> Mike

I'm not currently planning to make the crypto library expose AES
functions that take raw keys, since computing the AES round keys is
fairly slow and most users use their AES keys multiple times.  So in
this case I guess keep planning to use the sequence that is already
supported: aes_prepareenckey() + aes_encrypt() + memzero_explicit().
For CTR mode, use aes_prepareenckey() + aes_ctr() + memzero_explicit().

But if you're using either key multiple times you should call
aes_prepareenckey() just once and cache the result, as that is what it
is for.

- Eric
