From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: RE: [PATCH v2 1/3] crypto: scatterwak - Add scatterwalk_sg_copychunks
Date: Mon, 28 Mar 2016 16:48:57 +0000
Message-ID: <AM4PR0401MB1876F08B068F145E2ADCBC3AE7860@AM4PR0401MB1876.eurprd04.prod.outlook.com>
References: <1458745539-1252-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458745539-1252-2-git-send-email-tudor-dan.ambarus@nxp.com>
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
Received: from mail-am1on0084.outbound.protection.outlook.com ([157.56.112.84]:45856
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754869AbcC1RDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Mar 2016 13:03:36 -0400
In-Reply-To: <1458745539-1252-2-git-send-email-tudor-dan.ambarus@nxp.com>
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
> Subject: [PATCH v2 1/3] crypto: scatterwak - Add scatterwalk_sg_copychunks
> 
> This patch adds the function scatterwalk_sg_copychunks which writes a
> chunk of data from a scatterwalk to another scatterwalk.
> It will be used by caam driver to remove the leading zeros of RSA's algorithm
> output.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

Acked-by: Cristian Stoica <cristian.stoica@nxp.com>

> ---
>  crypto/scatterwalk.c         | 26 ++++++++++++++++++++++++++
>  include/crypto/scatterwalk.h |  2 ++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c index
> ea5815c..bc3222d 100644
> --- a/crypto/scatterwalk.c
> +++ b/crypto/scatterwalk.c
> @@ -125,6 +125,32 @@ void scatterwalk_map_and_copy(void *buf, struct
> scatterlist *sg,  }  EXPORT_SYMBOL_GPL(scatterwalk_map_and_copy);
> 
> +void scatterwalk_sg_copychunks(struct scatter_walk *dest,
> +			       struct scatter_walk *src, size_t nbytes) {
> +	for (;;) {
> +		unsigned int len_this_page = scatterwalk_pagelen(dest);
> +		u8 *vaddr;
> +
> +		if (len_this_page > nbytes)
> +			len_this_page = nbytes;
> +
> +		vaddr = scatterwalk_map(dest);
> +		scatterwalk_copychunks(vaddr, src, len_this_page, 0);
> +		scatterwalk_unmap(vaddr);
> +
> +		scatterwalk_advance(dest, len_this_page);
> +
> +		if (nbytes == len_this_page)
> +			break;
> +
> +		nbytes -= len_this_page;
> +
> +		scatterwalk_pagedone(dest, 0, 1);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(scatterwalk_sg_copychunks);
> +
>  int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes)  {
>  	int offset = 0, n = 0;
> diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
> index 35f99b6..8b799c5 100644
> --- a/include/crypto/scatterwalk.h
> +++ b/include/crypto/scatterwalk.h
> @@ -86,6 +86,8 @@ static inline void scatterwalk_unmap(void *vaddr)  void
> scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg);  void
> scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
>  			    size_t nbytes, int out);
> +void scatterwalk_sg_copychunks(struct scatter_walk *dest,
> +			       struct scatter_walk *src, size_t nbytes);
>  void *scatterwalk_map(struct scatter_walk *walk);  void
> scatterwalk_done(struct scatter_walk *walk, int out, int more);
> 
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
