From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] crypto: stm32 - Add CRC32 support for STM32F4XX
Date: Mon, 22 May 2017 19:29:48 -0500
Message-ID: <20170523002948.k4fh24rzccix2bsn@rob-hp-laptop>
References: <1494969530-91589-1-git-send-email-cosardindar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        mark.rutland@arm.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, linux@armlinux.org.uk,
        weiyongjun1@huawei.com, fabien.dessenne@st.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Cosar Dindar <cosardindar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35041 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760227AbdEWA3t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2017 20:29:49 -0400
Content-Disposition: inline
In-Reply-To: <1494969530-91589-1-git-send-email-cosardindar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 17, 2017 at 12:18:50AM +0300, Cosar Dindar wrote:
> This patch series add hardware CRC32 ("Ethernet") calculation support
> for STMicroelectronics STM32F4XX series devices.
> 
> As an hardware limitation polynomial and key setting are not supported
> as they are fixed as 0x4C11DB7 (poly) and 0xFFFFFFFF (key).
> 
> CRC32C Castagnoli algorithm is not supported also.
> Module is tested on STM32F429-disco board with crypto testmgr using
> cases within the key 0xFFFFFFFF.
> 
> Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
> ---
>  .../devicetree/bindings/crypto/st,stm32-crc.txt    |  4 +-
>  arch/arm/boot/dts/stm32429i-eval.dts               |  4 ++
>  arch/arm/boot/dts/stm32f429-disco.dts              |  4 ++
>  arch/arm/boot/dts/stm32f429.dtsi                   |  7 +++
>  arch/arm/boot/dts/stm32f469-disco.dts              |  4 ++
>  drivers/crypto/stm32/stm32_crc32.c                 | 68 ++++++++++++++++++----
>  6 files changed, 79 insertions(+), 12 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
