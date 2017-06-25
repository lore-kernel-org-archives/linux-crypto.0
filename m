From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 3/6] staging: ccree: remove unused function
Date: Sun, 25 Jun 2017 10:47:21 +0300
Message-ID: <1498376846-24136-4-git-send-email-gilad@benyossef.com>
References: <1498376846-24136-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498376846-24136-1-git-send-email-gilad@benyossef.com>
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

The function set_ack_last was not used anywhere. Remove it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index aaa56c8..f11487a 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -226,18 +226,6 @@ static inline void set_queue_last_ind(struct cc_hw_desc *pdesc)
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
