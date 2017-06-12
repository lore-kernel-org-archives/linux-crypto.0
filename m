From: Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH v3 0/5] Add support for the STM32F4 CRC32
Date: Mon, 12 Jun 2017 11:48:22 +0200
Message-ID: <96bd3288-b4f4-87c9-2904-aa52d10ea797@st.com>
References: <cover.1495463262.git.cosardindar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <mcoquelin.stm32@gmail.com>,
        <fabien.dessenne@st.com>, <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
To: Cosar Dindar <cosardindar@gmail.com>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56670 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752065AbdFLJtO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2017 05:49:14 -0400
In-Reply-To: <cover.1495463262.git.cosardindar@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Cosar,

On 05/22/2017 04:33 PM, Cosar Dindar wrote:
> This patch series add hardware CRC32 ("Ethernet") calculation support
> for STMicroelectronics STM32F429.
> 
> Polynomial and key setting are not supported, key is fixed as 0x4C11DB7
> and poly is 0xFFFFFFFF.
> 
> Module is tested on STM32F429-disco board with crypto testmgr using
> cases within the key 0xFFFFFFFF.
> 
> Changes in v3:
>      Rearranged patch order to fix build test error.
> 
> Cosar Dindar (5):
>    dt-bindings : Document the STM32F4 CRC32 binding
>    crypto : stm32 - Add STM32F4 CRC32 support
>    ARM: dts: stm32: Add CRC support to stm32f429
>    ARM: dts: stm32: enable CRC32 on stm32429-disco board
>    ARM: dts: stm32: enable CRC32 on stm32429i-eval board
> 
>   .../devicetree/bindings/crypto/st,stm32-crc.txt    |  4 +-
>   arch/arm/boot/dts/stm32429i-eval.dts               |  4 ++
>   arch/arm/boot/dts/stm32f429-disco.dts              |  4 ++
>   arch/arm/boot/dts/stm32f429.dtsi                   |  7 +++
>   drivers/crypto/stm32/stm32_crc32.c                 | 68 ++++++++++++++++++----
>   5 files changed, 75 insertions(+), 12 deletions(-)
> 

Patches 3, 4, 5 applied on stm32-dt-for-v4.13

regards
Alex
