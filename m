From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 1/3] crypto: af_alg - add sig gen / verify API
Date: Wed, 22 Jul 2015 00:12:52 +0200
Message-ID: <1856956.T1fkhHfG4Y@tachyon.chronox.de>
References: <3908391.JkjAozYBaW@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47976 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbbGUWOf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2015 18:14:35 -0400
In-Reply-To: <3908391.JkjAozYBaW@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As a prerequisite to add the asymmetric cipher AF_ALG API, this patch
adds the user space interface identifier to tell the kernel about
performing a signature generation and verification operation in addition
to the existing encryption / decryption operation.

CC: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/uapi/linux/if_alg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index f2acd2f..d81dcca 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -38,5 +38,7 @@ struct af_alg_iv {
 /* Operations */
 #define ALG_OP_DECRYPT			0
 #define ALG_OP_ENCRYPT			1
+#define ALG_OP_SIGN			2
+#define ALG_OP_VERIFY			3
 
 #endif	/* _LINUX_IF_ALG_H */
-- 
2.4.3
