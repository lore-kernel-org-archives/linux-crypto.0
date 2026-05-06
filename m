Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCB6311C11;
	Wed,  6 May 2026 13:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778074891; cv=none; b=IeVA5HzAPdNPptzJzHLwBLxNekwlkFQ+qzXwk8i5gk7z6tNEhMO78nyAnKB03qeRztvBVV3jhdxbCoPKM9gRmcpmeSEWI3VbCkhTawUCwR3bn6J29WV/P1VF7TwhAwnr2sGB21d/sVEAhKvc+XcnSNYRmVVJsqLO5RbryGb6Ki8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778074891; c=relaxed/simple;
	bh=2yOxkUqJz0Uk6NHnR7imWbZ8IIqYZZ5OLcXWaStmuu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGboVfwpL/5EwOcFT8rGqqGkZzA6vH3ratN7ckPhaVEorXbYjbGw+RFIa9+SSkXkbORAgHLkFcgUgVt7dHgYmG6RuJs2K1TzGZI8U+2dB7jIXZBjUua9C348766QPWAQJKY+LmG7xVxONIQxtsp2Rxg9jRDmInRxZDqTu2bjOF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id A1AE9C98;
	Wed, 06 May 2026 15:41:21 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 7F8016001EB0; Wed,  6 May 2026 15:41:21 +0200 (CEST)
Date: Wed, 6 May 2026 15:41:21 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <aftFAexDFrYbIeBM@wunner.de>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
 <afms-fn-mpwJPfa-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afms-fn-mpwJPfa-@gondor.apana.org.au>

On Tue, May 05, 2026 at 04:40:25PM +0800, Herbert Xu wrote:
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
> > 
> > Reported-by: Andrew Morton <akpm@linux-foundation.org> # off-list
> > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > ---
> >  crypto/Makefile | 5 +++++
> >  1 file changed, 5 insertions(+)
> 
> Patch applied.  Thanks.

My apologies Herbert, I was working on a v2 for this patch
but unfortunately didn't finish it until today:

https://lore.kernel.org/r/7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de/

Would it be possible for you to replace the patch you've already applied
with the new one?  I am very sorry for the hassle.

Since submitting v1, I've opened a gcc bug to get feedback from gcc
maintainers.  They're acknowledging a missing optimization here but
believe that a warning switch such as -Werror=frame-larger-than=1280
should never affect code generation, even if it is promoted to an
error.  Basically if the user is asking to be warned but gcc inlines
beyond the limit, the user gets to keep the pieces:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949

I took a closer look at the ECC point multiplication algorithm used,
it's relatively memory intensive because it uses co-Z addition as a
speedup:

https://eprint.iacr.org/2011/338.pdf

The algorithm is susceptible to timing attacks.  Newer constant time
Montgomery ladder algorithms are not, use less memory (thus likely
avoiding the high stack usage warning) but are not as fast.  I think
that's the proper longterm solution for this problem:

https://eprint.iacr.org/2020/956.pdf

In v2, I've amended the commit message with all that extra information
and I've also taken Nathan's review comments into account.

Thanks,

Lukas
