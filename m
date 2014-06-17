From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH 06/24] crypt: return actual error code on pcrypt_init
Date: Tue, 17 Jun 2014 22:29:02 +0800
Message-ID: <53A050AE.2050401@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Return the actual error code if call kset_create_and_add() failed

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller" <davem@davemloft.net>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 crypto/pcrypt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 309d345..053fb10 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -523,11 +523,13 @@ static struct crypto_template pcrypt_tmpl = {
 
 static int __init pcrypt_init(void)
 {
-	int err = -ENOMEM;
+	int err;
 
 	pcrypt_kset = kset_create_and_add("pcrypt", NULL, kernel_kobj);
-	if (!pcrypt_kset)
+	if (IS_ERR(pcrypt_kset)) {
+		err = PTR_ERR(pcrypt_kset);
 		goto err;
+	}
 
 	err = pcrypt_init_padata(&pencrypt, "pencrypt");
 	if (err)
-- 
1.8.3.2
