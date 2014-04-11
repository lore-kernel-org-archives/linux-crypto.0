From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2 1/2] crypto: bfin_crc: ignore duplicated registration of the same algorithm
Date: Fri, 11 Apr 2014 09:47:50 +0200
Message-ID: <201404110947.50951.marex@denx.de>
References: <1397193024-17802-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:42771 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaDKIRg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Apr 2014 04:17:36 -0400
In-Reply-To: <1397193024-17802-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, April 11, 2014 at 07:10:24 AM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> in case of multiple crc devices are probed.
> Call platform_set_drvdata() before adding new CRC device into the list.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
> v2-chagnes:
> - check the CRC list and avoid call crypto_register_ahash() if not empty
> - move platform_set_drvdata() before adding CRC device into the list
> 
>  drivers/crypto/bfin_crc.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
> index cea3e8c..7154d68 100644
> --- a/drivers/crypto/bfin_crc.c
> +++ b/drivers/crypto/bfin_crc.c
> @@ -665,20 +665,23 @@ static int bfin_crypto_crc_probe(struct
> platform_device *pdev) if (timeout == 0)
>  		dev_info(&pdev->dev, "init crc poly timeout\n");
> 
> +	platform_set_drvdata(pdev, crc);
> +
>  	spin_lock(&crc_list.lock);
> -	list_add(&crc->list, &crc_list.dev_list);
> -	spin_unlock(&crc_list.lock);
> 
> -	platform_set_drvdata(pdev, crc);
> +	if (list_empty(&crc_list.dev_list)) {

Try the following, which would remove the need for the else{} branch altogether:

list_add(...);
if (list_is_singular(...)) {
  crypto_register_....
  ...
}


Other than that

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
