From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in cbc mode
Date: Thu, 22 May 2008 08:03:00 +0800
Message-ID: <20080522000300.GC27138@gondor.apana.org.au>
References: <20080521200938.GA29631@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60313 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758519AbYEVADD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2008 20:03:03 -0400
Content-Disposition: inline
In-Reply-To: <20080521200938.GA29631@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 21, 2008 at 04:09:38PM -0400, Neil Horman wrote:
> Patch to add checking of DES3 test vectors using CBC mode.  FIPS-1402-2
> compliance mandates that any supported mode of oepration must include a self
> test.  This satisfies that requirement for cbc(des_ebe).  Tested successfully by
> me

Sorry but this makes no sense.  The test vectors you're feeding
into it are only one block long.  For a single block (and no IV)
there is no difference between ECB and CBC.  So please add some
real CBC test vectors for this.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
