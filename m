From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] powerpc/crypto: Remove virt_to_abs() usage in nx-842.c
Date: Mon, 20 Aug 2012 16:31:30 +0800
Message-ID: <20120820083130.GB22951@gondor.apana.org.au>
References: <1343960595-30232-1-git-send-email-michael@ellerman.id.au>
 <501BE2F6.5080506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Ellerman <michael@ellerman.id.au>,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:49989 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751882Ab2HTIbn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Aug 2012 04:31:43 -0400
Content-Disposition: inline
In-Reply-To: <501BE2F6.5080506@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 03, 2012 at 09:40:54AM -0500, Seth Jennings wrote:
> On 08/02/2012 09:23 PM, Michael Ellerman wrote:
> > virt_to_abs() is just a wrapper around __pa(), use __pa() directly.
> > 
> > We should be including <asm/page.h> to get __pa(). abs_addr.h will be
> > removed shortly so drop that.
> > 
> > We were getting of.h via abs_addr.h so we need to include that directly.
> > 
> > Having done all that, clean up the ordering of the includes.
> > 
> > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > ---
> >  drivers/crypto/nx/nx-842.c |   34 ++++++++++++++++++----------------
> >  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> Looks good here.  Thanks for doing this!
> 
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
