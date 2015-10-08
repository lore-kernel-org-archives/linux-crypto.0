From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH  v5 1/2] lib/mpi: Add mpi sgl helpers
Date: Thu, 8 Oct 2015 21:02:03 +0800
Message-ID: <20151008130203.GA24128@gondor.apana.org.au>
References: <20151002051032.27263.21150.stgit@tstruk-mobl1>
 <20151002051038.27263.5476.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33479 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbbJHNCJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 09:02:09 -0400
Content-Disposition: inline
In-Reply-To: <20151002051038.27263.5476.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 01, 2015 at 10:10:38PM -0700, Tadeusz Struk wrote:
>
> +/**
> + * mpi_write_to_sgl() - Funnction exports MPI to an sgl (msb first)
> + *
> + * This function works in the same way as the mpi_read_buffer, but it
> + * takes an sgl instead of u8 * buf.
> + *
> + * @a:		a multi precision integer
> + * @sgl:	scatterlist to write to. Needs to be at least
> + *		mpi_get_size(a) long.
> + * @nbytes:	receives the actual length of the data written.
> + * @sign:	if not NULL, it will be set to the sign of a.
> + *
> + * Return:	0 on success or error code in case of error
> + */
> +int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
> +		     int *sign)

Where is the maximum length of sgl? You should not assume that the
entire SG list is for you to use.  So the length that you are allowed
to use should be passed in explicitly.  You can just put it into
nbytes.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
