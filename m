From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH 0/3] ARM: sun6i: Support Security System crypto engine
Date: Thu, 13 Aug 2015 15:16:26 +0800
Message-ID: <20150813071626.GA21239@gondor.apana.org.au>
References: <1439271177-26523-1-git-send-email-wens@csie.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439271177-26523-1-git-send-email-wens-jdAy2FN1RRM@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 11, 2015 at 01:32:54PM +0800, Chen-Yu Tsai wrote:
> Hi everyone,
> 
> This series enables support for the crypto engine found in sun6i, or
> Allwinner A31/A31s SoCs. The crypto engine is the same hardware as on
> earlier sun4i/sun7i (A10/A20), with the only difference being the reset
> control is separated out of the clock gate control.
> 
> The same hardware is also available on the A33, but not the A23. Support
> for this requires additions to the clock driver, and will be submitted
> separately once things are clear on how to proceed. I already have a
> proof of concept working.
> 
> 
> Patch 1 adds an optional reset control property to the sunxi-ss binding.
> 
> Patch 2 adds optional reset control support to the sunxi-ss driver.
> 
> Patch 3 enables the crypto engine on sun6i, by adding the module clock and
> device node.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
