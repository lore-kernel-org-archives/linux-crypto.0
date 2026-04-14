Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3793D5246
	for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 10:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776162372; cv=none; b=McWhEe/I1aXT0MUQ7wS/arlPrScEjBE/5mxhU50uHMBjx/kv1v1Bi36IoJUe3GCSEmwWTxPlpx4tqaPT8fGmyAF89zo1Fl2SdPTgyE8ydg5nclYG/S9QQnxPs+DxOI6YD3HJb2RRx/OUIPaRiEAAWquvVMBPcfEXPz9yKKsy4NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776162372; c=relaxed/simple;
	bh=lLnw08jCTWpP4YPGRp45HZtXDNXrxAlLo5yo/Nfo7cA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pGh8FbF3lAS/3TDIX31pNUUYqVbxgCvKoWo3toKvwamV3pvoAD5f4Nv9BK0lh9y5uoQFWArYP1mhY0WXFJ1yI9pXPFJs4nRLbKCaZXGwFhU32BOiF5RThDq1FyXArAPhLGPpi5PV0fNEjuL/4+d+Dxn0TaNYO4fsubF+0wXmSW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qxeSX236; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qxeSX236"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488aa77a06eso89961895e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 03:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776162362; x=1776767162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZb/0/xSNQxp0F85Jgh+HG9e9qkIM5zeg0QYc5nf7j8=;
        b=qxeSX236u6IJQhMfCDa9vkjyLkypP5WvVHN8gCzg7R7LPi1EmNuGA/epR/cnVmtZN6
         LNBC4UUjI7MCOCKJL7N536wOaxzf2uRU76OR+4LxYa3PcftBSVpJPEWZ994OcRYk+iff
         vu92Yzzgd8M9fxzQdlr5HX+racwRWnALHOaUwYg8s+nC4h3KGxewyvdf3zd1huFLPBmM
         zAHl4+uj6nv2TAsCKB0epksQ/B9pU6DAizI6BDGFXX8bYv+R/y/MPpRbkPMsL6o70b+5
         sVkCb+Q2aJuast+LxHL0LyGzArRYQ2sYyNrwfVia6czijgLIkAWp0ZVpdEcrUOSZWHGt
         Zj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776162362; x=1776767162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eZb/0/xSNQxp0F85Jgh+HG9e9qkIM5zeg0QYc5nf7j8=;
        b=hHzVvPb3YVukSYyfGu6yMiZH4CFokhLTzhYmmJ1Sj51OWzS3hQdGYiJDFkzqyU08Qg
         SyZc69XxZ2i3qfRE+4gKP/DEPCIDF3xOnmHiQxSGmrh6ktSdNFXBUKSRy7lqO0SFfOuU
         8d5iRWHvDQ/flCqIeYaD2oJZ6iwrpfIp1vJVVghq2jyVaTf5ENVzncoAJLppWrVHyXV1
         uFoXuVLMZtX93MDbvC91uhHGEuNH/xGwqVqRKY4eBqBuYlwKP5mhtDeqJ9naNA3gBi/S
         0QOZuhObZ3NgYIn9ooOMzAfeypByUvA/+JSnoUqgy6PrqMuHCf6JW6DLB6fM3T/zWOXc
         mItA==
X-Forwarded-Encrypted: i=1; AFNElJ9b7JNcgGa2AFFQ9nTqPA6mjo+ZenP6yX9EwReNb0wVE+KileDtCrx+1b1k4Gvt0F5UOmzhSJKTtohAJfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPtYQHUimmFxG4qW1lATFxZFu2WGahbGxhrFaOs5ksA2jnvyqq
	Jebw2ppGil9dztQYyndz2/905qzm+oE3wo8xex1iTBq6fhBwwuQy0EkQ
X-Gm-Gg: AeBDiesXdRVQjlp62VfK0J9wHJOwC4VEJE2T0bhObVYEw/vXxHOuIM0v0ih2uKk5hfL
	lwdweqPvUUoZMYYTi/mX9XTFvinsAFNBII7GyQ/Gt9kJpsV5QcxVZrA8wsdPFPQStxJArYuhgmb
	gORaYOlHGVjnmMkpDmijIqeoIfYMuQOpHWuifwZIRuJYuXM6WkLQ6EPoYrScUdwHFkgY7vK63tU
	y+or6Wye50cR4BOnlbomy+k1r0dqYIAmk3RdYkx9jMIIIstTHRLDefLfRXwEDLb+IUL9DiDpqgi
	RNK6qPehUA4FwOG+Q0yhCwliZcLE1H6paVeMk+WMmvpB1fX9tTIMjLsuxA3z4KkVmXXhtJTXhgg
	Zhgnk7whXKuXPeiDHzYP1cQtzmHDptPjGZiVyBVqFdOi9CZYlU4xsDAIQOxAKMiVnnE6DnCOts0
	8nCcFWxzNrS3whE+n60OgRNGX02AVtVLLEmXACPKuB0Av74nSZaAaq7npJP3wW3mbW
