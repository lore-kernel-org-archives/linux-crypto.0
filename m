From: Joel Fernandes <joelf@ti.com>
Subject: Re: [PATCH] crypto: omap-sham: Map SG pages if they are HIGHMEM before
 accessing
Date: Fri, 14 Feb 2014 13:53:13 -0600
Message-ID: <52FE7429.608@ti.com>
References: <1390952600-29913-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38204 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaBNTxP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Feb 2014 14:53:15 -0500
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id s1EJrErd010381
	for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2014 13:53:14 -0600
Received: from DLEE70.ent.ti.com (dlemailx.itg.ti.com [157.170.170.113])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id s1EJrE8v016470
	for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2014 13:53:14 -0600
Received: from [10.247.21.110] (ileax41-snat.itg.ti.com [10.172.224.153])	by
 dlep32.itg.ti.com (8.14.3/8.13.8) with ESMTP id s1EJrE6Z030158	for
 <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2014 13:53:14 -0600
In-Reply-To: <1390952600-29913-1-git-send-email-joelf@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Gentle ping for this fix patch. Could it be accepted for -rc? Thanks.

-Joel

On 01/28/2014 05:43 PM, Joel Fernandes wrote:
> HIGHMEM pages may not be mapped so we must kmap them before accessing.
> This resolves a random OOPs error that was showing up during OpenSSL SHA tests.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  drivers/crypto/omap-sham.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 8bdde57..fcf6562 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -636,11 +636,21 @@ static size_t omap_sham_append_buffer(struct omap_sham_reqctx *ctx,
>  static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
>  {
>  	size_t count;
> +	const u8 *vaddr;
>  
>  	while (ctx->sg) {
> +		if (PageHighMem(sg_page(ctx->sg)))
> +			vaddr = kmap_atomic(sg_page(ctx->sg));
> +		else
> +			vaddr = sg_virt(ctx->sg);
> +
>  		count = omap_sham_append_buffer(ctx,
> -				sg_virt(ctx->sg) + ctx->offset,
> +				vaddr + ctx->offset,
>  				ctx->sg->length - ctx->offset);
> +
> +		if (PageHighMem(sg_page(ctx->sg)))
> +			kunmap_atomic((void *)vaddr);
> +
>  		if (!count)
>  			break;
>  		ctx->offset += count;
> 
