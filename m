From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - fix lock acquisition code
Date: Wed, 16 Mar 2016 09:02:26 -0500
Message-ID: <20160316140226.28262.97717.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0068.outbound.protection.outlook.com ([157.56.110.68]:27776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966737AbcCPOC4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Mar 2016 10:02:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch simplifies an unneeded read-write lock.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 336e5b7..4dbc187 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -53,7 +53,7 @@ static DEFINE_RWLOCK(ccp_unit_lock);
 static LIST_HEAD(ccp_units);
 
 /* Round-robin counter */
-static DEFINE_RWLOCK(ccp_rr_lock);
+static DEFINE_SPINLOCK(ccp_rr_lock);
 static struct ccp_device *ccp_rr;
 
 /* Ever-increasing value to produce unique unit numbers */
@@ -128,14 +128,14 @@ static struct ccp_device *ccp_get_device(void)
 	 */
 	read_lock_irqsave(&ccp_unit_lock, flags);
 	if (!list_empty(&ccp_units)) {
-		write_lock_irqsave(&ccp_rr_lock, flags);
+		spin_lock(&ccp_rr_lock);
 		dp = ccp_rr;
 		if (list_is_last(&ccp_rr->entry, &ccp_units))
 			ccp_rr = list_first_entry(&ccp_units, struct ccp_device,
 						  entry);
 		else
 			ccp_rr = list_next_entry(ccp_rr, entry);
-		write_unlock_irqrestore(&ccp_rr_lock, flags);
+		spin_unlock(&ccp_rr_lock);
 	}
 	read_unlock_irqrestore(&ccp_unit_lock, flags);
 
