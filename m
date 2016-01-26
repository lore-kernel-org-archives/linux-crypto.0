From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH 05/22] hw_random: Fix dependencies for !HAS_IOMEM archs
Date: Tue, 26 Jan 2016 09:58:51 +0000
Message-ID: <56A7435B.5000405@linaro.org>
References: <1453760661-1444-1-git-send-email-richard@nod.at>
 <1453760661-1444-6-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: user-mode-linux-devel@lists.sourceforge.net,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Lee Jones <lee.jones@linaro.org>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Pankaj Dev <pankaj.dev@st.com>, Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	linux-crypto@vger.kernel.org
To: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36188 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964956AbcAZJ6y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 04:58:54 -0500
Received: by mail-wm0-f42.google.com with SMTP id l65so96816429wmf.1
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jan 2016 01:58:53 -0800 (PST)
In-Reply-To: <1453760661-1444-6-git-send-email-richard@nod.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 25/01/16 22:24, Richard Weinberger wrote:
> Not every arch has io memory.
> So, unbreak the build by fixing the dependencies.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>

Thanks for cleaning up after me!

> ---
>   drivers/char/hw_random/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index dbf2271..ff00331 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -372,6 +372,7 @@ config HW_RANDOM_XGENE
>   config HW_RANDOM_STM32
>   	tristate "STMicroelectronics STM32 random number generator"
>   	depends on HW_RANDOM && (ARCH_STM32 || COMPILE_TEST)
> +	depends on HAS_IOMEM
>   	help
>   	  This driver provides kernel-side support for the Random Number
>   	  Generator hardware found on STM32 microcontrollers.
>
