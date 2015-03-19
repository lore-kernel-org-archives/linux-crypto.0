From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 02/16] crypto: /proc/crypto: identify internal ciphers
Date: Thu, 19 Mar 2015 07:58:22 +0100
Message-ID: <1531493.gM9Nt7nA8o@tachyon.chronox.de>
References: <21952258.n2qYaab1Is@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21952258.n2qYaab1Is@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
