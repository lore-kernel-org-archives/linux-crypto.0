From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 0/3] crypto: stm32 - Add power mamagement support
Date: Tue, 26 Jun 2018 14:52:43 +0200
Message-ID: <1530017566-14779-1-git-send-email-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This set of patches add pm and pm_runtime feature to stm32 crypto
drivers.

Lionel Debieve (3):
  crypto: stm32/cryp - Add power management support
  crypto: stm32/hash - Add power management support
  crypto: stm32/crc - Add power management support

 drivers/crypto/stm32/stm32-cryp.c  | 62 +++++++++++++++++++++++++++++++++
 drivers/crypto/stm32/stm32-hash.c  | 71 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/stm32/stm32_crc32.c | 62 +++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+)

-- 
2.7.4
