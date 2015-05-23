From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/8] crypto: aead - Use type-safe instance registration and
 remove cryptoff
Date: Sat, 23 May 2015 15:40:58 +0800
Message-ID: <20150523074058.GA14781@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39493 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbbEWHlC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 03:41:02 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series of patches makes the new seqiv/echainiv implementation
use the type-safe instance registration mechanism.

It also removes the cryptoff parameter from the new AEAD interface.
The cryptoff parameter only existed to ease the pain on implementing
seqniv (i.e., skipping IV when generating ICV, used by GCM and CCM).

However it turns out that it only helped because the implementation
was buggy and totally ignored the IPsec user's cryptoff setting.

So the last three pathces remove that use of cryptoff and instead
rearranges the AD such that the gap left by the IV is filled.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
