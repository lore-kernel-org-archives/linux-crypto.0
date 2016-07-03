From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v9 PATCH] crypto: caam - add support for RSA algorithm
Date: Sun, 3 Jul 2016 15:43:58 +0800
Message-ID: <20160703074358.GA25820@gondor.apana.org.au>
References: <1467387085-12212-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45680 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbcGCHoE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jul 2016 03:44:04 -0400
Content-Disposition: inline
In-Reply-To: <1467387085-12212-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 01, 2016 at 06:31:25PM +0300, Tudor Ambarus wrote:
> Add RSA support to caam driver.
> 
> Initial author is Yashpal Dutta <yashpal.dutta@freescale.com>.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Sorry, but this doesn't build:

  CC [M]  drivers/crypto/caam/caampkc.o
../drivers/crypto/caam/caampkc.c:17:28: fatal error: rsapubkey-asn1.h: No such file or directory
compilation terminated.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
