Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7273714A62B
	for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2024 12:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731327752; cv=none; b=hchdXgbUSccihr2c8LW2BiHu0dX6LIBNkTL07dtsn3Uj0el+Is11/7b0OZJgxjM9vdTKmEM08njvQ3lUy4d78vRBAoWW5DKUUgXd+5T84Lb6V0gmA2lMLIwJwEXyDTSU1Cln9UZwxgIqt/4ao2uJWKdRkRcXURKo3xOuzdfa3WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731327752; c=relaxed/simple;
	bh=bZak9OVETM4PZ81zUnrWTTnJZEc86dZkFpbdKddxSsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=egi37sNxSdwCPODSOQg6Xni097etcK9w/JOgZrRzuXsLlkSqu/cbE8nUjvhobPTpKuE2G/cPTiTg3Hy55z55xusVVi+a85eQHPj1FDrIenl6m0vhgPGDKEeUQCUTcEcoqBbWb2+t4PJoh2luu6Ao2m4RSZqjgkRs9ifYlGRvRog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[IPV6:::1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1tATQn-0005JA-Oi; Mon, 11 Nov 2024 13:22:09 +0100
Message-ID: <93e915b3-ef8e-4b98-aa7f-7759ae0b3091@pengutronix.de>
Date: Mon, 11 Nov 2024 13:22:05 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: caam - use JobR's space to access page 0 regs
To: Gaurav Jain <gaurav.jain@nxp.com>, =?UTF-8?Q?Horia_Geant=C4=83?=
 <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Silvano Di Ninno <silvano.dininno@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
 Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
 Sahil Malhotra <sahil.malhotra@nxp.com>,
 Nikolaus Voss <nikolaus.voss@haag-streit.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20241111121020.4013077-1-gaurav.jain@nxp.com>
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20241111121020.4013077-1-gaurav.jain@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

Hello Guarav,

Thanks for your patch.

On 11.11.24 13:10, Gaurav Jain wrote:
> Access to controller region is not permitted.

It's permitted on most of the older SoCs. Please mention on which SoCs
this is no longer true and which SoCs you tested your change on.

> use JobR's register space to access page 0 registers.
> 
> Fixes: 6a83830f649a ("crypto: caam - warn if blob_gen key is insecure")

Did the CAAM even support any of the SoCs, where this doesn't work anymore
back when the code was mainlined?

> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> ---
>  drivers/crypto/caam/blob_gen.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/blob_gen.c b/drivers/crypto/caam/blob_gen.c
> index 87781c1534ee..079a22cc9f02 100644
> --- a/drivers/crypto/caam/blob_gen.c
> +++ b/drivers/crypto/caam/blob_gen.c
> @@ -2,6 +2,7 @@
>  /*
>   * Copyright (C) 2015 Pengutronix, Steffen Trumtrar <kernel@pengutronix.de>
>   * Copyright (C) 2021 Pengutronix, Ahmad Fatoum <kernel@pengutronix.de>
> + * Copyright 2024 NXP
>   */
>  
>  #define pr_fmt(fmt) "caam blob_gen: " fmt
> @@ -104,7 +105,7 @@ int caam_process_blob(struct caam_blob_priv *priv,
>  	}
>  
>  	ctrlpriv = dev_get_drvdata(jrdev->parent);
> -	moo = FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->ctrl->perfmon.status));
> +	moo = FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->jr[0]->perfmon.status));

I believe your change is correct, but I would prefer that ctrlpriv gets a perfmon
member that is initialized in caam_probe to either &ctrlpriv->ctrl->perfmon.status
or &ctrlpriv->jr[0]->perfmon.status and then the code here would just use
&ctrlpriv->perfmon->status.

This would simplify code not only here, but also in caam_ctrl_rng_init.

Thanks,
Ahmad


>  	if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
>  		dev_warn(jrdev,
>  			 "using insecure test key, enable HAB to use unique device key!\n");


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
