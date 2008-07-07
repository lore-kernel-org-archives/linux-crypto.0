From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Mon, 7 Jul 2008 15:18:18 +0800
Message-ID: <20080707071818.GA8756@gondor.apana.org.au>
References: <20080703201924.GA5237@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43125 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751224AbYGGHSX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2008 03:18:23 -0400
Content-Disposition: inline
In-Reply-To: <20080703201924.GA5237@hmsendeavour.rdu.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 03, 2008 at 04:19:24PM -0400, Neil Horman wrote:
> This patchset add a pseudo random number generator to the kernel crypto library.
> Usefull in assisting with the implementation of various FIPS compliant ipsec
> algorithms.  Based on the suggestions provided in ANSI X9.31 Appendix A.2.4.
> Tested successfully by myself.  Set consists of two parts:
> 1/2: creation of files prng.c and prng.h
> 2/2: Addition of Kconfig & Makefile rules to build code
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

All applied to cryptodev-2.6.  Thanks Neil!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
