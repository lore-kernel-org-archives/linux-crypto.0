From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Do not sign extend input data to CCP
Date: Fri, 1 Aug 2014 22:40:51 +0800
Message-ID: <20140801144051.GF15005@gondor.apana.org.au>
References: <20140730204132.11748.11340.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59916 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaHAOk4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Aug 2014 10:40:56 -0400
Content-Disposition: inline
In-Reply-To: <20140730204132.11748.11340.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 30, 2014 at 03:41:32PM -0500, Tom Lendacky wrote:
> The CCP hardware interprets all numbers as unsigned numbers, therefore
> sign extending input data is not valid.  Modify the function calls
> for RSA and ECC to not perform sign extending.
> 
> This patch is based on the cryptodev-2.6 kernel tree.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
