From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH cryptodev] crypto: echainiv_read_iv() can be static
Date: Sat, 23 May 2015 11:22:47 +0800
Message-ID: <20150522074410.GA102425@lkp-sb04>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16000 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159AbbEWDWv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 23:22:51 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 echainiv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index e5a9878..d0e325d0 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -67,7 +67,7 @@ static int echainiv_setauthsize(struct crypto_aead *tfm,
 }
 
 /* We don't care if we get preempted and read/write IVs from the next CPU. */
-void echainiv_read_iv(u8 *dst, unsigned size)
+static void echainiv_read_iv(u8 *dst, unsigned size)
 {
 	u32 *a = (u32 *)dst;
 	u32 __percpu *b = echainiv_iv;
@@ -78,7 +78,7 @@ void echainiv_read_iv(u8 *dst, unsigned size)
 	}
 }
 
-void echainiv_write_iv(const u8 *src, unsigned size)
+static void echainiv_write_iv(const u8 *src, unsigned size)
 {
 	const u32 *a = (const u32 *)src;
 	u32 __percpu *b = echainiv_iv;
