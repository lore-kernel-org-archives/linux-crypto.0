From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/6] crypto: powerpc/md5: use md5 IV MD5_HX instead of their raw value
Date: Sun, 17 May 2015 12:54:14 +0200
Message-ID: <1431860057-5232-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1431860057-5232-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        mpe@ellerman.id.au, aaro.koskinen@iki.fi
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1431860057-5232-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
List-Id: linux-crypto.vger.kernel.org

Since MD5 IV are now available in crypto/md5.h, use them.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 arch/powerpc/crypto/md5-glue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/crypto/md5-glue.c b/arch/powerpc/crypto/md5-glue.c
index 452fb4d..9228967 100644
--- a/arch/powerpc/crypto/md5-glue.c
+++ b/arch/powerpc/crypto/md5-glue.c
@@ -37,10 +37,10 @@ static int ppc_md5_init(struct shash_desc *desc)
 {
 	struct md5_state *sctx = shash_desc_ctx(desc);
 
-	sctx->hash[0] = 0x67452301;
-	sctx->hash[1] = 0xefcdab89;
-	sctx->hash[2] = 0x98badcfe;
-	sctx->hash[3] =	0x10325476;
+	sctx->hash[0] = MD5_H0;
+	sctx->hash[1] = MD5_H1;
+	sctx->hash[2] = MD5_H2;
+	sctx->hash[3] =	MD5_H3;
 	sctx->byte_count = 0;
 
 	return 0;
-- 
2.3.6
