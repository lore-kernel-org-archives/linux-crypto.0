From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 7/8] crypto: ecdh - constify key
Date: Wed, 19 Apr 2017 01:07:16 +0200
Message-ID: <1694255.qHQGcMPfKl@positron.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58994 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758065AbdDRXKD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 19:10:03 -0400
In-Reply-To: <2715753.J0rCo2lbig@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/ecdh.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index 03a64f6..b5bb149 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -40,7 +40,7 @@
  */
 struct ecdh {
 	unsigned short curve_id;
-	char *key;
+	const char *key;
 	unsigned short key_size;
 };
 
-- 
2.9.3
