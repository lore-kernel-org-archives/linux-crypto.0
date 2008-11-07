From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/10] New crypto hash interface
Date: Fri, 7 Nov 2008 16:35:36 +0800
Message-ID: <20081107083536.GA10169@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39114 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750952AbYKGIfk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:35:40 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMob-00067L-8O
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:35:37 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1KyMoa-0002ju-Kn
	for linux-crypto@vger.kernel.org; Fri, 07 Nov 2008 16:35:36 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

The crc32c stuff finally tipped me over the edge into implementing
the often-talked about sync hash interface.  Our hash interface
backend has always been targeted towards software implementations
in that it takes byte arrays instead of scatter lists.  However,
the frontend has always been based on scatter lists.

Now that we have the ahash frontend for asynchronous users, there
is room for a synchronous interface that uses byte arrays only.
This is now implemented as shash.

Furthermore, the shash interface also supports the simultaneous
use of one tfm object by multiple threads, just like ahash.  This
is accomplished by storing the hash state in a descriptor object
passed in by the user.

One immediate benefit is that we'll be able to remove the locking
that IPsec currently applies around the hash operation.

As it stands the shash backend coexists with the hash/digest backend
and algorithms implemented as shash will be available to the old
hash frontend, but not vice versa.  The plan is to convert all
software hash algorithms to the new interface (starting with
crc32c), and then converting all hash/digest users to the new
frontend.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
