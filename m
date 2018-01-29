From: Lionel Debieve <lionel.Debieve@st.com>
Subject: [PATCH 0/3] crypto: stm32/hash: Correction to improve robustness
Date: Mon, 29 Jan 2018 15:28:08 +0100
Message-ID: <20180129142811.13273-1-lionel.Debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ludovic Barre <ludovic.barre@st.com>,
 Lionel Debieve <lionel.debieve@st.com>,
 Benjamin Gaignard <benjamin.gaignard@st.com>,
 Fabien Dessenne <fabien.dessenne@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
 <davem@davemloft.net>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@st.com>,
 <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>
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

From: Lionel Debieve <lionel.debieve@st.com>

Hi,

This patch serie will improve global robustness for stm32-hash driver. 

Patch #1 is fixing dma-burst issue when configuration is not set.
Patch #2 solves issue that occurs when irq append during final req processing.
Patch #3 is fixing an issue that have been introduced while managing padding but
breaking the padding length calculation by hardware to generate correct hash.

Regards,

Lionel Debieve (3):
  crypto: stm32/hash: avoid error if maxburst not defined
  crypto: stm32/hash: fix performance issues
  crypto: stm32/hash: rework padding length

 drivers/crypto/stm32/stm32-hash.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

-- 
2.15.1