X-Received: by 2002:a05:600c:a311:b0:483:7903:c3b1 with SMTP id 5b1f17b1804b1-488d68607fbmr169949555e9.20.1776162362105;
        Tue, 14 Apr 2026 03:26:02 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d7bc5f70fsm12239619f8f.3.2026.04.14.03.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 03:26:01 -0700 (PDT)
Date: Tue, 14 Apr 2026 11:26:00 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Lukas Wunner" <lukas@wunner.de>, "Andy Shevchenko"
 <andriy.shevchenko@linux.intel.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Andrey Ryabinin"
 <ryabinin.a.a@gmail.com>, "Ignat Korchagin" <ignat@linux.win>, "Stefan
 Berger" <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, "Alexander
 Potapenko" <glider@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>,
 "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo Frascino"
 <vincenzo.frascino@arm.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <20260414112600.553e7c44@pumpkin>
In-Reply-To: <d82181fe-a70d-4c64-a411-4bf80c51f58f@app.fastmail.com>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
	<adY8iUPrnoXDp_-g@ashevche-desk.local>
	<adZZ70lNnhoDnwok@wunner.de>
	<05d3e296-1b61-4ab4-9bec-6c11407e6f89@app.fastmail.com>
	<ad1IHo1rkVxqeMkc@wunner.de>
	<d82181fe-a70d-4c64-a411-4bf80c51f58f@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 Apr 2026 22:32:24 +0200
"Arnd Bergmann" <arnd@arndb.de> wrote:

> On Mon, Apr 13, 2026, at 21:46, Lukas Wunner wrote:
> > On Mon, Apr 13, 2026 at 05:42:39PM +0200, Arnd Bergmann wrote:  
> >> On Wed, Apr 8, 2026, at 15:36, Lukas Wunner wrote:  
> >
> > Attached please find the Assembler output created by gcc -save-temps,
> > both the original version and the one with limited inlining.
> >
> > The former requires a 1360 bytes stack frame, the latter 1232 bytes.
> > E.g. xycz_initial_double() is not inlined into ecc_point_mult(),
> > together with all its recursive baggage, so the latter version
> > contains two branch instructions to that function which the former
> > (original) version does not contain.  
> 
> Thanks!
> 
> So it indeed appears that the problem does not go away but only
> stays below the arbitrary threshold of 1280 bytes (which was
> recently raised). I would not trust that to actually be the
> case across all architectures then, as there are some targets
> like mips or parisc tend to use even more stack space than
> arm. With your current patch, that means there is a good chance
> the problem will come back later.

Not only that, the 'stack frome size' is just a proxy for total
stack use - which is a lot harder to calculate.
I've a cunning plan to use clangs function prototype hashing
to do a static stack calculation that includes indirect calls.
(I did one many years ago for some embedded code that had none.)
I suspect it will find all sorts of code paths that 'blow' the
kernel stack out of the water.
A good bet will be snprintf() calls in unusual error paths
(even after ignoring recursive snprintf() calls and all the %px
modifiers).

> > At the beginning of the function, it looks like the same register values
> > are stored to multiple locations on the stack.  I assume that's what you
> > mean by awful code generation?  This odd behavior seems more subdued in
> > the version with limited inlining.  
> 
> Right. As far as I can tell, the source code is heavily optimized
> for performance, but with the sanitizer active this would likely
> be several times slower, both from the actual sanitizing and
> from the register spilling. I can see how the use of 'u64'
> arrays makes this harder for a 32-bit target with limited
> available registers.

gcc make a right 'pigs breakfast' of handling u64 items on 32bit.
It gets really horrid on x86 (which has 8 registers including %sp
and %bp).
I got the impression it sometimes treats a u64 as being two 32bit
values, and other times as a 64bit value held in two registers.
The former tends to generate better code, but that latter happens
if an asm() block (or probably anything else) ends up with an 'A'
constraint for a value in %edx:%eax.
It will spill constant zero words to stack, and do multiplies by
values that are constant zero.
(I think the code generated for a single call to mul_64_64()
will show it all.)

I've just looked at that source.
It seems to be doing 'very wide' arithmetic using u64[].
That will be really horrid on 32bit - it needs to use u32[].

Stopping some of those function being inlined will help.
Even on 64bit I doubt it'll make that much difference to
overall performance.

	David

> 
>      Arnd
> 

