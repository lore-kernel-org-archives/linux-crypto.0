From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/16] crypto: aead - Add single SG interface and new IPsec IV
 generation
Date: Thu, 21 May 2015 15:09:15 +0800
Message-ID: <20150521070915.GA20997@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38122 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbEUHJT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:09:19 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series of patches takes the opportunity of the AEAD conversion
to adjust the interface so that it is more optimal for the intended
use-cases.

As it stands, AEAD takes two separate SG lists, one containing the
asssociated data (AD) and one containing the plain/cipher text.
These two lists have to be combined when we generate the ICV.

In order to provide the best performance, many AEAD algorithms try
to stitch these two lists together into a single contiguous SG
entry where possible.  Worse, with IPsec there is also an IV involved
that needs to be added into the mix.  The end result is a lot of
black magic all spread out through the crypto stack.  You just have
to take a look at the complexity in crypto/authenc.c to know what
I'm talking about (not to mention crypto/authencesn.c).

Another wart in the system is IV generation.  This is exclusively
used by IPsec.  However, it carries with it almost an entire
operation type in the form of givencrypt.  Again a lot of complexity
has been added in order to support this.

So this series slightly adjusts the AEAD interface in an attempt
to solve these two issues.  Firstly the AD is now placed into the
same SG list as the plain/cipher text.  This removes the need to
do any stitching.  As the primary user of AEAD, IPsec naturally
has a contiguous buffer containing the AD and plain/cipher text,
this simplifies esp4/esp6 quite a bit.

Secondly IV generation is now carried out in explicit but normal
AEAD algorithms.  The generated IV is simply part of the cipher
text.  This means that we can kill at least half of the AEAD geniv
code and all of the ablkcipher geniv code.  It also means that
authenc and other IPsec-specific algorithms no longer has to do
IV stitching.

This series only creates the new interface.  The actual conversion
will be carried out in subsequent series.  The old interface will
be maintained until the conversion is complete.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
