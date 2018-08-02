From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v7 2/9] crypto: cbc: Remove VLA usage
Date: Thu,  2 Aug 2018 15:51:45 -0700
Message-ID: <20180802225152.19194-3-keescook@chromium.org>
References: <20180802225152.19194-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802225152.19194-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
uses the upper bounds on blocksize. Since this is always a cipher
blocksize, use the existing cipher max blocksize.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/crypto/cbc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
index f5b8bfc22e6d..47db0aac2ab9 100644
--- a/include/crypto/cbc.h
+++ b/include/crypto/cbc.h
@@ -113,7 +113,9 @@ static inline int crypto_cbc_decrypt_inplace(
 	unsigned int bsize = crypto_skcipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 last_iv[bsize];
+	u8 last_iv[MAX_CIPHER_BLOCKSIZE];
+
+	BUG_ON(bsize > sizeof(last_iv));
 
 	/* Start of the last block. */
 	src += nbytes - (nbytes & (bsize - 1)) - bsize;
-- 
2.17.1
