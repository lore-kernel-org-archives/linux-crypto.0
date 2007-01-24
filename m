From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/6] [CRYPTO]: Misc patches before async crypto
Date: Wed, 24 Jan 2007 21:27:36 +1100
Message-ID: <20070124102736.GA21977@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2893 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750937AbXAXK1k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jan 2007 05:27:40 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1H9fLt-0005w2-Na
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:27:37 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1H9fLs-0005lh-00
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:27:36 +1100
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

I'll be pushing these patches into cryptodev-2.6 tonight.

This patch series removes the obsolete interfaces now that all users
in mainline and mm have been converted.

It also adds support to the API to allow multiple frontend types for
one backend.  The immediate application will be to provide an async
interface to all existing sync crypto algorithms.  However, it could
also be used for other purposes such as providing a virtual address
interface for synchronous algorithms where currently we require the
use of scatterlists.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
