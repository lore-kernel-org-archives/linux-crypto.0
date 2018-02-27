From: =?UTF-8?q?Hern=C3=A1n=20Gonzalez?= <hernan@vanguardiasur.com.ar>
Subject: [PATCH 2/4] crypto: bcm: Move *aead_alg_name[] from spu.c to util.c. Constify too.
Date: Tue, 27 Feb 2018 19:01:26 -0300
Message-ID: <1519768888-19866-2-git-send-email-hernan@vanguardiasur.com.ar>
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
Move variable to where it is actually used. No gain from this except for
some self-documenting.

Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
---
 drivers/crypto/bcm/spu.c  | 2 --
 drivers/crypto/bcm/spu.h  | 1 -
 drivers/crypto/bcm/util.c | 2 ++
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
index c3d177d..efaf3cf 100644
--- a/drivers/crypto/bcm/spu.c
+++ b/drivers/crypto/bcm/spu.c
@@ -26,8 +26,6 @@
 char *hash_alg_name[] = { "None", "md5", "sha1", "sha224", "sha256", "aes",
 	"sha384", "sha512", "sha3_224", "sha3_256", "sha3_384", "sha3_512" };
 
-char *aead_alg_name[] = { "ccm(aes)", "gcm(aes)", "authenc" };
-
 /* Assumes SPU-M messages are in big endian */
 void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len)
 {
diff --git a/drivers/crypto/bcm/spu.h b/drivers/crypto/bcm/spu.h
index aa6fc38..f252367 100644
--- a/drivers/crypto/bcm/spu.h
+++ b/drivers/crypto/bcm/spu.h
@@ -112,7 +112,6 @@ enum aead_type {
 };
 
 extern char *hash_alg_name[HASH_ALG_LAST];
-extern char *aead_alg_name[AEAD_TYPE_LAST];
 
 struct spu_request_opts {
 	bool is_inbound;
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index d543c01..fa6161a 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -23,6 +23,8 @@
 #define SPU_OFIFO_CTRL      0x40
 #define SPU_FIFO_WATERMARK  0x1FF
 
+static char const * const aead_alg_name[] = { "ccm(aes)", "gcm(aes)", "authenc" };
+
 /**
  * spu_sg_at_offset() - Find the scatterlist entry at a given distance from the
  * start of a scatterlist.
-- 
2.7.4
