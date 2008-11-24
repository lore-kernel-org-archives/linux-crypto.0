From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Have HW invalidate src and dest descriptors after
	processing
Date: Mon, 24 Nov 2008 21:53:52 +0800
Message-ID: <20081124135352.GC18313@gondor.apana.org.au>
References: <12271034133347-git-send-email-zbr@ioremap.net> <12271034132587-git-send-email-zbr@ioremap.net> <12271034131753-git-send-email-zbr@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51585 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823AbYKXNxz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 08:53:55 -0500
Content-Disposition: inline
In-Reply-To: <12271034131753-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 19, 2008 at 02:03:27PM +0000, Evgeniy Polyakov wrote:
> From: Patrick McHardy <kaber@trash.net>
> 
> The descriptors need to be invalidated after processing for ring
> cleanup to work properly and to avoid using an old destination
> descriptor when the src and cmd descriptors are already set up
> and the dst descriptor isn't.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
> ---
>  drivers/crypto/hifn_795x.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index 320d08d..4d22b21 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -1296,7 +1296,7 @@ static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
>  
>  	dma->srcr[idx].p = __cpu_to_le32(addr);
>  	dma->srcr[idx].l = __cpu_to_le32(size | HIFN_D_VALID |
> -			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
> +			HIFN_D_MASKDONEIRQ | HIFN_D_LAST);

Something is not right here.  This patch is an exact reversal
of the previous patch in this series.  Could you please take a
look?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
