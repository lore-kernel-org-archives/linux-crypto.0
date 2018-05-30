From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] crypto: aegis: fix indentation of a statement
Date: Wed, 30 May 2018 11:50:05 +0100
Message-ID: <20180530105005.13116-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trival fix to correct the indentation of a single statement

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 crypto/aegis128l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/aegis128l.c b/crypto/aegis128l.c
index 0cc1a7525c85..64dc2654b863 100644
--- a/crypto/aegis128l.c
+++ b/crypto/aegis128l.c
@@ -121,7 +121,7 @@ static void crypto_aegis128l_ad(struct aegis_state *state,
 				(const union aegis_chunk *)src;
 
 		while (size >= AEGIS128L_CHUNK_SIZE) {
-                    crypto_aegis128l_update_a(state, src_chunk);
+			crypto_aegis128l_update_a(state, src_chunk);
 
 			size -= AEGIS128L_CHUNK_SIZE;
 			src_chunk += 1;
-- 
2.17.0
