From: Neil Horman <nhorman@redhat.com>
Subject: Re: crypto: ansi_cprng - Do not select FIPS
Date: Fri, 14 Aug 2009 11:39:30 -0400
Message-ID: <20090814153930.GC20601@hmsreliant.think-freely.org>
References: <20090619123400.GA18778@gondor.apana.org.au> <20090619125500.GA18153@hmsreliant.think-freely.org> <20090813112955.GA25239@gondor.apana.org.au> <20090813144156.GA31826@shamino.rdu.redhat.com> <20090814031340.GA2380@gondor.apana.org.au> <20090814105829.GB20601@hmsreliant.think-freely.org> <20090814111355.GA5908@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41714 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZHNPje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2009 11:39:34 -0400
Content-Disposition: inline
In-Reply-To: <20090814111355.GA5908@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 14, 2009 at 09:13:55PM +1000, Herbert Xu wrote:
> On Fri, Aug 14, 2009 at 06:58:29AM -0400, Neil Horman wrote:
> >
> > Yeah, I suppose, it just seemed like a hack to me, since it really is a logical
> > boolean, and we use it as such.  Ok, I'll look at fixing this soon.  Thanks!
> 
> Well it wouldn't be the first time we had to hack around Kconfig
> logic, just look at those *2 symbols in crypto/Kconfig :)
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


What about something like this?  It defaults the CPRNG to m and makes FIPS
dependent on the CPRNG.  That way you get a module build by default, but you can
change it to y manually during config and still satisfy the dependency, and if
you select N it disables FIPS as well.  I rather like that better than making
FIPS a tristate.  I just tested it out here and it seems to work well.  Let me
know what you think

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1db0995..7623442 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -23,11 +23,13 @@ comment "Crypto core or helper"
 
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
+	depends on CRYPTO_ANSI_CPRNG
 	help
 	  This options enables the fips boot option which is
 	  required if you want to system to operate in a FIPS 200
 	  certification.  You should say no unless you know what
-	  this is.
+	  this is. Note that CRYPTO_ANSI_CPRNG is requred if this
+	  option is selected
 
 config CRYPTO_ALGAPI
 	tristate
@@ -787,12 +789,14 @@ comment "Random Number Generation"
 
 config CRYPTO_ANSI_CPRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
+	default m
 	select CRYPTO_AES
 	select CRYPTO_RNG
 	help
 	  This option enables the generic pseudo random number generator
 	  for cryptographic modules.  Uses the Algorithm specified in
-	  ANSI X9.31 A.2.4
+	  ANSI X9.31 A.2.4. Not this option must be enabled if CRYPTO_FIPS 
+	  is selected
 
 source "drivers/crypto/Kconfig"
 
