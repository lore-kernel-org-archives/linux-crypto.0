From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/9] crypto: add HMAC IPAD/OPAD constant
Date: Fri, 19 May 2017 08:53:22 +0200
Message-ID: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: qat-linux@intel.com, linux-kernel@vger.kernel.org,
 Corentin Labbe <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, thomas.lendacky@amd.com,
 gary.hook@amd.com, boris.brezillon@free-electrons.com, arno@natisbad.org,
 matthias.bgg@gmail.com, giovanni.cabiddu@intel.com,
 salvatore.benedetto@intel.com
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

Hello

Many HMAC users directly use directly 0x36/0x5c values.
It's better with crypto to use a name instead of directly some crypto constant.

Changes since v1:
- Moved constant to include/crypto/hmac.h
- Added <crypto/hmac.h> to includes

Corentin Labbe (9):
  crypto: add hmac IPAD/OPAD constant
  crypto: brcm - Use IPAD/OPAD constant
  crypto: ixp4xx - Use IPAD/OPAD constant
  crypto: marvell - Use IPAD/OPAD constant
  crypto: mv_cesa - Use IPAD/OPAD constant
  crypto: omap-sham - Use IPAD/OPAD constant
  crypto: qat - Use IPAD/OPAD constant
  crypto: mediatek - Use IPAD/OPAD constant
  crypto: ccp - Use IPAD/OPAD constant

 crypto/hmac.c                            | 5 +++--
 drivers/crypto/bcm/cipher.c              | 5 +++--
 drivers/crypto/ccp/ccp-crypto-sha.c      | 5 +++--
 drivers/crypto/ixp4xx_crypto.c           | 3 +--
 drivers/crypto/marvell/hash.c            | 5 +++--
 drivers/crypto/mediatek/mtk-sha.c        | 5 +++--
 drivers/crypto/mv_cesa.c                 | 5 +++--
 drivers/crypto/omap-sham.c               | 5 +++--
 drivers/crypto/qat/qat_common/qat_algs.c | 5 +++--
 include/crypto/hmac.h                    | 7 +++++++
 10 files changed, 32 insertions(+), 18 deletions(-)
 create mode 100644 include/crypto/hmac.h

-- 
2.13.0
