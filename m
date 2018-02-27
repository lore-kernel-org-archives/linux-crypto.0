From: =?UTF-8?q?Hern=C3=A1n=20Gonzalez?= <hernan@vanguardiasur.com.ar>
Subject: [PATCH 1/4] crypto: bcm: Remove unused variable (char *tag_to_hash_idx[])
Date: Tue, 27 Feb 2018 19:01:25 -0300
Message-ID: <1519768888-19866-1-git-send-email-hernan@vanguardiasur.com.ar>
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
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Note: this is compile only tested.
Variable was not used anywhere in the code, remove it and save 20 bytes.

add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-20 (-20)
Function                                     old     new   delta
tag_to_hash_idx                               20       -     -20
Total: Before=9185256, After=9185236, chg -0.00%

Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
---
 drivers/crypto/bcm/spu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
index dbb5c03..c3d177d 100644
--- a/drivers/crypto/bcm/spu.c
+++ b/drivers/crypto/bcm/spu.c
@@ -23,8 +23,6 @@
 #include "cipher.h"
 
 /* This array is based on the hash algo type supported in spu.h */
-char *tag_to_hash_idx[] = { "none", "md5", "sha1", "sha224", "sha256" };
-
 char *hash_alg_name[] = { "None", "md5", "sha1", "sha224", "sha256", "aes",
 	"sha384", "sha512", "sha3_224", "sha3_256", "sha3_384", "sha3_512" };
 
-- 
2.7.4
