From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 07/10] staging: ccree: update TODO list
Date: Sun,  3 Dec 2017 13:58:18 +0000
Message-ID: <1512309503-29766-8-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
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

Update the ccree staging TODO list in light of recent work.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/TODO | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/ccree/TODO b/drivers/staging/ccree/TODO
index c9f5754..f44edcd 100644
--- a/drivers/staging/ccree/TODO
+++ b/drivers/staging/ccree/TODO
@@ -6,25 +6,6 @@
 *									*
 *************************************************************************
 
-ccree specific items
-a.k.a stuff fixing for this driver to move out of staging
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+1. Migrate sysfs to debugfs.
+2. Handle HW FIFO fullness more cleanly.
 
-1.  Move to using Crypto Engine to handle backlog queueing.
-2.  Remove synchronous algorithm support leftovers.
-3.  Separate platform specific code for FIPS and power management into separate platform modules.
-4.  Drop legacy kernel support code.
-5.  Move most (all?) #ifdef CONFIG into inline functions.
-6.  Remove all unused definitions.
-7.  Re-factor to accomediate newer/older HW revisions besides the 712.
-8.  Handle the many checkpatch errors.
-9.  Implement ahash import/export correctly.
-10. Go through a proper review of DT bindings and sysfs ABI
-11. Sort out FIPS mode: bake tests into testmgr, sort out behaviour on error, 
-    figure if 3DES weak key check is needed
-
-Kernel infrastructure items
-a.k.a stuff we either neither need to fix in the kernel or understand what we're doing wrong
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-1. ahash import/export context has a PAGE_SIZE/8 size limit.  We need more.
-2. Crypto Engine seems to be built for HW with hardware queue depth of 1, we have 600++.
-- 
2.7.4
