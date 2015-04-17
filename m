From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 1/4] cryoto: drbg - clear all temporary memory
Date: Fri, 17 Apr 2015 14:54:08 +0200
Message-ID: <11443550.8lhOr92W5F@myon.chronox.de>
References: <1551177.C0RmlOO9iU@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34158 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbbDQM4x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 08:56:53 -0400
In-Reply-To: <1551177.C0RmlOO9iU@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The buffer uses for temporary data must be cleared entirely. In AES192
the used buffer is drbg_statelen(drbg) + drbg_blocklen(drbg) as
documented in the comment above drbg_ctr_df.

This patch ensures that the temp buffer is completely wiped.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index b69409c..8d2944f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -487,7 +487,7 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 
 out:
 	memset(iv, 0, drbg_blocklen(drbg));
-	memset(temp, 0, drbg_statelen(drbg));
+	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
 	memset(pad, 0, drbg_blocklen(drbg));
 	return ret;
 }
-- 
2.1.0
