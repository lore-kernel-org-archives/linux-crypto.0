From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86: restore avx2_supported check
Date: Fri, 13 Sep 2013 22:22:57 +1000
Message-ID: <20130913122257.GB8579@gondor.apana.org.au>
References: <20130903134947.5366.51429.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50057 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846Ab3IMMW7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 08:22:59 -0400
Content-Disposition: inline
In-Reply-To: <20130903134947.5366.51429.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 03, 2013 at 04:49:47PM +0300, Jussi Kivilinna wrote:
> Commit 3d387ef08c4 (Revert "crypto: blowfish - add AVX2/x86_64 implementation
> of blowfish cipher") reverted too much as it removed the 'assembler supports
> AVX2' check and therefore disabled remaining AVX2 implementations of Camellia
> and Serpent. Patch restores the check and enables these implementations.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Also applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
