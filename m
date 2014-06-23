From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: des3_ede/x86-64: fix parse warning
Date: Mon, 23 Jun 2014 19:39:17 +0300
Message-ID: <20140623163917.9000.14726.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:51849 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755721AbaFWQjX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Jun 2014 12:39:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch fixes following sparse warning:

  CHECK   arch/x86/crypto/des3_ede_glue.c
arch/x86/crypto/des3_ede_glue.c:308:52: warning: restricted __be64 degrades to integer
arch/x86/crypto/des3_ede_glue.c:309:52: warning: restricted __be64 degrades to integer
arch/x86/crypto/des3_ede_glue.c:310:52: warning: restricted __be64 degrades to integer
arch/x86/crypto/des3_ede_glue.c:326:44: warning: restricted __be64 degrades to integer

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/des3_ede_glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index ebc4215..0e9c066 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -289,8 +289,8 @@ static unsigned int __ctr_crypt(struct blkcipher_desc *desc,
 	struct des3_ede_x86_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	unsigned int bsize = DES3_EDE_BLOCK_SIZE;
 	unsigned int nbytes = walk->nbytes;
-	u64 *src = (u64 *)walk->src.virt.addr;
-	u64 *dst = (u64 *)walk->dst.virt.addr;
+	__be64 *src = (__be64 *)walk->src.virt.addr;
+	__be64 *dst = (__be64 *)walk->dst.virt.addr;
 	u64 ctrblk = be64_to_cpu(*(__be64 *)walk->iv);
 	__be64 ctrblocks[3];
 
