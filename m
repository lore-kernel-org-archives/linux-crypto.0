From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] xcbc: Fix algorithm leak when block size check fails
Date: Tue, 1 Jan 2008 15:46:08 +1100
Message-ID: <20080101044607.GA27124@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3044 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751150AbYAAEqL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Dec 2007 23:46:11 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J9Z0y-0005NO-R1
	for <linux-crypto@vger.kernel.org>; Tue, 01 Jan 2008 15:46:09 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J9Z0y-00073q-00
	for <linux-crypto@vger.kernel.org>; Tue, 01 Jan 2008 15:46:08 +1100
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

While back-porting xcbc I found this little buglet.

[CRYPTO] xcbc: Fix algorithm leak when block size check fails

When the underlying algorithm has a block size other than 16 we abort
without freeing it.  In fact, we try to return the algorithm itself
as an error!

This patch plugs the leak and makes it return -EINVAL instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 789cdee..e3d9503 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -307,7 +307,8 @@ static struct crypto_instance *xcbc_alloc(struct rtattr **tb)
 	case 16:
 		break;
 	default:
-		return ERR_PTR(PTR_ERR(alg));
+		inst = ERR_PTR(-EINVAL);
+		goto out_put_alg;
 	}
 
 	inst = crypto_alloc_instance("xcbc", alg);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
