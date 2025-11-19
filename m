Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BBD31ED7D;
	Wed, 19 Nov 2025 19:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763579077; cv=none; b=ffZQolU6vGWBojGbr8hr+zqr693aRJUsQIFJpTR4jz8h6ugj5WPu3BMZpPifWQ6GyZWUo58jf+DUo2jBBAV+gVj/OKHJLw1Mh9azeFOhaA9PBHqqaBzpgGpcEnTb/xjvxmYwrsH02gDkxljCMzfGvncOYGzRSDR1sWfso5CNa0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763579077; c=relaxed/simple;
	bh=sh/IqdirFiY9KE9bye27UXNCNGUTRosTLT2d0iGtz3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RYb8C+tdkg3LsOCJcGYIbwpjDmYYLqVnxh1WjirwHnt3yr63g4YSZOAnJNtguU2UsZC9WEEWligGH5whmu6x4Q8vTOZM41BWRLCm48uwmYM5mnsPxXEwXxSe/Ra5IQ5bMB80BsRjErDmgwlFyKypF9mQd2Ok7RQG5obVYZEqyms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=AjCgQ5TV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AjCgQ5TV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CB2C4CEF5;
	Wed, 19 Nov 2025 19:04:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AjCgQ5TV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763579074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8RaFVCFkNE2gveE58cqPfbgyLOAWWmddI0dYQ8V36dI=;
	b=AjCgQ5TVGq1Dv3lCojkIgQGkKSTpoZ0RHPb7p7hsPKEMhx8JShxfG+hN5Z1uI4ayDkodEi
	kG1JirwmPnOaTRC76burDXB9otX8LaP4VBH3MFQDW/AeHfXtpG059q/ZGexu3wd5Bkmd7D
	X2vmg4VrosG8UD/ZhV5aT50HRfXT7IY=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f1b13644 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 19 Nov 2025 19:04:33 +0000 (UTC)
Date: Wed, 19 Nov 2025 20:04:28 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto 1/2] array_size: introduce min_array_size()
 function decoration
Message-ID: <aR4UvNzdLLofbRpW@zx2c4.com>
References: <20251118170240.689299-1-Jason@zx2c4.com>
 <20251118232435.GA6346@quark>
 <aR0Bv-MJShwCZBYL@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aR0Bv-MJShwCZBYL@zx2c4.com>

On Wed, Nov 19, 2025 at 12:31:11AM +0100, Jason A. Donenfeld wrote:
> There's also this other approach from 2001 that the C committee I guess
> shot down: https://www.open-std.org/jtc1/sc22/wg14/www/docs/dr_205.htm
> It is basically:
> 
>     #define __at_least static
> 
> We could attempt to do the same with `at_least`...
> 
> It kind of feels like we're just inventing a language at that point
> though.

Actually, you know, the more this apparently terrible idea sits in my
head, the more I like it.

Which of these is most readable to you?

bool __must_check xchacha20poly1305_decrypt(
        u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
        const size_t ad_len, const u8 nonce[min_array_size(XCHACHA20POLY1305_NONCE_SIZE)],
        const u8 key[min_array_size(CHACHA20POLY1305_KEY_SIZE)]);

bool __must_check xchacha20poly1305_decrypt(
        u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
        const size_t ad_len, const u8 nonce[static XCHACHA20POLY1305_NONCE_SIZE],
        const u8 key[static CHACHA20POLY1305_KEY_SIZE]);

bool __must_check xchacha20poly1305_decrypt(
        u8 *dst, const u8 *src, const size_t src_len, const u8 *ad,
        const size_t ad_len, const u8 nonce[at_least XCHACHA20POLY1305_NONCE_SIZE],
        const u8 key[at_least CHACHA20POLY1305_KEY_SIZE]);

The macro function syntax of the first one means nested bracket brain
parsing. The second one means more `static` usage that might be
unfamiliar. The third one actually makes it kind of clear what's up.
It's got that weird-but-nice Objective-C-style sentence programming
thing.

Would somebody jump in here to tell me to stop sniffing glue? I feel
silly actually considering this, but here I am. Maybe this is actually
an okay idea?

Jason
