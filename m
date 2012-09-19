From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: cast5/avx - fix storing of new IV in CBC encryption
Date: Wed, 19 Sep 2012 14:24:57 +0300
Message-ID: <20120919112456.12812.51190.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34107 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2ISLZA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2012 07:25:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cast5/avx incorrectly XORs new IV over old IV at end of CBC encryption
function when it should store. This causes CBC encryption to give
incorrect output on multi-page encryption requests.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/cast5_avx_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index 445aab0..e0ea14f 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -165,7 +165,7 @@ static unsigned int __cbc_encrypt(struct blkcipher_desc *desc,
 		nbytes -= bsize;
 	} while (nbytes >= bsize);
 
-	*(u64 *)walk->iv ^= *iv;
+	*(u64 *)walk->iv = *iv;
 	return nbytes;
 }
 
