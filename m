From: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] crypto: caam - add Job Ring support for DPAA2 parts
Date: Tue, 25 Jul 2017 21:21:30 +0800
Message-ID: <20170725132129.GB29754@dragon>
References: <20170718153050.15330-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170718153050.15330-1-horia.geanta-3arQi8VN3Tc@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 18, 2017 at 06:30:46PM +0300, Horia Geantă wrote:
> This patch set adds support for CAAM's legacy Job Ring backend / interface
> on platforms having DPAA2 (Datapath Acceleration Architecture v2), like
> LS1088A or LS2088A.
> 
> I would like to get the DT patches through the crypto list (to make sure
> they don't end up merged before driver support).

Unless it's really urgent (usually critical bug fix), the DTS patches
should go through arm-soc tree.  We usually take DTS patches after the
driver counterpart has been accepted by subsystem maintainers, or in the
best case, has landed on mainline.

Shawn
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
