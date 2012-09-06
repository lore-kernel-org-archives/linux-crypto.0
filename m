From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH] crypto: geode-aes: Use module_pci_driver
Date: Thu, 6 Sep 2012 09:41:06 +0530
Message-ID: <CAK9yfHzoZScpD=BPjoSVGr+p7B5Xb0E8M-zMAc9-cyGCfL7Jug@mail.gmail.com>
References: <1346062531-27827-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-geode@lists.infradead.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, sachin.kamat@linaro.org, patches@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49774 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2IFELH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2012 00:11:07 -0400
Received: by vbbff1 with SMTP id ff1so965353vbb.19
        for <linux-crypto@vger.kernel.org>; Wed, 05 Sep 2012 21:11:06 -0700 (PDT)
In-Reply-To: <1346062531-27827-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Any comments on this patch?

On 27 August 2012 15:45, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> module_pci_driver makes the code simpler by eliminating
> module_init and module_exit calls.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/crypto/geode-aes.c |   15 +--------------
>  1 files changed, 1 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
> index 933fb4b4..51f196d 100644
> --- a/drivers/crypto/geode-aes.c
> +++ b/drivers/crypto/geode-aes.c
> @@ -585,21 +585,8 @@ static struct pci_driver geode_aes_driver = {
>         .remove = __devexit_p(geode_aes_remove)
>  };
>
> -static int __init
> -geode_aes_init(void)
> -{
> -       return pci_register_driver(&geode_aes_driver);
> -}
> -
> -static void __exit
> -geode_aes_exit(void)
> -{
> -       pci_unregister_driver(&geode_aes_driver);
> -}
> +module_pci_driver(geode_aes_driver);
>
>  MODULE_AUTHOR("Advanced Micro Devices, Inc.");
>  MODULE_DESCRIPTION("Geode LX Hardware AES driver");
>  MODULE_LICENSE("GPL");
> -
> -module_init(geode_aes_init);
> -module_exit(geode_aes_exit);
> --
> 1.7.4.1
>



-- 
With warm regards,
Sachin
