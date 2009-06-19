From: Neil Horman <nhorman@redhat.com>
Subject: Re: crypto: ansi_cprng - Do not select FIPS
Date: Fri, 19 Jun 2009 08:55:00 -0400
Message-ID: <20090619125500.GA18153@hmsreliant.think-freely.org>
References: <20090619123400.GA18778@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45242 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZFSMzG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 08:55:06 -0400
Content-Disposition: inline
In-Reply-To: <20090619123400.GA18778@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2009 at 08:34:00PM +0800, Herbert Xu wrote:
> Hi Neil:
> 
> Why does the CPRNG select FIPS? It should work with FIPS off
> too, no?
> 
Thanks!  Thats definately an oversight.  Likely I included it because I was
implementing it as part of the FIPS effort.  The CPRNG definately works fine,
even if fips is disabled.  Although I think the relationship should be reversed,
not just removed, as FIPS support requires the use of the CPRNG.  Something like
this:

 
commit d9645d88d97e81c6528f311ee126df79a0d27501
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Fri Jun 19 08:52:37 2009 -0400

    Fix CPRNG/FIPS dependency
    
    The ANSI CPRNG has no dependence on FIPS support.  FIPS support however,
    requires the use of the CPRNG.  Adjust that depedency relationship in Kconfig
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4dfdd03..f2002d8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -23,6 +23,7 @@ comment "Crypto core or helper"
 
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
+	select CRYPTO_ANSI_CPRNG
 	help
 	  This options enables the fips boot option which is
 	  required if you want to system to operate in a FIPS 200
@@ -782,7 +783,6 @@ config CRYPTO_ANSI_CPRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
 	select CRYPTO_AES
 	select CRYPTO_RNG
-	select CRYPTO_FIPS
 	help
 	  This option enables the generic pseudo random number generator
 	  for cryptographic modules.  Uses the Algorithm specified in
