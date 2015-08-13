From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Thu, 13 Aug 2015 09:40:36 -0700
Message-ID: <55CCC884.3090806@intel.com>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1> <20150813035445.25108.76927.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61782 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbbHMQlp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 12:41:45 -0400
In-Reply-To: <20150813035445.25108.76927.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/12/2015 08:54 PM, Tadeusz Struk wrote:
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
>  	akcipher_request_complete(areq, err);
>  }
>  
> 

Herbert,
Could you take this one and I'll work with David on the rest.
Thanks,
T
