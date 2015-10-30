From: Heiko Stuebner <heiko@sntech.de>
Subject: Re: [RESEND PATCH 1/4] Crypto: Crypto driver support aes/des/des3 for rk3288
Date: Fri, 30 Oct 2015 15:26:08 +0100
Message-ID: <2230290.pTq1BehVXW@phil>
References: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com> <1446193369-4453-2-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Zain Wang <zain.wang@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:43143 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660AbbJ3O0Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2015 10:26:24 -0400
In-Reply-To: <1446193369-4453-2-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

first of all, thanks for working on this, it will be really cool to see the
crypto accelerator supported in the kernel :-)

Am Freitag, 30. Oktober 2015, 16:22:46 schrieb Zain Wang:
> Crypto driver support cbc/ecb two chainmode, and aes/des/des3 three cipher mode.
> The names registered are:
>     ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
> You can alloc tags above in your case.
> 
> And other algorithms and platforms will be added later on.
> 
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
> ---
>  drivers/crypto/Makefile                            |   1 +
>  drivers/crypto/rk_crypto/Makefile                  |   3 +
>  drivers/crypto/rk_crypto/rk3288_crypto.c           | 393 ++++++++++++++++
>  drivers/crypto/rk_crypto/rk3288_crypto.h           | 291 ++++++++++++
>  .../crypto/rk_crypto/rk3288_crypto_ablkcipher.c    | 502 +++++++++++++++++++++
>  5 files changed, 1190 insertions(+)
>  create mode 100644 drivers/crypto/rk_crypto/Makefile
>  create mode 100644 drivers/crypto/rk_crypto/rk3288_crypto.c
>  create mode 100644 drivers/crypto/rk_crypto/rk3288_crypto.h
>  create mode 100644 drivers/crypto/rk_crypto/rk3288_crypto_ablkcipher.c
> 
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index c3ced6f..00d103c 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -29,3 +29,4 @@ obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
>  obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
>  obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
>  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
> +obj-$(CONFIG_CRYPTO_DEV_RK3288) += rk_crypto/

as Mark said in the other mail, there may very well follow other Rockchip
crypto-related drivers, so maybe it might be better to name the core
option CONFIG_CRYPTO_DEV_ROCKCHIP. And then maybe define
CONFIG_CRYPTO_DEV_RK3288 in a Kconfig in the subdirectory (like vmx does).


> diff --git a/drivers/crypto/rk_crypto/Makefile b/drivers/crypto/rk_crypto/Makefile
> new file mode 100644
> index 0000000..0f62d87
> --- /dev/null
> +++ b/drivers/crypto/rk_crypto/Makefile

generally, a lot of those subdirectories reference only the manufacturer
name, so my suggestion would be to name yours just "rockchip" instead of
"rk_crypto", to also ease readability.


> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_CRYPTO_DEV_RK3288) += rk_crypto_driver.o
> +rk_crypto_driver-objs := rk3288_crypto.o \
> +			 rk3288_crypto_ablkcipher.o \

that looks looks wrong.

(1) the config option does not get defined in any Kconfig file in your set
(2) naming the driver generically while you compile a variant will hinder
    multiplatform kernels, because you might want to build both the rk3288
    code and some additional stuff?
(3) the _driver suffix is unnecessary

So I guess just name it rk3288_crypto.o ?

[...]

While I have read through the code implementing the device, I haven't
seen anything spring out but do not know enough about the crypto subsystem
itself. But it looks like you got some feedback already anyway from others :-)


Thanks
Heiko
