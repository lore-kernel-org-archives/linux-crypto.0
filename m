From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH v2 2/2] hwrng: msm - Add support for prng v2
Date: Wed, 20 Jun 2018 19:07:25 +0530
Message-ID: <20180620133725.GB27187@vkoul-mobl>
References: <20180619095430.26358-1-vkoul@kernel.org>
 <20180619095430.26358-3-vkoul@kernel.org>
 <152947431955.16708.15247307054260887941@swboyd.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Stephen Boyd <swboyd@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152947431955.16708.15247307054260887941@swboyd.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 19-06-18, 22:58, Stephen Boyd wrote:
> Quoting Vinod Koul (2018-06-19 02:54:30)
> > Qcom 8996 and later chips support prng v2 which requires to
> > implement only .read callback for hwrng.
> > 
> > This version of chip has multiple Execution Environments (EE) and
> > secure world is typically responsible for configuring the prng.
> 
> Sometimes secure world is not configuring the rng though. I prefer we
> have a DT flag for this to indicate if secure world has configured it or
> not and then skip the init logic when the bool property is present in
> DT. Then the DT property can be set on firmwares that are making things
> blow up when we try to read the 'configured' register. I'd also file a
> bug to qcom to tell them to unlock that config register for reads so
> that things can work simpler, but who knows how that will work out.

I dont feel that would be required. See below..

> It really sounds like the hardware isn't actually different, just the
> firmware has decided to be more strict about making reads fail now.

So in this case base hw block seems similar but consists of multiple
Execution Environment (EEs) and all of these contain only data
registers. Only secure environment has configuration. Each one has its
own register space.

In a case where we dont have secure world, we can point to secure
environment with v1 ops, so driver shall configure and run.

Thanks
-- 
~Vinod
