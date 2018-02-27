From: =?UTF-8?q?Hern=C3=A1n=20Gonzalez?= <hernan@vanguardiasur.com.ar>
Subject: [PATCH 4/4] crypto: bcm: Constify variables in spu2.c
Date: Tue, 27 Feb 2018 19:01:28 -0300
Message-ID: <1519768888-19866-4-git-send-email-hernan@vanguardiasur.com.ar>
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
Variables constified:
*spu2_cipher_type_names
*spu2_hash_mode_names
*spu2_cipher_mode_names
*spu2_hash_type_names

Constifying and declaring as static saves 160 bytes.

add/remove: 0/4 grow/shrink: 0/0 up/down: 0/-160 (-160)
Function                                     old     new   delta
spu2_cipher_type_names                        24       -     -24
spu2_hash_mode_names                          32       -     -32
spu2_cipher_mode_names                        32       -     -32
spu2_hash_type_names                          72       -     -72
Total: Before=9185236, After=9185076, chg -0.00%

Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
---
 drivers/crypto/bcm/spu2.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
index bf7ac62..fcf3885 100644
--- a/drivers/crypto/bcm/spu2.c
+++ b/drivers/crypto/bcm/spu2.c
@@ -49,22 +49,22 @@ enum spu2_proto_sel {
 	SPU2_DTLS_AEAD = 10
 };
 
-char *spu2_cipher_type_names[] = { "None", "AES128", "AES192", "AES256",
-	"DES", "3DES"
+static char * const spu2_cipher_type_names[] = { "None", "AES128", "AES192",
+	"AES256", "DES", "3DES"
 };
 
-char *spu2_cipher_mode_names[] = { "ECB", "CBC", "CTR", "CFB", "OFB", "XTS",
-	"CCM", "GCM"
+static char * const spu2_cipher_mode_names[] = { "ECB", "CBC", "CTR", "CFB",
+	"OFB", "XTS", "CCM", "GCM"
 };
 
-char *spu2_hash_type_names[] = { "None", "AES128", "AES192", "AES256",
-	"Reserved", "Reserved", "MD5", "SHA1", "SHA224", "SHA256", "SHA384",
-	"SHA512", "SHA512/224", "SHA512/256", "SHA3-224", "SHA3-256",
+static char * const spu2_hash_type_names[] = { "None", "AES128", "AES192",
+	"AES256", "Reserved", "Reserved", "MD5", "SHA1", "SHA224", "SHA256",
+	"SHA384", "SHA512", "SHA512/224", "SHA512/256", "SHA3-224", "SHA3-256",
 	"SHA3-384", "SHA3-512"
 };
 
-char *spu2_hash_mode_names[] = { "CMAC", "CBC-MAC", "XCBC-MAC", "HMAC",
-	"Rabin", "CCM", "GCM", "Reserved"
+static char * const spu2_hash_mode_names[] = { "CMAC", "CBC-MAC", "XCBC-MAC",
+	"HMAC", "Rabin", "CCM", "GCM", "Reserved"
 };
 
 static char *spu2_ciph_type_name(enum spu2_cipher_type cipher_type)
-- 
2.7.4
