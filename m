From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v4 1/4] MPILIB: add mpi_read_buf(), mpi_copy() and
 mpi_get_size() helpers
Date: Fri, 12 Jun 2015 10:44:19 +0800
Message-ID: <20150612024419.GB30982@gondor.apana.org.au>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1>
 <20150611190538.31826.97258.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36076 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbFLCo2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 22:44:28 -0400
Content-Disposition: inline
In-Reply-To: <20150611190538.31826.97258.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 11, 2015 at 12:05:38PM -0700, Tadeusz Struk wrote:
>
> +/**
> + * mpi_get_size() - returns max size required to store the number
> + *
> + * @a:	A multi precision integer for which we want to allocate a bufer
> + *
> + * Return: size required to store the number
> + */
> +unsigned int mpi_get_size(MPI a)
> +{
> +	return a->nlimbs * BYTES_PER_MPI_LIMB;
> +}
> +EXPORT_SYMBOL_GPL(mpi_get_size);

Perhaps inline this function?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
