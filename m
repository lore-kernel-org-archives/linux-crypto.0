Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BF83E16A5
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 03:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791084056; cv=none; b=OHsBA1+Gv66g+44HOCJnDRaKoDIyku6k/5udbAVe9rBQ2JsgvN1zzIeTwDIlrccq/YgrjS02yD9QU/L+jh1Kpjn2nQOio9cpYgArolLylBu4SaOydiCWqvUnqg2HuEfevkFsWhIhLhDwFSxlTvfQmUp2Qbv839d0iVzXikcn/SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791084056; c=relaxed/simple;
	bh=ZuoVLXI9mZ7Ed8I5MUuPHCLNfDIzZ0wmyd2KS2Qgu5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMN7XeZAWKpFuHhz0xzh6IJDL15Voe/ocSPMKaLRT4QuUGS4jpe+4ydpRMl8nTNlwtwmHPuaIu7huW80n4ZtxsxzkG1YQCNg/Um891/HQ9fK9Ijhll2dHSQOCaqYebQX8Y5d/f12SZmwmYUR6Fg/kFYeRY8ypXdZgkLOZcWYSo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0XgZHiw; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0XgZHiw"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33e62211987so795256eec.2
        for <linux-crypto@vger.kernel.org>; Sat, 03 Oct 2026 20:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791084054; x=1791688854; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x2thzfSt5QLT8HAsgWdixq/Y9P05apsvpgjsWLwXNuo=;
        b=B0XgZHiwIuXftckS6QbH+LUuWK7NJZDT3/wKixb7SF2xgjN+IcAmACMyKp3RMn14Go
         op8+gW0fVXk5In3Gk89F36XPaIhwDc4TYGoaIOsSBpRS2j6CRj6GZUG5305h4dTrsLCO
         GqJ7Fz6CvTGCBXVHAGDkOQTO8hNn37AvcVSWejREOxelnu7OgwXs13R6mbEIZM2QOcEA
         FYT05de1UJGniKCblrixXDM3hguvsd9VI2Y1fVaeoiyYOxnQ7qge7S/dK7WLirdrhLkh
         c/No4shSCuZfOUkHMeiHi5g3ESe6S6RVvZxODTLSSige2A7MVdGT5u74ND/C3RW3a1sW
         jQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791084054; x=1791688854;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x2thzfSt5QLT8HAsgWdixq/Y9P05apsvpgjsWLwXNuo=;
        b=zL4xYbYNI3tmOleUiGBFgNeh9YzdkEiAJC6blw5LwhwxqFAT9f2C+Xeoymf3NeNt2r
         5wyza8E+FWWH4sRCK2Yp9XWlVNRSYS8PDtxNVUxGXpKl5sk6lOTKsynTM5vN6FztN/BT
         kd6Ik2241zuAmdJlMaTtVXnPTdiUw21eqxzRc+QZvZbENppR2D5xfC29FI4Z/azC3gL1
         zq4ZH01Zr8kVkqGCINmskTFJfIgXfLX5/w3UzAPKJnBcGy1S6HEegNB7v8HXaV/v1SzB
         v1Mk00FbjFD40Kr02ciEl55gAmbvSF15mgPdUbg+qI9LMWB+HnM8QURx4GhVd7D3Pg27
         wOEQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4ay4+5NQGkZYOSdQmub0X3LYjyjgHWlDIhi1TZuPOs/3G1nI0YsMakH23Bstv8//X7GzeIUYQjlWIFUs=@vger.kernel.org
X-Gm-Message-State: AFq9FYJTEG8MLE8+qWtMh0mmYa38Zzh8h7T2v/LPFm85uajcpYtHnKdo
	xVUZTCUT8cPfxqQsIRh/dI5kMc//547Ek4GnuR/B8N3Dmqanx89mYlFx
X-Gm-Gg: AYBFou0K9H/+GRaNfiYEJbRqVhvG4Ez/vn1/X5kBDlDgn24zPcCz2ZNUjXEWWh5KiOO
	XleVqTzzEqZMmdzq0sFsGwpfqUm+f9qPUR8ld5mVDjaeR4T4e5kB1Jp0IzQUZ6m9VhTxjeMkGAI
	8Wu24bli5/oMnMzid2oZ5QZLBzTNYqao7Xryr6ToOEfpldbopqzVklrpcp+R0bvhwcNeGy0TVyb
	bYNcbFuACXGja1gHhyGVrSxI8M59+rsrWqGC3+mZT3DCgb8v+mv80Jq+5LCpVmbTiiaiMsOn+Gr
	Dhhi/EDEWLdayc5xEfsJ/3pyZDFv6TWqtqCQPJKOjjO/zbcZQsqJwPIE/LCV7Q2AAVAz8a76XzE
	iQz5qS3NMbSCktzcy1iSo9HIMRuUe8XGdkr0B/61u89KSG1EK7fXnzI8ZeCGxJWLyh3pxzzXwl/
	W/eNVuF7WC2GFObfuakP6RB0U/zqIo9e1clcTQZ/FjkKVCIvptIPoqYbhqYJiAWDGq45IatXYO+
	sdVW7xaJvf3kUF2cDg=
X-Received: by 2002:a05:7300:6a90:b0:339:8131:424e with SMTP id 5a478bee46e88-34f2185ad93mr8712750eec.34.1791084054190;
        Sat, 03 Oct 2026 20:20:54 -0700 (PDT)
Received: from kernel ([103.219.206.69])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351272bb9basm1070301eec.24.2026.10.03.20.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 20:20:53 -0700 (PDT)
Date: Sun, 4 Oct 2026 08:50:47 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: ebiggers@kernel.org, ardb@kernel.org, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chacha20poly1305 - Fix missing state zeroization
 in xchacha decrypt
Message-ID: <asHGD1_z-N9k0czy@kernel>
References: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
 <asFj6Nxf6fglYfor@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asFj6Nxf6fglYfor@zx2c4.com>

On Sat, Oct 03, 2026 at 10:22:00PM +0200, Jason A. Donenfeld wrote:
> On Sat, Oct 03, 2026 at 11:38:26AM +0530, Mohamad Raizudeen wrote:
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
> > Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction and selftest from Zinc")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> > ---
> >  lib/crypto/chacha20poly1305.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> > index ea42a28f4ff7..03b14d272520 100644
> > --- a/lib/crypto/chacha20poly1305.c
> > +++ b/lib/crypto/chacha20poly1305.c
> > @@ -199,10 +199,13 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
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
> 
> In my memory, the reason it's like this is because for WireGuard,
> xchapoly is just being used to encrypt a cookie value, which has no
> forward secrecy concerns at all. So it doesn't matter if it's left
> around on the stack.
> 
> Are there other use cases, though, where you think it might matter?
> 
> Jason

No, none that exist today. The only in-tree callers are the wireguard
cookie code and the kunit test and I agree the cookie has no forward
secrecy concerns. My only thought is that the function is
EXPORT_SYMBOL()ed, so a future caller with a long term key would leave
the derived subkey on the stack and since chacha20poly1305_decrypt()
already wipes the state, having the xchacha variant do the same seemed
like safer default.

Also, Eric requested a v2 that moves the zeroization into the helper
function for consistency with the encrypt path, so I will be sending
that out shortly.

Thanks,
Mohamad Raizudeen
