Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A263CE0A7;
	Sun,  4 Oct 2026 17:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134522; cv=none; b=dKW6e9QUt8EOk8lX0sdjNOSBuqmxt/zzT0T1g2d9HxnMH5/Rxnd84/VToq8RLF1uS4ItfMiuG0TpUY6Qq15MJFXZldI5uorYj7s7iQFMGfiTuizMAoJUMrWaMpmgtGciF9jErU59T92T0axUAWj/SSkYoSUc2hHxEb5YCPhgoC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134522; c=relaxed/simple;
	bh=JJIxKKQtGN4NVZBfNuSdSRlGLUdqNuPCSBu1QXY+KvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7/J6o1r6PGUcP9ggoFJKE7Olyc+Cl0yQKsNMO70hAdKco8yRNxiDA42pdN7cWYH6SFeUsgpz5kg79fgODGQfKYiLIueCzKg3U22ky7BuB1iZytLH/TDA1bCKM6fxbMlrmy4Rcs45JJ9Tx/Gu5nsA07qbprUkjo8UxRr/72gW44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmxDTf4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmxDTf4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2CD1F000FF;
	Sun,  4 Oct 2026 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791134520;
	bh=BUe0EJ5jaLe5TSZ1RJ8hdpmXp9c6cy822p5BCBSP1SA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TmxDTf4oNDy9jibG8tQIVO/z9F6ggSeH9JLDIoL1iuFuC6r1Cm4QpLiNqHjGaFbpR
	 4oIyFhXoVOB4drINeVijrnDDwh7UNSvf3md/tycmrWGMucVZwa2JCshym4vz7HiWLB
	 jXJsyuKzlE/9UCUdBcamOP7hrY/SBW4Qdky82VofpYrA/zyePIhuAhgtsXCx+HGzgq
	 moTgyZ+NnLxTg5WRnR1Xfaway3ckK5patXaW9ME3+WQUF+ggvl4ErbSkfLRFo484d1
	 PQnqiC48mbq34ecnfTy/Si4cIssVh4QAaTTfeAimYaJ58Mi6OHGNeQQnG3aeHQdHzv
	 ov2Gr28mDh0Rw==
Date: Sun, 4 Oct 2026 19:21:55 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: ardb@kernel.org, Jason@zx2c4.com, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: chacha20poly1305: zeroize state in
 __chacha20poly1305_decrypt
Message-ID: <20261004172155.GB1906@quark>
References: <20261004043413.6870-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004043413.6870-1-raizudeen.kerneldev@gmail.com>

On Sun, Oct 04, 2026 at 10:04:13AM +0530, Mohamad Raizudeen wrote:
> The `__chacha20poly1305_decrypt` function does not zeroize the chacha
> state, unlike its encrypt counterpart. The regular
> `chacha20poly1305_decrypt` function handles this by manually calling
> chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
> the result directly without clearing the state, leaving the derived
> chacha20 subkey on the stack.
> 
> Fix this by moving the chacha_zeroize_state() call into
> __chacha20poly1305_decrypt() itself, so the helper cleans up after
> itself just like __chacha20poly1305_encrypt does. This ensures all
> callers are secure without needing manual cleanup.
> 
> Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction and selftest from Zinc")
> Cc: stable@vger.kernel.org
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

Sorry, to nitpick this a bit more:

Can you reword this to clarify that this is an ABI robustness
improvement rather than a fix, since currently the single caller of
xchacha20poly1305_decrypt() in wg_cookie_message_consume() doesn't
require forward secrecy, as mentioned by Jason.  And maybe remove Fixes
and 'Cc stable'.  Otherwise this commit will unnecessarily trigger all
the stable backport and CVE spam.

> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index ea42a28f4ff7..80904321458b 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -137,8 +137,10 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>  		__le64 lens[2];
>  	} b;
>  
> -	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
> +	if (unlikely(src_len < POLY1305_DIGEST_SIZE)) {
> +		chacha_zeroize_state(chacha_state);
>  		return false;
> +	}

How about we move this length check into the two callers before they
write anything to the state at all?  Then the state would not need to be
zeroized if the length check fails.  Note that
chacha20poly1305_decrypt_sg_inplace() already does it this way.

>  	memzero_explicit(&b, sizeof(b));
>  
> +	chacha_zeroize_state(chacha_state);
>  	return !ret;

Nit: Use the same order and whitespace as
chacha20poly1305_crypt_sg_inplace():

	chacha_zeroize_state(chacha_state);
	memzero_explicit(&b, sizeof(b));

	return !ret;

- Eric
