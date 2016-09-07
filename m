From: Iaroslav Gridin <voker57@gmail.com>
Subject: Re: [PATCH] crypto: qce: Initialize core src clock @100Mhz
Date: Wed, 7 Sep 2016 19:13:22 +0300
Message-ID: <20160907161321.s6v2bkmq7tezmrwa@localhost>
References: <20160903164535.1118-1-voker57@gmail.com>
 <4e509050-6e8e-069c-f00d-eca9a0f3b33d@mm-sol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        andy.gross@linaro.org, david.brown@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4e509050-6e8e-069c-f00d-eca9a0f3b33d@mm-sol.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 07, 2016 at 04:04:01PM +0300, Stanimir Varbanov wrote:
> Hi Iaroslav,
> 
> On 09/03/2016 07:45 PM, Iaroslav Gridin wrote:
> > Without that, QCE performance is about 2x less.
> 
> On which platform? The clock rates are per SoC.

Dragonboard 8074. Should clock rate be moved to its DT?

> > 
> > Signed-off-by: Iaroslav Gridin <voker57@gmail.com>
> > ---
> >  drivers/crypto/qce/core.c | 18 +++++++++++++++++-
> >  drivers/crypto/qce/core.h |  2 +-
> >  2 files changed, 18 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> > index 0cde513..657354c 100644
> > --- a/drivers/crypto/qce/core.c
> > +++ b/drivers/crypto/qce/core.c
> > @@ -193,6 +193,10 @@ static int qce_crypto_probe(struct platform_device *pdev)
> >  	if (ret < 0)
> >  		return ret;
> >  
> > +	qce->core_src = devm_clk_get(qce->dev, "core_src");
> > +	if (IS_ERR(qce->core_src))
> > +		return PTR_ERR(qce->core_src);
> > +
> >  	qce->core = devm_clk_get(qce->dev, "core");
> >  	if (IS_ERR(qce->core))
> >  		return PTR_ERR(qce->core);
> > @@ -205,10 +209,20 @@ static int qce_crypto_probe(struct platform_device *pdev)
> >  	if (IS_ERR(qce->bus))
> >  		return PTR_ERR(qce->bus);
> >  
> > -	ret = clk_prepare_enable(qce->core);
> > +	ret = clk_prepare_enable(qce->core_src);
> >  	if (ret)
> >  		return ret;
> >  
> > +	ret = clk_set_rate(qce->core_src, 100000000);
> 
> Could you point me from where you got this number? Also I think you
> shouldn't be requesting "core_src" it should be a parent of "core" clock
> in the clock tree. Did you tried to set rate on "core" clock?

Tried it, helps with speed as well.
