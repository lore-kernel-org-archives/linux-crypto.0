From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/4] crypto: cast6 - fix sparse warnings (symbol was not
 declared, should be static?)
Date: Tue, 28 Aug 2012 16:47:09 +0300
Message-ID: <20120828134709.7113.79406.stgit@localhost6.localdomain6>
References: <20120828134654.7113.67137.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:53554 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2H1NrM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Aug 2012 09:47:12 -0400
In-Reply-To: <20120828134654.7113.67137.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix "symbol 'x' was not declared. Should it be static?" sparse warnings.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 include/crypto/cast6.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/cast6.h b/include/crypto/cast6.h
index 02dde6b..157af6f 100644
--- a/include/crypto/cast6.h
+++ b/include/crypto/cast6.h
@@ -20,4 +20,9 @@ int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 void __cast6_encrypt(struct cast6_ctx *ctx, u8 *dst, const u8 *src);
 void __cast6_decrypt(struct cast6_ctx *ctx, u8 *dst, const u8 *src);
 
+extern const u32 cast6_s1[256];
+extern const u32 cast6_s2[256];
+extern const u32 cast6_s3[256];
+extern const u32 cast6_s4[256];
+
 #endif
