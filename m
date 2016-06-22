From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Wed, 22 Jun 2016 18:14:32 +0800
Message-ID: <20160622101432.GA30454@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39340 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbcFVMeW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 08:34:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This was prompted by the caam RSA submission where a lot of work
was done just to strip the RSA output of leading zeroes.  This is
in fact completely pointless because the only user of RSA in the
kernel then promptly puts them back.

This patch series resolves this madness by simply leaving any
leading zeroes in place.  Note that we're not requiring authors
to add leading zeroes, even though that is encouraged if it is
easy to do.  In practice you'd only run into this every 2^32 or
2^64 operations so please don't overdo it.

I've also taken the opportunity to cleanup the pkcs1pad code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
