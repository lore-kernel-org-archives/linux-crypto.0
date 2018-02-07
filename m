From: Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH 0/2] crypto: stm32/cryp - add AEAD cipher algorithms
Date: Wed, 7 Feb 2018 14:08:53 +0100
Message-ID: <1518008935-30428-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Lionel Debieve <lionel.debieve@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patchset depends on "crypto: engine - Permit to enqueue all async requests"
proposed by Corentin Labbe [https://lkml.org/lkml/2018/1/26/608].
stm32-cryp uses this updated crpyto engine to handle AEAD cipher algortihms.

Fabien Dessenne (2):
  crypto: stm32/cryp - add aes gcm / ccm support
  crypto: stm32/cryp - add stm32mp1 support

 drivers/crypto/stm32/stm32-cryp.c | 937 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 908 insertions(+), 29 deletions(-)

-- 
2.7.4
