Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A151480DD5;
	Sat,  3 Oct 2026 16:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045575; cv=none; b=fTAuIHlcTQl8dIZa4QBQRR1LfKbdtWi19vXKFbGbhhfFwxxu/5U2JowQ5TvIZsrQFFZclgWga2nV6Sg5pzH7ua3exz/T4JXlSD29jJZmcsHfdRmK3bN8gP2vrN2/uP5ELs9rParOGn+wI3RCqq3Vowprjt2s7fzmiglnZWuK/RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045575; c=relaxed/simple;
	bh=yfA9QuxBkO85ULPSHfWZ66qoJ/F8k05KhwBI+xwGPkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEuxj7hoFxTXA0Nl3lQGCTF/vLQVoGNwN31RPV7iK8JRV4yID2dYCqI46Ikw+7I/71A0GIfV2BV5PMwtL17LjpgtiMyCz/9NQcFu3VOfgiaIqhGKVkhJPDCCZtjTXGW1MhvBAP8FThbqkAkkihGjStOc4YPYOko4xWbDZ5LCyuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldqQkNj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldqQkNj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912DF1F0089C;
	Sat,  3 Oct 2026 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045574;
	bh=3dYyVwLdI1ZROemI1KKJTepuzd+3RUnatIxHJ7QwWUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ldqQkNj848ULRx6Lm0k/YZW2p74ptm0Rp++n2XlAYRHKYc76oVfNjgmWVPLzGFAmQ
	 /6bLxveYgb8Vn2LeqOM7mf34iY8EWRcfmRZiI7853nu4gsB7UFKMRCZcE+GThatdFm
	 GIT2E+uGC2b7bxIRfs13nEKMvz4zr3gtMgAGxXNK3TYiCess0nWo1cYJNbOwBw2nLJ
	 CKuL3mM1rrusVB1Wl9xsgJi9NvcenDgeD1OevV6YeVEkUD+wIqs/7c9Waj7Pq8Jlt3
	 NtHkYvcdI1jdqwFay/Y1RQ/r/qrPcC5FA69I4bdnCraNYP7PGTLJ4GTtOORwfK62Of
	 TgIDopV37Xfng==
Date: Sat, 3 Oct 2026 18:39:26 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <skhan@linuxfoundation.org>, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chacha20poly1305 - Fix missing state zeroization
 in xchacha decrypt
Message-ID: <20261003163926.GC152469@quark>
References: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
 <b937fca8-f436-47a5-988c-963fa1af6296@app.fastmail.com>
 <20261003085757.GA144870@quark>
 <ea68191f-86cf-44b1-a045-237b93a4953f@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea68191f-86cf-44b1-a045-237b93a4953f@app.fastmail.com>

On Sat, Oct 03, 2026 at 11:28:20AM +0200, Ard Biesheuvel wrote:
> 
> 
> On Sat, 3 Oct 2026, at 10:57, Eric Biggers wrote:
> > On Sat, Oct 03, 2026 at 09:34:21AM +0200, Ard Biesheuvel wrote:
> >> 
> >> 
> >> On Sat, 3 Oct 2026, at 08:08, Mohamad Raizudeen wrote:
> >> > The `__chacha20poly1305_decrypt` function does not zeroize the chacha
> >> > state, unlike its encrypt counterpart. The regular
> >> > `chacha20poly1305_decrypt` function handles this by manually calling
> >> > chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
> >> > the result directly without clearing the state.
> >> >
> >> > This leaves the derived chacha20 subkey on the stack after the function
> >> > returns. Fix this by storing the return value, calling
> >> > chacha_zeroize_state() and then returning the result, matching the
> >> > logic in `chacha20poly1305_decrypt`.
> >> >
> >> > Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction 
> >> > and selftest from Zinc")
> >> > Cc: stable@vger.kernel.org
> >> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> >> > ---
> >> >  lib/crypto/chacha20poly1305.c | 5 ++++-
> >> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/lib/crypto/chacha20poly1305.c 
> >> > b/lib/crypto/chacha20poly1305.c
> >> > index ea42a28f4ff7..03b14d272520 100644
> >> > --- a/lib/crypto/chacha20poly1305.c
> >> > +++ b/lib/crypto/chacha20poly1305.c
> >> > @@ -199,10 +199,13 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 
> >> > *src, const size_t src_len,
> >> >  			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
> >> >  {
> >> >  	struct chacha_state chacha_state;
> >> > +	bool ret;
> >> > 
> >> >  	xchacha_init(&chacha_state, key, nonce);
> >> > -	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
> >> > +	ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
> >> >  					  &chacha_state);
> >> > +	chacha_zeroize_state(&chacha_state);
> >> > +	return ret;
> >> >  }
> >> >  EXPORT_SYMBOL(xchacha20poly1305_decrypt);
> >> > 
> >> 
> >> Wouldn't it be better to move the existing call from chacha20poly1305_decrypt()
> >> to __chacha20poly1305_decrypt()?
> >
> > Since __chacha20poly1305_decrypt() has two return statements that would
> > need to be considered, I think this patch (which makes each
> > *chacha_init() clearly paired with chacha_zeroize_state()) is slightly
> > cleaner.
> >
> 
> Fair enough.

Actually, looking at the whole file, in the encryption case
__chacha20poly1305_encrypt() already "takes ownership" of the state and
handles zeroizing it.  So given that, I think it does make sense for
__chacha20poly1305_decrypt() to do the same thing, for consistency
between the encryption and decryption cases.

Mohamad, could you send out a v2 that does that?

Also, for the subject prefix, use: "lib/crypto: chacha20poly1305:"

Thanks!

- Eric
