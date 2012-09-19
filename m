From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: x86/glue_helper - fix storing of new IV in CBC
 encryption
Date: Wed, 19 Sep 2012 09:40:30 +0300
Message-ID: <20120919064030.10037.69526.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:49653 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2ISGke (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2012 02:40:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Glue_helper incorrectly XORs new IV over old IV at end of CBC encryption
function when it should store. This causes CBC encryption to give
incorrect output on multi-page encryption requests.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/glue_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 4854f0f..30b3927 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -110,7 +110,7 @@ static unsigned int __glue_cbc_encrypt_128bit(const common_glue_func_t fn,
 		nbytes -= bsize;
 	} while (nbytes >= bsize);
 
-	u128_xor((u128 *)walk->iv, (u128 *)walk->iv, iv);
+	*(u128 *)walk->iv = *iv;
 	return nbytes;
 }
 
