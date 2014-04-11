From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v3 1/2] crypto: bfin_crc: ignore duplicated registration of the same algorithm
Date: Fri, 11 Apr 2014 11:33:37 +0200
Message-ID: <201404111133.37451.marex@denx.de>
References: <1397208625-23522-1-git-send-email-sonic.adi@gmail.com>
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
Received: from mail-out.m-online.net ([212.18.0.9]:43441 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaDKJdh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Apr 2014 05:33:37 -0400
In-Reply-To: <1397208625-23522-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, April 11, 2014 at 11:30:25 AM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> in case of multiple crc devices are probed.
> Call platform_set_drvdata() before adding new CRC device into the list.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
> v3-change:
> - check list_is_singular() before register the algorithm
> 
>  drivers/crypto/bfin_crc.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
> index cea3e8c..892b6d2 100644
> --- a/drivers/crypto/bfin_crc.c
> +++ b/drivers/crypto/bfin_crc.c
> @@ -665,19 +665,19 @@ static int bfin_crypto_crc_probe(struct
> platform_device *pdev) if (timeout == 0)
>  		dev_info(&pdev->dev, "init crc poly timeout\n");
> 
> +	platform_set_drvdata(pdev, crc);
> +
>  	spin_lock(&crc_list.lock);
>  	list_add(&crc->list, &crc_list.dev_list);
>  	spin_unlock(&crc_list.lock);
> 
> -	platform_set_drvdata(pdev, crc);
> -
> -	ret = crypto_register_ahash(&algs);
> -	if (ret) {
> -		spin_lock(&crc_list.lock);
> -		list_del(&crc->list);
> -		spin_unlock(&crc_list.lock);
> -		dev_err(&pdev->dev, "Cann't register crypto ahash device\n");
> -		goto out_error_dma;
> +	if (list_is_singular(&crc_list.dev_list)) {
> +		ret = crypto_register_ahash(&algs);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +				"Cann't register crypto ahash device\n");

"Cann't" with two Ns ;-/

Well, add "Reviewed-by: Marek Vasut <marex@denx.de>" into the next go please :)

Best regards,
Marek Vasut
