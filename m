From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH RESEND v2 0/4] hwrng: atmel: add DT support
Date: Thu, 20 Nov 2014 22:43:49 +0800
Message-ID: <20141120144349.GC32061@gondor.apana.org.au>
References: <cover.1416475860.git.nicolas.ferre@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org,
	Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>,
	robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	peter-+2lRwdCCLRT2eFz/2MeuCQ@public.gmane.org
To: Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1416475860.git.nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 20, 2014 at 10:43:21AM +0100, Nicolas Ferre wrote:
> This is the patch series that Boris sent yesterday. I've just collected
> "Acked-by" tags and resend it with updated cover letter.
> 
> This series adds DT support for the TRNG (True Random Generator) block and adds
> missing trng nodes to at91sam9g45 dtsi files.
> 
> Herbert,
> As you said that you can take this series, here is the latest vertion ready for you to
> pick it up. Thanks for your help.
> 
> Bye,
> 
> Boris Brezillon (4):
>   hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
>   hwrng: atmel: add DT support
>   hwrng: atmel: Add TRNG DT binding doc
>   ARM: at91/dt: add trng node to at91sam9g45

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
