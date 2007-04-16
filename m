From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/6] [CRYPTO]: Async blkcipher backend support
Date: Mon, 16 Apr 2007 20:51:05 +1000
Message-ID: <20070416105105.GA10188@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4910 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752403AbXDPKvJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Apr 2007 06:51:09 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HdOna-0004ah-Qj
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:51:06 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HdOna-0002t0-00
	for <linux-crypto@vger.kernel.org>; Mon, 16 Apr 2007 20:51:06 +1000
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

This series of patches adds the backend support for asynchronous blkcipher
implementations.  This includes the ablkcipher crypto type, generic crypto
request queueing, as well as a sample cryptd implementation that turns any
sync blkcipher algorithm into an async one by processing requests in a
dedicated kernel thread.

This allows drivers for hardware blkcipher devices to be written.

Here is a list of steps from this point onwards:

* Establish async users where appropriate (dm-crypt is done).
* Create async interface for hash/compress.
* Port existing crypto drivers across.

Any help is welcome, especially with respect to the last item since
I don't have any crypto devices here.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
