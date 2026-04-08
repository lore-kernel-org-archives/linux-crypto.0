Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5430D33688E;
	Wed,  8 Apr 2026 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655412; cv=none; b=DOXN+9ov7paFcSY9dFGWJxyDCLQ2kLdE6xeXvMnQJzJzShtaf/5+bwrshJ1nk4QEli2bXn9ey4xJpmLJNXuaJPKABR/pJEJcPXUJnubR0GlMF1w56Howpu2mDgTBdZ9vUNu5TF+3fic5DKsjiSaUsKVdh82eIVXVM2xsuU+eHRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655412; c=relaxed/simple;
	bh=GqYlqPTxaiuDuhHmw2tK5xEt6akRcLKZBuJICkC6jcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJ5p4ddrzweMo9SA54VxBV5HzkN8JeLHwdhoUeJn4my7MdJ0X5u5GsR/eAS8qa6N2y5U808VlL0BXQFmMmVE8tG+bRpd2XaCt9sxWvm5Qs9k8bZLLpjjRSlaFSyLfg/v0BxkJNFR3rxcdpir4Y7z39QQEETkJhSxD36yNLeL93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 464F1C1D;
	Wed, 08 Apr 2026 15:36:47 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 0FAE360E3C71; Wed,  8 Apr 2026 15:36:47 +0200 (CEST)
Date: Wed, 8 Apr 2026 15:36:47 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <adZZ70lNnhoDnwok@wunner.de>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
 <adY8iUPrnoXDp_-g@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adY8iUPrnoXDp_-g@ashevche-desk.local>

On Wed, Apr 08, 2026 at 02:31:21PM +0300, Andy Shevchenko wrote:
> On Wed, Apr 08, 2026 at 08:15:49AM +0200, Lukas Wunner wrote:
> > Andrew reports the following build breakage of arm allmodconfig,
> > reproducible with gcc 14.2.0 and 15.2.0:
> > 
> >   crypto/ecc.c: In function 'ecc_point_mult':
> >   crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
> > 
> > gcc excessively inlines functions called by ecc_point_mult() (without
> > there being any explicit inline declarations) and doesn't seem smart
> > enough to stay below CONFIG_FRAME_WARN.
> > 
> > clang does not exhibit the issue.
> > 
> > The issue only occurs with CONFIG_KASAN_STACK=y because it enlarges the
> > frame size.  This has been a controversial topic a couple of times:
> > 
> > https://lore.kernel.org/r/CAK8P3a3_Tdc-XVPXrJ69j3S9048uzmVJGrNcvi0T6yr6OrHkPw@mail.gmail.com/
> > 
> > Prevent gcc from going overboard with inlining to unbreak the build.
> > The maximum inline limit to avoid the error is 101.  Use 100 to get a
> > nice round number per Andrew's preference.
> 
> I think this is not the best solution. We still can refactor the code
> and avoid being dependant to the (useful) kernel options.

Refactor how?  Mark functions "noinline"?  That may negatively impact
performance for everyone.

Note that this is a different kind of stack frame exhaustion than the one
in drivers/mtd/chips/cfi_cmdset_0001.c:do_write_buffer():  The latter
is a single function with lots of large local variables, whereas
ecc_point_mult() itself has a reasonable number of variables on the stack,
but gcc inlines numerous function calls that each increase the stack frame.

And gcc isn't smart enough to stop inlining when it reaches the maximum
stack frame size allowed by CONFIG_FRAME_WARN.

It's apparently a compiler bug.  Why should we work around compiler bugs
by refactoring the code?  The proposed patch instructs gcc to limit
inlining and we can easily remove that once the bug is fixed.

As Arnd explains in the above-linked message, stack frame exhaustion
in crypto/ tends to be caused by compiler bugs.  There are already two
other workarounds for compiler bugs in crypto/Makefile, one for wp512.o
and another for serpent_generic.o.  Amending CFLAGS is how we've dealt
with these issues in the past, not by refactoring code.

Thanks,

Lukas
