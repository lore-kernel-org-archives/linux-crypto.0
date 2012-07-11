From: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Subject: RE: [PATCH 4/4] Talitos: fix the issue of dma memory leak
Date: Wed, 11 Jul 2012 07:09:08 +0000
Message-ID: <FD18E5D573A8AB48A365D4D78185DE9923CC29@039-SN1MPN1-001.039d.mgd.msft.net>
References: <1341900014-20915-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Li Yang-R58472 <r58472@freescale.com>,
	Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Liu Qiang-B32616 <B32616@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:12686
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756314Ab2GKHJL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 03:09:11 -0400
In-Reply-To: <1341900014-20915-1-git-send-email-qiang.liu@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 10 Jul 2012 09:00:14 +0300, Qiang Liu <qiang.liu@freescale.com> wrote:
> An error will be happened when test with mass data:
> "DMA-API: device driver tries to sync DMA memory it has not allocated";
> "DMA-API: debugging out of memory - disabling"
> dma mapping memory of request->desc is not released by right device,
> it should be private->dev but not dev;
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---
>  drivers/crypto/talitos.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 81f8497..a7da48c 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -264,7 +264,7 @@ static void flush_channel(struct device *dev, int
> ch, int error, int reset_ch)
>  			else
>  				status = error;
> -		dma_unmap_single(dev, request->dma_desc,
> +		 dma_unmap_single(priv->dev, request->dma_desc,
>  				 sizeof(struct talitos_desc),
>  				 DMA_BIDIRECTIONAL);

Are you sure this fix applies to the upstream version of talitos?
(i.e. have you encountered the error while running on cryptodev.git ?)

Looks to me this is a fix for the not-upstreamed-yet NAPI patch
(which needs to be reworked according to Dave's feedback).

When you respin the patch series, consider removing this one.

Cheers,
Horia
