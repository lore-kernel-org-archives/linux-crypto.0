From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: PadLock XSHA
Date: Sat, 30 Aug 2008 18:43:16 +1000
Message-ID: <20080830084316.GA19371@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50599 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275AbYH3InX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Aug 2008 04:43:23 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Michal:

Can you remind me the reason why our PadLock SHA implementation
copies things into a page before hashing it?

According to the programming manual, it would seem that the state
should be recorded in EDI after each 64-byte block so we should
be able to use the init/update/final model, no?

Or has the chip changed since we implemented it?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
