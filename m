From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Wed, 27 Jun 2018 12:31:44 +0530
Message-ID: <20180627070144.GG22377@vkoul-mobl>
References: <20180619142853.wgi5easw4zv6ttrb@gondor.apana.org.au>
 <52764537.cSZCttAJ1I@tauon.chronox.de>
 <20180627062701.GF22377@vkoul-mobl>
 <170012246.0U45yCEtus@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <170012246.0U45yCEtus@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Stephan,

Thanks for quick reply,

On 27-06-18, 08:43, Stephan Mueller wrote:
> > On 27-06-18, 08:13, Stephan Mueller wrote:
> > > The key is:
> > >         alg->base.cra_ctxsize   = sizeof(struct drbg_state);
> > > 
> > > during initialization since the kernel crypto API allocates that buffer
> > > for
> > > you and releases it during deallocation.
> > 
> > The difference here is that memory is allocated by crypto and driver has
> > no way to pass "it's" own data while doing registration. Ideally
> > registration should accept a pointer/long and pass that back on a
> > callbacks
> 
> Looking at your code, it seems you do what makes sense: there is only one 
> instance of the driver, if at all. Thus, having qcom_rng_dev as static makes 
> sense. The kernel crypto API allows arbitrary instances of the RNG as well as 
> frequent allocations and deallocations. And this is why there must be a 
> disconnect between the one hardware-resource driver-instance data structure 
> and the (potentially) multiple crypto API RNG instances and their data 
> structures.

For now it is true, but somehow doesn't make me happy to bank on that..

> > 
> > Currently am doing bunch of initialization in .probe (platform driver)
> > and I think recommendation would be to move that to .cra_init, which seem
> > plausible but I don't have pdev to read hw_resource etc.. so would still
> > need to get that.
> 
> It seems that your allocation during probe relates to the hardware resource 
> where you only have one in the system. Thus, doing the allocation here makes 
> sense. And, you do not want to perform probe or such resource allocation once 
> per crypto API RNG instance allocation. As said, there can be multiple or even 
> they can be allocated and deallocated frequently. This in particular applies 
> if your driver's "stdrng" has the highest prio which means that it will be 
> allocated and deallocated frequently.

Right, that is how I visualized it.

Is there a way where we can tweak the register API to pass hw_resource
pointer and get that back? Would that work with the security model in
crypto.

I do not like globals and somehow don't feel that we should do it that
way

Thanks for the quick look on the code.

~Vinod
