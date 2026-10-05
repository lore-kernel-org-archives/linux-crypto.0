Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07702E266C
	for <linux-crypto@vger.kernel.org>; Mon,  5 Oct 2026 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791172367; cv=none; b=szLQhqBa6d6rQTFKXXYicyKrLBugEvGZcK+Absmf3kHd6DY2xZo+0nwp+KZhuydr50w0Hb34APd5KtZ9jK5p+8QUtog5s1wO6xANIllev23NxflfKgndIZOVcpM/pVhTNjDu2VDWO3MOm/mtOhn60w+lroTi0DyujK+knPmgVxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791172367; c=relaxed/simple;
	bh=rg8HqcEt6/UKvtkh4FvIyk7WZ6ROa9pdbPJeFBHWYtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMlYnPdm9rfMlu6HZyC2KGM0vHMMZfkNbX5bAhYcdTjXHo96yszMF8mVH4RY4SdhMLJptVebwYZ6R3Gz1WbyNVMVuTG70oRz+uLWYb7poq9zih7H4+VSIfxGnmYxdMqqLdJN2U+itnr7fJKOmt9AipPHk0ygeWRiajMiOCJFf+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rj2QoOZd; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rj2QoOZd"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15354aa70e8so2756318c88.1
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2026 20:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791172364; x=1791777164; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y0A/ymLpHBtY+HqPCY23ZCUWm2WvUIC70nptaCiUNE4=;
        b=rj2QoOZdzOgjAberCJa2w7HT3cqLsu6XGG4ZVqn2bGR+DW7wXHQImG9g8igd4U26y8
         GldvwE7ZF5kU4RtMAubkxhuA08wbbPvW6e7j1hKzRo4+FR2uBjjA1/G8KGwZ21T6HoFT
         7q8u500yuQ07Y6gWmwRik4ZC/HWexj6wxzNuTKBmrzg89fZKE4IBscfpJtrsbPeo5aL/
         77Wwjyu51Q3bNVW+QPau5MmYLbG4VrzRWxm7w/geuY2qgrFcLaz5JoFgz4+xMyHPBAEQ
         EaNCBBlg6TavHzzBbSFMCWtoVvdiRkV7mUeVJgniQtlraCNQx/dsTdCO8LTDMzaI2Dil
         A7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791172364; x=1791777164;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y0A/ymLpHBtY+HqPCY23ZCUWm2WvUIC70nptaCiUNE4=;
        b=petM74zAl3DOzgSS1B1VCna1Op+iuecufXeGq88pGuMQ2H33Fzv6rAxnIjBWKptk+T
         NZwjgZeo0Y9JQgdMxzN0tjsjzyRn7eOSwRzl4ubFEmIX2qHA/RnBdGXFDsU/5w0iymSx
         bDWapudARffQToSLCWLEOA+blvxqxh0kUIaAMfrYx/c+9iy7QdrKbGbjUrXG0ifBFFtB
         nYjERZoc2mEvFKBqn1t4zzq6/CN2aD0CNOHOizSInv49Qp4qQixyFWgfokxDACtoNWuw
         CTCZtfdCS7Vfp9i1djsSQJGRtp5HQGVI2+5URGv5Yce3P6weUQWi6XaDftXuEBK3cpAy
         wUXQ==
X-Forwarded-Encrypted: i=1; AKwUvBzZLBLm0FJAbBR/hHZT4q/5tUc8DRJnoww3768Uy1sxVAM7lmEUvOM4DAztzphhBTO1RmUQPcZY7CWLXCw=@vger.kernel.org
X-Gm-Message-State: AFuF++koGRlyKKwRrt8aZKfFumfJU8v2j5/KgeSXLHdEIkSxopstjaAL
	yWc0K6bsdPvdeNSI06cZYS1O7OdJhVVANKYsxOtFgMCnQVxdIpCerZLRZSZbaQ==
