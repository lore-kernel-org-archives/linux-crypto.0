From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/11] crypto: aead - Tweaks/fixes to new AEAD interface
Date: Wed, 27 May 2015 14:35:39 +0800
Message-ID: <20150527063539.GA25889@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49273 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbbE0Gfm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:35:42 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Previously the AD was required to exist in both the source and
destination buffers.  This creates a rather confusing situation
where the destination served as both input as well as output.

This series rectifies by allowing the destination to contain
the AD (e.g., it always does for in-place encryption) but not
require it.  Those AEAD algorithms that need the AD to be in
the destination buffer will do their own copying.

This series also merges some common code between echainiv and
seqiv.  In particular, the entire compatibility layer is now
shared.

Finally a number of bugs have been quashed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
