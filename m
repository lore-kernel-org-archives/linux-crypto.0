From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: Re: [PATCH 1/3] crypto: authenc - add TLS type encryption
Date: Tue, 8 Mar 2016 08:20:37 +0000
Message-ID: <AM4PR0401MB1876F5088D4EC6BE577BC97CE7B10@AM4PR0401MB1876.eurprd04.prod.outlook.com>
References: <20160306012044.6369.63924.stgit@tstruk-mobl1>
 <20160306012049.6369.99836.stgit@tstruk-mobl1>
 <AM4PR0401MB18766E17BCB4769B982ADFCBE7B10@AM4PR0401MB1876.eurprd04.prod.outlook.com>,<56DD90CB.4080704@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0091.outbound.protection.outlook.com ([157.55.234.91]:32736
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932069AbcCHIfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Mar 2016 03:35:42 -0500
In-Reply-To: <56DD90CB.4080704@intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 Hi Tadeusz,

There is also a follow-up in the next paragraph:

"That pretty much sums up the new attack: the side-channel defenses that were hoped to be sufficient were found not to be (again). So the answer, this time I believe, is to make the processing rigorously constant-time."

The author makes new changes and continues instrumenting the code and still finds 20 CPU cycles (out of 18000) difference between medians for different paddings. This small difference was detected also on a timing side-channel - which is the point I'm making.

SSL/TLS is prone to this implementation issue and many user-space libraries got this wrong. It would be good to see some numbers to back-up the claim of timing differences as not being an issue for this one.

Cristian S.


________________________________________
From: Tadeusz Struk <tadeusz.struk@intel.com>
Sent: Monday, March 7, 2016 4:31 PM
To: Cristian Stoica; herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; davem@davemloft.net
Subject: Re: [PATCH 1/3] crypto: authenc - add TLS type encryption

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
