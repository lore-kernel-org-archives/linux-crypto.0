Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B4139A070;
	Sat,  3 Oct 2026 08:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791017887; cv=none; b=N1YWCb3K7U9CQzTqno21+Zgo+z5JFqVydyGD8yukUDl2QOd2tqvfAF+gCmTEOk0ICKfd9o8wYOWs4FmWSiZmm6YIjhPlgWK4wfLlYQlLeBuCcL39dwZrZsU4YaTMU/coFgGDGxJ40sEiwiGA9zLe3+Sqi4SVgxmykrw2dDuI3c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791017887; c=relaxed/simple;
	bh=vWbObrTVDISaqcFkvZOPgRkUAZjL6CUFRGrRvrqiHwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2s0wfEAdsK8Qz06EnhaBIva4nHRMHQlYNrij+Krfc/MQDuW1vcAa1ao7zuEcCPGAtoRteviS/q0OOBs4AKysysTuIvuPuiys1N0CbHSQTF+kMQ6427IBKedwqsKifcjrlr6VwkGfqjZ1gT49mvBn5JH4IQtM/EyzHJI0Q83T10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXIKNr0H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXIKNr0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305351F0089B;
	Sat,  3 Oct 2026 08:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791017886;
	bh=v0JKctx69+xZiW7IO4m163g3d43PNgPfYEAwC2Gh+CQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cXIKNr0H+srcG54lMn1htIkavXakVxfj+FyqmxR7lf9lSe3x77JpPfsg4yFmh/6t/
	 M+LdSswpWpbmLbcewg+axkBMXgSLJdQh9iycpQMLzo1OzctO+dacuZEPAzCpYH096T
	 dF65b2jrRtSiex7Eim8Mu/kdfyTNFE2dSp8Wz8MLai/GqZBBbHpZV+fct5Mtf+RmIs
	 s3qMfnakHwKzNSBolgmoJlYohXlUkqzlynsrBVVE3gwv9SS7pbQHsZ7Lf3XmNVe34z
	 /jdjWFuHNGnnmlo0Syq1YUtulo26oYDl864tqbA1tK0nBgXBd89x3NYDyh6QcF39VH
	 T7Dp5yW1uLiow==
Date: Sat, 3 Oct 2026 10:57:57 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <skhan@linuxfoundation.org>, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chacha20poly1305 - Fix missing state zeroization
 in xchacha decrypt
Message-ID: <20261003085757.GA144870@quark>
References: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
 <b937fca8-f436-47a5-988c-963fa1af6296@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b937fca8-f436-47a5-988c-963fa1af6296@app.fastmail.com>

On Sat, Oct 03, 2026 at 09:34:21AM +0200, Ard Biesheuvel wrote:
> 
> 
> On Sat, 3 Oct 2026, at 08:08, Mohamad Raizudeen wrote:
> > The `__chacha20poly1305_decrypt` function does not zeroize the chacha
> > state, unlike its encrypt counterpart. The regular
> > `chacha20poly1305_decrypt` function handles this by manually calling
> > chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
> > the result directly without clearing the state.
> >
> > This leaves the derived chacha20 subkey on the stack after the function
> > returns. Fix this by storing the return value, calling
> > chacha_zeroize_state() and then returning the result, matching the
> > logic in `chacha20poly1305_decrypt`.
> >
> > Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction 
> > and selftest from Zinc")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> > ---
> >  lib/crypto/chacha20poly1305.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/crypto/chacha20poly1305.c 
> > b/lib/crypto/chacha20poly1305.c
> > index ea42a28f4ff7..03b14d272520 100644
> > --- a/lib/crypto/chacha20poly1305.c
> > +++ b/lib/crypto/chacha20poly1305.c
> > @@ -199,10 +199,13 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 
> > *src, const size_t src_len,
> >  			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
> >  {
> >  	struct chacha_state chacha_state;
> > +	bool ret;
> > 
> >  	xchacha_init(&chacha_state, key, nonce);
> > -	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
> > +	ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
> >  					  &chacha_state);
> > +	chacha_zeroize_state(&chacha_state);
> > +	return ret;
> >  }
> >  EXPORT_SYMBOL(xchacha20poly1305_decrypt);
> > 
> 
> Wouldn't it be better to move the existing call from chacha20poly1305_decrypt()
> to __chacha20poly1305_decrypt()?

Since __chacha20poly1305_decrypt() has two return statements that would
need to be considered, I think this patch (which makes each
*chacha_init() clearly paired with chacha_zeroize_state()) is slightly
cleaner.

- Eric
