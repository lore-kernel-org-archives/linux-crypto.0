From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: FIPS - allow RSA keys >= 2048 bits
Date: Tue, 23 Aug 2016 10:09:32 +0200
Message-ID: <3300015.Y5nlQbUkhj@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37254 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756613AbcHWITb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Aug 2016 04:19:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With a public notification, NIST now allows the use of RSA keys with a
modulus >= 2048 bits. The new rule allows any modulus size >= 2048 bits
provided that either 2048 or 3072 bits are supported at least so that
the entire RSA implementation can be CAVS tested.

This patch fixes the inability to boot the kernel in FIPS mode, because
certs/x509.genkey defines a 4096 bit RSA key per default. This key causes
the RSA signature verification to fail in FIPS mode without the patch
below.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/rsa_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 4df6451..0b66dc8 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -35,8 +35,8 @@ int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
 			n_sz--;
 		}
 
-		/* In FIPS mode only allow key size 2K & 3K */
-		if (n_sz != 256 && n_sz != 384) {
+		/* In FIPS mode only allow key size 2K and higher */
+		if (n_sz < 256) {
 			pr_err("RSA: key size not allowed in FIPS mode\n");
 			return -EINVAL;
 		}
-- 
2.7.4
