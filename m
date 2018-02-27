From: =?UTF-8?q?Hern=C3=A1n=20Gonzalez?= <hernan@vanguardiasur.com.ar>
Subject: [PATCH 3/4] crypto: bcm: Constify *hash_alg_name[]
Date: Tue, 27 Feb 2018 19:01:27 -0300
Message-ID: <1519768888-19866-3-git-send-email-hernan@vanguardiasur.com.ar>
References: <1519768888-19866-1-git-send-email-hernan@vanguardiasur.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        hernan@vanguardiasur.com.ar, steven.lin1@broadcom.com,
        arvind.yadav.cs@gmail.com, colin.king@canonical.com,
        raveendra.padasalagi@broadcom.com, ray.jui@broadcom.com,
        scott.branden@broadcom.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519768888-19866-1-git-send-email-hernan@vanguardiasur.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Note: This is compile only tested.
No gain from this except some self-documenting.

Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
---
 drivers/crypto/bcm/spu.c | 5 +++--
 drivers/crypto/bcm/spu.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
index efaf3cf..c7bb79e 100644
--- a/drivers/crypto/bcm/spu.c
+++ b/drivers/crypto/bcm/spu.c
@@ -23,8 +23,9 @@
 #include "cipher.h"
 
 /* This array is based on the hash algo type supported in spu.h */
-char *hash_alg_name[] = { "None", "md5", "sha1", "sha224", "sha256", "aes",
-	"sha384", "sha512", "sha3_224", "sha3_256", "sha3_384", "sha3_512" };
+char const * const hash_alg_name[] = { "None", "md5", "sha1", "sha224",
+	"sha256", "aes", "sha384", "sha512", "sha3_224", "sha3_256", "sha3_384",
+	"sha3_512" };
 
 /* Assumes SPU-M messages are in big endian */
 void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len)
diff --git a/drivers/crypto/bcm/spu.h b/drivers/crypto/bcm/spu.h
index f252367..71cf6b5 100644
--- a/drivers/crypto/bcm/spu.h
+++ b/drivers/crypto/bcm/spu.h
@@ -111,7 +111,7 @@ enum aead_type {
 	AEAD_TYPE_LAST
 };
 
-extern char *hash_alg_name[HASH_ALG_LAST];
+extern const char * const hash_alg_name[HASH_ALG_LAST];
 
 struct spu_request_opts {
 	bool is_inbound;
-- 
2.7.4
