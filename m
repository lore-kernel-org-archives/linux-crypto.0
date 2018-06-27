From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Wed, 27 Jun 2018 09:51:48 +0200
Message-ID: <3762582.fWXRAqm3bE@tauon.chronox.de>
References: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au> <170012246.0U45yCEtus@tauon.chronox.de> <20180627070144.GG22377@vkoul-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Vinod <vkoul@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627070144.GG22377@vkoul-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 27. Juni 2018, 09:01:44 CEST schrieb Vinod:

Hi Vinod,

> > > Currently am doing bunch of initialization in .probe (platform driver)
> > > and I think recommendation would be to move that to .cra_init, which
> > > seem
> > > plausible but I don't have pdev to read hw_resource etc.. so would still
> > > need to get that.
> > 
> > It seems that your allocation during probe relates to the hardware
> > resource
> > where you only have one in the system. Thus, doing the allocation here
> > makes sense. And, you do not want to perform probe or such resource
> > allocation once per crypto API RNG instance allocation. As said, there
> > can be multiple or even they can be allocated and deallocated frequently.
> > This in particular applies if your driver's "stdrng" has the highest prio
> > which means that it will be allocated and deallocated frequently.
> 
> Right, that is how I visualized it.
> 
> Is there a way where we can tweak the register API to pass hw_resource
> pointer and get that back? Would that work with the security model in
> crypto.

I would not see an easy way for that. The core register API of the kernel 
crypto API would need to be changed.
> 
> I do not like globals and somehow don't feel that we should do it that
> way

Granted, I concur here.



Ciao
Stephan
