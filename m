From: Cosar Dindar <cosardindar@gmail.com>
Subject: [PATCH v3 0/5] Add support for the STM32F4 CRC32
Date: Mon, 22 May 2017 17:33:13 +0300
Message-ID: <cover.1495463262.git.cosardindar@gmail.com>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, fabien.dessenne@st.com,
        weiyongjun1@huawei.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Cosar Dindar <cosardindar@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch series add hardware CRC32 ("Ethernet") calculation support
for STMicroelectronics STM32F429.

Polynomial and key setting are not supported, key is fixed as 0x4C11DB7
and poly is 0xFFFFFFFF.

Module is tested on STM32F429-disco board with crypto testmgr using
cases within the key 0xFFFFFFFF.

Changes in v3:
    Rearranged patch order to fix build test error.

Cosar Dindar (5):
  dt-bindings : Document the STM32F4 CRC32 binding
  crypto : stm32 - Add STM32F4 CRC32 support
  ARM: dts: stm32: Add CRC support to stm32f429
  ARM: dts: stm32: enable CRC32 on stm32429-disco board
  ARM: dts: stm32: enable CRC32 on stm32429i-eval board

 .../devicetree/bindings/crypto/st,stm32-crc.txt    |  4 +-
 arch/arm/boot/dts/stm32429i-eval.dts               |  4 ++
 arch/arm/boot/dts/stm32f429-disco.dts              |  4 ++
 arch/arm/boot/dts/stm32f429.dtsi                   |  7 +++
 drivers/crypto/stm32/stm32_crc32.c                 | 68 ++++++++++++++++++----
 5 files changed, 75 insertions(+), 12 deletions(-)

-- 
2.7.4
