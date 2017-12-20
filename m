From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [RFT] crypto: aes-generic - turn off -ftree-pre and -ftree-sra
Date: Wed, 20 Dec 2017 21:52:05 +0100
Message-ID: <20171220205213.1025257-1-arnd@arndb.de>
Cc: James Morris <james.l.morris@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:53696 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754428AbdLTUw5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 15:52:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While testing other changes, I discovered that gcc-7.2.1 produces badly
optimized code for aes_encrypt/aes_decrypt. This is especially true when
CONFIG_UBSAN_SANITIZE_ALL is enabled, where it leads to extremely
large stack usage that in turn might cause kernel stack overflows:

crypto/aes_generic.c: In function 'aes_encrypt':
crypto/aes_generic.c:1371:1: warning: the frame size of 4880 bytes is larger than 2048 bytes [-Wframe-larger-than=]
crypto/aes_generic.c: In function 'aes_decrypt':
crypto/aes_generic.c:1441:1: warning: the frame size of 4864 bytes is larger than 2048 bytes [-Wframe-larger-than=]

I verified that this problem exists on all architectures that are
supported by gcc-7.2, though arm64 in particular is less affected than
the others. I also found that gcc-7.1 and gcc-8 do not show the extreme
stack usage but still produce worse code than earlier versions for this
file, apparently because of optimization passes that generally provide
a substantial improvement in object code quality but understandably fail
to find any shortcuts in the AES algorithm.

Turning off the tree-pre and tree-sra optimization steps seems to
reverse the effect, and could be used as a workaround in case we
don't get a good gcc fix.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
Cc: Richard Biener <rguenther@suse.de>
Cc: Jakub Jelinek <jakub@gcc.gnu.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Jakub and Richard have done a more detailed analysis of this, and are
working on ways to improve the code again. In the meantime, I'm sending
this workaround to the Linux crypto maintainers to make them aware of
this issue and for testing.

What would be a good way to test the performance of the AES code with
the various combinations of compiler versions, as well as UBSAN and this
patch enabled or disabled?
---
 crypto/aes_generic.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index ca554d57d01e..35f973ba9878 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1331,6 +1331,20 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 	f_rl(bo, bi, 3, k);	\
 } while (0)
 
+#if __GNUC__ >= 7
+/*
+ * Newer compilers try to optimize integer arithmetic more aggressively,
+ * which generally improves code quality a lot, but in this specific case
+ * ends up hurting more than it helps, in some configurations drastically
+ * so. This turns off two optimization steps that have been shown to
+ * lead to rather badly optimized code with gcc-7.
+ *
+ * See also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
+ */
+#pragma GCC optimize("-fno-tree-pre")
+#pragma GCC optimize("-fno-tree-sra")
+#endif
+
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
2.9.0
