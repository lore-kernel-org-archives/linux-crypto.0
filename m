Return-Path: <SRS0=uYt1=XS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21E5C4740C
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Sep 2019 07:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A89E22089F
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Sep 2019 07:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mqA8fY2+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390911AbfIWHxa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Sep 2019 03:53:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38277 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390655AbfIWHxa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Sep 2019 03:53:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id 3so8081736wmi.3;
        Mon, 23 Sep 2019 00:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UpxK2Urn4a9eY/kYII4628rmtr2h95p2aQmCQljgxpY=;
        b=mqA8fY2+eWN+vcKQziUdBV9fHCdd+vWnip0ZQdaztG9Sg8wT8RdOyBUEKNJFPBuOV4
         +YvY28Z8AOIqHUHSdGfFOhN52CHc0nVd/za9X0Gpq3PWd3YcSQdRrCqMEGz6j1JB5VlE
         R8GE8E4Ubg1comHkA2SKsdsGcInoqIjqdgXLetveYddXwl3xlGDTBla9U0nQLDztfAdE
         7bNM/1FZZmQIYKe1AmBRj3SP0FVRcyyHmszsPvj+DbF6e7lBxLqAgrIARwW8eLQEd45h
         QRFP749ZqiRw/agThbNzldYi47qw6MJMVWfcEotR5NPg7taV0jqXNUhO8U8rrs0dAuVx
         yZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UpxK2Urn4a9eY/kYII4628rmtr2h95p2aQmCQljgxpY=;
        b=RzHHkjDabSLLtTKZyiSMIiwNuw+E2s4N2tQig8RBuvQg2ewfxAWILOpSEHgIn7KUVp
         lpGe6joCbAfRJpaqBcxPM+v79cjhfFr7O4eLDTXSUrN440ijZrWxZ5VtKn2qIzdvIr+k
         2hu6WfRNt9KySMkN8OwePjUNXCS+TfcFtjpIPeBsOIhUo9bUvIvR4FSBUTbh2XvtO4T9
         VTaSSWCnSTh9FaNU6I4Z4es4vi9dd5/PyQHBFxl6/He0s42CKxVezcmGQsjHzL7SSLIM
         owjBzfnBFIEzkpvYUQAmPF/1Ob5Ay0JO580GS5M5VaV5C10FGPQ1b2oaU/BInJxzlbjh
         Q3qw==
X-Gm-Message-State: APjAAAUjb3ReR5KnzAbHzaIj+i/AhxuvWLXrP1I3X0uv6GwAGIj9TA/d
        8UMOI0s3ffV7LoiDmAruHeGIWpoN
X-Google-Smtp-Source: APXvYqzHqDXmLy6DqjIE9EP+6gqb0JSKrhT9t4CpwFD0zLjZCG+9y75TadrJV0ce3050t0e0mrFKDg==
X-Received: by 2002:a1c:9956:: with SMTP id b83mr12316396wme.63.1569225207034;
        Mon, 23 Sep 2019 00:53:27 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 189sm22166938wma.6.2019.09.23.00.53.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Sep 2019 00:53:26 -0700 (PDT)
Date:   Mon, 23 Sep 2019 09:53:24 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 2/2] crypto: sun4i-ss: enable pm_runtime
Message-ID: <20190923075324.GA1599@Red>
References: <20190919051035.4111-1-clabbe.montjoie@gmail.com>
 <20190919051035.4111-3-clabbe.montjoie@gmail.com>
 <20190919165559.e7xyapggcwp2ukdt@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919165559.e7xyapggcwp2ukdt@gilmour>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 19, 2019 at 06:55:59PM +0200, Maxime Ripard wrote:
