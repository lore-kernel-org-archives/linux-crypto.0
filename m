From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add optional continuous repetition test to
	entropy store based rngs
Date: Fri, 5 Jun 2009 10:30:06 +1000
Message-ID: <20090605003006.GA5236@gondor.apana.org.au>
References: <20090604195030.GA11300@hmsreliant.think-freely.org> <1244146450.22069.216.camel@calx> <20090605000456.GA10883@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57797 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751202AbZFEAaP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2009 20:30:15 -0400
Content-Disposition: inline
In-Reply-To: <20090605000456.GA10883@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 04, 2009 at 08:04:56PM -0400, Neil Horman wrote:
>
> Not sure what to do about this.  The intent is to provide the external reference
> to the fips_enabled flag (which is either defined as an extern in or #defined to
> 0 dependent on CONFIG_CRYPTO_FIPS).  I can cut'n'paste the code block from the
> include file and put it in here, but that seems like a worse solution to me.
> Let me know your thoughts, and I can change this accordingly.

You can put the fips flag into its own header file, e.g., linux/fips.h.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
