From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] tcrypt: add self test for des3_ebe cipher operating in cbc mode
Date: Sat, 24 May 2008 10:06:25 +1000
Message-ID: <20080524000624.GB26747@gondor.apana.org.au>
References: <20080523195145.GA28328@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38156 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151AbYEXAG1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 May 2008 20:06:27 -0400
Content-Disposition: inline
In-Reply-To: <20080523195145.GA28328@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Neil:

On Fri, May 23, 2008 at 04:18:55PM -0400, Neil Horman wrote:
> Patch to add checking of DES3 test vectors using CBC mode.  FIPS-1402-2
> compliance mandates that any supported mode of oepration must include a self
> test.  This satisfies that requirement for cbc(des_ebe).  Tested successfully by
> me

Could you document the source of these vectors in the patch
description please?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
