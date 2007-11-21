From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Wed, 21 Nov 2007 00:08:57 -0800
Message-ID: <200711210008.57978.vda.linux@googlemail.com>
References: <200711131534.33521.vda.linux@googlemail.com> <200711182030.17123.vda.linux@googlemail.com> <20071121035333.GA25782@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:39534 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbXKUIJZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2007 03:09:25 -0500
Received: by el-out-1112.google.com with SMTP id v27so864916ele
        for <linux-crypto@vger.kernel.org>; Wed, 21 Nov 2007 00:09:24 -0800 (PST)
In-Reply-To: <20071121035333.GA25782@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday 20 November 2007 19:53, Herbert Xu wrote:
> On Sun, Nov 18, 2007 at 08:30:16PM -0800, Denys Vlasenko wrote:
> > Oh, Herbert, have heart, my camellia.c source file is smaller
> > than the one I started from. It's not like it's twice as big.
> > It's smaller already.
> >
> > 64-bit key setup is not just faster, it is also smaller
> > by ~4k, and this benefit is always there, not only when
> > key setup is performed.
>
> The key setup path is the slow path so I don't see why we can't
> just switch to the 64-bit version if it's better.

Yes, with minor modifications "64-bit" version
can be compiled and will work correctly on 32-bit CPU.
But it will be larger. This is what I got on i386:

   text    data     bss     dec     hex filename
  18230     224       0   18454    4816 t/crypto/camellia.o
  20198     224       0   20422    4fc6 t_fake64/crypto/camellia.o

> BTW I tried to apply your -6 patch but it doesn't apply against
> cryptodev-2.6 so I had to drop it.

Will correct this and re-post.
--
vda
