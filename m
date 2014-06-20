From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: caam - remove duplicate FIFOST_CONT_MASK define
Date: Sat, 21 Jun 2014 02:42:43 +0800
Message-ID: <20140620184243.GJ3169@gondor.apana.org.au>
References: <20140609151941.GN9600@mwanda>
 <20140612181812.cbc7c9b0adfe42d74ea2f636@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Alex Porosanu <alexandru.porosanu@freescale.com>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35743 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965999AbaFTSmx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jun 2014 14:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20140612181812.cbc7c9b0adfe42d74ea2f636@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 12, 2014 at 06:18:12PM -0500, Kim Phillips wrote:
> On Mon, 9 Jun 2014 18:19:41 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > The FIFOST_CONT_MASK define is cut and pasted twice so we can delete the
> > second instance.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
