From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 10/10] staging: ccree: update TODO
Date: Thu, 14 Dec 2017 14:02:47 +0000
Message-ID: <1513260170-26346-11-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Update TODO with handling on sysfs -> debugfs transition

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/TODO | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/TODO b/drivers/staging/ccree/TODO
index f44edcd..6d8702b 100644
--- a/drivers/staging/ccree/TODO
+++ b/drivers/staging/ccree/TODO
@@ -6,6 +6,5 @@
 *									*
 *************************************************************************
 
-1. Migrate sysfs to debugfs.
-2. Handle HW FIFO fullness more cleanly.
+1. Handle HW FIFO fullness more cleanly.
 
-- 
2.7.4
