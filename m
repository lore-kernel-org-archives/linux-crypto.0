From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: VIA Padlock driver no longer loads automatically
Date: Tue, 21 Apr 2009 13:56:13 +0800
Message-ID: <20090421055613.GA14319@gondor.apana.org.au>
References: <20090420181402.2b0424f4@dhcp-100-2-144.bos.redhat.com> <20090421055331.GA14062@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41791 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484AbZDUF4Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2009 01:56:16 -0400
Content-Disposition: inline
In-Reply-To: <20090421055331.GA14062@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 21, 2009 at 01:53:31PM +0800, Herbert Xu wrote:
> 
> Thanks for the report.  This patch should fix the problem.

In fact, padlock-aes shouldn't have been aes-all in the first
place so I'm going to add tihs patch too.

commit acd246b7494c629aa617da49716409566cf52149
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Apr 21 13:55:20 2009 +0800

    crypto: padlock - Revert aes-all alias to aes
    
    Since the padlock-aes driver doesn't require a fallback (it's
    only padlock-sha that does), it should use the aes alias rather
    than aes-all so that ones that do need a fallback can use it.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 3f0fdd1..856b3cc 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -489,4 +489,4 @@ MODULE_DESCRIPTION("VIA PadLock AES algorithm support");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
 
-MODULE_ALIAS("aes-all");
+MODULE_ALIAS("aes");

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
