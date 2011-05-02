From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/2] crypto: caam - fix printk recursion for long error
 texts
Date: Mon, 2 May 2011 18:29:17 -0500
Message-ID: <20110502182917.4400d8e2.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Steve Cornelius <sec@pobox.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:4884 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751151Ab1EBXaB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2011 19:30:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

during recent descriptor development, an Invalid Sequence Command
error triggered a:

BUG: recent printk recursion!

due to insufficient memory allocated for the error text.

The Invalid Sequence Command error text is the longest.
The length of the maximum error string is computed as
the sum of:

"DECO: ": 6
"jump tgt desc idx 255: ": 23
Invalid Sequence Command text: 272
zero termination character: 1

i.e, 302 characters.

Define this maximum error string length in error.h and fix
caam_jr_strstatus callsites.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |    6 +++---
 drivers/crypto/caam/error.h   |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 719ad06..449f5b6 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -113,7 +113,7 @@ static void split_key_done(struct device *dev, u32 *desc, u32 err,
 	dev_err(dev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 	if (err) {
-		char tmp[256];
+		char tmp[CAAM_ERROR_STR_MAX];
 
 		dev_err(dev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
 	}
@@ -414,7 +414,7 @@ static void ipsec_esp_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		 offsetof(struct ipsec_esp_edesc, hw_desc));
 
 	if (err) {
-		char tmp[256];
+		char tmp[CAAM_ERROR_STR_MAX];
 
 		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
 	}
@@ -454,7 +454,7 @@ static void ipsec_esp_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 		 offsetof(struct ipsec_esp_edesc, hw_desc));
 
 	if (err) {
-		char tmp[256];
+		char tmp[CAAM_ERROR_STR_MAX];
 
 		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
 	}
diff --git a/drivers/crypto/caam/error.h b/drivers/crypto/caam/error.h
index 067afc1..02c7baa 100644
--- a/drivers/crypto/caam/error.h
+++ b/drivers/crypto/caam/error.h
@@ -6,5 +6,6 @@
 
 #ifndef CAAM_ERROR_H
 #define CAAM_ERROR_H
+#define CAAM_ERROR_STR_MAX 302
 extern char *caam_jr_strstatus(char *outstr, u32 status);
 #endif /* CAAM_ERROR_H */
-- 
1.7.5
