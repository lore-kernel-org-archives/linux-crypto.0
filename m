From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 3/9] crypto: crc-t10dif - make crc_t10dif a static inline
Date: Fri,  5 Oct 2018 10:13:27 +0200
Message-ID: <20181005081333.15018-4-ard.biesheuvel@linaro.org>
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

crc_t10dif() is a trivial wrapper around crc_t10dif_update() so move
it into the header file as a static inline function.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/crc-t10dif.h | 6 +++++-
 lib/crc-t10dif.c           | 6 ------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index 6bb0c0bf357b..4dfe09ff4cf2 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -10,7 +10,11 @@
 
 extern __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
 				size_t len);
-extern __u16 crc_t10dif(unsigned char const *, size_t);
 extern __u16 crc_t10dif_update(__u16 crc, unsigned char const *, size_t);
 
+static inline __u16 crc_t10dif(const unsigned char *buffer, size_t len)
+{
+	return crc_t10dif_update(0, buffer, len);
+}
+
 #endif
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 4d0d47c1ffbd..036ee664c9e1 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -81,12 +81,6 @@ __u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
 }
 EXPORT_SYMBOL(crc_t10dif_update);
 
-__u16 crc_t10dif(const unsigned char *buffer, size_t len)
-{
-	return crc_t10dif_update(0, buffer, len);
-}
-EXPORT_SYMBOL(crc_t10dif);
-
 static int __init crc_t10dif_mod_init(void)
 {
 	crypto_register_notifier(&crc_t10dif_nb);
-- 
2.11.0
