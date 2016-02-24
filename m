From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v2 0/2] crypto: asynchronous compression api
Date: Wed, 24 Feb 2016 17:47:22 +0000
Message-ID: <20160224174722.GA2857@sivswdev01.ir.intel.com>
References: <20160209105355.GA10652@gondor.apana.org.au>
 <1455039069-17475-1-git-send-email-giovanni.cabiddu@intel.com>
 <20160216195717.GA4207@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:52048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbcBXRra (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Feb 2016 12:47:30 -0500
Content-Disposition: inline
In-Reply-To: <20160216195717.GA4207@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Tue, Feb 16, 2016 at 07:57:17PM +0000, Herbert Xu wrote:
> Can you give an example on how to use the noctx support with
> your acomp interface?

In this version of the acomp api an algorithm can specify different sizes for
the compression and the decompression contexts by setting the comp_reqsize and
the decomp_reqsize fields in the acomp_alg structure.
The api also provides two new function calls to allocate the request:
	struct acomp_req *acomp_compression_request_alloc(
					struct crypto_acomp *acomp, gfp_t gfp)
	struct acomp_req *acomp_decompression_request_alloc(
					struct crypto_acomp *acomp, gfp_t gfp)
The implementation of these calls use comp_reqsize and decomp_reqsize to 
allocate the context and therefore, if an algorithm supports it, it is possible
to have requests with no context.

Here is a simple example that shows how to use the api from a user prospective:

	struct crypto_acomp *tfm;
	struct acomp_req *req = NULL;
	struct scatterlist src;
	struct scatterlist dst;
	tfm = crypto_alloc_acomp("deflate", 0, 0);
	req = acomp_compression_request_alloc(tfm, GFP_KERNEL);
	/* Prepare src and dst sgls */
	acomp_request_set_params(req, &src, &dst, slen, dlen);
	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG, cb_func,
				   cb_data);
	ret = crypto_acomp_compress(req);

Regarding the SCOMP backends, when an algorithm registers as
CRYPTO_ALG_TYPE_SCOMPRESS, requests allocated with both
acomp_compression_request_alloc and acomp_decompression_request_alloc have 
the same size (sizeof (struct acomp_req) + sizeof(void *)).
The request context stores a pointer to the scomp context allocated 
using crypto_scomp_alloc_ctx().
If the algorithm specifies the CRYPTO_SCOMP_DECOMP_NOCTX flag,
acomp_decompression_request_alloc does not call crypto_scomp_alloc_ctx() and
stores NULL into the request context.
This way the scomp context is not allocated and decompression requests are
called without context. See patch v3.

Regards,

-- 
Giovanni
