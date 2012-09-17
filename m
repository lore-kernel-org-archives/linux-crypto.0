From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH][1.3][SEC] Added entry for P5040 in SEC-VID to SEC-ERA mapping table.
Date: Mon, 17 Sep 2012 12:50:43 +0530
Message-ID: <1347866443-22469-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Vakul Garg <vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:43032
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab2IQHXd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Sep 2012 03:23:33 -0400
Received: from mail93-co1 (localhost [127.0.0.1])	by mail93-co1-R.bigfish.com
 (Postfix) with ESMTP id A3EA28C013F	for <linux-crypto@vger.kernel.org>; Mon,
 17 Sep 2012 07:23:32 +0000 (UTC)
Received: from CO1EHSMHS008.bigfish.com (unknown [10.243.78.253])	by
 mail93-co1.bigfish.com (Postfix) with ESMTP id B36C6700042	for
 <linux-crypto@vger.kernel.org>; Mon, 17 Sep 2012 07:23:29 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net ([10.213.130.145])	by
 az84smr01.freescale.net (8.14.3/8.14.0) with ESMTP id q8H7NPuW002650	for
 <linux-crypto@vger.kernel.org>; Mon, 17 Sep 2012 00:23:26 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On P5040, SEC-ERA does not print correctly. This is because SEC-VID to SEC-ERA
mapping table does not contain information for P5040. This patch adds this
information.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
 drivers/crypto/caam/ctrl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b3fecfa..81ed4bc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -176,7 +176,8 @@ int caam_get_era(u64 caam_id)
 		{0x0A14, 1, 3},
 		{0x0A14, 2, 4},
 		{0x0A16, 1, 4},
-		{0x0A11, 1, 4}
+		{0x0A11, 1, 4},
+		{0x0A13, 1, 5}
 	};
 	int i;
 
-- 
1.7.7.6
