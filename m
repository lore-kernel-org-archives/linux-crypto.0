From: Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH v2 0/3] STM32 CRYP crypto driver
Date: Tue, 15 Aug 2017 09:19:41 +0200
Message-ID: <1502781584-18468-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lionel Debieve <lionel.debieve@st.com>,
 Benjamin Gaignard <benjamin.gaignard@st.com>,
 Ludovic Barre <ludovic.barre@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
 <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@st.com>,
 <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This set of patches adds a new crypto driver for STMicroelectronics stm32 HW.
This drivers uses the crypto API and provides with HW-enabled AEAD and block
cipher algorithms.
It makes use of the crypto engine which is upgraded in order to support AEAD
requests.

This driver was successfully tested with tcrypt / testmgr.

Changes since v2:
- update dt-bindings (interrupts description)
- rebase on STM32 crypto patches (L. Debieve : update CRC32 + add HASH)

Fabien Dessenne (3):
  crypto: engine - permit to enqueue aead_request
  dt-bindings: Document STM32 CRYP bindings
  crypto: stm32 - Support for STM32 CRYP crypto module

 .../devicetree/bindings/crypto/st,stm32-cryp.txt   |   20 +
 crypto/crypto_engine.c                             |  101 +
 drivers/crypto/stm32/Kconfig                       |    9 +
 drivers/crypto/stm32/Makefile                      |    3 +-
 drivers/crypto/stm32/stm32-cryp.c                  | 1962 ++++++++++++++++++++
 include/crypto/engine.h                            |   16 +
 6 files changed, 2110 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
 create mode 100644 drivers/crypto/stm32/stm32-cryp.c

-- 
2.7.4
