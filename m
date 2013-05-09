From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 2/2] crypto: s5p-sss: remove unnecessary platform_set_drvdata()
Date: Fri, 10 May 2013 01:32:46 +0300
Message-ID: <518C240E.3010403@mleia.com>
References: <002601ce4a0c$b59fe120$20dfa360$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 'Herbert Xu' <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from li271-223.members.linode.com ([178.79.152.223]:38084 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab3EIWnn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 May 2013 18:43:43 -0400
In-Reply-To: <002601ce4a0c$b59fe120$20dfa360$@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/06/13 06:49, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han<jg1.han@samsung.com>
> ---
>   drivers/crypto/s5p-sss.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 4b31432..cf149b1 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -647,7 +647,6 @@ static int s5p_aes_probe(struct platform_device *pdev)
>   	clk_disable(pdata->clk);
>
>   	s5p_dev = NULL;
> -	platform_set_drvdata(pdev, NULL);
>
>   	return err;
>   }
> @@ -668,7 +667,6 @@ static int s5p_aes_remove(struct platform_device *pdev)
>   	clk_disable(pdata->clk);
>
>   	s5p_dev = NULL;
> -	platform_set_drvdata(pdev, NULL);
>
>   	return 0;
>   }

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

--
With best wishes,
Vladimir
