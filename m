From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 07/15] staging: ccree: add TODO list
Date: Sun, 23 Apr 2017 12:26:15 +0300
Message-ID: <1492939583-25688-8-git-send-email-gilad@benyossef.com>
References: <1492939583-25688-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, gilad.benyossef@arm.com,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>,
        Stephan Muller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:46976 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1044405AbdDWJ1I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 05:27:08 -0400
In-Reply-To: <1492939583-25688-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add TODO list for moving out of staging tree for ccree crypto driver

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/TODO | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 drivers/staging/ccree/TODO

diff --git a/drivers/staging/ccree/TODO b/drivers/staging/ccree/TODO
new file mode 100644
index 0000000..c9f5754
--- /dev/null
+++ b/drivers/staging/ccree/TODO
@@ -0,0 +1,30 @@
+
+
+*************************************************************************
+*									*
+* Arm Trust Zone CryptoCell REE Linux driver upstreaming TODO items	*
+*									*
+*************************************************************************
+
+ccree specific items
+a.k.a stuff fixing for this driver to move out of staging
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+1.  Move to using Crypto Engine to handle backlog queueing.
+2.  Remove synchronous algorithm support leftovers.
+3.  Separate platform specific code for FIPS and power management into separate platform modules.
+4.  Drop legacy kernel support code.
+5.  Move most (all?) #ifdef CONFIG into inline functions.
+6.  Remove all unused definitions.
+7.  Re-factor to accomediate newer/older HW revisions besides the 712.
+8.  Handle the many checkpatch errors.
+9.  Implement ahash import/export correctly.
+10. Go through a proper review of DT bindings and sysfs ABI
+11. Sort out FIPS mode: bake tests into testmgr, sort out behaviour on error, 
+    figure if 3DES weak key check is needed
+
+Kernel infrastructure items
+a.k.a stuff we either neither need to fix in the kernel or understand what we're doing wrong
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+1. ahash import/export context has a PAGE_SIZE/8 size limit.  We need more.
+2. Crypto Engine seems to be built for HW with hardware queue depth of 1, we have 600++.
-- 
2.1.4
