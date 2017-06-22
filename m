From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 4/7] staging: ccree: remove unused function
Date: Thu, 22 Jun 2017 16:36:58 +0300
Message-ID: <1498138623-6126-5-git-send-email-gilad@benyossef.com>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The function set_ack_last was not used anywhere. Remove it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index c730c3c..ac0eb97 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -226,18 +226,6 @@ static inline void set_queue_last_ind_bit(struct cc_hw_desc *pdesc)
 }
 
 /*
- * Signs the end of HW descriptors flow by asking for completion ack,
- * and release the HW engines
- *
- * @pdesc: pointer HW descriptor struct
- */
-static inline void set_ack_last(struct cc_hw_desc *pdesc)
-{
-	pdesc->word[3] |= FIELD_PREP(WORD3_QUEUE_LAST_IND, 1);
-	pdesc->word[4] |= FIELD_PREP(WORD4_ACK_NEEDED, 1);
-}
-
-/*
  * Set the DIN field of a HW descriptors
  *
  * @pdesc: pointer HW descriptor struct
-- 
2.1.4
