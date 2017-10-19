From: Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH v4 0/2] STM32 CRYP crypto driver
Date: Thu, 19 Oct 2017 11:03:57 +0200
Message-ID: <1508403839-14131-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Lionel Debieve <lionel.debieve@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:40666 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752020AbdJSJE4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2017 05:04:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This set of patches adds a new crypto driver for STMicroelectronics stm32 HW.
This drivers uses the crypto API and provides with HW-enabled block cipher
algorithms.

This driver was successfully tested with tcrypt / testmgr.

Changes since v4:
- remove AEAD support from crypto engine as proposed by Herbert : waiting for
  the crypto_engine interface clean up before
  [https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1474434.html]
- remove AES GCM & CCM algorithms

Changes since v3:
- update dt-bindings with Rob Herring remarks

Changes since v2:
- update dt-bindings (interrupts description)
- rebase on STM32 crypto patches (L. Debieve : update CRC32 + add HASH)

Fabien Dessenne (3):
  crypto: engine - permit to enqueue aead_request
  dt-bindings: Document STM32 CRYP bindings
  crypto: stm32 - Support for STM32 CRYP crypto module

Fabien Dessenne (2):
  dt-bindings: Document STM32 CRYP bindings
  crypto: stm32 - Support for STM32 CRYP crypto module

 .../devicetree/bindings/crypto/st,stm32-cryp.txt   |   19 +
 drivers/crypto/stm32/Kconfig                       |    9 +
 drivers/crypto/stm32/Makefile                      |    3 +-
 drivers/crypto/stm32/stm32-cryp.c                  | 1188 ++++++++++++++++++++
 4 files changed, 1218 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
 create mode 100644 drivers/crypto/stm32/stm32-cryp.c

-- 
2.7.4
