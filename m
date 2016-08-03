From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] crypto: sha3 - Add missing ULL suffixes for 64-bit constants
Date: Wed,  3 Aug 2016 19:37:03 +0200
Message-ID: <1470245823-21090-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Garzik <jeff@garzik.org>,
	Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 32-bit (e.g. with m68k-linux-gnu-gcc-4.1):

    crypto/sha3_generic.c:27: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:28: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:29: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:29: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:31: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:31: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:32: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:32: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:32: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:33: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:33: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:34: warning: integer constant is too large for ‘long’ type
    crypto/sha3_generic.c:34: warning: integer constant is too large for ‘long’ type

Fixes: 53964b9ee63b7075 ("crypto: sha3 - Add SHA-3 hash algorithm")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 crypto/sha3_generic.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 62264397a2d28636..7e8ed96236cefa79 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -24,14 +24,14 @@
 #define ROTL64(x, y) (((x) << (y)) | ((x) >> (64 - (y))))
 
 static const u64 keccakf_rndc[24] = {
-	0x0000000000000001, 0x0000000000008082, 0x800000000000808a,
-	0x8000000080008000, 0x000000000000808b, 0x0000000080000001,
-	0x8000000080008081, 0x8000000000008009, 0x000000000000008a,
-	0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
-	0x000000008000808b, 0x800000000000008b, 0x8000000000008089,
-	0x8000000000008003, 0x8000000000008002, 0x8000000000000080,
-	0x000000000000800a, 0x800000008000000a, 0x8000000080008081,
-	0x8000000000008080, 0x0000000080000001, 0x8000000080008008
+	0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808aULL,
+	0x8000000080008000ULL, 0x000000000000808bULL, 0x0000000080000001ULL,
+	0x8000000080008081ULL, 0x8000000000008009ULL, 0x000000000000008aULL,
+	0x0000000000000088ULL, 0x0000000080008009ULL, 0x000000008000000aULL,
+	0x000000008000808bULL, 0x800000000000008bULL, 0x8000000000008089ULL,
+	0x8000000000008003ULL, 0x8000000000008002ULL, 0x8000000000000080ULL,
+	0x000000000000800aULL, 0x800000008000000aULL, 0x8000000080008081ULL,
+	0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
 };
 
 static const int keccakf_rotc[24] = {
-- 
1.9.1
