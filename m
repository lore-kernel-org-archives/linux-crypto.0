Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A4CC4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Nov 2022 08:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiKDIug (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Nov 2022 04:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKDIuf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2022 04:50:35 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B0120369;
        Fri,  4 Nov 2022 01:50:32 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oqsOO-00A1Ry-T4; Fri, 04 Nov 2022 16:50:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Nov 2022 16:50:13 +0800
Date:   Fri, 4 Nov 2022 16:50:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nikolaus Voss <nv@vosn.de>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        David Gstir <david@sigma-star.at>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH] crypto: caam: blob_gen.c: warn if key is insecure
Message-ID: <Y2TSRSlefTj6bvYK@gondor.apana.org.au>
References: <20221019134706.E52E71D10@mail.steuer-voss.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019134706.E52E71D10@mail.steuer-voss.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 19, 2022 at 02:44:56PM +0200, Nikolaus Voss wrote:
>
> @@ -62,11 +63,13 @@ int caam_process_blob(struct caam_blob_priv *priv,
>  		      struct caam_blob_info *info, bool encap)
>  {
>  	struct caam_blob_job_result testres;
> +	const struct caam_drv_private *ctrlpriv;

Please keep the declarations sorted by length in reverse.

> @@ -100,6 +103,11 @@ int caam_process_blob(struct caam_blob_priv *priv,
>  		goto out_unmap_in;
>  	}
>  
> +	ctrlpriv = dev_get_drvdata(jrdev->parent);
> +	moo = FIELD_GET(CSTA_MOO, ctrlpriv->ctrl->perfmon.status);
> +	if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
> +		dev_warn(jrdev, "using insecure test key!\n");

Who is the audience of this warning? Is it possible for this warning
to be too frequent?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
