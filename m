Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169F521E091;
	Sun, 29 Mar 2026 22:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774824654; cv=none; b=P6pWbsj/27NWMlRBta+XednlnGkSUQQ2DM6JDyFS9UaC+EZ2LsFDawTS4HMeY+6xqMNUJQet79dDx77/EG1vp+Qtfnr6FfP9AhObQuVtgvs1WPJXTKVYBRj47TPaZk839pnxfTOrV37P7WzqA5tgUwlE0kw96ivnin8wAnmsi4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774824654; c=relaxed/simple;
	bh=8LiQypyuQD4fJJRYqGpzrs3WMEZdJ2aKFKRiogiJJtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4wW02A5mVH+mQgwuWsxEXEZmnpSjJDHr3zpJZjWCWEDfRa6BmEBEgJD/3zPB9KDKhwa6jGDObCrIUqoCBWiPL/bjRNJlcFZ4cR2QCtI9hjPcFolNYKWOCv0jKutliX84ayF0dVpixi5F5K9WcV7Mq1YIVsDD8UCKU0DydBTqqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sHnIaAvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sHnIaAvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E7BC116C6;
	Sun, 29 Mar 2026 22:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774824653;
	bh=8LiQypyuQD4fJJRYqGpzrs3WMEZdJ2aKFKRiogiJJtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sHnIaAvTGiSmCm1RovoUapTsV76TgLjmHoIUpvhU4pjCtKwVk8U1A+fnG5rVruvEW
	 3lyL3PaOAJGBWcXD25m+mFHFtfxl7OE+eLZQCouepAZIQJjfLk4bnDWVzuPzU5cLBE
	 v3Z/3WNad1EkN/eXrnr7rVFFu2XUvm2/MlC7Q13j/kZNQhkLyJrr4A92saU+D+z8bs
	 xFaNxCLgiBTU65TmD0eknvC5zzsHLhjOrYDfGAXXxLy0kohxupNsNhDz3S3e9Ravmq
	 1DjvdwxCa5r6VOiOvgiDNkUV7tiqxoc81SFR+Q3+687vP/aMqW9aufYXBV6tz/OQyj
	 cCvsKsUnNuy4w==
Date: Sun, 29 Mar 2026 15:50:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] crypto: rng - Add crypto_stdrng_get_bytes()
Message-ID: <20260329225051.GA140406@quark>
References: <20260326001507.66500-1-ebiggers@kernel.org>
 <20260326001507.66500-2-ebiggers@kernel.org>
 <CAHmME9qWks00NyM8-kLKCcZNM6LAme5VZJkgrpg3ZVjbZFtH4Q@mail.gmail.com>
 <20260326023105.GA2304@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326023105.GA2304@sol>

On Wed, Mar 25, 2026 at 07:31:05PM -0700, Eric Biggers wrote:
> On Thu, Mar 26, 2026 at 02:38:47AM +0100, Jason A. Donenfeld wrote:
> > I'm a little worried about this because I don't want to see a
> > proliferation of crypto_stdrng_get_bytes() users. How can we be sure
> > that this is mostly never used?
> > 
> > 
> > Jason
> 
> Perhaps a slightly different comment?  By the end of the series it is:
> 
> /**
>  * crypto_stdrng_get_bytes() - get cryptographically secure random bytes
>  * @buf: output buffer holding the random numbers
>  * @len: length of the output buffer
>  *
>  * This function fills the caller-allocated buffer with random numbers using the
>  * normal Linux RNG if fips_enabled=0, or the highest-priority "stdrng"
>  * algorithm in the crypto_rng subsystem if fips_enabled=1.
>  *
>  * Context: May sleep
>  * Return: 0 function was successful; < 0 if an error occurred
>  */
> 
> We could add something like:
> 
>     Don't call this unless you are sure you need it.  In most cases you
>     should just call get_random_bytes_wait() directly.

Let me know if that addresses your concern, or if you're looking for
something else.

- Eric
