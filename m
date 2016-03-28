From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: RE: [PATCH v2 2/3] crypto: scatterwalk - export scatterwalk_pagedone
Date: Mon, 28 Mar 2016 16:49:20 +0000
Message-ID: <AM4PR0401MB1876A6B9D5A19FCA7DA14C85E7860@AM4PR0401MB1876.eurprd04.prod.outlook.com>
References: <1458745539-1252-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458745539-1252-3-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tadeusz.struk@intel.com" <tadeusz.struk@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"smueller@chronox.de" <smueller@chronox.de>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0081.outbound.protection.outlook.com ([157.55.234.81]:33885
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753051AbcC1QtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2016 12:49:24 -0400
In-Reply-To: <1458745539-1252-3-git-send-email-tudor-dan.ambarus@nxp.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Tudor Ambarus
> Sent: Wednesday, March 23, 2016 5:06 PM
> To: herbert@gondor.apana.org.au
> Cc: tadeusz.struk@intel.com; linux-crypto@vger.kernel.org;
> smueller@chronox.de; Horia Ioan Geanta Neag <horia.geanta@nxp.com>;
> Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
> Subject: [PATCH v2 2/3] crypto: scatterwalk - export scatterwalk_pagedone
> 
> Used in caam driver. Export the symbol since the caam driver can be built as a
> module.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Acked-by: Cristian Stoica <cristian.stoica@nxp.com>

> ---
>  crypto/scatterwalk.c         | 5 +++--
>  include/crypto/scatterwalk.h | 2 ++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c index
> bc3222d..03d34f9 100644
> --- a/crypto/scatterwalk.c
> +++ b/crypto/scatterwalk.c
> @@ -47,8 +47,8 @@ void *scatterwalk_map(struct scatter_walk *walk)  }
> EXPORT_SYMBOL_GPL(scatterwalk_map);
> 
> -static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
> -				 unsigned int more)
> +void scatterwalk_pagedone(struct scatter_walk *walk, int out,
> +			  unsigned int more)
>  {
>  	if (out) {
>  		struct page *page;
> @@ -69,6 +69,7 @@ static void scatterwalk_pagedone(struct scatter_walk
> *walk, int out,
>  			scatterwalk_start(walk, sg_next(walk->sg));
>  	}
>  }
> +EXPORT_SYMBOL_GPL(scatterwalk_pagedone);
> 
>  void scatterwalk_done(struct scatter_walk *walk, int out, int more)  { diff --
> git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h index
> 8b799c5..6535a20 100644
> --- a/include/crypto/scatterwalk.h
> +++ b/include/crypto/scatterwalk.h
> @@ -89,6 +89,8 @@ void scatterwalk_copychunks(void *buf, struct
> scatter_walk *walk,  void scatterwalk_sg_copychunks(struct scatter_walk
> *dest,
>  			       struct scatter_walk *src, size_t nbytes);  void
> *scatterwalk_map(struct scatter_walk *walk);
> +void scatterwalk_pagedone(struct scatter_walk *walk, int out,
> +			  unsigned int more);
>  void scatterwalk_done(struct scatter_walk *walk, int out, int more);
> 
>  void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
