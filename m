From: Lionel Debieve <lionel.debieve@st.com>
Subject: [PATCH 0/2] Fix stm32-rng for default state and suspend
Date: Mon, 23 Apr 2018 17:04:24 +0200
Message-ID: <20180423150426.22198-1-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Rob Herring <rob.herring@linaro.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series are fixing the default build state for stm32-rng that
activate the driver with arm multi_v7_defconfig.
Second patch is fixing the power suspend/resume behavior which was
not working.

Lionel Debieve (2):
  hwrng: stm32 - define default state for rng driver
  hwrng: stm32-rng: Fix pm_suspend issue

 drivers/char/hw_random/Kconfig     | 1 +
 drivers/char/hw_random/stm32-rng.c | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
2.15.1
