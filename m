From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 3/6] crypto: talitos - fix sha224
Date: Tue, 19 Sep 2017 14:59:05 +0200 (CEST)
Message-ID: <6c02a6a98c4e3af746ab7ed7d366192cff2222b8.1505825623.git.christophe.leroy@c-s.fr>
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

Kernel crypto tests report the following error at startup

[    2.752626] alg: hash: Test 4 failed for sha224-talitos
[    2.757907] 00000000: 30 e2 86 e2 e7 8a dd 0d d7 eb 9f d5 83 fe f1 b0
00000010: 2d 5a 6c a5 f9 55 ea fd 0e 72 05 22

This patch fixes it

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 49f1561fa694..dff88838dce7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1756,9 +1756,9 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		req_ctx->swinit = 0;
 	} else {
 		desc->ptr[1] = zero_entry;
-		/* Indicate next op is not the first. */
-		req_ctx->first = 0;
 	}
+	/* Indicate next op is not the first. */
+	req_ctx->first = 0;
 
 	/* HMAC key */
 	if (ctx->keylen)
-- 
2.13.3
