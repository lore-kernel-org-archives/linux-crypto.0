From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: sha-s390 - Reset index after processing partial block
Date: Mon, 7 Feb 2011 20:28:17 +1100
Message-ID: <20110207092817.GA16881@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36515 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1BGJ2Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Feb 2011 04:28:25 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This patch fixes an old but nasty bug in the sha-s390 code.

commit 9d20b571f5bda7273656e1b86ef91eddc94adacc
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Feb 7 20:26:06 2011 +1100

    crypto: sha-s390 - Reset index after processing partial block
    
    The partial block handling in sha-s390 is broken when we get a
    partial block that is followed by an update which fills it with
    bytes left-over.  Instead of storing the newly left-over bytes
    at the start of the buffer, it will be stored immediately after
    the previous partial block.
    
    This patch fixes this by resetting the index pointer.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index f42dbab..48884f8 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -38,6 +38,7 @@ int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 		BUG_ON(ret != bsize);
 		data += bsize - index;
 		len -= bsize - index;
+		index = 0;
 	}
 
 	/* process as many blocks as possible */

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
