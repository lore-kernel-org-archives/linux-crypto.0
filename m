Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB2719E819
	for <linux-crypto@vger.kernel.org>; Tue,  2 Dec 2025 01:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764640673; cv=none; b=Es7aLfRr8BtfwgzQsNBJIlSxJm01H1KOmhLhOTn8eI5s41e4ja4F8Y1OmnBOvLaj9Eu0yLMsybVHfetMyI94II+p6ICFDXusbcbXkqikL6/xWwxKEZVXio1e/GXThHKjvMELWV3Wcj567APpCSFnDEoSARV8U99AZvxAaq7oTjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764640673; c=relaxed/simple;
	bh=6E2Q7HjyW0VjpOxkdX4VlLYeyybx7gIWsxkWMew/DlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZpgY5PxpQa3tN86isw49z7aCisTnjo43HSTlDGDpP/iojn/L7zheFc7gYU9bk0edW+GNptg7NiPR1e2V931D3BRzDLwsBCkSoZbaiVHD8w7BpKkjY5wdllnFJWuxM32qkB5UtFaRfIZm4ubvQpG8+B4s2upaUbRH544Q+SLmi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0KHFySb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0KHFySb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B5CC4CEF1;
	Tue,  2 Dec 2025 01:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764640672;
	bh=6E2Q7HjyW0VjpOxkdX4VlLYeyybx7gIWsxkWMew/DlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B0KHFySbJRfWZWhN4xHvYb/mvXLYQwR0+oQKTQSGkuYKyKqbAL0RgAcajX1DJL6CQ
	 PDgmrV3Mu6CxrfQDdtczc8FoSAWXb+WfAP11NdzbDLxjk/2Ydsa3DVfazFbAsgHbtR
	 fBRuoA+PkJFk4T17z7uaR+cDIZNKgkAgWO5N/75wRgSMX5bcNPk+q/BynTLy9zwG91
	 aV8z6fMaVC8E/F52NCsR46ukNOqG3h3BZsuaBnqurtH1j5b5Wwi9JUT71mjEhnniZ/
	 xGjMqY86LHq7J46T/yTnPh+QyVd9Xp7fS2G4Ft62DQcS+mwc8raavm4P745dN2JJxu
	 ftBQtRBwqMR5A==
Date: Tue, 2 Dec 2025 01:57:50 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de,
	kees@kernel.org, linux-crypto@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <20251202015750.GA1638706@google.com>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>

On Tue, Dec 02, 2025 at 02:12:47AM +0100, Alejandro Colomar wrote:
> Be careful about [static n].  It has implications that you're probably
> not aware of.  Also, it doesn't have some implications you might expect
> from it.
> 
> -  [static n] on an argument implies __attribute__((nonnull())) on that
>    argument; it means that the argument can't be null.  You may want to
>    make sure you're using -fno-delete-null-pointer-checks if you use
>    [static n].

The kernel uses -fno-delete-null-pointer-checks.

As for the caller side, isn't it the expected behavior?  NULL isn't
at_least n, unless n == 0 (see below).

> -  [static n] implies that n>0.  You should make sure that n>0, or UB
>    would be triggered.

There isn't any reason to use it on an array parameter with size 0,
though.  Unless someone uses it on a VLA where the size is a previous
function parameter, but that's not what this is wanted for.

> -  [n] means two promises traditionally:
>    -  The caller will provide at least n elements.
>    -  The callee will use no more than n elements.
>    However, [static n] only carries the first promise.  According to
>    ISO C, the callee may access elements beyond that.
>    GCC, as a quality implementation, enforces the second promise too,
>    but this is not portable; you should make sure that all supported
>    compilers enforces that as an extension.

While it would be helpful to get a warning in the second case too, the
first case is already helpful (and more important anyway).

> -  Plus, it's just brain-damaged noise.
> 
> I recommend that you talk with GCC to fix the issues with
> -Wstringop-overflow that don't allow you to use [n] safely.  That would
> be useful anyway.

It seems the ship already sailed decades ago, though: [n] has always
been "advisory" in C.  [static n] is needed to make it be enforced, and
surely it was done that way for backwards compatibility.

Perhaps people would like to volunteer to get gcc and clang to provide
an option to provide nonstandard behavior where [n] is enforced, and
then push to get the C standard revised to specify that behavior.  It
sounds great to me, but that would of course be a very long project.

In the mean time, we don't need to delay using the tool we have now.

> On the other hand, to resolve the issue at hand, how about an
> alternative approach?
> 
> void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>                                const u8 *ad, const size_t ad_len,
>                                const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
>                                const u8 key[CHACHA20POLY1305_KEY_SIZE]);
> 
> #define xchacha20poly1305_encrypt_arr(dst, src, slen, ad, ad_len, nonce, k)\
> ({                                                                    \
> 	static_assert(ARRAY_SIZE(nonce) == XCHACHA20POLY1305_NONCE_SIZE);\
> 	static_assert(ARRAY_SIZE(key) == CHACHA20POLY1305_KEY_SIZE);  \
> 	xchacha20poly1305_encrypt(dst, src, slen, ad, ad_len, nonce, k);\
> })

No.  That would be more code, would double the API size, and make it the
caller's responsibility to decide which one to call.  And often there
won't be a correct option, as the caller may have arrays that are larger
than the required size, or a mix of arrays and pointers, etc.

- Eric
