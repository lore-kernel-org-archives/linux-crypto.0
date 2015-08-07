From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 05/14] crypto: caam - Change kmalloc to kzalloc to
 avoid residual data
Date: Fri, 7 Aug 2015 17:59:43 +0800
Message-ID: <20150807095943.GA26831@gondor.apana.org.au>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-6-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com, shawnguo@kernel.org,
	kernel@pengutronix.de, linux@arm.linux.org.uk, robh+dt@kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35574 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbbHGJ7x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 05:59:53 -0400
Content-Disposition: inline
In-Reply-To: <1438799328-10757-6-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 05, 2015 at 11:28:39AM -0700, Victoria Milhoan wrote:
> Since fields must be ORed in to operate correctly using any order of
> operations, changed allocations of the combination of extended
> descriptor structs + hardware scatterlists to use kzalloc() instead
> of kmalloc(), so as to ensure that residue data would not be ORed in
> with the correct data.
> 
> Signed-off-by: Steve Cornelius <steve.cornelius@freescale.com>
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>

Please rebase this on the current cryptodev tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
