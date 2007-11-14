From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [camellia-oss:00952] Re: [PATCH 5/5] camellia: de-unrolling, 64bit-ization
Date: Tue, 13 Nov 2007 19:47:08 -0700
Message-ID: <200711131947.09040.vda.linux@googlemail.com>
References: <20071113.150702.628183529.takamiya@po.ntts.co.jp> <200711131534.33521.vda.linux@googlemail.com> <20071113.174104.224925773.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: takamiya@po.ntts.co.jp, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:4792 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbXKNCrQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 21:47:16 -0500
Received: by wr-out-0506.google.com with SMTP id 36so31892wra
        for <linux-crypto@vger.kernel.org>; Tue, 13 Nov 2007 18:47:15 -0800 (PST)
In-Reply-To: <20071113.174104.224925773.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday 13 November 2007 18:41, David Miller wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> Date: Tue, 13 Nov 2007 15:34:33 -0700
>
> > My preferred solution is to make loop unrolling conditional on
> > CONFIG_CC_OPTIMIZE_FOR_SIZE - and this is what is done in my
> > (first) patch (see attached). This part:
>
> The default build is going to be CONFIG_CC_OPTIMIZE_FOR_SIZE
> basically for everyone, this is what people get by default
> and this is what every distribution uses.
>
> Therefore %99.9999 of folks will get the slowdown.
>
> So in my book this is not an acceptable way to deal with
> this problem.

Loop unrolling here amounts to 25% code growth:

   text    data     bss     dec     hex filename
  21714       0       0   21714    54d2 camellia5.o
  15906       0       0   15906    3e22 camellia5_Os.o

Saving 25% or code size and going 5% slower is perfectly acceptable
tradeof for some users. NB: I'm not saying all, ut some significant
part of users would like to be able to have this choice.

If CONFIG_CC_OPTIMIZE_FOR_SIZE is not an acceptable method,
do you have other ideas?
--
vda
