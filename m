From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling,
 64bit-ization
Date: Wed, 14 Nov 2007 13:18:17 +0900 (JST)
Message-ID: <20071114.131817.179962802.takamiya@po.ntts.co.jp>
References: <200711131534.33521.vda.linux@googlemail.com>
	<20071113.174104.224925773.davem@davemloft.net>
	<200711131947.09040.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: vda.linux@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:54674 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbXKNESr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 23:18:47 -0500
In-Reply-To: <200711131947.09040.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

>> Tue, 13 Nov 2007 19:47:08 -0700
>> [Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization]
>> Denys Vlasenko <vda.linux@googlemail.com> wrote...

> On Tuesday 13 November 2007 18:41, David Miller wrote:
> > From: Denys Vlasenko <vda.linux@googlemail.com>
> > Date: Tue, 13 Nov 2007 15:34:33 -0700
> >
> > > My preferred solution is to make loop unrolling conditional on
> > > CONFIG_CC_OPTIMIZE_FOR_SIZE - and this is what is done in my
> > > (first) patch (see attached). This part:
> >
> > The default build is going to be CONFIG_CC_OPTIMIZE_FOR_SIZE
> > basically for everyone, this is what people get by default
> > and this is what every distribution uses.
> >
> > Therefore %99.9999 of folks will get the slowdown.
> >
> > So in my book this is not an acceptable way to deal with
> > this problem.
> 
> Loop unrolling here amounts to 25% code growth:
> 
>    text    data     bss     dec     hex filename
>   21714       0       0   21714    54d2 camellia5.o
>   15906       0       0   15906    3e22 camellia5_Os.o
> 
> Saving 25% or code size and going 5% slower is perfectly acceptable
> tradeof for some users. NB: I'm not saying all, ut some significant
> part of users would like to be able to have this choice.

  IMHO, if you are going to use camellia on the embedded system, size
  of code will be important.

  On the other hand, I think typically the CPU performance is
  restricted on the embedded system, so the performance of code will
  be important...

  I'm not sure 5% slow down is important or not. It will depend on the
  system.

  Regards,

--
Noriaki TAKAMYA
