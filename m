From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Sun, 18 Nov 2007 21:21:39 +0800
Message-ID: <20071118132139.GA28491@gondor.apana.org.au>
References: <200711131534.33521.vda.linux@googlemail.com> <200711140015.19887.vda.linux@googlemail.com> <20071114141416.GA15085@gondor.apana.org.au> <200711141428.25933.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4473 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbXKRNWD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 08:22:03 -0500
Content-Disposition: inline
In-Reply-To: <200711141428.25933.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 14, 2007 at 02:28:25PM -0700, Denys Vlasenko wrote:
>
> I also split this patch into two parts for easier review:
> camellia5:
>         adds 64-bit key setup

Sorry but this still duplicates way too much code.  Also key
setup is the slow path relatively speaking so it's even less
justifiable.

> camellia6:
>         unifies encrypt/decrypt routines for different key lengths.
>         This reduces module size by ~25%, with tiny (less than 1%)
>         speed impact.
>         Also collapses encrypt/decrypt into more readable
>         (visually shorter) form using macros.

This looks pretty neat though.  I'll merge it unless I hear any
objections.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
