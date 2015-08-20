From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: skcipher - Introduce new skcipher interface
Date: Thu, 20 Aug 2015 15:20:55 +0800
Message-ID: <20150820072055.GA27176@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45628 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbbHTHU7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 03:20:59 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

These two patches introduce a new skcipher interface that aims
to replace the existing blkcipher and ablkcipher interfaces.  A
bit of history, the blkcipher interface was originally split from
the cipher interface in order to differentiate the underly block
cipher algorithm from the modes such as ECB/CBC.  Later ablkcipher
was added in order to support hardware devices.

Unlike the shash/ahash split, both blkcipher and ablkcipher operate
on SG lists.  Therefore there is really no need to maintain them
as separate interfaces.

The new skcipher interface is essentially identical to ablkcipher
but without the implicit IV generators that have been rendered
obsolete by the new AEAD interface.

The next step in the process is to convert existing users over
to skcipher.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
