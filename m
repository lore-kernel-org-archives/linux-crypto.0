From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 04/20] crypto: /proc/crypto: identify internal ciphers
Date: Mon, 30 Mar 2015 21:57:42 +0200
Message-ID: <1697828.hl4vyQHuZT@tachyon.chronox.de>
References: <3417827.fluZli1WvQ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39601 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbbC3UIM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 16:08:12 -0400
In-Reply-To: <3417827.fluZli1WvQ@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With ciphers that now cannot be accessed via the kernel crypto API,
callers shall be able to identify the ciphers that are not callable. The
/proc/crypto file is added a boolean field identifying that such
internal ciphers.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/proc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/proc.c b/crypto/proc.c
index 4a0a7aa..4ffe73b 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -89,6 +89,9 @@ static int c_show(struct seq_file *m, void *p)
 	seq_printf(m, "selftest     : %s\n",
 		   (alg->cra_flags & CRYPTO_ALG_TESTED) ?
 		   "passed" : "unknown");
+	seq_printf(m, "internal     : %s\n",
+		   (alg->cra_flags & CRYPTO_ALG_INTERNAL) ?
+		   "yes" : "no");
 
 	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
 		seq_printf(m, "type         : larval\n");
-- 
2.1.0
