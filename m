From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/7] [CRYPTO]: Complete transition away from crypto_tfm
Date: Sat, 2 Sep 2006 21:05:20 +1000
Message-ID: <20060902110520.GA4690@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37392 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751040AbWIBLFW
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Sep 2006 07:05:22 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

This patch series finishes the conversion from crypto_tfm to typed
types such as crypto_cipher.

It also changes padlock-sha to use selection by type to locate the
fallback.

Last but not least there is an optimisation for generic CBC decryption.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
VGER BF report: H 0.0426369
