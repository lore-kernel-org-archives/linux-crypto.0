From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 1/3] crypto: authenc - add TLS type encryption
Date: Mon, 7 Mar 2016 06:31:39 -0800
Message-ID: <56DD90CB.4080704@intel.com>
References: <20160306012044.6369.63924.stgit@tstruk-mobl1>
 <20160306012049.6369.99836.stgit@tstruk-mobl1>
 <AM4PR0401MB18766E17BCB4769B982ADFCBE7B10@AM4PR0401MB1876.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Cristian Stoica <cristian.stoica@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25297 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbcCGOgN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Mar 2016 09:36:13 -0500
In-Reply-To: <AM4PR0401MB18766E17BCB4769B982ADFCBE7B10@AM4PR0401MB1876.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Cristian,
On 03/07/2016 01:05 AM, Cristian Stoica wrote:
> Hi Tadeusz,
> 
> 
> +static int crypto_encauth_dgst_verify(struct aead_request *req,
> +                                     unsigned int flags)
> +{
> +       struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +       unsigned int authsize = crypto_aead_authsize(tfm);
> +       struct aead_instance *inst = aead_alg_instance(tfm);
> +       struct crypto_encauth_ctx *ctx = crypto_aead_ctx(tfm);
> +       struct encauth_instance_ctx *ictx = aead_instance_ctx(inst);
> +       struct crypto_ahash *auth = ctx->auth;
> +       struct encauth_request_ctx *areq_ctx = aead_request_ctx(req);
> +       struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
> +       u8 *hash = areq_ctx->tail;
> +       int i, err = 0, padd_err = 0;
> +       u8 paddlen, *ihash;
> +       u8 padd[255];
> +
> +       scatterwalk_map_and_copy(&paddlen, req->dst, req->assoclen +
> +                                req->cryptlen - 1, 1, 0);
> +
> +       if (paddlen > 255 || paddlen > req->cryptlen) {
> +               paddlen = 1;
> +               padd_err = -EBADMSG;
> +       }
> +
> +       scatterwalk_map_and_copy(padd, req->dst, req->assoclen +
> +                                req->cryptlen - paddlen, paddlen, 0);
> +
> +       for (i = 0; i < paddlen; i++) {
> +               if (padd[i] != paddlen)
> +                       padd_err = -EBADMSG;
> +       }
> 
> 
> This part seems to have the same issue my TLS patch has.
> See for reference what Andy Lutomirski had to say about it:
> 
> http://www.mail-archive.com/linux-crypto%40vger.kernel.org/msg11719.html

Thanks for reviewing and for pointing this out. I was aware of the timing-side
issues and done everything I could to avoid it. The main issue that allowed the
Lucky Thirteen attack was that the digest wasn't performed at all if the padding
verification failed. This is not an issue here.
The other issue, which is caused by the length of data to digest being dependent
on the padding length is inevitable and there is nothing we can do about it.
As the note in the paper says:
"However, our behavior matches OpenSSL, so we leak only as much as they do."

Thanks,
-- 
TS