X-Gm-Gg: AYBFou3QBSu1NHl4zzp+t7se/I1E6l57IGOhohb5+KaBktpH363esYtesOnGVATKNQf
	wyGyWJXHLGpcSyP/NiWNO/o2P7H+pwn2Qc2rLRez+hwa2hGVdDIp0BvB6K66J4J1NfFVgx6gwvw
	OqEObH7Pz/WD6+DwsOTL+Dyg9SHR4093kc1wRuQtsTuZGF4POR0yi2EnfRvGwQsp2wbA8NpyLax
	3Psre7j1bYAy8KrsnJIu5xlYwOvRUfEmljLpure7oRg8bBVU0+47u7ZGhVhKLbFb2HrYw/b/4+G
	97y1aip8EKBgZbp7WwmSQ/70iHJjXgT1xVcC2HjtyG2TA7MeeLw5BdibbpOv+L4SVQ8NXisGuyX
	u/er3l19NzrbBzU+dmN3j0dlRGByjvccR6pUieUs9LGBPb5VIob7ZndfETZTBYRHoQKR+3iu8gi
	xmAM6+bJj1M+KbpZ6rjoDHu18xIh64PAfyNDZQJ2nTb+pwJ3e5QZcgjmpQg8aqPUJOZtH48YxSn
	kWMRCBBQiSQULSBDS4NYQ8UmkyU
X-Received: by 2002:a05:7023:a4d:20b0:149:1feb:6d9d with SMTP id a92af1059eb24-151c38b3a52mr8616726c88.19.1791172363728;
        Sun, 04 Oct 2026 20:52:43 -0700 (PDT)
Received: from kernel ([103.219.206.69])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-151fa751693sm41149630c88.2.2026.10.04.20.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 20:52:43 -0700 (PDT)
Date: Mon, 5 Oct 2026 09:22:36 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: ardb@kernel.org, Jason@zx2c4.com, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: chacha20poly1305: zeroize state in
 __chacha20poly1305_decrypt
Message-ID: <asMfBGbckJAhCa45@kernel>
References: <20261004043413.6870-1-raizudeen.kerneldev@gmail.com>
 <20261004172155.GB1906@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004172155.GB1906@quark>

On Sun, Oct 04, 2026 at 07:21:55PM +0200, Eric Biggers wrote:
> On Sun, Oct 04, 2026 at 10:04:13AM +0530, Mohamad Raizudeen wrote:
> > The `__chacha20poly1305_decrypt` function does not zeroize the chacha
> > state, unlike its encrypt counterpart. The regular
> > `chacha20poly1305_decrypt` function handles this by manually calling
> > chacha_zeroize_state(). However, `xchacha20poly1305_decrypt` returns
> > the result directly without clearing the state, leaving the derived
> > chacha20 subkey on the stack.
> > 
> > Fix this by moving the chacha_zeroize_state() call into
> > __chacha20poly1305_decrypt() itself, so the helper cleans up after
> > itself just like __chacha20poly1305_encrypt does. This ensures all
> > callers are secure without needing manual cleanup.
> > 
> > Fixes: ed20078b7e333 ("crypto: chacha20poly1305 - import construction and selftest from Zinc")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> 
> Sorry, to nitpick this a bit more:
> 
> Can you reword this to clarify that this is an ABI robustness
> improvement rather than a fix, since currently the single caller of
> xchacha20poly1305_decrypt() in wg_cookie_message_consume() doesn't
> require forward secrecy, as mentioned by Jason.  And maybe remove Fixes
> and 'Cc stable'.  Otherwise this commit will unnecessarily trigger all
> the stable backport and CVE spam.
> 
> > diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> > index ea42a28f4ff7..80904321458b 100644
> > --- a/lib/crypto/chacha20poly1305.c
> > +++ b/lib/crypto/chacha20poly1305.c
> > @@ -137,8 +137,10 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
> >  		__le64 lens[2];
> >  	} b;
> >  
> > -	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
> > +	if (unlikely(src_len < POLY1305_DIGEST_SIZE)) {
> > +		chacha_zeroize_state(chacha_state);
> >  		return false;
> > +	}
> 
> How about we move this length check into the two callers before they
> write anything to the state at all?  Then the state would not need to be
> zeroized if the length check fails.  Note that
> chacha20poly1305_decrypt_sg_inplace() already does it this way.
> 
> >  	memzero_explicit(&b, sizeof(b));
> >  
> > +	chacha_zeroize_state(chacha_state);
> >  	return !ret;
> 
> Nit: Use the same order and whitespace as
> chacha20poly1305_crypt_sg_inplace():
> 
> 	chacha_zeroize_state(chacha_state);
> 	memzero_explicit(&b, sizeof(b));
> 
> 	return !ret;
> 
> - Eric

Sure, that makes sense. I will drop the fixes and stable tags and reword
the commit message to focus on ABI robustness.

Moving the length check to the callers is a much cleaner approach. I
will implement that and fix the whitespace ordering for v3.

Thanks,
Mohamad Raizudeen
