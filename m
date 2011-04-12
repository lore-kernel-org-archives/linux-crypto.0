From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 4/4] crypto: caam - remove duplicate dev_err
Date: Mon, 11 Apr 2011 19:15:28 -0500
Message-ID: <20110411191528.36e41831.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steve Cornelius <sec@pobox.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:23932 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab1DLAPq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Apr 2011 20:15:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

keep the hex error value reporting version (a) to be consistent
with decrypt_done(), and (b) to keep our hardware guys happy.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 8eb84d3..245cfe4 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -418,7 +418,6 @@ static void ipsec_esp_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	if (err) {
 		char tmp[256];
 
-		dev_err(jrdev, "%s\n", caam_jr_strstatus(tmp, err));
 		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
 	}
 
-- 
1.7.4.3.dirty
