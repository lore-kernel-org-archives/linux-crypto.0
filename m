From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/3] staging: ccree: Fixes and cleanups
Date: Thu,  2 Nov 2017 08:10:20 +0000
Message-ID: <1509610224-14708-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

Fixes and cleanups for 4.15

Changes from v1:
- Move DMA mask code to before turning on clocks, based
  on feedback from Dan Carpenter.
- Add missing kmalloc success check, as spotted by Dan
  Carpenter.

Gilad Ben-Yossef (3):
  staging: ccree: copy IV to DMAable memory
  staging: ccree: handle limiting of DMA masks
  staging: ccree: remove dead code

 drivers/staging/ccree/ssi_cipher.c | 24 ++++++++++++++++++------
 drivers/staging/ccree/ssi_cipher.h |  1 +
 drivers/staging/ccree/ssi_driver.c | 25 ++++++++++++++++++++-----
 drivers/staging/ccree/ssi_driver.h |  1 -
 4 files changed, 39 insertions(+), 12 deletions(-)

-- 
2.7.4
