From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: ccp - Add hash state import and export support
Date: Mon, 25 Jan 2016 22:48:23 +0800
Message-ID: <20160125144823.GG8840@gondor.apana.org.au>
References: <20160112171738.23496.44254.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46215 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbcAYOs2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:48:28 -0500
Content-Disposition: inline
In-Reply-To: <20160112171738.23496.44254.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 12, 2016 at 11:17:38AM -0600, Tom Lendacky wrote:
> Commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
> added a check to prevent ahash algorithms from successfully registering
> if the import and export functions were not implemented. This prevents
> an oops in the hash_accept function of algif_hash. This commit causes
> the ccp-crypto module SHA support and AES CMAC support from successfully
> registering and causing the ccp-crypto module load to fail because the
> ahash import and export functions are not implemented.
> 
> Update the CCP Crypto API support to provide import and export support
> for ahash algorithms.
> 
> Cc: <stable@vger.kernel.org> # 3.14.x-
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
