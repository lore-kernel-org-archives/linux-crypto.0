From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 7/9] crypto: crct10dif/generic - switch crypto API driver to core library
Date: Fri,  5 Oct 2018 10:13:31 +0200
Message-ID: <20181005081333.15018-8-ard.biesheuvel@linaro.org>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/crct10dif_generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
index 8e94e29dc6fc..9ea4242c4921 100644
--- a/crypto/crct10dif_generic.c
+++ b/crypto/crct10dif_generic.c
@@ -53,7 +53,7 @@ static int chksum_update(struct shash_desc *desc, const u8 *data,
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
+	ctx->crc = crc_t10dif_update(ctx->crc, data, length);
 	return 0;
 }
 
@@ -68,7 +68,7 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
 static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
 			u8 *out)
 {
-	*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
+	*(__u16 *)out = crc_t10dif_update(*crcp, data, len);
 	return 0;
 }
 
-- 
2.11.0
