From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: tcrypt - Fix AEAD testing
Date: Wed, 30 Jul 2008 20:57:32 +0800
Message-ID: <20080730125732.GA30198@gondor.apana.org.au>
References: <20080730084219.GA28306@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39516 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751777AbYG3M5g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Jul 2008 08:57:36 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KOBFE-0005UW-Pr
	for <linux-crypto@vger.kernel.org>; Wed, 30 Jul 2008 22:57:33 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KOBFE-0007rV-00
	for <linux-crypto@vger.kernel.org>; Wed, 30 Jul 2008 20:57:32 +0800
Content-Disposition: inline
In-Reply-To: <20080730084219.GA28306@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 30, 2008 at 04:42:19PM +0800, Herbert Xu wrote:
> Hi:
> 
> Just noticed a regression I caused:

Hmm, AEAD chunk testing still didn't quite work.  Looks like it's
been broken for a while.  This makes it go again.

commit 3c19fe451e050111d7da607788f09979a7af92e6
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Jul 30 16:23:51 2008 +0800

    crypto: tcrypt - Fix AEAD chunk testing
    
    My changeset 4b22f0ddb6564210c9ded7ba25b2a1007733e784
    
    	crypto: tcrpyt - Remove unnecessary kmap/kunmap calls
    
    introduced a typo that broke AEAD chunk testing.  In particular,
    axbuf should really be xbuf.
    
    There is also an issue with testing the last segment when encrypting.
    The additional part produced by AEAD wasn't tested.  Similarly, on
    decryption the additional part of the AEAD input is mistaken for
    corruption.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 59821a2..6636802 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -481,21 +481,31 @@ next_one:
 
 			for (k = 0, temp = 0; k < template[i].np; k++) {
 				printk(KERN_INFO "page %u\n", k);
-				q = &axbuf[IDX[k]];
-				hexdump(q, template[i].tap[k]);
+				q = &xbuf[IDX[k]];
+
+				n = template[i].tap[k];
+				if (k == template[i].np - 1)
+					n += enc ? authsize : -authsize;
+				hexdump(q, n);
 				printk(KERN_INFO "%s\n",
-				       memcmp(q, template[i].result + temp,
-					      template[i].tap[k] -
-					      (k < template[i].np - 1 || enc ?
-					       0 : authsize)) ?
+				       memcmp(q, template[i].result + temp, n) ?
 				       "fail" : "pass");
 
-				for (n = 0; q[template[i].tap[k] + n]; n++)
-					;
+				q += n;
+				if (k == template[i].np - 1 && !enc) {
+					if (memcmp(q, template[i].input +
+						      temp + n, authsize))
+						n = authsize;
+					else
+						n = 0;
+				} else {
+					for (n = 0; q[n]; n++)
+						;
+				}
 				if (n) {
 					printk("Result buffer corruption %u "
 					       "bytes:\n", n);
-					hexdump(&q[template[i].tap[k]], n);
+					hexdump(q, n);
 				}
 
 				temp += template[i].tap[k];

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
