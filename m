From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v8 1/3] crypto: scatterwak - Add scatterwalk_sg_copychunks
Date: Mon, 20 Jun 2016 18:54:49 +0800
Message-ID: <20160620105449.GA10464@gondor.apana.org.au>
References: <1466002364-16945-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1466002364-16945-2-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58790 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbcFTK4s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 06:56:48 -0400
Content-Disposition: inline
In-Reply-To: <1466002364-16945-2-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 15, 2016 at 05:52:42PM +0300, Tudor Ambarus wrote:
> This patch adds the function scatterwalk_sg_copychunks which writes
> a chunk of data from a scatterwalk to another scatterwalk.
> It will be used by caam driver to remove the leading zeros
> for the output data of the RSA algorithm, after the computation completes.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Not only does dropping leading zeroes lead to questions about
information leaks, but it makes every one of our RSA drivers
look crap.

So I'm going to change this and make it not skip leading zeroes.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
