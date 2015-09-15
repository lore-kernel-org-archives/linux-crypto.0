From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] MPI: Fix mpi_read_buffer
Date: Tue, 15 Sep 2015 20:24:25 +0800
Message-ID: <20150915122424.GA3743@gondor.apana.org.au>
References: <20150824145214.26239.98271.stgit@tstruk-mobl1>
 <12302.1442308196@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33542 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbbIOMYf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 08:24:35 -0400
Content-Disposition: inline
In-Reply-To: <12302.1442308196@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 15, 2015 at 10:09:56AM +0100, David Howells wrote:
> Tadeusz Struk <tadeusz.struk@intel.com> wrote:
> 
> > Change mpi_read_buffer to return a number without leading zeros
> > so that mpi_read_buffer and mpi_get_buffer return the same thing.
> 
> Hmmm...  This would appear to have the undesirable side effect of causing 1
> out of 256 module signing keys to be unusable (ie. those that begin with 00).

I thought Tadeusz was just restoring the original behaviour, no?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
