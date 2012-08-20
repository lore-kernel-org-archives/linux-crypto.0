From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] Crytpo hash drivers for sparc64 crypto
 instructions.
Date: Mon, 20 Aug 2012 16:22:02 +0800
Message-ID: <20120820082202.GC22529@gondor.apana.org.au>
References: <20120819.221000.1440395237780126787.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sparclinux@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:50619 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754465Ab2HTIWE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2012 04:22:04 -0400
Content-Disposition: inline
In-Reply-To: <20120819.221000.1440395237780126787.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Aug 19, 2012 at 10:10:00PM -0700, David Miller wrote:
> 
> SPARC-T4 and later support cryptographic instructions.
> 
> This patch series adds support for the hash digest algorithms.
> 
> This includes md5, sha1, sha224, sha256, sha384, and sha512.
> 
> Herbert, this depends upon sparc64 cpu feature detection
> infrastructure that is going in via the sparc-next tree, so I intend
> to commit this work there if you don't mind.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks! Looks good to me.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
