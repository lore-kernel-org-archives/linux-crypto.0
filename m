From: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling,
 64bit-ization
Date: Tue, 20 Nov 2007 03:49:57 +0900 (JST)
Message-ID: <20071120.034957.465778866.takamiya@linux-ipv6.org>
References: <200711141428.25933.vda.linux@googlemail.com>
	<20071118132139.GA28491@gondor.apana.org.au>
	<200711182030.17123.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from linux6.nezu.wide.ad.jp ([203.178.142.218]:47282 "EHLO
	nezu.linux-ipv6.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbXKSTBw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2007 14:01:52 -0500
In-Reply-To: <200711182030.17123.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

>> Sun, 18 Nov 2007 20:30:16 -0800
>> [Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization]
>> Denys Vlasenko <vda.linux@googlemail.com> wrote...

> > > camellia6:
> > >         unifies encrypt/decrypt routines for different key lengths.
> > >         This reduces module size by ~25%, with tiny (less than 1%)
> > >         speed impact.
> > >         Also collapses encrypt/decrypt into more readable
> > >         (visually shorter) form using macros.
> 
> And here is
> 
> camellia7:
>         Move "key XOR is end of F-function" code part into
>         camellia_setup_tail(), it is sufficiently similar
>         between camellia_setup128 and camellia_setup256.
>         This shaves off another ~1k:
>           dec     hex filename
>         21414    53a6 2.6.23.1.camellia6.t/crypto/camellia.o
>         20518    5026 2.6.23.1.camellia7.t/crypto/camellia.o
>         16355    3fe3 2.6.23.1.camellia6.t64/crypto/camellia.o
>         15813    3dc5 2.6.23.1.camellia7.t64/crypto/camellia.o
> 
> 
> At the moment I cannot run test it, try to do it ASAP.
> 
> Takamiya-san, can you review attached patch please?

  Sorry for late reply.

  I think you're testing now:-), and if speed impact is less than 1%
  as you say, I think it is acceptable.

  The smaller code size is, the easier to enable camellia in the
  embedded systems.

  Regards,

Acked-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

--
Noriaki TAKAMIYA
