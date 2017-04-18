From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 1/8] crypto: AF_ALG -- add DH keygen / ssgen API
Date: Wed, 19 Apr 2017 01:04:23 +0200
Message-ID: <2802307.jua8XzG37p@positron.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59004 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758132AbdDRXJ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 19:09:57 -0400
In-Reply-To: <2715753.J0rCo2lbig@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the flags for handling DH key generation and DH shared
secret generation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/uapi/linux/if_alg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index 02e6162..c48eeb6 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -41,5 +41,7 @@ struct af_alg_iv {
 #define ALG_OP_ENCRYPT			1
 #define ALG_OP_SIGN			2
 #define ALG_OP_VERIFY			3
+#define ALG_OP_KEYGEN			4
+#define ALG_OP_SSGEN			5
 
 #endif	/* _LINUX_IF_ALG_H */
-- 
2.9.3
