From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG AIO - lock context IV
Date: Thu, 01 Feb 2018 11:04:36 +0100
Message-ID: <2665140.KarSQuFonJ@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <20180131122956.000061a3@huawei.com> <CAOtvUMd=T8WkeMRhcF6PzDerzBsszBOCp9x=DpCjQMtLxgTPvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59108 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbeBAKEj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 05:04:39 -0500
In-Reply-To: <CAOtvUMd=T8WkeMRhcF6PzDerzBsszBOCp9x=DpCjQMtLxgTPvg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 1. Februar 2018, 10:35:07 CET schrieb Gilad Ben-Yossef:

Hi Gilad,

> > 
> > Which works well for the sort of optimization I did and for hardware that
> > can do iv dependency tracking itself. If hardware dependency tracking was
> > avilable, you would be able to queue up requests with a chained IV
> > without taking any special precautions at all. The hardware would
> > handle the IV update dependencies.
> > 
> > So in conclusion, Stephan's approach should work and give us a nice
> > small patch suitable for stable inclusion.
> > 
> > However, if people know that their setup overhead can be put in parallel
> > with previous requests (even when the IV is not yet updated) then they
> > will
> > probably want to do something inside their own driver and set the flag
> > that Stephan is proposing adding to bypass the mutex approach.
> 
> The patches from Stephan looks good to me, but I think we can do better
> for the long term approach you are discussing.

What you made me think of is the following: shouldn't we relay the inline IV 
flag on to the crypto drivers?

The reason is to allow a clean implementation of the enabling or disabling of 
the dependency handling in the driver. Jonathan's driver, for example, decides 
based on the pointer value of the IV buffer whether it is the same buffer and 
thus dependency handling is to be applied. This is fragile.

As AF_ALG knows whether the inline IV with separate IVs per request or the 
serialization with one IV buffer for all requests is requested, it should 
relay this state on to the drivers. Thus, for example, Jonathan's driver can 
be changed to rely on this flag instead on the buffer pointer value to decide 
whether to enable its dependency handling.

Ciao
Stephan
