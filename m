From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH 0/3] Raid: enable talitos xor offload for improving performance
Date: Tue, 10 Jul 2012 14:00:35 +0800
Message-ID: <1341900035-20958-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

The following 4 patches enabling fsl-dma and talitos offload raid
operations for improving raid performance and balancing CPU load.

Write performance will be improved by 40% tested by iozone. CPU load
will be reduced by 8%.

Qiang Liu (4):
      Talitos: move the data structure into header file
      Talitos: Support for async_tx XOR offload
      fsl-dma: support attribute of DMA_MEMORY when async_tx enabled
      Talitos: fix the issue of dma memory leak

 drivers/crypto/Kconfig   |    9 +
 drivers/crypto/talitos.c |  520 ++++++++++++++++++++++++++++++++++++----------
 drivers/crypto/talitos.h |  161 ++++++++++++++
 drivers/dma/fsldma.c     |   78 +++-----
 4 files changed, 606 insertions(+), 162 deletions(-)
