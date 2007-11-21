From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Wed, 21 Nov 2007 00:38:09 -0800
Message-ID: <200711210038.09911.vda.linux@googlemail.com>
References: <200711131534.33521.vda.linux@googlemail.com> <200711210008.57978.vda.linux@googlemail.com> <20071121081237.GA28089@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:45007 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbXKUIib (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2007 03:38:31 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2706909wah
        for <linux-crypto@vger.kernel.org>; Wed, 21 Nov 2007 00:38:30 -0800 (PST)
In-Reply-To: <20071121081237.GA28089@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday 21 November 2007 00:12, Herbert Xu wrote:
> On Wed, Nov 21, 2007 at 12:08:57AM -0800, Denys Vlasenko wrote:
> > Yes, with minor modifications "64-bit" version
> > can be compiled and will work correctly on 32-bit CPU.
> > But it will be larger. This is what I got on i386:
> >
> >    text    data     bss     dec     hex filename
> >   18230     224       0   18454    4816 t/crypto/camellia.o
> >   20198     224       0   20422    4fc6 t_fake64/crypto/camellia.o
>
> What are the size differences on x86-64?

The above sizes were: final code (with all patches applied)
built for i386
versus same code with #if BITS_PER_LONG >= 64 replaced by #if 1,
and a few fixes for "integer is too big for long" warnings)

For 64-bit, replacing that #if is a no-op, sizes
will be the same.

If you are asking about 64-bit size comparison *across patches*
5..8, here they are:

64-bit:
dec      hex   filename
22786    5902  2.6.23.1.camellia4.t64/crypto/camellia.o
21422    53ae  2.6.23.1.camellia5.t64/crypto/camellia.o
16355    3fe3  2.6.23.1.camellia6.t64/crypto/camellia.o
15813    3dc5  2.6.23.1.camellia7.t64/crypto/camellia.o
15670    3d36  2.6.23.1.camellia8.t64/crypto/camellia.o

--
vda
