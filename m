From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/8] crypto: aed - Convert authenc to new interface
Date: Thu, 30 Jul 2015 17:41:38 +0800
Message-ID: <20150730094138.GA15941@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40969 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbbG3Jlm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:41:42 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series converts all implementations of authenc to the new AEAD
interface.

Note that all drivers are compile-tested only.  So please test
them if you have the right hardware.

Oh and you'll need to pull the crypto tree into cryptodev before
you apply these patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
