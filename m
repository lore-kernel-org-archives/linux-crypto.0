From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: nx - don't err if compressed output > input
Date: Wed, 29 Jul 2015 19:42:09 -0400
Message-ID: <1438213329-6884-1-git-send-email-ddstreet@ieee.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34752 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbbG2XnG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jul 2015 19:43:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return success instead of error if compression succeeds but the output is
larger than the input.

It's unlikely that the caller will use the compressed data since it's
larger than the original uncompressed data, but there was no error and
returning an error code is incorrect.  Further, for testing small input
buffers, the output is likely to be larger than the input and success
needs to be returned to verify the test.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index b6a26907..f4cbde0 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -226,9 +226,12 @@ static int nx842_validate_result(struct device *dev,
 	switch (csb->completion_code) {
 	case 0:	/* Completed without error */
 		break;
-	case 64: /* Target bytes > Source bytes during compression */
+	case 64: /* Compression ok, but output larger than input */
+		dev_dbg(dev, "%s: output size larger than input size\n",
+					__func__);
+		break;
 	case 13: /* Output buffer too small */
-		dev_dbg(dev, "%s: Compression output larger than input\n",
+		dev_dbg(dev, "%s: Out of space in output buffer\n",
 					__func__);
 		return -ENOSPC;
 	case 66: /* Input data contains an illegal template field */
-- 
2.1.0
