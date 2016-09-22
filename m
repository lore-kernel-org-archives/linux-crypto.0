From: Horia Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH v2] crypto: caam - fix sg dump
Date: Thu, 22 Sep 2016 10:23:23 +0000
Message-ID: <DB4PR04MB0847584C19565F8B3FBE6ED698C90@DB4PR04MB0847.eurprd04.prod.outlook.com>
References: <1474534678-10118-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto-owner@vger.kernel.org"
        <linux-crypto-owner@vger.kernel.org>
To: Cata Vasile <cata.vasile@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0077.outbound.protection.outlook.com ([104.47.2.77]:3199
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751187AbcIVKhl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:37:41 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/22/2016 11:58 AM, Catalin Vasile wrote:=0A=
> Ensure scatterlists have a virtual memory mapping before dumping.=0A=
> =0A=
> Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>=0A=
> ---=0A=
> Changes:=0A=
> 	V2:=0A=
> 		* resolved issue of sleeping in atomic contexts=0A=
> ---=0A=
> ---=0A=
>  drivers/crypto/caam/caamalg.c | 79 +++++++++++++++++++++++++++++++++----=
------=0A=
>  1 file changed, 61 insertions(+), 18 deletions(-)=0A=
> =0A=
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c=0A=
> index f1116e7..eb97562 100644=0A=
> --- a/drivers/crypto/caam/caamalg.c=0A=
> +++ b/drivers/crypto/caam/caamalg.c=0A=
> @@ -111,6 +111,42 @@=0A=
>  #else=0A=
>  #define debug(format, arg...)=0A=
>  #endif=0A=
> +=0A=
> +#ifdef DEBUG=0A=
> +#include <linux/highmem.h>=0A=
> +=0A=
> +static void dbg_dump_sg(const char *level, const char *prefix_str,=0A=
> +			int prefix_type, int rowsize, int groupsize,=0A=
> +			struct scatterlist *sg, size_t tlen, bool ascii,=0A=
> +			bool may_sleep)=0A=
may_sleep is no longer needed.=0A=
=0A=
> +{=0A=
> +	struct scatterlist *it;=0A=
> +	void *it_page;=0A=
> +	size_t len;=0A=
> +	void *buf;=0A=
> +=0A=
> +	for (it =3D sg; it !=3D NULL && tlen > 0 ; it =3D sg_next(sg)) {=0A=
> +		/*=0A=
> +		 * make sure the scatterlist's page=0A=
> +		 * has a valid virtual memory mapping=0A=
> +		 */=0A=
> +		it_page =3D kmap_atomic(sg_page(it));=0A=
> +		if (unlikely(!it_page)) {=0A=
> +			printk(KERN_ERR "dbg_dump_sg: kmap failed\n");=0A=
pr_err is preferred.=0A=
=0A=
> +			return;=0A=
> +		}=0A=
> +=0A=
> +		buf =3D it_page + it->offset;=0A=
> +		len =3D min(tlen, it->length);=0A=
> +		print_hex_dump(level, prefix_str, prefix_type, rowsize,=0A=
> +			       groupsize, buf, len, ascii);=0A=
> +		tlen -=3D len;=0A=
> +=0A=
> +		kunmap_atomic(it_page);=0A=
> +	}=0A=
> +}=0A=
> +#endif=0A=
I see that the function currently shows up only in places where DEBUG=0A=
define is already used.=0A=
However, it would be nice to have a no-op implementation in case DEBUG=0A=
is not set, to avoid ifdeffery as much as possible.=0A=
=0A=
> +=0A=
>  static struct list_head alg_list;=0A=
>  =0A=
>  struct caam_alg_entry {=0A=
> @@ -1982,9 +2018,9 @@ static void ablkcipher_encrypt_done(struct device *=
jrdev, u32 *desc, u32 err,=0A=
>  	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",=0A=
>  		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,=0A=
>  		       edesc->src_nents > 1 ? 100 : ivsize, 1);=0A=
> -	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",=0A=
> -		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),=0A=
> -		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);=0A=
> +	dbg_dump_sg(KERN_ERR, "dst    @"__stringify(__LINE__)": ",=0A=
> +		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,=0A=
> +		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1, true);=0A=
>  #endif=0A=
>  =0A=
>  	ablkcipher_unmap(jrdev, edesc, req);=0A=
> @@ -2014,9 +2050,9 @@ static void ablkcipher_decrypt_done(struct device *=
jrdev, u32 *desc, u32 err,=0A=
>  	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",=0A=
>  		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,=0A=
>  		       ivsize, 1);=0A=
> -	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",=0A=
> -		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),=0A=
> -		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);=0A=
> +	dbg_dump_sg(KERN_ERR, "dst    @"__stringify(__LINE__)": ",=0A=
> +		    DUMP_PREFIX_ADDRESS, 16, 4, req->dst,=0A=
> +		    edesc->dst_nents > 1 ? 100 : req->nbytes, 1, true);=0A=
>  #endif=0A=
>  =0A=
>  	ablkcipher_unmap(jrdev, edesc, req);=0A=
> @@ -2171,12 +2207,15 @@ static void init_ablkcipher_job(u32 *sh_desc, dma=
_addr_t ptr,=0A=
>  	int len, sec4_sg_index =3D 0;=0A=
>  =0A=
>  #ifdef DEBUG=0A=
> +	bool may_sleep =3D ((req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |=0A=
> +					      CRYPTO_TFM_REQ_MAY_SLEEP)) !=3D 0);=0A=
>  	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",=0A=
>  		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,=0A=
>  		       ivsize, 1);=0A=
> -	print_hex_dump(KERN_ERR, "src    @"__stringify(__LINE__)": ",=0A=
> -		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),=0A=
> -		       edesc->src_nents ? 100 : req->nbytes, 1);=0A=
> +	printk(KERN_ERR "asked=3D%d, nbytes%d\n", (int)edesc->src_nents ? 100 :=
 req->nbytes, req->nbytes);=0A=
