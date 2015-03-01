From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3] hwrng: omap - Change RNG_CONFIG_REG to RNG_CONTROL_REG
 when, checking and disabling TRNG
Date: Sun, 1 Mar 2015 23:02:11 +1300
Message-ID: <20150301100211.GA15959@gondor.apana.org.au>
References: <54E6BA01.7090904@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lokeshvutla@ti.com, dsaxena@plexity.net,
	linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org
To: Andre Wolokita <andre.wolokita@analog.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45447 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbbCAKDy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Mar 2015 05:03:54 -0500
Content-Disposition: inline
In-Reply-To: <54E6BA01.7090904@analog.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 20, 2015 at 03:37:21PM +1100, Andre Wolokita wrote:
> In omap4_rng_init(), a check of bit 10 of the RNG_CONFIG_REG is done to determine
> whether the RNG is running. This is suspicious firstly due to the use of
> RNG_CONTROL_ENABLE_TRNG_MASK and secondly because the same mask is written to
> RNG_CONTROL_REG after configuration of the FROs. Similar suspicious logic is
> repeated in omap4_rng_cleanup() when RNG_CONTROL_REG masked with
> RNG_CONTROL_ENABLE_TRNG_MASK is read, the same mask bit is cleared, and then
> written to RNG_CONFIG_REG. Unless the TRNG is enabled with one bit in RNG_CONTROL
> and disabled with another in RNG_CONFIG and these bits are mirrored in some way,
> I believe that the TRNG is not really shutting off, leaving the FROs running
> indefinitely which, in an extreme case, could lead to degredation of the
> hardware and potentially reduce the level of entropy generated.
> 
> Apart from the strange logic, I have reason to suspect that the OMAP4 related
> code in this driver is driving an Inside Secure IP hardware RNG and strongly
> suspect that bit 10 of RNG_CONFIG_REG is one of the bits configuring the
> sampling rate of the FROs. This option is by default set to 0 and is not being
> set anywhere in omap-rng.c. Reading this bit during omap4_rng_init() will
> always return 0. It will remain 0 because ~(value of TRNG_MASK in control) will
> always be 0, because the TRNG is never shut off. This is of course presuming
> that the OMAP4 features the Inside Secure IP, which I strongly suspect.
> 
> I'm interested in knowing what the guys at TI think about this, as only they
> can confirm or deny the detailed structure of these registers.
> 
> Signed-off-by: Andre Wolokita <Andre.Wolokita@analog.com>

Your patch is white-space damaged.  Please fix and resubmit.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
