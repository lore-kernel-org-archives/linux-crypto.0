From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/6] crypto: shash - Require all algorithms to support
	export/import
Date: Wed, 22 Jul 2009 14:38:44 +0800
Message-ID: <20090722063844.GA28998@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51378 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751696AbZGVGiq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 02:38:46 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MTVTR-0005xf-Ld
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2009 16:38:45 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MTVTR-0007ic-1K
	for linux-crypto@vger.kernel.org; Wed, 22 Jul 2009 14:38:45 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series ensures that all existing shash/ahash implementations
support the export/import interface.  It is now also a requirement
that all new ones must do so as well.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
