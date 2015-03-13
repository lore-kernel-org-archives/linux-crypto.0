From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] omap-rng: Change RNG_CONFIG_REG to RNG_CONTROL_REG when
 checking and disabling TRNG
Date: Fri, 13 Mar 2015 21:07:18 +1100
Message-ID: <20150313100718.GA966@gondor.apana.org.au>
References: <1426048175-17760-1-git-send-email-Andre.Wolokita@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andre Wolokita <Andre.Wolokita@analog.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:52993 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbCMKHq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 06:07:46 -0400
Content-Disposition: inline
In-Reply-To: <1426048175-17760-1-git-send-email-Andre.Wolokita@analog.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 11, 2015 at 03:29:35PM +1100, Andre Wolokita wrote:
> In omap4_rng_init(), a check of bit 10 of the RNG_CONFIG_REG is done to determine
> whether the RNG is running. This is suspicious firstly due to the use of
> RNG_CONTROL_ENABLE_TRNG_MASK and secondly because the same mask is written to
> RNG_CONTROL_REG after configuration of the FROs. Similar suspicious logic is
> repeated in omap4_rng_cleanup() when RNG_CONTROL_REG masked with
> RNG_CONTROL_ENABLE_TRNG_MASK is read, the same mask bit is cleared, and then
> written to RNG_CONFIG_REG. Unless the TRNG is enabled with one bit in RNG_CONTROL
> and disabled with another in RNG_CONFIG and these bits are mirrored in some way,
> I believe that the TRNG is not really shutting off.
> 
> Apart from the strange logic, I have reason to suspect that the OMAP4 related
> code in this driver is driving an Inside Secure IP hardware RNG and strongly
> suspect that bit 10 of RNG_CONFIG_REG is one of the bits configuring the
> sampling rate of the FROs. This option is by default set to 0 and is not being
> set anywhere in omap-rng.c. Reading this bit during omap4_rng_init() will
> always return 0. It will remain 0 because ~(value of TRNG_MASK in control) will
> always be 0, because the TRNG is never shut off. This is of course presuming
> that the OMAP4 features the Inside Secure IP.
> 
> I'm interested in knowing what the guys at TI think about this, as only they
> can confirm or deny the detailed structure of these registers.

Where is the sign-off?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
