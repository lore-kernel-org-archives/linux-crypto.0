From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: caam: Can you do zero-length seq fifo loads?
Date: Sat, 13 Jun 2015 22:36:11 +0800
Message-ID: <20150613143611.GA17200@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	linux-crypto@vger.kernel.org, jinyanjiang@gmail.com
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60177 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbbFMOgQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 13 Jun 2015 10:36:16 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kim:

I'm trying to convert the caam driver to the new AEAD interface.

I've run into some weird code in the GCM implementation.  The
function gcm_set_sh_desc handles generic GCM and it does some
pretty hairy stuff with respect to zero-length AD and zero-length
cryptlen.

It appears to be avoiding doing a zero-length seq fifo load by
checking the length before each operation.  So my question is
is it forbidden to do a zero-length seq fifo load? If so what
happens when you do it? This is important because none of the
other AEAD implementations (e.g., RFC4543) check for zero lengths.
With the new AEAD user-space interface it is quite easy to give
a zero-length request to any AEAD algorithm.

Also it appears that in caamhash we don't avoid doing zero-length
seq fifo loads at all.  And they obviously work because our very
first selftest for SHA is a zero-length digest.

So could it be that zero-length seq fifo loads do work but only
work once?

Or is it that seq fifo loads stop working after a previous seq fifo
load reaches length zero? If so can you get around this by always
adding some extra pading after the end of the sequence?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
