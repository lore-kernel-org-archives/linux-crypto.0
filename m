From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 1/6] crypto: talitos - Don't provide setkey for non hmac
 hashing algs.
Date: Tue, 19 Sep 2017 14:59:01 +0200 (CEST)
Message-ID: <47fddd0f43aaedf31bc55da9ff3114079254452f.1505825623.git.christophe.leroy@c-s.fr>
References: <cover.1505825623.git.christophe.leroy@c-s.fr>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
 David S. Miller <davem@davemloft.net>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <cover.1505825623.git.christophe.leroy@c-s.fr>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

Today, md5sum fails with error -ENOKEY because a setkey
function is set for non hmac hashing algs, see strace output below:

mmap(NULL, 378880, PROT_READ, MAP_SHARED, 6, 0) = 0x77f50000
accept(3, 0, NULL)                      = 7
vmsplice(5, [{"bin/\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 378880}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 262144
splice(4, NULL, 7, NULL, 262144, SPLICE_F_MORE) = -1 ENOKEY (Required key not available)
write(2, "Generation of hash for file kcap"..., 50) = 50
munmap(0x77f50000, 378880)              = 0

This patch ensures that setkey() function is set only
for hmac hashing.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 79791c690858..5cc160078286 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3057,7 +3057,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		t_alg->algt.alg.hash.final = ahash_final;
 		t_alg->algt.alg.hash.finup = ahash_finup;
 		t_alg->algt.alg.hash.digest = ahash_digest;
-		t_alg->algt.alg.hash.setkey = ahash_setkey;
+		if (!strncmp(alg->cra_name, "hmac", 4))
+			t_alg->algt.alg.hash.setkey = ahash_setkey;
 		t_alg->algt.alg.hash.import = ahash_import;
 		t_alg->algt.alg.hash.export = ahash_export;
 
-- 
2.13.3
