Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06515295D90
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 20:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763151823; cv=none; b=pUXw6VV2f90roESGZNzpRBI2Syf3gE0xUBuYqEzBOmiNTt8AZbr6Ky3iSzIpp20uAj2xcoYl5pmZlx5zWUEdNVNQ8rRNO1BLlfqa40oGMasN57GWaZJ7OpMhqKA1iHTlEDdBPFC6ccEHZEYKeWuj1caxAVXs/Q7vOnVDqaOlTWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763151823; c=relaxed/simple;
	bh=zeQsQks0bBqhN9qYVuFN9cWp3J1HcdYVZRFOQdzEY+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1i8XaAjFcnc5BXFoaMVuKkzPDiQXX0Ut8vClb6x/0ztznFjcxPtOEetgtOR+yFlRjKdx57OqsyZYkTbiqX4VJnjdRkREBDwNEHI9xe3c6OFpirpGreQ921VHf+X2O9el/uSzYeOVcWO0rtuIHKsfz/HtZyIsFdeekZPwk0aGm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=EYyiKPdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EYyiKPdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8248C4CEF5;
	Fri, 14 Nov 2025 20:23:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EYyiKPdB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763151819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EXYoll/xdHiGHyI4049pxfon4GdFykmgZ8c8GfcB97E=;
	b=EYyiKPdBsaFlajWa0aODn2KKHHE/8iTpxAje+wRDUddwN8o4xVEpVnWUcr2dFdZLuDtWkZ
	Nc60gvHde3IFUhSjIvEa/XkLI1dQKlJDldY07i3S+tO9jOSTHzQRr5LlwdMy9TMo0pnD1p
	EsfQDHbUTVovhrewsvcZAUbxDbC8ibE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0234b901 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 14 Nov 2025 20:23:39 +0000 (UTC)
Date: Fri, 14 Nov 2025 21:23:34 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, arnd@arndb.de
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <aRePu_IMV5G76kHK@zx2c4.com>
References: <20251114180706.318152-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251114180706.318152-2-ardb+git@google.com>

On Fri, Nov 14, 2025 at 07:07:07PM +0100, Ard Biesheuvel wrote:
> void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>                                const u8 *ad, const size_t ad_len,
>                                const u8 (*nonce)[XCHACHA20POLY1305_NONCE_SIZE],
>                                const u8 (*key)[CHACHA20POLY1305_KEY_SIZE])
> 
> However, this variant is checked more strictly by the compiler, and only
> arrays of the correct size are accepted as plain arguments (using the &
> operator), and so inadvertent mixing up of arguments or passing buffers
> of an incorrect size will trigger an error at build time.

Interesting idea! And codegen is the same, you say?

There's another variant of this that doesn't change callsites and keeps
the single pointer, which more accurate reflects what the function does:

void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
                               const u8 *ad, const size_t ad_len,
                               const u8 nonce[static XCHACHA20POLY1305_NONCE_SIZE],
                               const u8 key[static CHACHA20POLY1305_KEY_SIZE])

An obscure use of the `static` keyword, but this is what it's used for -
telling the compiler what size you expect the object to be. Last time I
investigated this, only clang respected it, but now it looks like gcc
does too:

    zx2c4@thinkpad /tmp $ cat a.c
    
    void blah(unsigned char herp[static 7]);
    
    static void schma(void)
    {
        unsigned char good[] = { 1, 2, 3, 4, 5, 6, 7 };
        unsigned char bad[] = { 1, 2, 3, 4, 5, 6 };
        blah(good);
        blah(bad);
    }
    zx2c4@thinkpad /tmp $ gcc -c a.c
    a.c: In function ‘schma’:
    a.c:9:9: warning: ‘blah’ accessing 7 bytes in a region of size 6 [-Wstringop-overflow=]
        9 |         blah(bad);
          |         ^~~~~~~~~
    a.c:9:9: note: referencing argument 1 of type ‘unsigned char[7]’
    a.c:2:6: note: in a call to function ‘blah’
        2 | void blah(unsigned char herp[static 7]);
          |      ^~~~
    zx2c4@thinkpad /tmp $ clang -c a.c
    a.c:9:2: warning: array argument is too small; contains 6 elements, callee requires at least 7
          [-Warray-bounds]
        9 |         blah(bad);
          |         ^    ~~~
    a.c:2:25: note: callee declares array parameter as static here
        2 | void blah(unsigned char herp[static 7]);
          |                         ^   ~~~~~~~~~~
    1 warning generated.


This doesn't account for buffers that are oversize -- the less dangerous
case -- but maybe that's fine, to keep "normal" semantics of function
calls and still get some checking? And adding `static` a bunch of places
is easy. It could apply much wider than just chapoly.

This all makes me wish we had NT's SAL notations though...

Jason
