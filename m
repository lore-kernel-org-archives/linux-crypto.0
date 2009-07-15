From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/35] Converting ahash to new style
Date: Wed, 15 Jul 2009 15:14:24 +0800
Message-ID: <20090715071424.GA19023@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53606 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751163AbZGOHO0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:14:26 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyh7-0004ms-0W
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:14:25 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MQyh6-0004xB-Az
	for linux-crypto@vger.kernel.org; Wed, 15 Jul 2009 15:14:24 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series of patches converts ahash to the new algorithm format
just like shash.  Note that I've incorporated a couple of the
previously posted patches (notably the padlock/hmac conversion)
into it.

At this point all implementations are either shash or ahash.  So
we can now move forward to convert users such as authenc over to
ahash.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
