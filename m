From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 00/27] staging: ccree: fixes and cleanups
Date: Wed,  3 Jan 2018 13:35:07 +0000
Message-ID: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
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

The usual combo of code cleanups and fixes.

The highlights are:
- Use SPDX for all driver copyright/license
- Make ccree compliant with crypto API handling of backlog requests
- Make ccree compliant with Crypto API rules of resource alloc/release
- Settle on a single coherent file naming convention (which is why
  the diff looks so big)

Note that there are some fixes in the set that I currently consider
out of scope for stable. I will consider if I can/should roll
separate minimal fix patches for stable after these are taken.

With this set of changes, I've handled anything that I know about
that keeps it from moving out of staging to the best of my understanding
and would like to ask for a review before moving out of staging.

Thanks and happy new year ;-)

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Changes from v1:
- Fixed wrong use of CPP style comments in SPDX include file
  headers as pointed out by Philippe Ombredanne.
- Moved to using SPDX-3.0 style GPL-2.0-only tags
- Rephrased one commit message to better clarify it is a fix
  and not just a cleanup
- Separated two commits which got squashed together unintentionally 
- Rebased on top of latest staging-next

Gilad Ben-Yossef (27):
  staging: ccree: SPDXify driver
  staging: ccree: fold hash defs into queue defs
  staging: ccree: fold reg common defines into driver
  staging: ccree: remove GFP_DMA flag from mem allocs
  staging: ccree: pick alloc mem flags based on req flags
  staging: ccree: copy larval digest from RAM
  staging: ccree: tag debugfs init/exit func properly
  staging: ccree: remove unused leftover field
  staging: ccree: break send_request and fix ret val
  staging: ccree: add backlog processing
  stating: ccree: revert "staging: ccree: fix leak of import() after
    init()"
  staging: ccree: failing the suspend is not an error
  staging: ccree: check DMA pool buf !NULL  before free
  staging: ccree: handle end of sg list gracefully
  staging: ccree: use Makefile to include PM code
  staging: ccree: remove unused field
  staging: ccree: use array for double buffer
  staging: ccree: allocate hash bufs inside req ctx
  staging: ccree: do not map bufs in ahash_init
  staging: ccree: fix indentation of func params
  staging: ccree: fold common code into service func
  staging: ccree: put pointer next to var name
  stating: ccree: fix allocation of void sized buf
  staging: ccree: use a consistent file naming convention
  staging: ccree: remove unneeded includes
  staging: ccree: update TODO
  staging: ccree: add missing include

 drivers/staging/ccree/Kconfig            |    2 +
 drivers/staging/ccree/Makefile           |    7 +-
 drivers/staging/ccree/TODO               |    2 +-
 drivers/staging/ccree/cc_aead.c          | 2702 +++++++++++++++++++++++++++++
 drivers/staging/ccree/cc_aead.h          |  109 ++
 drivers/staging/ccree/cc_buffer_mgr.c    | 1651 ++++++++++++++++++
 drivers/staging/ccree/cc_buffer_mgr.h    |   74 +
 drivers/staging/ccree/cc_cipher.c        | 1167 +++++++++++++
 drivers/staging/ccree/cc_cipher.h        |   74 +
 drivers/staging/ccree/cc_crypto_ctx.h    |   21 +-
 drivers/staging/ccree/cc_debugfs.c       |   24 +-
 drivers/staging/ccree/cc_debugfs.h       |   17 +-
 drivers/staging/ccree/cc_driver.c        |  477 ++++++
 drivers/staging/ccree/cc_driver.h        |  194 +++
 drivers/staging/ccree/cc_fips.c          |  112 ++
 drivers/staging/ccree/cc_fips.h          |   37 +
 drivers/staging/ccree/cc_hash.c          | 2297 +++++++++++++++++++++++++
 drivers/staging/ccree/cc_hash.h          |  114 ++
 drivers/staging/ccree/cc_host_regs.h     |  142 ++
 drivers/staging/ccree/cc_hw_queue_defs.h |   32 +-
 drivers/staging/ccree/cc_ivgen.c         |  280 +++
 drivers/staging/ccree/cc_ivgen.h         |   55 +
 drivers/staging/ccree/cc_kernel_regs.h   |  167 ++
 drivers/staging/ccree/cc_lli_defs.h      |   17 +-
 drivers/staging/ccree/cc_pm.c            |  123 ++
 drivers/staging/ccree/cc_pm.h            |   57 +
 drivers/staging/ccree/cc_request_mgr.c   |  714 ++++++++
 drivers/staging/ccree/cc_request_mgr.h   |   51 +
 drivers/staging/ccree/cc_sram_mgr.c      |  107 ++
 drivers/staging/ccree/cc_sram_mgr.h      |   65 +
 drivers/staging/ccree/dx_crys_kernel.h   |  180 --
 drivers/staging/ccree/dx_host.h          |  155 --
 drivers/staging/ccree/dx_reg_common.h    |   26 -
 drivers/staging/ccree/hash_defs.h        |   36 -
 drivers/staging/ccree/ssi_aead.c         | 2720 ------------------------------
 drivers/staging/ccree/ssi_aead.h         |  122 --
 drivers/staging/ccree/ssi_buffer_mgr.c   | 1675 ------------------
 drivers/staging/ccree/ssi_buffer_mgr.h   |   87 -
 drivers/staging/ccree/ssi_cipher.c       | 1182 -------------
 drivers/staging/ccree/ssi_cipher.h       |   87 -
 drivers/staging/ccree/ssi_driver.c       |  519 ------
 drivers/staging/ccree/ssi_driver.h       |  201 ---
 drivers/staging/ccree/ssi_fips.c         |  125 --
 drivers/staging/ccree/ssi_fips.h         |   50 -
 drivers/staging/ccree/ssi_hash.c         | 2459 ---------------------------
 drivers/staging/ccree/ssi_hash.h         |  107 --
 drivers/staging/ccree/ssi_ivgen.c        |  295 ----
 drivers/staging/ccree/ssi_ivgen.h        |   68 -
 drivers/staging/ccree/ssi_pm.c           |  145 --
 drivers/staging/ccree/ssi_pm.h           |   45 -
 drivers/staging/ccree/ssi_request_mgr.c  |  605 -------
 drivers/staging/ccree/ssi_request_mgr.h  |   59 -
 drivers/staging/ccree/ssi_sram_mgr.c     |  117 --
 drivers/staging/ccree/ssi_sram_mgr.h     |   78 -
 54 files changed, 10807 insertions(+), 11227 deletions(-)
 create mode 100644 drivers/staging/ccree/cc_aead.c
 create mode 100644 drivers/staging/ccree/cc_aead.h
 create mode 100644 drivers/staging/ccree/cc_buffer_mgr.c
 create mode 100644 drivers/staging/ccree/cc_buffer_mgr.h
 create mode 100644 drivers/staging/ccree/cc_cipher.c
 create mode 100644 drivers/staging/ccree/cc_cipher.h
 create mode 100644 drivers/staging/ccree/cc_driver.c
 create mode 100644 drivers/staging/ccree/cc_driver.h
 create mode 100644 drivers/staging/ccree/cc_fips.c
 create mode 100644 drivers/staging/ccree/cc_fips.h
 create mode 100644 drivers/staging/ccree/cc_hash.c
 create mode 100644 drivers/staging/ccree/cc_hash.h
 create mode 100644 drivers/staging/ccree/cc_host_regs.h
 create mode 100644 drivers/staging/ccree/cc_ivgen.c
 create mode 100644 drivers/staging/ccree/cc_ivgen.h
 create mode 100644 drivers/staging/ccree/cc_kernel_regs.h
 create mode 100644 drivers/staging/ccree/cc_pm.c
 create mode 100644 drivers/staging/ccree/cc_pm.h
 create mode 100644 drivers/staging/ccree/cc_request_mgr.c
 create mode 100644 drivers/staging/ccree/cc_request_mgr.h
 create mode 100644 drivers/staging/ccree/cc_sram_mgr.c
 create mode 100644 drivers/staging/ccree/cc_sram_mgr.h
 delete mode 100644 drivers/staging/ccree/dx_crys_kernel.h
 delete mode 100644 drivers/staging/ccree/dx_host.h
 delete mode 100644 drivers/staging/ccree/dx_reg_common.h
 delete mode 100644 drivers/staging/ccree/hash_defs.h
 delete mode 100644 drivers/staging/ccree/ssi_aead.c
 delete mode 100644 drivers/staging/ccree/ssi_aead.h
 delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_buffer_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_cipher.c
 delete mode 100644 drivers/staging/ccree/ssi_cipher.h
 delete mode 100644 drivers/staging/ccree/ssi_driver.c
 delete mode 100644 drivers/staging/ccree/ssi_driver.h
 delete mode 100644 drivers/staging/ccree/ssi_fips.c
 delete mode 100644 drivers/staging/ccree/ssi_fips.h
 delete mode 100644 drivers/staging/ccree/ssi_hash.c
 delete mode 100644 drivers/staging/ccree/ssi_hash.h
 delete mode 100644 drivers/staging/ccree/ssi_ivgen.c
 delete mode 100644 drivers/staging/ccree/ssi_ivgen.h
 delete mode 100644 drivers/staging/ccree/ssi_pm.c
 delete mode 100644 drivers/staging/ccree/ssi_pm.h
 delete mode 100644 drivers/staging/ccree/ssi_request_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_request_mgr.h
 delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.c
 delete mode 100644 drivers/staging/ccree/ssi_sram_mgr.h

-- 
2.7.4
