From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/8] crypto: rng - Avoid boot failure with missing DRBG module
Date: Sun, 21 Jun 2015 19:07:02 +0800
Message-ID: <20150621110702.GA29747@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55988 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbbFULHI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 07:07:08 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Distros use an initramfs to boot the system.  The initramfs may
not contain all the modules that are normally present on the system.
This poses a problem to the new default DRBG because it may be
built as a module.  This isn't a problem itself since it is only
meant to be used by IV generators which are now explicit.  However,
as we still have legacy algorithms that are yet to be converted,
they will not be available unless DRBG is loaded first.

The upshot is that the system may fail to boot if DRBG isn't in
the initramfs and the system uses file system encryption for the
root file system.

This series avoids this issue by allowing legacy IV generators
to function even when an RNG is not available.  Only the givencrypt
functionality will be unavilable if the RNG is absent.

This change brings up a new problem.  Up until now the system
RNG has been held down by the instances of the IV generators.
This meant that it was never freed unless all IV generator instances
were removed from the system.

The new code only holds the RNG during algorithm initialisation.
So unless something was done the crypto system RNG would be freed
and allocated all the time which is not a good thing.

This series avoids this by only freeing the system RNG when the
admin requests it through the crypto_user interface.  A new command
DELRNG has been added for this purpose.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
