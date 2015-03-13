From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH RESEND] crypto: algif_rng - zeroize buffer with random data
Date: Fri, 13 Mar 2015 11:44:07 +0100
Message-ID: <1488589.sO3PXAYh7F@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
@@ -87,7 +87,7 @@ static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
 		return genlen;
 
 	err = memcpy_to_msg(msg, result, len);
-	memzero_explicit(result, genlen);
+	memzero_explicit(result, len);
 
 	return err ? err : len;
 }
-- 
2.1.0
