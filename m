From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/6] crypto: talitos - fix GFP flag usage
Date: Thu, 17 Jul 2008 20:17:58 +0800
Message-ID: <20080717121758.GA25267@gondor.apana.org.au>
References: <20080716182215.36c1bd11.kim.phillips@freescale.com> <BDCB5191-EEDE-4046-A741-80E6EF1333CF@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kim Phillips <kim.phillips@freescale.com>,
	linux-crypto@vger.kernel.org,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50665 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758936AbYGQMSF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2008 08:18:05 -0400
Content-Disposition: inline
In-Reply-To: <BDCB5191-EEDE-4046-A741-80E6EF1333CF@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 16, 2008 at 06:33:45PM -0500, Kumar Gala wrote:
> 
> On Jul 16, 2008, at 6:22 PM, Kim Phillips wrote:
> 
> >use GFP_ATOMIC when necessary; use atomic_t when allocating  
> >submit_count.
> 
> why?

You mean why are atomics required? Yes that is a good question.

Kim?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
