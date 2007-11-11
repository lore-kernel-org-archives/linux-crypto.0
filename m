From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] stream: Stream cipher wrapper
Date: Sun, 11 Nov 2007 20:11:51 +0800
Message-ID: <20071111121151.GA14285@gondor.apana.org.au>
References: <fd3e431c0711061137lfa743abwa2be4d563d39e83b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1592 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754149AbXKKML7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Nov 2007 07:11:59 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711061137lfa743abwa2be4d563d39e83b@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 06, 2007 at 07:37:20PM +0000, Tan Swee Heng wrote:
> Added a "stream" template to support stream ciphers (eSTREAM
> candidates in particular) within the CryptoAPI framework.

Thanks for the patch.

Having reviewed it and the specification of Salsa20 I think
we can already support an Salsa20 implementation without the
addition of this new interface.

In fact, thanks the work Joy has done with CTR, the Salsa20
stream cipher can be expressed as

	ctr(salsa20,0,16,8)

where salsa20 is the Salsa20 expansion function.

So could you please update your patches so that it works under
this framework? So your salsa20 simple cipher should be OK as
it is minus the extra bits like setiv.  Plus you should add a
block cipher salsa20 algorithm that just invokes the above CTR
algorithm and constructs the IV in the appropriate manner.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
