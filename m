From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Wed, 16 Jul 2008 20:45:33 +0800
Message-ID: <20080716124533.GA16103@gondor.apana.org.au>
References: <20080703202102.GB5237@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53455 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752049AbYGPMpg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 08:45:36 -0400
Content-Disposition: inline
In-Reply-To: <20080703202102.GB5237@hmsendeavour.rdu.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 03, 2008 at 04:21:02PM -0400, Neil Horman wrote:
>
> + * See http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
> + * for implementation details

BTW, any reason why counter mode is used? This document specifies
simple AES only, with no modes of operations.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
