From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/3] crypto: akcipher - Changes to asymmetric key API
Date: Fri, 2 Oct 2015 12:14:36 +0800
Message-ID: <20151002041436.GA671@gondor.apana.org.au>
References: <20151001202845.7193.51602.stgit@tstruk-mobl1>
 <20151002032000.GA32754@gondor.apana.org.au>
 <560DFCAA.2040609@intel.com>
 <20151002040409.GA557@gondor.apana.org.au>
 <560E0392.4020005@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41874 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbJBEOk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Oct 2015 00:14:40 -0400
Content-Disposition: inline
In-Reply-To: <560E0392.4020005@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 01, 2015 at 09:09:54PM -0700, Tadeusz Struk wrote:
>
> This is used not only in rsa, but also in the new mpi sgl helpers.
> Should I drop all the params checking?

For a start the MPI helpers shouldn't be using sg_len as the length
that they are allowed to read or write.  The length should be
explicitly passed in by the caller because it may be smaller than
the length of the entire SG list.

So no I don't see why you need to use sg_len in the MPI helpers.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
