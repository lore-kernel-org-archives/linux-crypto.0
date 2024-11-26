Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F211A260
	for <linux-crypto@vger.kernel.org>; Tue, 26 Nov 2024 06:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732603701; cv=none; b=GqCTNH8XxXTllhEE1VUtcf0GF2C3yJ7cM6wyKE8k1Uuyl0olE+cyocp7m2jL/FFXnPpSQG5TFnrNPdrt2E5Uv3MNB799/EjaeCeML03Bwx78q4O0DckJvsegud0VM1Hqhdt0ltIeIq1/b+JXJhG6E+vHd5bclcUfZZyizJbMdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732603701; c=relaxed/simple;
	bh=Ctk1dgnhm49NbtYzSV3G1D1fKfFhlTi7fC9eDW2ePhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DT8qbJ7ok1wOAaoOmrTbQrKy19cm1/gjYy/IfA6wKi3ZZF+yOrreCE/HAkAKG56y7efm42mxhqPDBMZNW14x+vHnasOHYtWSfKVQCuQKmXSCEpY6zOQh0TEON0Qel5UPjNP3C1oOo0+RVnuHRL+yTTIG04UomIxTjEm0fqfqGdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1tFpMn-0000X8-Hw; Tue, 26 Nov 2024 07:48:09 +0100
Message-ID: <ebe0c847-dd72-4145-b32e-774ea30ba183@pengutronix.de>
Date: Tue, 26 Nov 2024 07:48:06 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: caam - use JobR's space to access page 0 regs
To: Gaurav Jain <gaurav.jain@nxp.com>, Horia Geanta <horia.geanta@nxp.com>,
 Pankaj Gupta <pankaj.gupta@nxp.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 Silvano Di Ninno <silvano.dininno@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
 Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
 Sahil Malhotra <sahil.malhotra@nxp.com>,
 Nikolaus Voss <nikolaus.voss@haag-streit.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20241126064607.456633-1-gaurav.jain@nxp.com>
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20241126064607.456633-1-gaurav.jain@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

On 26.11.24 07:46, Gaurav Jain wrote:
> On iMX8DXL/QM/QXP(SECO) & iMX8ULP(ELE) SoCs, access to controller
> region(CAAM page 0) is not permitted from non secure world.
> use JobR's register space to access page 0 registers.
> 
> Fixes: 6a83830f649a ("crypto: caam - warn if blob_gen key is insecure")
> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>

Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

> ---
> 
> changes in v2
> Updated commit message with SoCs details on which CAAM page 0 is not
> accessible from non secure world.
> 
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
>  	if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
>  		dev_warn(jrdev,
>  			 "using insecure test key, enable HAB to use unique device key!\n");


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
