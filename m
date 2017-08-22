From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 00/11] crypto: gcm - add GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:07 +0200
Message-ID: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
 linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de,
 mingo@redhat.com, hpa@zytor.com, x86@kernel.org, horia.geanta@nxp.com,
 dan.douglass@nxp.com, thomas.lendacky@amd.com, gary.hook@amd.com,
 harsh@chelsio.com, matthias.bgg@gmail.com, leosilva@linux.vnet.ibm.com,
 pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
 mpe@ellerman.id.au
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

Many GCM users use directly GCM IV size instead of using some constant.

This patch add all IV size constant used by GCM and convert drivers for using them..

Corentin Labbe (11):
  crypto: gcm - add GCM iv size constant
  crypto: caam - Use GCM IV size constant
  crypto: ccp - Use GCM IV size constant
  crypto: nx - Use GCM IV size constant
  crypto: atmel - Use GCM IV size constant
  crypto: bcm - Use GCM IV size constant
  crypto: mediatek - Use GCM IV size constant
  crypto: chelsio - Use GCM IV size constant
  crypto: omap - Use GCM IV size constant
  crypto: gcm - Use GCM IV size constant
  crypto: aesni - Use GCM IV size constant

 arch/x86/crypto/aesni-intel_glue.c         |  7 ++++---
 crypto/gcm.c                               | 23 ++++++++++++-----------
 drivers/crypto/atmel-aes.c                 |  5 +++--
 drivers/crypto/bcm/cipher.c                |  8 ++++----
 drivers/crypto/bcm/cipher.h                |  3 +--
 drivers/crypto/caam/caamalg.c              | 10 +++++-----
 drivers/crypto/caam/compat.h               |  1 +
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |  9 ++++-----
 drivers/crypto/chelsio/chcr_algo.c         |  9 +++++----
 drivers/crypto/mediatek/mtk-aes.c          |  3 ++-
 drivers/crypto/nx/nx-aes-gcm.c             |  9 +++++----
 drivers/crypto/omap-aes-gcm.c              |  7 ++++---
 drivers/crypto/omap-aes.c                  |  5 +++--
 include/crypto/gcm.h                       |  8 ++++++++
 14 files changed, 61 insertions(+), 46 deletions(-)
 create mode 100644 include/crypto/gcm.h

-- 
2.13.0
