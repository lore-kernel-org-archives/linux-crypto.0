From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/15] rng: New style interface
Date: Mon, 20 Apr 2015 13:35:15 +0800
Message-ID: <20150420053515.GA18444@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44837 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbbDTFfT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:35:19 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series converts the crypto_rng interface over to the "new"
style.  I'm putting it in quotes because this style has been
around since 2008.  In fact, RNG was the very last interface
type added before the introduction of the new style.

Eventually all existing interfaces should be converted over but
obviously it's taking some time to get there :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
