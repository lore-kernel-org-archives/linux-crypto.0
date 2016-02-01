From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: ccp - Limit the amount of information exported
Date: Mon, 1 Feb 2016 22:34:14 +0800
Message-ID: <20160201143414.GB11410@gondor.apana.org.au>
References: <20160129184514.10863.45404.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	David Miller <davem@davemloft.net>
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54269 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbcBAOeR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 09:34:17 -0500
Content-Disposition: inline
In-Reply-To: <20160129184514.10863.45404.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 29, 2016 at 12:45:14PM -0600, Tom Lendacky wrote:
> Since the exported information can be exposed to user-space, instead of
> exporting the entire request context only export the minimum information
> needed.
> 
> Cc: <stable@vger.kernel.org> # 3.14.x-
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
