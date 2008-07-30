From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: tcrypt - Fix AEAD testing
Date: Wed, 30 Jul 2008 16:42:19 +0800
Message-ID: <20080730084219.GA28306@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59290 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbYG3ImW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Jul 2008 04:42:22 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KO7GF-0001RQ-QW
	for <linux-crypto@vger.kernel.org>; Wed, 30 Jul 2008 18:42:20 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KO7GF-0007N2-00
	for <linux-crypto@vger.kernel.org>; Wed, 30 Jul 2008 16:42:19 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Just noticed a regression I caused:

commit 80cdd7e17b52d343c4fe9d3860f84204ead0d9a0
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Jul 30 16:23:51 2008 +0800

    crypto: tcrypt - Fix AEAD testing
    
    My changeset 4b22f0ddb6564210c9ded7ba25b2a1007733e784
    
    	crypto: tcrpyt - Remove unnecessary kmap/kunmap calls
    
    introduced a typo that broke AEAD chunk testing.  In particular,
    axbuf should really be xbuf.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 59821a2..a25d6e2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -481,7 +481,7 @@ next_one:
 
 			for (k = 0, temp = 0; k < template[i].np; k++) {
 				printk(KERN_INFO "page %u\n", k);
-				q = &axbuf[IDX[k]];
+				q = &xbuf[IDX[k]];
 				hexdump(q, template[i].tap[k]);
 				printk(KERN_INFO "%s\n",
 				       memcmp(q, template[i].result + temp,

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
