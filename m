From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 00/10] staging: ccree: fixes and cleanups
Date: Thu,  9 Nov 2017 09:16:08 +0000
Message-ID: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
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

This is another batch of ccree fixes & cleanups.

The first patch is a bug fix. All others are pure
readability and coding style fixes.

Changes from v1:
- Fix several coding style issues pointed out by
  Dan Carpenter.
- Added two more patches of similar issues that
  surfaced during the review.

Gilad Ben-Yossef (10):
  staging: ccree: fix leak of import() after init()
  staging: ccree: make long func call sites readable
  staging: ccree: simplify AEAD using local var
  staging: ccree: simplify buf mgr using local vars
  staging: ccree: fold common code into function
  staging: ccree: simplify pm manager using local var
  staging: ccree: remove unneeded cast
  staging: ccree: remove compare to none zero
  staging: ccree: remove braces for single statement
  staging: ccree: remove unused cc_base parameter

 drivers/staging/ccree/ssi_aead.c        |  60 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 553 ++++++++++++++------------------
 drivers/staging/ccree/ssi_buffer_mgr.h  |  49 ++-
 drivers/staging/ccree/ssi_cipher.c      |  39 ++-
 drivers/staging/ccree/ssi_driver.c      |  51 ++-
 drivers/staging/ccree/ssi_driver.h      |   2 +-
 drivers/staging/ccree/ssi_hash.c        | 201 ++++++------
 drivers/staging/ccree/ssi_ivgen.c       |   4 +-
 drivers/staging/ccree/ssi_pm.c          |  46 ++-
 drivers/staging/ccree/ssi_pm.h          |  12 +-
 drivers/staging/ccree/ssi_request_mgr.c |  29 +-
 drivers/staging/ccree/ssi_request_mgr.h |   6 +-
 drivers/staging/ccree/ssi_sram_mgr.c    |  13 +-
 drivers/staging/ccree/ssi_sram_mgr.h    |   6 +-
 14 files changed, 502 insertions(+), 569 deletions(-)

-- 
2.7.4
