Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE98C3A5A6
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 16:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71066214AF
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 16:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568912164;
	bh=zsfPmeUZCZdmuEtRS/K6Wqpv2tm4qLC9eXVgWfIrPAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tYb+wyPzA58aPigD40VR1kF5jEpLKcCBNCvTts1H21YLocaiaD+voPZ6fUjw1cbPt
	 MzDT5V8nfdjlwRIQsD3IfcJfwCpCLLubLExLWARJCl8VKxEnAnm3kM7cYg/zT0+o3W
	 st4AYna1aJ02m6FL3nBa3FACbXQ0Kvreo3zlD3YQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389253AbfISQ4D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 12:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388945AbfISQ4D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 12:56:03 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE9D9206C2;
        Thu, 19 Sep 2019 16:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568912162;
        bh=zsfPmeUZCZdmuEtRS/K6Wqpv2tm4qLC9eXVgWfIrPAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u4g6J2LMzhF7guyY4SPvfR9r4kprWzEm6OSCjCaYm6nPTL1zNWUWZNqz7TkJHg7si
         sScSk5E7uMoq7IPXbonY1O8Q4zscoRZKH+eS9CLRj8PXFoHCZ8Ola2hyqQ2aMRpQBo
         YjL6OTFJVfJ/tVQkgvwsKUHP83mOX1bSDr1eWhBo=
Date:   Thu, 19 Sep 2019 18:55:59 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 2/2] crypto: sun4i-ss: enable pm_runtime
Message-ID: <20190919165559.e7xyapggcwp2ukdt@gilmour>
References: <20190919051035.4111-1-clabbe.montjoie@gmail.com>
 <20190919051035.4111-3-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m4buvghxnpijbdft"
Content-Disposition: inline
In-Reply-To: <20190919051035.4111-3-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--m4buvghxnpijbdft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Sep 19, 2019 at 07:10:35AM +0200, Corentin Labbe wrote:
> This patch enables power management on the Security System.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |  9 +++
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 94 +++++++++++++++++++----
>  drivers/crypto/sunxi-ss/sun4i-ss-hash.c   | 12 +++
>  drivers/crypto/sunxi-ss/sun4i-ss-prng.c   |  9 ++-
>  drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +
>  5 files changed, 110 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> index fa4b1b47822e..c9799cbe0530 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> @@ -480,6 +480,7 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
>  	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
>  	struct sun4i_ss_alg_template *algt;
>  	const char *name = crypto_tfm_alg_name(tfm);
> +	int err;
>
>  	memset(op, 0, sizeof(struct sun4i_tfm_ctx));
>
> @@ -497,13 +498,21 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
>  		return PTR_ERR(op->fallback_tfm);
>  	}
>
> +	err = pm_runtime_get_sync(op->ss->dev);
> +	if (err < 0)
> +		goto error_pm;
>  	return 0;

Newline here

> +error_pm:
> +	crypto_free_sync_skcipher(op->fallback_tfm);
> +	return err;
>  }
>
>  void sun4i_ss_cipher_exit(struct crypto_tfm *tfm)
>  {
>  	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
> +
>  	crypto_free_sync_skcipher(op->fallback_tfm);
> +	pm_runtime_put(op->ss->dev);
>  }
>
>  /* check and set the AES key, prepare the mode to be used */
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> index 6c2db5d83b06..311c2653a9c3 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> @@ -44,7 +44,8 @@ static struct sun4i_ss_alg_template ss_algs[] = {
>  				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun4i_req_ctx),
>  				.cra_module = THIS_MODULE,
> -				.cra_init = sun4i_hash_crainit
> +				.cra_init = sun4i_hash_crainit,
> +				.cra_exit = sun4i_hash_craexit

You should add a comma at the end to prevent having to modify it again

>  			}
>  		}
>  	}
> @@ -70,7 +71,8 @@ static struct sun4i_ss_alg_template ss_algs[] = {
>  				.cra_blocksize = SHA1_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct sun4i_req_ctx),
>  				.cra_module = THIS_MODULE,
> -				.cra_init = sun4i_hash_crainit
> +				.cra_init = sun4i_hash_crainit,
> +				.cra_exit = sun4i_hash_craexit

Ditto

>  			}
>  		}
>  	}
> @@ -262,6 +264,61 @@ static int sun4i_ss_enable(struct sun4i_ss_ctx *ss)
>  	return err;
>  }
>
> +/*
> + * Power management strategy: The device is suspended unless a TFM exists for
> + * one of the algorithms proposed by this driver.
> + */
> +#if defined(CONFIG_PM)
> +static int sun4i_ss_pm_suspend(struct device *dev)
> +{
> +	struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
> +
> +	sun4i_ss_disable(ss);
> +	return 0;
> +}
> +
> +static int sun4i_ss_pm_resume(struct device *dev)
> +{
> +	struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
> +
> +	return sun4i_ss_enable(ss);
> +}
> +#endif
> +

Why not just have the suspend and resume function and the enable /
disable functions merged together, you're not using them directy as
far as I can see.

> +const struct dev_pm_ops sun4i_ss_pm_ops = {
> +	SET_RUNTIME_PM_OPS(sun4i_ss_pm_suspend, sun4i_ss_pm_resume, NULL)
> +};
> +
> +/*
> + * When power management is enabled, this function enables the PM and set the
> + * device as suspended
> + * When power management is disabled, this function just enables the device
> + */
> +static int sun4i_ss_pm_init(struct sun4i_ss_ctx *ss)
> +{
> +	int err;
> +
> +	pm_runtime_use_autosuspend(ss->dev);
> +	pm_runtime_set_autosuspend_delay(ss->dev, 2000);
> +
> +	err = pm_runtime_set_suspended(ss->dev);
> +	if (err)
> +		return err;
> +	pm_runtime_enable(ss->dev);
> +#if !defined(CONFIG_PM)
> +	err = sun4i_ss_enable(ss);
> +#endif
> +	return err;
> +}

This looks nicer:
https://elixir.bootlin.com/linux/latest/source/drivers/spi/spi-sun4i.c#L492

Or, just make it depend on CONFIG_PM, we should probably do it anyway
at the ARCH level anyway.

Maxime

--m4buvghxnpijbdft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXYOzHwAKCRDj7w1vZxhR
xUwDAP9O9xdsnOnkb0SasX2EtOGv2LlMjbgmiiXL09f4KZYYggEAjIdC2vHA8T6J
paJO7YWU8+BcPkZ4sPIudoliIvHaxw0=
=S4zM
-----END PGP SIGNATURE-----

--m4buvghxnpijbdft--
