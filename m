From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/3] Avoid spinning in chainiv if allowed
Date: Fri, 14 Dec 2007 22:43:17 +0800
Message-ID: <20071214144317.GA18890@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4783 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755270AbXLNOnT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 09:43:19 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J3Bkz-00054A-SD
	for <linux-crypto@vger.kernel.org>; Sat, 15 Dec 2007 01:43:18 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J3Bkz-0004ux-00
	for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2007 22:43:17 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Now that things have settled down I've picked up the old async
chainiv patch and updated it for the current tree.  Here is the
result.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