> +	dbg_dump_sg(KERN_ERR, "src    @"__stringify(__LINE__)": ",=0A=
> +		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,=0A=
> +		    edesc->src_nents ? 100 : req->nbytes, 1, may_sleep);=0A=
>  #endif=0A=
>  =0A=
>  	len =3D desc_len(sh_desc);=0A=
> @@ -2228,12 +2267,14 @@ static void init_ablkcipher_giv_job(u32 *sh_desc,=
 dma_addr_t ptr,=0A=
>  	int len, sec4_sg_index =3D 0;=0A=
>  =0A=
>  #ifdef DEBUG=0A=
> +	bool may_sleep =3D ((req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |=0A=
> +					      CRYPTO_TFM_REQ_MAY_SLEEP)) !=3D 0);=0A=
>  	print_hex_dump(KERN_ERR, "presciv@" __stringify(__LINE__) ": ",=0A=
>  		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,=0A=
>  		       ivsize, 1);=0A=
> -	print_hex_dump(KERN_ERR, "src    @" __stringify(__LINE__) ": ",=0A=
> -		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),=0A=
> -		       edesc->src_nents ? 100 : req->nbytes, 1);=0A=
> +	dbg_dump_sg(KERN_ERR, "src    @" __stringify(__LINE__) ": ",=0A=
> +		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,=0A=
> +		    edesc->src_nents ? 100 : req->nbytes, 1, may_sleep);=0A=
>  #endif=0A=
>  =0A=
>  	len =3D desc_len(sh_desc);=0A=
> @@ -2503,18 +2544,20 @@ static int aead_decrypt(struct aead_request *req)=
=0A=
>  	u32 *desc;=0A=
>  	int ret =3D 0;=0A=
>  =0A=
> +#ifdef DEBUG=0A=
> +	bool may_sleep =3D ((req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |=0A=
> +					      CRYPTO_TFM_REQ_MAY_SLEEP)) !=3D 0);=0A=
> +	dbg_dump_sg(KERN_ERR, "dec src@"__stringify(__LINE__)": ",=0A=
> +		    DUMP_PREFIX_ADDRESS, 16, 4, req->src,=0A=
> +		    req->assoclen + req->cryptlen, 1, may_sleep);=0A=
> +#endif=0A=
> +=0A=
The logic / flow shouldn't change (in this patch at least), leave the=0A=
print in the same place.=0A=
=0A=
>  	/* allocate extended descriptor */=0A=
>  	edesc =3D aead_edesc_alloc(req, AUTHENC_DESC_JOB_IO_LEN,=0A=
>  				 &all_contig, false);=0A=
>  	if (IS_ERR(edesc))=0A=
>  		return PTR_ERR(edesc);=0A=
>  =0A=
> -#ifdef DEBUG=0A=
> -	print_hex_dump(KERN_ERR, "dec src@"__stringify(__LINE__)": ",=0A=
> -		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),=0A=
> -		       req->assoclen + req->cryptlen, 1);=0A=
> -#endif=0A=
> -=0A=
>  	/* Create and submit job descriptor*/=0A=
>  	init_authenc_job(req, edesc, all_contig, false);=0A=
>  #ifdef DEBUG=0A=
> =0A=
=0A=
