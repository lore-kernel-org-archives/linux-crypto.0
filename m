From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: algif_rng - zeroize buffer holding random data
Date: Wed, 11 Mar 2015 07:45:35 +0100
Message-ID: <7837811.JDlpL5zc04@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.178]:41864 "EHLO
	mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbCKGv5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 02:51:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Due to the change to RNGs to always return zero in success case, the RNG
interface must zeroize the buffer with the length provided by the
caller.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 67f612c..a346173 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -87,7 +87,7 @@ static int rng_recvmsg(struct kiocb *unused, struct socket 
*sock,
 		return genlen;
 
 	err = memcpy_to_msg(msg, result, len);
-	memzero_explicit(result, genlen);
+	memzero_explicit(result, len);
 
 	return err ? err : len;
 }
-- 
2.1.0
