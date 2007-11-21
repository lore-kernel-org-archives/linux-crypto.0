From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Wed, 21 Nov 2007 16:12:37 +0800
Message-ID: <20071121081237.GA28089@gondor.apana.org.au>
References: <200711131534.33521.vda.linux@googlemail.com> <200711182030.17123.vda.linux@googlemail.com> <20071121035333.GA25782@gondor.apana.org.au> <200711210008.57978.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3069 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855AbXKUIMv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Nov 2007 03:12:51 -0500
Content-Disposition: inline
In-Reply-To: <200711210008.57978.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 21, 2007 at 12:08:57AM -0800, Denys Vlasenko wrote:
>
> Yes, with minor modifications "64-bit" version
> can be compiled and will work correctly on 32-bit CPU.
> But it will be larger. This is what I got on i386:
> 
>    text    data     bss     dec     hex filename
>   18230     224       0   18454    4816 t/crypto/camellia.o
>   20198     224       0   20422    4fc6 t_fake64/crypto/camellia.o

What are the size differences on x86-64?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
