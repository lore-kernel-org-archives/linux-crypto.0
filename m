Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897B43DB620;
	Wed,  5 Aug 2026 20:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785961331; cv=none; b=fpQ476EW77dvbnIxldfm0P/xMKmX2J8xamOiBs8wfIxjfX80F+s+s/VpSDs8V7e1IgQzb5frIks6PHtlyMl/fNHwWttUP9K1BFQ3Ep42GFKPedh9mhTVj6+WvSSBgj0PrMT3JKcYwOWf6AF6hwXQvTF2YWKXvfXCe0dddPogc/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785961331; c=relaxed/simple;
	bh=oUQYo5hYQv7YdMUhgOqDOY2gf813n5dHN2cXzzTfEHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nmv7Wvl45qhiSWDzzzOaE7sMQwX1+9KoI39EAw9X9kNyHmVDKQweoKSa7ogntftaGzZw5KD0Z9OlkoGY7AumL+ZKrdXKJesVkpLyE/Fw4y33S0kkOezRGdhIrJfijinRmHKQN/E/drr4YmIqpXtU5FxUhoXhIjwsHyMkgW+zM3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jykiCnNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jykiCnNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC281F000E9;
	Wed,  5 Aug 2026 20:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785961328;
	bh=EcNr4xBBeUBAGcEts0blrYQDixSKZc0gpM06fDP+83I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jykiCnNI075J+sqTd4/zSaPaNrOI2Lblp6F5eMfUbs+i30ol5JSGPI+Dt+Onv0Ef6
	 4gzi6dLVEB1IPk7ZKUnAe6nesr3Ttuk/WxYPVX1D4BFM0N8hddTLxO2gEx5P7b4gHN
	 JIED0iO7ARk/O9y0697BQDMC9o6Q4EJ7QYC436wCVbWUO3KKZapgKHrAy+tgNpNj0Z
	 H3WM/91hBBTH5l6cLv/skSi/L/r0FwYIz+EqIrv9nx4QrzXCZaCsOMeMoYPR5le2eI
	 941MIiJs0GitZlKqhY37xLca4cw1fY0Ednx62Dm67/wWbNluxKdkSDnRYkxvoEwhbs
	 aL8hsQrcWfMpQ==
Date: Wed, 5 Aug 2026 13:22:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 00/10] crypto: Provide a function for zeroizing
 crypto_aes_ctx
Message-ID: <20260805202206.GE3438@quark>
References: <20260805115749.392672-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805115749.392672-1-thuth@redhat.com>

On Wed, Aug 05, 2026 at 01:57:38PM +0200, Thomas Huth wrote:
> Several crypto drivers need to zeroize their local crypto_aes_ctx
> structures after use to avoid leaking key material on the stack.
> Currently some call sites do this with their own memzero_explicit()
> call, which is error-prone since it is easy to miss a return path
> (what already happened in a driver). Some other call sites miss
> to clear crypto_aes_ctx completely.
> 
> To improve this situation, the first patch introduces an aes_zeroize_ctx()
> helper that can be used with __cleanup() to automatically zeroize the
> context when it goes out of scope. The following 6 patches add this
> __cleanup() to spots in the code where this has been forgotten so far.
> The final patches change some files to do the zeroization with
> the new __cleanup() way instead of calling memzero_explicit() manually.
> 
> v3:
> - Renamed aes_clear_ctx() to aes_zeroize_ctx()
> - Split up the safeexcel patch to rework safexcel_aead_setkey in a
>   separate patch
> - Removed goto in the padlock patch
> 
> v2:
> - Rebased onto cryptodev master branch, updated the "qat" patch accordingly

I'll assume that Herbert will take this series via cryptodev/master,
since it mostly deals with drivers/crypto/.  And the new library APIs
don't use 'struct crypto_aes_ctx'.  It's just going to stay around for a
while to serve drivers that call aes_expandkey().

I'll take the AES-CMAC one.

- Eric
