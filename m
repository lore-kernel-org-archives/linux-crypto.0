From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ansi_cprng - Fix module initialization
Date: Sat, 29 Aug 2009 17:36:46 +1000
Message-ID: <20090829073646.GB12104@gondor.apana.org.au>
References: <20090825081416.GC14755@secunet.com> <20090825105900.GB24710@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36770 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751264AbZH2Hgx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Aug 2009 03:36:53 -0400
Content-Disposition: inline
In-Reply-To: <20090825105900.GB24710@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 25, 2009 at 06:59:00AM -0400, Neil Horman wrote:
> On Tue, Aug 25, 2009 at 10:14:16AM +0200, Steffen Klassert wrote:
> > Return the value we got from crypto_register_alg() instead of
> > returning 0 in any case.
> > 
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
