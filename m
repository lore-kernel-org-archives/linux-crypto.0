From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 0/8] improve performances on mediatek crypto driver
Date: Thu, 9 Mar 2017 10:11:11 +0800
Message-ID: <1489025479-48036-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

Some patches of this series improve the performances whereas others
clean up code and refine data structure to make it more efficient

Changes since v1:
- drop OFB and CFB patch

Ryder Lee (8):
  crypto: mediatek - rework interrupt handler
  crypto: mediatek - add MTK_* prefix and correct annotations.
  crypto: mediatek - make mtk_sha_xmit() more generic
  crypto: mediatek - simplify descriptor ring management
  crypto: mediatek - add queue_task tasklet
  crypto: mediatek - fix error handling in mtk_aes_complete()
  crypto: mediatek - add mtk_aes_gcm_tag_verify()
  crypto: mediatek - make hardware operation flow more efficient

 drivers/crypto/mediatek/mtk-aes.c      | 421 +++++++++++++++++----------------
 drivers/crypto/mediatek/mtk-platform.c |  15 +-
 drivers/crypto/mediatek/mtk-platform.h |  56 +++--
 drivers/crypto/mediatek/mtk-sha.c      | 309 +++++++++---------------
 4 files changed, 369 insertions(+), 432 deletions(-)

-- 
1.9.1
