From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 0/6] ccree style fixes and simplification
Date: Sun, 30 Jul 2017 19:15:02 +0300
Message-ID: <1501431309-27705-1-git-send-email-gilad@benyossef.com>
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

Various style code fixes and simplification from myself and Suniel.

Changes from v2:

- Rebase on top of current staging-next.
- Added resource release on error simplification patch suggested by
  Dan C. as part of the review.

I made sure the code applies on top both current staging-next
(commit 0d0d4d21a09981e65b2bd386c999e8c0ecc6444e) as well as
staging-testing and of course compiles and runs. If this doesn't
apply cleanly I'm going to start suspecting Gremlins at out IT dept.

Gilad Ben-Yossef (3):
  staging: ccree: fix split strings
  staging: ccree: kmalloc by sizeof var not type
  staging: ccree: simplify resource release on error

Suniel Mahesh (3):
  staging: ccree: Replace kzalloc with devm_kzalloc
  staging: ccree: Convert to devm_ioremap_resource for map, unmap
  staging: ccree: Use platform_get_irq and devm_request_irq

 drivers/staging/ccree/ssi_aead.c        |  16 ++-
 drivers/staging/ccree/ssi_buffer_mgr.c  |  86 ++++++--------
 drivers/staging/ccree/ssi_cipher.c      |  34 +++---
 drivers/staging/ccree/ssi_driver.c      | 192 +++++++++++++-------------------
 drivers/staging/ccree/ssi_driver.h      |   4 +-
 drivers/staging/ccree/ssi_hash.c        |  50 ++++-----
 drivers/staging/ccree/ssi_ivgen.c       |  10 +-
 drivers/staging/ccree/ssi_request_mgr.c |  15 +--
 8 files changed, 170 insertions(+), 237 deletions(-)

-- 
2.1.4
