From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/30] crypto: skcipher - skcipher algorithm conversion part 2
Date: Tue, 12 Jul 2016 13:15:55 +0800
Message-ID: <20160712051554.GA28324@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48907 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbcGLFP6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:15:58 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This patch series continues the task of converting blkcipher and
ablkcipher implementations over to the unified skcipher interface.

It includes a repost of patches in the previous series which have
not been included because of the addition of the chunksize parameter
(block size for stream ciphers and the like which still need to be
processed in blocks except for the last one).

This series also removes the top-level blkcipher/ablkcipher entry
points, meaning that while they can still be used by internal crypto
entities such as cryptd, they can no longer be allocated from the
outside.

Finally this series introduces a new skcipher walk interface that
combines both blkcipher walk and ablkcipher walk into one.  This
is then used in the conversion of the lrw algorithm to skcipher.

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
