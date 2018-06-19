From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 3/3] hwrng: msm - Add support for prng v2
Date: Tue, 19 Jun 2018 09:34:58 +0530
Message-ID: <20180619040458.GJ25852@vkoul-mobl>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-4-vkoul@kernel.org>
 <20180618182123.GT14924@minitux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180618182123.GT14924@minitux>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18-06-18, 11:21, Bjorn Andersson wrote:
> On Mon 18 Jun 07:12 PDT 2018, Vinod Koul wrote:
> 
> > Qcom 8996 and later chips support prng v2 where we need to only
> > implement .read callback for hwrng.
> > 
> 
> The hardware still needs initialization, so I think you should expand
> this to mention that the initialization is moved to secure world and
> that's the reason why we only implement read.
> 
> The question is what happens in projects with other security models.

I did think about that, in those case a DT change would do the trick by
pointing to the TZ EE and loading v1 driver but then is DT board sepcific
or SoC specific, I think latter :(

Can we detect the model..?

> >  	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
> > @@ -154,6 +161,9 @@ static int msm_rng_probe(struct platform_device *pdev)
> >  		return PTR_ERR(rng->clk);
> >  
> >  	rng->hwrng = &msm_rng;
> > +	version = (unsigned long)of_device_get_match_data(&pdev->dev);
> 
> If this is "version" then please make it 1 or 2, if you agree with
> Stephen's suggestion of omitting the initialization of init I think this
> would be better as 0/1 and the variable named "skip_init".

ok will do

-- 
~Vinod
