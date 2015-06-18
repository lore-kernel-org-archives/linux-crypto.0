From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: aead - Fix aead_instance struct size
Date: Thu, 18 Jun 2015 14:00:49 +0800
Message-ID: <E1Z5Ssb-0007Mt-7J@gondolin.me.apana.org.au>
References: <20150618055959.GA28242@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41599 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbFRGAw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 02:00:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z5Ssb-0005Mo-TC
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2015 16:00:50 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The struct aead_instance is meant to extend struct crypto_instance
by incorporating the extra members of struct aead_alg.  However,
the current layout which is copied from shash/ahash does not specify
the struct fully.  In particular only aead_alg is present.

For shash/ahash this works because users there add extra headroom
to sizeof(struct crypto_instance) when allocating the instance.
Unfortunately for aead, this bit was lost when the new aead_instance
was added.

Rather than fixing it like shash/ahash, this patch simply expands
struct aead_instance to contain what is supposed to be there, i.e.,
adding struct crypto_instance.

In order to not break existing AEAD users, this is done through an
anonymous union.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/aead.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index ba52c37b8..4b25471 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -15,12 +15,19 @@
 
 #include <crypto/aead.h>
 #include <crypto/algapi.h>
+#include <linux/stddef.h>
 #include <linux/types.h>
 
 struct rtattr;
 
 struct aead_instance {
-	struct aead_alg alg;
+	union {
+		struct {
+			char head[offsetof(struct aead_alg, base)];
+			struct crypto_instance base;
+		} s;
+		struct aead_alg alg;
+	};
 };
 
 struct crypto_aead_spawn {
