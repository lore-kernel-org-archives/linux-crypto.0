From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: fix nx-842 pSeries driver minimum buffer size
Date: Tue,  2 Jun 2015 15:22:10 -0400
Message-ID: <1433272930-5991-1-git-send-email-ddstreet@ieee.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36733 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbbFBTWX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2015 15:22:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Reduce the nx-842 pSeries driver minimum buffer size from 128 to 8.
Also replace the single use of IO_BUFFER_ALIGN macro with the standard
and correct DDE_BUFFER_ALIGN.

The hw sometimes rejects buffers that contain padding past the end of the
8-byte aligned section where it sees the "end" marker.  With the minimum
buffer size set too high, some highly compressed buffers were being padded
and the hw was incorrectly rejecting them; this sets the minimum correctly
so there will be no incorrect padding.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 17f1917..41bc551 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -30,13 +30,10 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Robert Jennings <rcj@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
 
-/* IO buffer must be 128 byte aligned */
-#define IO_BUFFER_ALIGN 128
-
 static struct nx842_constraints nx842_pseries_constraints = {
-	.alignment =	IO_BUFFER_ALIGN,
+	.alignment =	DDE_BUFFER_ALIGN,
 	.multiple =	DDE_BUFFER_LAST_MULT,
-	.minimum =	IO_BUFFER_ALIGN,
+	.minimum =	DDE_BUFFER_LAST_MULT,
 	.maximum =	PAGE_SIZE, /* dynamic, max_sync_size */
 };
 
-- 
2.1.0
