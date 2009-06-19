From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: ansi_cprng - Do not select FIPS
Date: Fri, 19 Jun 2009 20:34:00 +0800
Message-ID: <20090619123400.GA18778@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Neil Horman <nhorman@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43009 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752828AbZFSMd7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 08:33:59 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Neil:

Why does the CPRNG select FIPS? It should work with FIPS off
too, no?

commit 27300176d75e4723e2125e745a98a77bf0133f72
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Jun 19 20:32:58 2009 +0800

    crypto: ansi_cprng - Do not select FIPS
    
    The RNG should work with FIPS disabled.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4dfdd03..03ef1a9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -782,7 +782,6 @@ config CRYPTO_ANSI_CPRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
 	select CRYPTO_AES
 	select CRYPTO_RNG
-	select CRYPTO_FIPS
 	help
 	  This option enables the generic pseudo random number generator
 	  for cryptographic modules.  Uses the Algorithm specified in

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
