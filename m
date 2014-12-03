From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: algif - Mark sgl end at the end of data
Date: Wed, 3 Dec 2014 22:26:59 +0800
Message-ID: <20141203142659.GA11236@gondor.apana.org.au>
References: <20141202150750.32521.20584.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51030 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaLCO1G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2014 09:27:06 -0500
Content-Disposition: inline
In-Reply-To: <20141202150750.32521.20584.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2014 at 07:07:50AM -0800, Tadeusz Struk wrote:
> Hi,
> algif_skcipher sends 127 sgl buffers for encryption regardless of how
> many buffers acctually have data to process, where the few first with
> valid len and the rest with zero len. This is not very eficient and may cause
> problems when algs do something like this without checking the buff
> lenght:
> for_each_sg(sgl, sg, sg_nents, i)
> 	sg_virt(sg)
> This patch marks the last one with data as the last one to process.
> 
> Changes:
> v2 - use data len to find the last buffer instead of nents in RX list.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  crypto/algif_skcipher.c |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index f2a88a7..cde507f 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -414,6 +414,23 @@ unlock:
>  	return err ?: size;
>  }
>  
> +static int skcipher_get_nents_with_data(struct scatterlist *sg, int len)
> +{

This is way too complicated.  Why not just do it every time we add
data and modify sgl->cur?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
