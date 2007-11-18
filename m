From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] salsa20: Salsa20 stream cipher
Date: Sun, 18 Nov 2007 23:46:26 +0800
Message-ID: <20071118154626.GA29523@gondor.apana.org.au>
References: <fd3e431c0711151152t3df5b833s37238a5625ff6e63@mail.gmail.com> <fd3e431c0711180729m63086783x7e69bc5e4e28920d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1790 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750854AbXKRPqa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 10:46:30 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711180729m63086783x7e69bc5e4e28920d@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 18, 2007 at 11:29:52PM +0800, Tan Swee Heng wrote:
> This patch implements the Salsa20 stream cipher using the blkcipher interface.
> 
> The core cipher code comes from Daniel Bernstein's submission to eSTREAM:
>   http://www.ecrypt.eu.org/stream/svn/viewcvs.cgi/ecrypt/trunk/submissions/salsa20/full/ref/
> 
> The test vectors comes from:
>   http://www.ecrypt.eu.org/stream/svn/viewcvs.cgi/ecrypt/trunk/submissions/salsa20/full/
> 
> It has been tested successfully with "modprobe tcrypt mode=34" on an
> UML instance.
> 
> Regards,
> Swee Heng
> 
> Signed-off-by: Tan Swee Heng <thesweeheng@gmail.com>

Patch applied.  Thanks for the quick response!

BTW I made a small change to the Kconfig file so that it now selects
BLKCIPHER instead of ALGAPI.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
