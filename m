From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] KEYS: Use crypto rsa pkcs1pad module for software
 public keys
Date: Sat, 27 Feb 2016 18:47:27 +0000
Message-ID: <20160227184727.GA8926@gondor.apana.org.au>
References: <20160226152333.29934.21098.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, dhowells@redhat.com,
	balrogg@googlemail.com, keyrings@vger.kernel.org,
	zohar@linux.vnet.ibm.com, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53418 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbcB0Srh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 13:47:37 -0500
Content-Disposition: inline
In-Reply-To: <20160226152333.29934.21098.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:
> 
> Here's a set of patches that change the software public key asymmetric key
> subtype to use the RSA pkcs1pad module in the crypto layer.  I've merged
> together mine and Tadeusz's patches.
> 
> I have not included Tadeusz's original three patches that converted to
> using the raw rsa module in this set, but they're prerequisites for this.

Looks OK to me.  Where do you want these patches to go?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
