From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - memset request context to zero during
 import
Date: Sat, 27 Feb 2016 20:35:12 +0100
Message-ID: <20160227193512.GE9123@gondor.apana.org.au>
References: <20160225224813.2020.48336.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34976 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbcB0TfQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 14:35:16 -0500
Content-Disposition: inline
In-Reply-To: <20160225224813.2020.48336.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 25, 2016 at 04:48:13PM -0600, Tom Lendacky wrote:
> Since a crypto_ahash_import() can be called against a request context
> that has not had a crypto_ahash_init() performed, the request context
> needs to be cleared to insure there is no random data present. If not,
> the random data can result in a kernel oops during crypto_ahash_update().
> 
> Cc: <stable@vger.kernel.org> # 3.14.x-
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
