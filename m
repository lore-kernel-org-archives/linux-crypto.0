From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix JR platform device subsequent
 (re)creations
Date: Wed, 5 Apr 2017 22:08:34 +0800
Message-ID: <20170405140834.GA27150@gondor.apana.org.au>
References: <CAL_JsqLHEycZLaxLZcAnDS4gp6D8xQDpgZXV1g3dokzF_EeQtQ@mail.gmail.com>
 <20170403151204.27488-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>,
        Ruchika Gupta <ruchika.gupta@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37526 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753924AbdDEOOB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 10:14:01 -0400
Content-Disposition: inline
In-Reply-To: <20170403151204.27488-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 03, 2017 at 06:12:04PM +0300, Horia Geantă wrote:
> The way Job Ring platform devices are created and released does not
> allow for multiple create-release cycles.
> 
> JR0 Platform device creation error
> JR0 Platform device creation error
> caam 2100000.caam: no queues configured, terminating
> caam: probe of 2100000.caam failed with error -12
> 
> The reason is that platform devices are created for each job ring:
> 
>         for_each_available_child_of_node(nprop, np)
>                 if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
>                     of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
>                         ctrlpriv->jrpdev[ring] =
>                                 of_platform_device_create(np, NULL, dev);
> 
> which sets OF_POPULATED on the device node, but then it cleans these up:
> 
>         /* Remove platform devices for JobRs */
>         for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
>                 if (ctrlpriv->jrpdev[ring])
>                         of_device_unregister(ctrlpriv->jrpdev[ring]);
>         }
> 
> which leaves OF_POPULATED set.
> 
> Use of_platform_populate / of_platform_depopulate instead.
> This allows for a bit of driver clean-up, jrpdev is no longer needed.
> 
> Logic changes a bit too:
> -exit in case of_platform_populate fails, since currently even QI backend
> depends on JR; true, we no longer support the case when "some" of the JR
> DT nodes are incorrect
> -when cleaning up, caam_remove() would also depopulate RTIC in case
> it would have been populated somewhere else - not the case for now
> 
> Fixes: 313ea293e9c4d ("crypto: caam - Add Platform driver for Job Ring")
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Suggested-by: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
> Not sending this directly to -stable, since it does not apply cleanly.

Patch applied.  I forced it to apply on the crypto tree, then merged
it forward to cryptodev.  Please check the end result and let me know
if it's wrong.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
