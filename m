From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 178/199] arch/s390/crypto/crypto_des.h: Checkpatch cleanup
Date: Sun, 23 May 2010 22:02:05 +0200
Message-ID: <1274644930-26600-21-git-send-email-andrea.gelmini@gelma.net>
References: <1274644930-26600-1-git-send-email-andrea.gelmini@gelma.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux390@de.ibm.com, linux-crypto@vger.kernel.org,
	linux-s390@vger.kernel.org
To: andrea.gelmini@gelma.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:10127 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0EWUCz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 May 2010 16:02:55 -0400
In-Reply-To: <1274644930-26600-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

arch/s390/crypto/crypto_des.h:18: ERROR: do not use C99 // comments

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/s390/crypto/crypto_des.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/crypto/crypto_des.h b/arch/s390/crypto/crypto_des.h
index c964b64..6210457 100644
--- a/arch/s390/crypto/crypto_des.h
+++ b/arch/s390/crypto/crypto_des.h
@@ -15,4 +15,4 @@
 
 extern int crypto_des_check_key(const u8*, unsigned int, u32*);
 
-#endif //__CRYPTO_DES_H__
+#endif /*__CRYPTO_DES_H__*/
-- 
1.7.1.251.gf80a2
