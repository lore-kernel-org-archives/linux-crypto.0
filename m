From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/2] crypto: bfin_crc: ignore duplicated registration of the same algorithm
Date: Thu, 10 Apr 2014 10:59:21 +0200
Message-ID: <201404101059.21811.marex@denx.de>
References: <1397119259-20638-1-git-send-email-sonic.adi@gmail.com>
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
Received: from mail-out.m-online.net ([212.18.0.9]:36602 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934879AbaDJJCw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 05:02:52 -0400
In-Reply-To: <1397119259-20638-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, April 10, 2014 at 10:40:58 AM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> in case of multiple crc devices are probed.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/crypto/bfin_crc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
> index cea3e8c..5f5f427 100644
> --- a/drivers/crypto/bfin_crc.c
> +++ b/drivers/crypto/bfin_crc.c
> @@ -672,7 +672,7 @@ static int bfin_crypto_crc_probe(struct platform_device
> *pdev) platform_set_drvdata(pdev, crc);

Rant: Reading through the code a little, the platform_set_drvdata() should 
happen before you add the new CRC device into the list (above this code).

>  	ret = crypto_register_ahash(&algs);
> -	if (ret) {
> +	if (ret && ret != -EEXIST) {

Uh oh, how is this supposed to work ? Does blackfin have multiple crc32 
processing units ? Can you simply not check if the crc_list is not empty and 
avoid calling crypto_register_ahash() for subsequent crc32 units at all ?

>  		spin_lock(&crc_list.lock);
>  		list_del(&crc->list);
>  		spin_unlock(&crc_list.lock);

Best regards,
Marek Vasut