> Hi,
> 
> On Thu, Sep 19, 2019 at 07:10:35AM +0200, Corentin Labbe wrote:
> > This patch enables power management on the Security System.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |  9 +++
> >  drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 94 +++++++++++++++++++----
> >  drivers/crypto/sunxi-ss/sun4i-ss-hash.c   | 12 +++
> >  drivers/crypto/sunxi-ss/sun4i-ss-prng.c   |  9 ++-
> >  drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +
> >  5 files changed, 110 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> > index fa4b1b47822e..c9799cbe0530 100644
> > --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> > +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> > @@ -480,6 +480,7 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
> >  	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
> >  	struct sun4i_ss_alg_template *algt;
> >  	const char *name = crypto_tfm_alg_name(tfm);
> > +	int err;
> >
> >  	memset(op, 0, sizeof(struct sun4i_tfm_ctx));
> >
> > @@ -497,13 +498,21 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
> >  		return PTR_ERR(op->fallback_tfm);
> >  	}
> >
> > +	err = pm_runtime_get_sync(op->ss->dev);
> > +	if (err < 0)
> > +		goto error_pm;
> >  	return 0;
> 
> Newline here
> 
> > +error_pm:
> > +	crypto_free_sync_skcipher(op->fallback_tfm);
> > +	return err;
> >  }
> >
> >  void sun4i_ss_cipher_exit(struct crypto_tfm *tfm)
> >  {
> >  	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
> > +
> >  	crypto_free_sync_skcipher(op->fallback_tfm);
> > +	pm_runtime_put(op->ss->dev);
> >  }
> >
> >  /* check and set the AES key, prepare the mode to be used */
> > diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > index 6c2db5d83b06..311c2653a9c3 100644
> > --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > @@ -44,7 +44,8 @@ static struct sun4i_ss_alg_template ss_algs[] = {
> >  				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
> >  				.cra_ctxsize = sizeof(struct sun4i_req_ctx),
> >  				.cra_module = THIS_MODULE,
> > -				.cra_init = sun4i_hash_crainit
> > +				.cra_init = sun4i_hash_crainit,
> > +				.cra_exit = sun4i_hash_craexit
> 
> You should add a comma at the end to prevent having to modify it again
> 
> >  			}
> >  		}
> >  	}
> > @@ -70,7 +71,8 @@ static struct sun4i_ss_alg_template ss_algs[] = {
> >  				.cra_blocksize = SHA1_BLOCK_SIZE,
> >  				.cra_ctxsize = sizeof(struct sun4i_req_ctx),
> >  				.cra_module = THIS_MODULE,
> > -				.cra_init = sun4i_hash_crainit
> > +				.cra_init = sun4i_hash_crainit,
> > +				.cra_exit = sun4i_hash_craexit
> 
> Ditto
> 
> >  			}
> >  		}
> >  	}
> > @@ -262,6 +264,61 @@ static int sun4i_ss_enable(struct sun4i_ss_ctx *ss)
> >  	return err;
> >  }
> >
> > +/*
> > + * Power management strategy: The device is suspended unless a TFM exists for
> > + * one of the algorithms proposed by this driver.
> > + */
> > +#if defined(CONFIG_PM)
> > +static int sun4i_ss_pm_suspend(struct device *dev)
> > +{
> > +	struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
> > +
> > +	sun4i_ss_disable(ss);
> > +	return 0;
> > +}
> > +
> > +static int sun4i_ss_pm_resume(struct device *dev)
> > +{
> > +	struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
> > +
> > +	return sun4i_ss_enable(ss);
> > +}
> > +#endif
> > +
> 
> Why not just have the suspend and resume function and the enable /
> disable functions merged together, you're not using them directy as
> far as I can see.
> 
> > +const struct dev_pm_ops sun4i_ss_pm_ops = {
> > +	SET_RUNTIME_PM_OPS(sun4i_ss_pm_suspend, sun4i_ss_pm_resume, NULL)
> > +};
> > +
> > +/*
> > + * When power management is enabled, this function enables the PM and set the
> > + * device as suspended
> > + * When power management is disabled, this function just enables the device
> > + */
> > +static int sun4i_ss_pm_init(struct sun4i_ss_ctx *ss)
> > +{
> > +	int err;
> > +
> > +	pm_runtime_use_autosuspend(ss->dev);
> > +	pm_runtime_set_autosuspend_delay(ss->dev, 2000);
> > +
> > +	err = pm_runtime_set_suspended(ss->dev);
> > +	if (err)
> > +		return err;
> > +	pm_runtime_enable(ss->dev);
> > +#if !defined(CONFIG_PM)
> > +	err = sun4i_ss_enable(ss);
> > +#endif
> > +	return err;
> > +}
> 
> This looks nicer:
> https://elixir.bootlin.com/linux/latest/source/drivers/spi/spi-sun4i.c#L492
> 
> Or, just make it depend on CONFIG_PM, we should probably do it anyway
> at the ARCH level anyway.
> 

Hello

I usually prefer to give choice (PM vs not PM), but it simplify a lot the code to depend on PM, so I will go for it.

Thanks
