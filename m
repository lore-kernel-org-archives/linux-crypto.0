From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 1/2] crypto: ccp - Use only the relevant interrupt bits
Date: Wed, 12 Apr 2017 17:54:35 -0500
Message-ID: <20170412225435.17707.67228.stgit@taos>
References: <20170412225324.17707.75176.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0074.outbound.protection.outlook.com ([104.47.33.74]:27874
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754893AbdDLWyt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 18:54:49 -0400
In-Reply-To: <20170412225324.17707.75176.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Each CCP queue can product interrupts for 4 conditions:
operation complete, queue empty, error, and queue stopped.
This driver only works with completion and error events.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 191274d..a60aac7 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -109,9 +109,8 @@
 #define INT_COMPLETION			0x1
 #define INT_ERROR			0x2
 #define INT_QUEUE_STOPPED		0x4
-#define ALL_INTERRUPTS			(INT_COMPLETION| \
-					 INT_ERROR| \
-					 INT_QUEUE_STOPPED)
+#define	INT_EMPTY_QUEUE			0x8
+#define ALL_INTERRUPTS			(INT_COMPLETION | INT_ERROR)
 
 #define LSB_REGION_WIDTH		5
 #define MAX_LSB_CNT			8
