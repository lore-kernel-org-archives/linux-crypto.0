From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 1/6] crypto: api - laying macros for statically allocated buffers
Date: Sat,  7 Apr 2018 20:38:18 +0200
Message-ID: <1523126303-23205-2-git-send-email-s.mesoraca16@gmail.com>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
Cc: kernel-hardening@lists.openwall.com,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kees Cook <keescook@chromium.org>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	Eric Biggers <ebiggers3@gmail.com>,
	Laura Abbott <labbott@redhat.com>
To: linux-kernel@vger.kernel.org
Return-path: <kernel-hardening-return-12877-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
List-Id: linux-crypto.vger.kernel.org

Creating 2 new compile-time constants for internal use,
in preparation for the removal of VLAs[1] from crypto code.
All ciphers implemented in Linux have a block size less than or
equal to 16 bytes and the most demanding hw require 16 bytes
alignment for the block buffer.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/internal.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/internal.h b/crypto/internal.h
index 9a3f399..89ae41e 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -26,6 +26,14 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 
+/*
+ * Maximum values for blocksize and alignmask, used to allocate
+ * static buffers that are big enough for any combination of
+ * ciphers and architectures.
+ */
+#define MAX_BLOCKSIZE			16
+#define MAX_ALIGNMASK			15
+
 /* Crypto notification events. */
 enum {
 	CRYPTO_MSG_ALG_REQUEST,
-- 
1.9.1
