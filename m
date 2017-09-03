From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/8] staging: ccree: more cleanup work for 4.14
Date: Sun,  3 Sep 2017 17:57:35 +0300
Message-ID: <1504450664-28252-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

More cleanup work from Sunil and myself.

I've previously sent some of these as part of a larger patch set.
I've decided to split the patch set to smaller chunks to make it
more manageable.

This patch set applies on top of commit 28eb51f7468a
("staging:rtl8188eu:core Fix remove unneccessary else block").

Changes from v1:
- Fix kbuild reported error of "label at end of compound statement"

Gilad Ben-Yossef (5):
  staging: ccree: simplify resource release on error
  staging: ccree: remove unused completion
  staging: ccree: move over to BIT macro for bit defines
  staging: ccree: replace noop macro with inline
  staging: ccree: remove BUG macro usage

Suniel Mahesh (3):
  staging: ccree: Replace kzalloc with devm_kzalloc
  staging: ccree: Convert to devm_ioremap_resource for map, unmap
  staging: ccree: Use platform_get_irq and devm_request_irq

 drivers/staging/ccree/ssi_aead.c        |   3 +-
 drivers/staging/ccree/ssi_buffer_mgr.c  |  14 +--
 drivers/staging/ccree/ssi_cipher.c      |   4 +-
 drivers/staging/ccree/ssi_cipher.h      |  10 +-
 drivers/staging/ccree/ssi_driver.c      | 196 +++++++++++++-------------------
 drivers/staging/ccree/ssi_driver.h      |  15 +--
 drivers/staging/ccree/ssi_hash.c        |   3 +-
 drivers/staging/ccree/ssi_pm.c          |   3 +-
 drivers/staging/ccree/ssi_request_mgr.c |  22 +++-
 9 files changed, 118 insertions(+), 152 deletions(-)

-- 
2.1.4
