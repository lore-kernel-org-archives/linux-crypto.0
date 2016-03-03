From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] KEYS: Use crypto rsa pkcs1pad module for software
 public keys
Date: Thu, 3 Mar 2016 09:43:31 +0100
Message-ID: <20160303084331.GB3260@gondor.apana.org.au>
References: <20160227184727.GA8926@gondor.apana.org.au>
 <1381.1456738328@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, balrogg@googlemail.com,
	keyrings@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37152 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcCCIns (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 03:43:48 -0500
Content-Disposition: inline
In-Reply-To: <1381.1456738328@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 29, 2016 at 09:32:08AM +0000, David Howells wrote:
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > David Howells <dhowells@redhat.com> wrote:
> > > 
> > > Here's a set of patches that change the software public key asymmetric key
> > > subtype to use the RSA pkcs1pad module in the crypto layer.  I've merged
> > > together mine and Tadeusz's patches.
> > > 
> > > I have not included Tadeusz's original three patches that converted to
> > > using the raw rsa module in this set, but they're prerequisites for this.
> > 
> > Looks OK to me.  Where do you want these patches to go?
> 
> Can I turn that into an Reviewed-by?  I'll take them through my tree and
> James's tree.

Of course.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
