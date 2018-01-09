From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/5] more cleanups
Date: Tue,  9 Jan 2018 10:24:28 +0000
Message-ID: <1515493478-30454-1-git-send-email-gilad@benyossef.com>
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

File name consistency renames, include files diet and address
some sparse warnings.

Gilad Ben-Yossef (5):
  staging: ccree: use a consistent file naming convention
  staging: ccree: remove unneeded includes
  staging: ccree: add missing include
  staging: ccree: make stub function static inline
  staging: ccree: dma mask is type u64

 drivers/staging/ccree/Makefile                     |  6 +--
 drivers/staging/ccree/{ssi_aead.c => cc_aead.c}    | 19 +++-----
 drivers/staging/ccree/{ssi_aead.h => cc_aead.h}    |  2 +-
 .../ccree/{ssi_buffer_mgr.c => cc_buffer_mgr.c}    | 14 ++----
 .../ccree/{ssi_buffer_mgr.h => cc_buffer_mgr.h}    |  4 +-
 .../staging/ccree/{ssi_cipher.c => cc_cipher.c}    | 12 ++---
 .../staging/ccree/{ssi_cipher.h => cc_cipher.h}    |  6 +--
 drivers/staging/ccree/cc_debugfs.c                 |  3 +-
 drivers/staging/ccree/cc_debugfs.h                 |  8 ++--
 .../staging/ccree/{ssi_driver.c => cc_driver.c}    | 55 +++++-----------------
 .../staging/ccree/{ssi_driver.h => cc_driver.h}    |  6 +--
 drivers/staging/ccree/{ssi_fips.c => cc_fips.c}    |  4 +-
 drivers/staging/ccree/{ssi_fips.h => cc_fips.h}    |  0
 drivers/staging/ccree/{ssi_hash.c => cc_hash.c}    | 12 ++---
 drivers/staging/ccree/{ssi_hash.h => cc_hash.h}    |  4 +-
 .../staging/ccree/{dx_host.h => cc_host_regs.h}    |  0
 drivers/staging/ccree/cc_hw_queue_defs.h           |  2 +-
 drivers/staging/ccree/{ssi_ivgen.c => cc_ivgen.c}  | 11 ++---
 drivers/staging/ccree/{ssi_ivgen.h => cc_ivgen.h}  |  0
 .../ccree/{dx_crys_kernel.h => cc_kernel_regs.h}   |  0
 drivers/staging/ccree/{ssi_pm.c => cc_pm.c}        | 16 +++----
 drivers/staging/ccree/{ssi_pm.h => cc_pm.h}        |  4 +-
 .../ccree/{ssi_request_mgr.c => cc_request_mgr.c}  | 15 ++----
 .../ccree/{ssi_request_mgr.h => cc_request_mgr.h}  |  2 +-
 .../ccree/{ssi_sram_mgr.c => cc_sram_mgr.c}        |  4 +-
 .../ccree/{ssi_sram_mgr.h => cc_sram_mgr.h}        |  0
 26 files changed, 76 insertions(+), 133 deletions(-)
 rename drivers/staging/ccree/{ssi_aead.c => cc_aead.c} (99%)
 rename drivers/staging/ccree/{ssi_aead.h => cc_aead.h} (99%)
 rename drivers/staging/ccree/{ssi_buffer_mgr.c => cc_buffer_mgr.c} (99%)
 rename drivers/staging/ccree/{ssi_buffer_mgr.h => cc_buffer_mgr.h} (97%)
 rename drivers/staging/ccree/{ssi_cipher.c => cc_cipher.c} (99%)
 rename drivers/staging/ccree/{ssi_cipher.h => cc_cipher.h} (95%)
 rename drivers/staging/ccree/{ssi_driver.c => cc_driver.c} (90%)
 rename drivers/staging/ccree/{ssi_driver.h => cc_driver.h} (98%)
 rename drivers/staging/ccree/{ssi_fips.c => cc_fips.c} (98%)
 rename drivers/staging/ccree/{ssi_fips.h => cc_fips.h} (100%)
 rename drivers/staging/ccree/{ssi_hash.c => cc_hash.c} (99%)
 rename drivers/staging/ccree/{ssi_hash.h => cc_hash.h} (98%)
 rename drivers/staging/ccree/{dx_host.h => cc_host_regs.h} (100%)
 rename drivers/staging/ccree/{ssi_ivgen.c => cc_ivgen.c} (97%)
 rename drivers/staging/ccree/{ssi_ivgen.h => cc_ivgen.h} (100%)
 rename drivers/staging/ccree/{dx_crys_kernel.h => cc_kernel_regs.h} (100%)
 rename drivers/staging/ccree/{ssi_pm.c => cc_pm.c} (91%)
 rename drivers/staging/ccree/{ssi_pm.h => cc_pm.h} (95%)
 rename drivers/staging/ccree/{ssi_request_mgr.c => cc_request_mgr.c} (98%)
 rename drivers/staging/ccree/{ssi_request_mgr.h => cc_request_mgr.h} (98%)
 rename drivers/staging/ccree/{ssi_sram_mgr.c => cc_sram_mgr.c} (98%)
 rename drivers/staging/ccree/{ssi_sram_mgr.h => cc_sram_mgr.h} (100%)

-- 
2.7.4
