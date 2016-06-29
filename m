From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3 PATCH 2/8] crypto: rsa - Generate fixed-length output
Date: Wed, 29 Jun 2016 19:30:06 +0800
Message-ID: <20160629113006.GA27604@gondor.apana.org.au>
References: <20160629102649.GA26987@gondor.apana.org.au>
 <E1bICk5-00072W-Td@gondolin.me.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D0319396ED@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Zaborowski, Andrew" <andrew.zaborowski@intel.com>,
	"Struk, Tadeusz" <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>
To: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50109 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbcF2LaO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 07:30:14 -0400
Content-Disposition: inline
In-Reply-To: <309B30E91F5E2846B79BD9AA9711D0319396ED@IRSMSX102.ger.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 29, 2016 at 11:23:06AM +0000, Benedetto, Salvatore wrote:
> Hi Herbert,
> 
> > 
> > This patch also changes DH to use the new interface.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
> > 
> >  crypto/rsa.c        |    8 +++----
> >  include/linux/mpi.h |    2 -
> >  lib/mpi/mpicoder.c  |   55 ++++++++++++++++++++++++-----------------------
> > -----
> >  3 files changed, 31 insertions(+), 34 deletions(-)
> > 
> 
> I don't see the DH change in this patch.

Doh, one more posting is needed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
