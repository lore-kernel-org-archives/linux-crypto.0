From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/10] crypto: api - Call type show function before legacy for proc
Date: Fri, 07 Nov 2008 16:37:01 +0800
Message-ID: <E1KyMpx-0002l9-1o@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39127 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751608AbYKGIhF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:37:05 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMpx-0006AR-8P
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:37:01 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Call type show function before legacy for proc

This patch makes /proc/crypto call the type-specific show function
if one is present before calling the legacy show functions for
cipher/digest/compress.  This allows us to reuse the type values
for those legacy types.  In particular, hash and digest will share
one type value while shash is phased in as the default hash type.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/proc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 37a13d0..5dc07e4 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -94,6 +94,17 @@ static int c_show(struct seq_file *m, void *p)
 	seq_printf(m, "selftest     : %s\n",
 		   (alg->cra_flags & CRYPTO_ALG_TESTED) ?
 		   "passed" : "unknown");
+
+	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
+		seq_printf(m, "type         : larval\n");
+		seq_printf(m, "flags        : 0x%x\n", alg->cra_flags);
+		goto out;
+	}
+
+	if (alg->cra_type && alg->cra_type->show) {
+		alg->cra_type->show(m, alg);
+		goto out;
+	}
 	
 	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
 	case CRYPTO_ALG_TYPE_CIPHER:
@@ -115,16 +126,11 @@ static int c_show(struct seq_file *m, void *p)
 		seq_printf(m, "type         : compression\n");
 		break;
 	default:
-		if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
-			seq_printf(m, "type         : larval\n");
-			seq_printf(m, "flags        : 0x%x\n", alg->cra_flags);
-		} else if (alg->cra_type && alg->cra_type->show)
-			alg->cra_type->show(m, alg);
-		else
-			seq_printf(m, "type         : unknown\n");
+		seq_printf(m, "type         : unknown\n");
 		break;
 	}
 
+out:
 	seq_putc(m, '\n');
 	return 0;
 }
