From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5] crypto: rsa - return raw integers for the ASN.1 parser
Date: Wed, 15 Jun 2016 17:28:13 +0800
Message-ID: <20160615092813.GB15841@gondor.apana.org.au>
References: <1465910098-16349-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48471 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbcFOJ2U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 05:28:20 -0400
Content-Disposition: inline
In-Reply-To: <1465910098-16349-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 14, 2016 at 04:14:58PM +0300, Tudor Ambarus wrote:
> Return the raw key with no other processing so that the caller
> can copy it or MPI parse it, etc.
> 
> The scope is to have only one ANS.1 parser for all RSA
> implementations.
> 
> Update the RSA software implementation so that it does
> the MPI conversion on top.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Patch applied.  Thanks for persisting with this.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
