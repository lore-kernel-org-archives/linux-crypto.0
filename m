From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 0/3] STM32 CRC update
Date: Thu, 13 Jul 2017 15:06:30 +0200
Message-ID: <1499951193-14842-1-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Lionel Debieve <lionel.debieve@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:25234 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751204AbdGMNHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 09:07:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This set of patches update the STM32 CRC driver.
It contains two corrections and one global Kconfig rework.
First correction is about the relaxed usage in scope of arm
platform usage, second about a unbind driver issue.
Last patch is about a Kconfig rework that make configuration
generic for STM32 crypto algos, HASH and CRYP are pushed
accordingly.

Lionel Debieve (3):
  crypto: stm32 - CRC use relaxed function
  crypto: stm32 - solve crc issue during unbind
  crypto: stm32 - Rename module to use generic crypto

 drivers/crypto/Makefile            |  2 +-
 drivers/crypto/stm32/Kconfig       |  6 +++---
 drivers/crypto/stm32/Makefile      |  3 +--
 drivers/crypto/stm32/stm32_crc32.c | 17 +++++++++--------
 4 files changed, 14 insertions(+), 14 deletions(-)

-- 
2.7.4
