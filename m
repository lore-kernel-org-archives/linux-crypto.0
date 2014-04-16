From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr: add empty and large test vectors for
 SHA-1, SHA-224, SHA-256, SHA-384 and SHA-512
Date: Wed, 16 Apr 2014 21:50:00 +0800
Message-ID: <20140416135000.GG4684@gondor.apana.org.au>
References: <20140412123529.5372.69900.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39104 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbaDPNuD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2014 09:50:03 -0400
Content-Disposition: inline
In-Reply-To: <20140412123529.5372.69900.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 12, 2014 at 03:35:29PM +0300, Jussi Kivilinna wrote:
> Patch adds large test-vectors for SHA algorithms for better code coverage in
> optimized assembly implementations. Empty test-vectors are also added, as some
> crypto drivers appear to have special case handling for empty input.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
