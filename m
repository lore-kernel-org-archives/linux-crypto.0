From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 03/18] crypto: marvell: add flag to determine algorithm
 endianness
Date: Mon, 19 Oct 2015 15:04:51 +0000
Message-ID: <20151019150451.GB3953@io.lakedaemon.net>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
 <E1ZnqkG-0005WH-TE@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:41858 "EHLO
	outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbbJSPU5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 11:20:57 -0400
Content-Disposition: inline
In-Reply-To: <E1ZnqkG-0005WH-TE@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Russell,

On Sun, Oct 18, 2015 at 05:23:40PM +0100, Russell King wrote:
> Rather than determining whether we're using a MD5 hash by looking at
> the digest size, switch to a cleaner solution using a per-request flag
> initialised by the method type.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/crypto/marvell/cesa.h |  1 +
>  drivers/crypto/marvell/hash.c | 17 +++++++++--------
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
...
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index f59faabcd34f..aa12274608ab 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -351,7 +351,7 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
>  		 * Hardware's MD5 digest is in little endian format, but
>  		 * SHA in big endian format
>  		 */
> -		if (digsize == MD5_DIGEST_SIZE) {
> +		if (creq->algo_le) {
>  			__le32 *result = (void *)ahashreq->result;
>  
>  			for (i = 0; i < digsize / 4; i++)
> @@ -407,7 +407,7 @@ static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
>  };
>  
>  static int mv_cesa_ahash_init(struct ahash_request *req,
> -			      struct mv_cesa_op_ctx *tmpl)
> +			      struct mv_cesa_op_ctx *tmpl, bool algo_le)

nit: Would it make more sense the do bool algo_endian, and then ...

> @@ -861,7 +862,7 @@ static int mv_cesa_md5_init(struct ahash_request *req)
>  
>  	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
>  
> -	mv_cesa_ahash_init(req, &tmpl);
> +	mv_cesa_ahash_init(req, &tmpl, true);

	mv_cesa_ahash_init(req, &tmpl, ALGO_ENDIAN_LITTLE);

'true' doesn't seem as obvious.  But again, nit-picky.

thx,

Jason.
