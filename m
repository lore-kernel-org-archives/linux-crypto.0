From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH 1/4] crypto: caam/jr - add support for DPAA2 parts
Date: Thu, 3 Aug 2017 14:09:50 +0800
Message-ID: <20170803060950.GA12039@gondor.apana.org.au>
References: <20170718153050.15330-1-horia.geanta@nxp.com>
 <20170718153050.15330-2-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170718153050.15330-2-horia.geanta-3arQi8VN3Tc@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 06:30:47PM +0300, Horia Geantă wrote:
> Add support for using the caam/jr backend on DPAA2-based SoCs.
> These have some particularities we have to account for:
> -HW S/G format is different
> -Management Complex (MC) firmware initializes / manages (partially)
> the CAAM block: MCFGR, QI enablement in QICTL, RNG
> 
> Signed-off-by: Horia Geantă <horia.geanta-3arQi8VN3Tc@public.gmane.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
