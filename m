From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 10/12] staging: ccree: drop no longer used macro
Date: Sun, 28 May 2017 17:40:35 +0300
Message-ID: <1495982440-10047-11-git-send-email-gilad@benyossef.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

MSB64 macro is no longer used or needed. Drop it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index ec2113a..f12761a 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -237,8 +237,6 @@ static inline void set_ack_last(struct cc_hw_desc *pdesc)
 	pdesc->word[4] |= FIELD_PREP(WORD4_ACK_NEEDED, 1);
 }
 
-#define MSB64(_addr) (sizeof(_addr) == 4 ? 0 : ((_addr) >> 32) & U16_MAX)
-
 /*
  * Set the DIN field of a HW descriptors
  *
-- 
2.1.4
