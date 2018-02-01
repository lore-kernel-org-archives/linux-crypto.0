From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] crypto: sha3-generic - Use __optimize to support old compilers
Date: Thu,  1 Feb 2018 11:22:00 +0100
Message-ID: <1517480520-4465-3-git-send-email-geert@linux-m68k.org>
References: <1517480520-4465-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Li <sparse@chrisli.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-sparse-owner@vger.kernel.org>
In-Reply-To: <1517480520-4465-1-git-send-email-geert@linux-m68k.org>
Sender: linux-sparse-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

With gcc-4.1.2:

    crypto/sha3_generic.c:39: warning: ‘__optimize__’ attribute directive ignored

Use the newly introduced __optimize macro to fix this.

Fixes: 83dee2ce1ae791c3 ("crypto: sha3-generic - rewrite KECCAK transform to help the compiler optimize")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 crypto/sha3_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index a965b9d8055983af..c409cd87fea5decd 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -35,7 +35,7 @@ static const u64 keccakf_rndc[24] = {
 
 /* update the state with given number of rounds */
 
-static void __attribute__((__optimize__("O3"))) keccakf(u64 st[25])
+static void __optimize("O3") keccakf(u64 st[25])
 {
 	u64 t[5], tt, bc[5];
 	int round;
-- 
2.7.4

