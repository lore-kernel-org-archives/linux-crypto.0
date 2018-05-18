From: Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH] crypto: chtls - fix a missing-check bug
Date: Fri, 18 May 2018 14:55:35 -0500
Message-ID: <1526673338-486-1-git-send-email-wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Michael Werner <werner@chelsio.com>,
        Casey Leedom <leedom@chelsio.com>,
        linux-crypto@vger.kernel.org (open list:CXGB4 CRYPTO DRIVER (chcr)),
        linux-kernel@vger.kernel.org (open list)
To: Wenwen Wang <wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In do_chtls_setsockopt(), the tls crypto info is first copied from the
poiner 'optval' in userspace and saved to 'tmp_crypto_info'. Then the
'version' of the crypto info is checked. If the version is not as expected,
i.e., TLS_1_2_VERSION, error code -ENOTSUPP is returned to indicate that
the provided crypto info is not supported yet. Then, the 'cipher_type'
field of the 'tmp_crypto_info' is also checked to see if it is
TLS_CIPHER_AES_GCM_128. If it is, the whole struct of
tls12_crypto_info_aes_gcm_128 is copied from the pointer 'optval' and then
the function chtls_setkey() is invoked to set the key.

Given that the 'optval' pointer resides in userspace, a malicious userspace
process can race to change the data pointed by 'optval' between the two
copies. For example, a user can provide a crypto info with TLS_1_2_VERSION
and TLS_CIPHER_AES_GCM_128. After the first copy, the user can modify the
'version' and the 'cipher_type' fields to any versions and/or cipher types
that are not allowed. This way, the user can bypass the checks, inject
bad data to the kernel, cause chtls_setkey() to set a wrong key or other
issues.

This patch reuses the data copied in the first try so as to ensure these
checks will not be bypassed.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 007c45c..39aab05 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -491,9 +491,13 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
 
 	switch (tmp_crypto_info.cipher_type) {
 	case TLS_CIPHER_AES_GCM_128: {
-		rc = copy_from_user(crypto_info, optval,
-				    sizeof(struct
-					   tls12_crypto_info_aes_gcm_128));
+		/* Obtain version and type from previous copy */
+		crypto_info[0] = tmp_crypto_info;
+		/* Now copy the following data */
+		rc = copy_from_user((char *)crypto_info + sizeof(*crypto_info),
+				optval + sizeof(*crypto_info),
+				sizeof(struct tls12_crypto_info_aes_gcm_128)
+				- sizeof(*crypto_info));
 
 		if (rc) {
 			rc = -EFAULT;
-- 
2.7.4
