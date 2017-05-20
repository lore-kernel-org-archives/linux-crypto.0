From: Cosar Dindar <cosardindar@gmail.com>
Subject: [PATCH v2 0/5] Add support for the STM32F4 CRC32
Date: Sat, 20 May 2017 16:30:18 +0300
Message-ID: <cover.1495285223.git.cosardindar@gmail.com>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, fabien.dessenne@st.com,
        weiyongjun1@huawei.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Cosar Dindar <cosardindar@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36776 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751206AbdETNbI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 May 2017 09:31:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series add hardware CRC32 ("Ethernet") calculation support
for STMicroelectronics STM32F429.

Polynomial and key setting are not supported, key is fixed as 0x4C11DB7
and poly is 0xFFFFFFFF.

Module is tested on STM32F429-disco board with crypto testmgr using
cases within the key 0xFFFFFFFF.

Cosar Dindar (5):
  crypto : stm32 - Add STM32F4 CRC32 support
  dt-bindings : Document the STM32F4 CRC32 binding
  ARM: dts: stm32: enable CRC32 on stm32429-disco board
  ARM: dts: stm32: enable CRC32 on stm32429i-eval board
  ARM: dts: stm32: Add CRC support to stm32f429

 .../devicetree/bindings/crypto/st,stm32-crc.txt    |  4 +-
 arch/arm/boot/dts/stm32429i-eval.dts               |  4 ++
 arch/arm/boot/dts/stm32f429-disco.dts              |  4 ++
 arch/arm/boot/dts/stm32f429.dtsi                   |  7 +++
 drivers/crypto/stm32/stm32_crc32.c                 | 68 ++++++++++++++++++----
 5 files changed, 75 insertions(+), 12 deletions(-)

-- 
2.7.4
