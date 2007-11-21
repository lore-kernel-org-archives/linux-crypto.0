From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Wed, 21 Nov 2007 11:53:33 +0800
Message-ID: <20071121035333.GA25782@gondor.apana.org.au>
References: <200711131534.33521.vda.linux@googlemail.com> <200711141428.25933.vda.linux@googlemail.com> <20071118132139.GA28491@gondor.apana.org.au> <200711182030.17123.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4717 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745AbXKUEuC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2007 23:50:02 -0500
Content-Disposition: inline
In-Reply-To: <200711182030.17123.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 18, 2007 at 08:30:16PM -0800, Denys Vlasenko wrote:
>
> Oh, Herbert, have heart, my camellia.c source file is smaller
> than the one I started from. It's not like it's twice as big.
> It's smaller already.
> 
> 64-bit key setup is not just faster, it is also smaller
> by ~4k, and this benefit is always there, not only when
> key setup is performed.

The key setup path is the slow path so I don't see why we can't
just switch to the 64-bit version if it's better.

BTW I tried to apply your -6 patch but it doesn't apply against
cryptodev-2.6 so I had to drop it.

Please make sure that you only send one patch per email and that
they apply against cryptodev-2.6.  If the patches have dependencies
then please make that clear as well.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
