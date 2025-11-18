Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDAA2E11BC;
	Tue, 18 Nov 2025 23:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508679; cv=none; b=QjTuKJhPrRT9Csn1IVg3Wh7avatWBtPSeI5b0JgvFM67Vjuzfe7Srdap4hoLGnuInxThmeotj3EE/Feb9SdshRCRtkJv0sCgmsRTl7wF+y+qtaekFhqyWng+duFA3kowsqHdRxgI8hd1MTurOAV5wuNqJLQjb6vHHc/TmORv+aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508679; c=relaxed/simple;
	bh=ZJLIOO6eSOhQgQtxVYwfKcw2e6tNQfte2BPffybf8Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKpx7+CMv2krDyN9TGcHoVPB5pG7GVXI8/EDsuLxmYaR/ABu1+Ojb/Uu4CWHzMTthxTkB6UeDL6jgQ4Gfu1zLUwQQXsJgc/Twos+EAwHEDW/oqKk/5Yu1vcvJiHoBqWAzlFmxyS/UtLpwuhERoxcIIO7LkwT/IiNm16uZ7oqEVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=IMwXnce8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="IMwXnce8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38FBC2BC87;
	Tue, 18 Nov 2025 23:31:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="IMwXnce8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763508675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OTrRKTowr/XYLifEHT7QW6Oji6btm+tLEepxLg9Usls=;
	b=IMwXnce8XDeRhOtdlOc1F+jheMgOBcxe32LBE6uBrYi7RQA5GuHqK/r6yXh4K6rAj+xNNs
	MpYFU61vSn9kRUiRSkGJeh3MD3DIgDAwBzhjDZwAf3afA4nzMH66ZZgKgRFsvFTTZqWcpj
	G2246Q7VItW3Zcnqtj+rkeGQW0tXWng=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ad72c2f5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 18 Nov 2025 23:31:14 +0000 (UTC)
Date: Wed, 19 Nov 2025 00:31:11 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto 1/2] array_size: introduce min_array_size()
 function decoration
Message-ID: <aR0Bv-MJShwCZBYL@zx2c4.com>
References: <20251118170240.689299-1-Jason@zx2c4.com>
 <20251118232435.GA6346@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251118232435.GA6346@quark>

On Tue, Nov 18, 2025 at 03:24:35PM -0800, Eric Biggers wrote:
> On Tue, Nov 18, 2025 at 06:02:39PM +0100, Jason A. Donenfeld wrote:
> > diff --git a/include/linux/array_size.h b/include/linux/array_size.h
> > index 06d7d83196ca..8671aee11479 100644
> > --- a/include/linux/array_size.h
> > +++ b/include/linux/array_size.h
> 
> I think compiler.h would be a better place?

That was my initial idea, but then I saw that array_size.h got split
out, and this seemed be on the topic...

> 
> > @@ -10,4 +10,11 @@
> >   */
> >  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> >  
> > +/**
> > + * min_array_size - parameter decoration to hint to the compiler that the
> > + *                  passed array should have at least @n elements
> > + * @n: minimum number of elements, after which the compiler may warn
> > + */
> > +#define min_array_size(n) static n
> 
> "after which" => "below which"

Er, thanks.

> 
> Anyway, I actually have a slight preference for just using 'static n'
> directly, without the unnecessary min_array_size() wrapper.  But if
> other people prefer min_array_size(), that's fine with me too.  At least
> this is what Linus asked for
> (https://lore.kernel.org/linux-crypto/CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com/).

There's also this other approach from 2001 that the C committee I guess
shot down: https://www.open-std.org/jtc1/sc22/wg14/www/docs/dr_205.htm
It is basically:

    #define __at_least static

We could attempt to do the same with `at_least`...

It kind of feels like we're just inventing a language at that point
though.

Jason
