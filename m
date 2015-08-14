From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Fri, 14 Aug 2015 13:14:10 +0800
Message-ID: <20150814051410.GA2370@gondor.apana.org.au>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1>
 <20150813035445.25108.76927.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44779 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbHNFOc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2015 01:14:32 -0400
Content-Disposition: inline
In-Reply-To: <20150813035445.25108.76927.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 12, 2015 at 08:54:45PM -0700, Tadeusz Struk wrote:
> Don't need to move data inside of the output buffer
> because SW doen't need to do this anymore sice the new MPI
> mpi_read_buf() has been added. Just set the correct output len.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_asym_algs.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> index fe352a6..6ddb13c 100644
> --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> @@ -144,9 +144,6 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
>  		ptr++;
>  	}
>  
> -	if (areq->dst_len != req->ctx->key_sz)
> -		memcpy(areq->dst, ptr, areq->dst_len);
> -

This looks wrong.  It appears to be trying to remove leading
zeroes so you can't just change the length because then you end
up removing the trailing digits equal to the number of leading
zeroes.

The existing code is also wrong as you should be using memmove
instead of memcpy.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
