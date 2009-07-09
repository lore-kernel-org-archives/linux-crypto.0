From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/16] Convert hmac to shash
Date: Thu, 9 Jul 2009 12:50:52 +0800
Message-ID: <20090709045052.GA21092@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47637 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbZGIEuz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:50:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOlav-0006Bd-SD
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:50:53 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MOlau-0005Ua-Vk
	for linux-crypto@vger.kernel.org; Thu, 09 Jul 2009 12:50:53 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series adds the infrastructure required to turn hmac into an
shash algorithm.  As this is the very first new-style algorithm
type to do this it takes a bit more work than usual.

At the end I've also added an optimisation to hmac to prehash
the pads.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
