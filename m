From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] MPI: Fix mpi_read_buffer
Date: Tue, 25 Aug 2015 21:17:08 +0800
Message-ID: <20150825131708.GC13824@gondor.apana.org.au>
References: <20150824145214.26239.98271.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44449 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbbHYNRR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Aug 2015 09:17:17 -0400
Content-Disposition: inline
In-Reply-To: <20150824145214.26239.98271.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 24, 2015 at 07:52:14AM -0700, Tadeusz Struk wrote:
> Change mpi_read_buffer to return a number without leading zeros
> so that mpi_read_buffer and mpi_get_buffer return the same thing.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
