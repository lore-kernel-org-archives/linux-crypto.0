Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC81B221FB4;
	Sat,  3 Oct 2026 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791058928; cv=none; b=nw3Vi6wScyYBPsb5A27lKxR+Ezrb/BFciF0lJvALV9/mMRYPvhAL/a/UyhMYO6TamQAOZsX3jc6h8Jd6bop4KBiG8AT/KTgm9l08SCo5Silgz2KGuHF4pulDSsjzVMycSlNbAfBGl1n4+inkinz7TlTHlZ6nKlrn0gHftlw5XHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791058928; c=relaxed/simple;
	bh=ed1lGsJ+1gqMPNVoWL3aELzqPoySA/fwsDpsdVzIxYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ruOV65F5OMxmj7BNt1NXKQCAYkgnKAWAuBhSCsnlyAo4RVdJ/J4NAs6eEJWWj2FGRHNe2g+/bazBDLwHAPe6cPW4TEiGZ6W2r3WPP9RHYewSA1LRPdD3ddfuCYe2zYxKyEhNiG5JgXkOSskppqUZhMMVPNYsqhgSzrzPO0yFmp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=TOixXT7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TOixXT7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E301F0089B;
	Sat,  3 Oct 2026 20:22:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=zx2c4.com header.i=@zx2c4.com header.a=rsa-sha256 header.s=20210105 header.b=TOixXT7a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1791058923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Or+qA0Cnb+L7NO6L4PEfticloQh82qWV1cmacilxU10=;
	b=TOixXT7aovNieDKA6F6Q8JkqhABbKyM85UnwRHzgqYR52NtSNbKsxH50Xtle+dDzwdz92b
	llcuMEq9orWrSb9qmIUWZKYl84oV+DZjB76qLXufOw2Bos152bZ/NPVI2f+nZxpzU8VgH3
	jXemBS1VmyiGHWNY+PFYz7L+Yp03ZOQ=
Received: 
	by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id e40e2a3a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 3 Oct 2026 20:22:02 +0000 (UTC)
Date: Sat, 3 Oct 2026 22:22:00 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: ebiggers@kernel.org, ardb@kernel.org, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: chacha20poly1305 - Fix missing state zeroization
 in xchacha decrypt
Message-ID: <asFj6Nxf6fglYfor@zx2c4.com>
References: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261003060826.7792-1-raizudeen.kerneldev@gmail.com>

On Sat, Oct 03, 2026 at 11:38:26AM +0530, Mohamad Raizudeen wrote:
> The `__chacha20poly1305_decrypt` function does not zeroize the chacha
> state, unlike its encrypt counterpart. The regular
> `chacha20poly1305_decrypt` function handles this by manually calling
> chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
> the result directly without clearing the state.
> 
> This leaves the derived chacha20 subkey on the stack after the function
> returns. Fix this by storing the return value, calling
> chacha_zeroize_state() and then returning the result, matching the
> logic in `chacha20poly1305_decrypt`.
> 
> Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction and selftest from Zinc")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
>  lib/crypto/chacha20poly1305.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index ea42a28f4ff7..03b14d272520 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -199,10 +199,13 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>  			       const u8 key[at_least CHACHA20POLY1305_KEY_SIZE])
>  {
>  	struct chacha_state chacha_state;
> +	bool ret;
>  
>  	xchacha_init(&chacha_state, key, nonce);
> -	return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
> +	ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
>  					  &chacha_state);
> +	chacha_zeroize_state(&chacha_state);
> +	return ret;
>  }
>  EXPORT_SYMBOL(xchacha20poly1305_decrypt);

In my memory, the reason it's like this is because for WireGuard,
xchapoly is just being used to encrypt a cookie value, which has no
forward secrecy concerns at all. So it doesn't matter if it's left
around on the stack.

Are there other use cases, though, where you think it might matter?

Jason
