From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/5] crypto: cryptomgr - Add test infrastructure
Date: Thu, 21 Aug 2008 21:19:00 +1000
Message-ID: <20080821111900.GA4941@gondor.apana.org.au>
References: <20080804065958.GA8264@gondor.apana.org.au> <E1KPu5X-0002Au-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50508 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756589AbYHULTE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Aug 2008 07:19:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KW8Bx-0005b3-CJ
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2008 21:19:01 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KW8Bx-0001I0-00
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2008 21:19:01 +1000
Content-Disposition: inline
In-Reply-To: <E1KPu5X-0002Au-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 04, 2008 at 03:02:39PM +0800, Herbert Xu wrote:
> crypto: cryptomgr - Add test infrastructure

I've changed cryptomgr_init to a subsys_initcall so that when
it's built-in it gets called before any built-in algorithms try
to register themselves.

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 0cc6913..4601e42 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -293,7 +293,7 @@ static void __exit cryptomgr_exit(void)
 	testmgr_exit();
 }
 
-module_init(cryptomgr_init);
+subsys_initcall(cryptomgr_init);
 module_exit(cryptomgr_exit);
 
 MODULE_LICENSE("GPL");

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
