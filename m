From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 0010/1529] Fix typo
Date: Sat, 21 May 2016 13:36:43 +0200
Message-ID: <20160521113643.31792-1-andrea.gelmini@gelma.net>
Cc: trivial@kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, corbet@lwn.net, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org
To: andrea.gelmini@gelma.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34740 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbcEULgs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 May 2016 07:36:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/crypto/asymmetric-keys.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/asymmetric-keys.txt b/Documentation/crypto/asymmetric-keys.txt
index 8c07e0e..2b7816d 100644
--- a/Documentation/crypto/asymmetric-keys.txt
+++ b/Documentation/crypto/asymmetric-keys.txt
@@ -76,7 +76,7 @@ the criterion string:
 Looking in /proc/keys, the last 8 hex digits of the key fingerprint are
 displayed, along with the subtype:
 
-	1a39e171 I-----     1 perm 3f010000     0     0 asymmetri modsign.0: DSA 5acc2142 []
+	1a39e171 I-----     1 perm 3f010000     0     0 asymmetric modsign.0: DSA 5acc2142 []
 
 
 =========================
-- 
2.8.2.534.g1f66975
