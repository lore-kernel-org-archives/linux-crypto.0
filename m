From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/3] KEYS: Use crypto rsa pkcs1pad module for software public keys
Date: Mon, 29 Feb 2016 09:32:08 +0000
Message-ID: <1381.1456738328@warthog.procyon.org.uk>
References: <20160227184727.GA8926@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, tadeusz.struk@intel.com,
	balrogg@googlemail.com, keyrings@vger.kernel.org,
	zohar@linux.vnet.ibm.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbcB2JcM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Feb 2016 04:32:12 -0500
In-Reply-To: <20160227184727.GA8926@gondor.apana.org.au>
Content-ID: <1380.1456738328.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> David Howells <dhowells@redhat.com> wrote:
> > 
> > Here's a set of patches that change the software public key asymmetric key
> > subtype to use the RSA pkcs1pad module in the crypto layer.  I've merged
> > together mine and Tadeusz's patches.
> > 
> > I have not included Tadeusz's original three patches that converted to
> > using the raw rsa module in this set, but they're prerequisites for this.
> 
> Looks OK to me.  Where do you want these patches to go?

Can I turn that into an Reviewed-by?  I'll take them through my tree and
James's tree.

David
