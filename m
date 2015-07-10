From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: Drop owner assignment from platform_driver
Date: Fri, 10 Jul 2015 08:30:34 +0200
Message-ID: <20150710083034.0429f147@bbrezillon>
References: <1436507176-27632-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Arnaud Ebalard <arno@natisbad.org>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38289 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393AbbGJGai (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 02:30:38 -0400
In-Reply-To: <1436507176-27632-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 10 Jul 2015 14:46:16 +0900
Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

> platform_driver does not need to set an owner because
> platform_driver_register() will set it.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> 
> ---
> 
> The coccinelle script which generated the patch was sent here:
> http://www.spinics.net/lists/kernel/msg2029903.html
> ---
>  drivers/crypto/marvell/cesa.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
> index 1c6f98dd88f4..0643e3366e33 100644
> --- a/drivers/crypto/marvell/cesa.c
> +++ b/drivers/crypto/marvell/cesa.c
> @@ -533,7 +533,6 @@ static struct platform_driver marvell_cesa = {
>  	.probe		= mv_cesa_probe,
>  	.remove		= mv_cesa_remove,
>  	.driver		= {
> -		.owner	= THIS_MODULE,
>  		.name	= "marvell-cesa",
>  		.of_match_table = mv_cesa_of_match_table,
>  	},



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
