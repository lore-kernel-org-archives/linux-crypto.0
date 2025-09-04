Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5DB267733;
	Thu,  4 Sep 2025 21:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757021349; cv=none; b=kn5nzqIDClgKWVZ98LFXOlyFOtoVhQdBJY443j8TC8R9SatM27LDg7RUMnsaVSxNw12btGDVI99BlvZlkdHdLcv25qPYFyeL6mmdz9ZHZ4acUZuiqiVf/QfEm0aRIDPhksfth30rmCdacJFmg49ANEMEW8qz5BThJ5tN5qCURos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757021349; c=relaxed/simple;
	bh=zwVfQ4e81a5GF5MGdxzFSQ2T8B3QG9QkppcjSBMFUyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbVixb+8ygUe+VeGg1bz42+cVMSaYrCZg787I0Bv5bCfkbtyi89JEhUHikz/5xhkqjomzIz2W5dSSHiGbOvLGoULN1H0rYjFtmLjX1lu582wTPFHXi+sTvSrHCx3M7HRvrvpVss2Sibac6uT/RqY4Jc4P6jFyXgifwLkE7N5Hi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJERxhXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJERxhXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5445FC4CEF0;
	Thu,  4 Sep 2025 21:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757021349;
	bh=zwVfQ4e81a5GF5MGdxzFSQ2T8B3QG9QkppcjSBMFUyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PJERxhXly4qaHcjfD1/Obudxp+z+HinquC/iASlJ4merE8MGIjrxG5owab6FWc6T+
	 lWALHgFxGaIWkwnETgJdN+AC/wEGQyDnF966VBKwwzVCO6Pu5Yu6K/LN7jW8R17ODb
	 OvNXETatNefGXKrtJJ0QDo43u6Fh6wK9QTsNORa7FunMCd+oaPmRvW31KH8OzNzs4t
	 M8OgLmpsGLEy5Wrd6wOBSyZS9twQ5FT98YSRPFGvwgHPo2ZcEGrYmZ+G+kJlGYjAro
	 KvbhdzBX48nKoAOn+DUWmXY++Ks8a5AFIcMnn5skgBBSzyH4kWfEsPH9SNHy3ENtZf
	 mkudZxuuy+sDg==
Date: Thu, 4 Sep 2025 21:29:06 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
	Vladis Dronov <vdronov@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-modules@vger.kernel.org
Subject: Re: [PATCH RFC 026/104] crypto: fips140: convert lib/crypto/sha256.c
 to using crypto API wrappers
Message-ID: <20250904212906.GD854551@google.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
 <20250904155216.460962-27-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904155216.460962-27-vegard.nossum@oracle.com>

On Thu, Sep 04, 2025 at 05:50:58PM +0200, Vegard Nossum wrote:
>  /**
>   * sha256() - Compute SHA-256 message digest in one shot
> @@ -373,7 +392,9 @@ void sha256_final(struct sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
>   *
>   * Context: Any context.
>   */
> -void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]);
> +DECLARE_CRYPTO_API(sha256, void,
> +	(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]),
> +	(data, len, out));

This makes all these function declarations awfully hard to read...  If
fips140.ko is really going to be supported at all, perhaps it would make
more sense for the override to happen in the function implementations?
E.g. the first line of the sha256() function implementation would be
FIPS_CALL(sha256, data, len, out) or similar, and that would either do
nothing, or call the sha256() from fips140.ko and return.

I think that would be *slightly* less invasive.  Though of course it
doesn't get around the problem that the fips140.ko override support
still has to be handled individually for every function...

- Eric
