From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 1/6] crypto: SHA1 multibuffer map scatter gather walk's
 buffer address directly for x86_64
Date: Tue, 13 May 2014 16:19:42 -0700
Message-ID: <1400023182.2970.238.camel@schen9-DESK>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbaEMXTy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 19:19:54 -0400
In-Reply-To: <cover.1399990803.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For x86_64, it is not necessary to incur the additional overhead in
kmap_atomic to map the scatter gather buffer to a linear address.
Mapping the address directly will allow in x86_64 allows multi-buffer
crypto hash alogrithms to have several unfinished buffers with their
address stored in job context before switching out of the crypto daemon.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/ahash.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a92dc38..556f1fa 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -46,7 +46,11 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
+#ifdef CONFIG_X86_64
+	walk->data = page_address(walk->pg);
+#else
 	walk->data = kmap_atomic(walk->pg);
+#endif
 	walk->data += offset;
 
 	if (offset & alignmask) {
@@ -93,7 +97,9 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 		return nbytes;
 	}
 
+#ifndef CONFIG_X86_64
 	kunmap_atomic(walk->data);
+#endif
 	crypto_yield(walk->flags);
 
 	if (err)
-- 
1.7.11.7
