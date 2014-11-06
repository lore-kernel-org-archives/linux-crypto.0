From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam - fix output sequence contiguity check
Date: Thu, 6 Nov 2014 23:16:47 +0800
Message-ID: <20141106151647.GC4544@gondor.apana.org.au>
References: <1414072483-4118-1-git-send-email-tudor.ambarus@freescale.com>
 <1414163617-26342-1-git-send-email-tudor.ambarus@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51263 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaKFPQu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 10:16:50 -0500
Content-Disposition: inline
In-Reply-To: <1414163617-26342-1-git-send-email-tudor.ambarus@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 24, 2014 at 06:13:37PM +0300, Tudor Ambarus wrote:
> This patch fixes the assumption that output sequence is not contiguous
> when input sequence is not contiguous and in-place encryption is done.
> Output sequence does not need to be contiguous with associated data.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
