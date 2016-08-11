From: Artem Savkov <asavkov@redhat.com>
Subject: [PATCH] X.509: Fix double free in x509_cert_parse().
Date: Thu, 11 Aug 2016 14:18:56 +0200
Message-ID: <1470917936-23904-1-git-send-email-asavkov@redhat.com>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
To: tadeusz.struk@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Patch "crypto: KEYS: convert public key and digsig asym to the akcipher
api" introduced double freeing of cert->pub->key. There is no need to free
it in error_decode label as it is later freed in x509_free_certificate().

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 1f1899d..9157071 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -133,7 +133,6 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	return cert;
 
 error_decode:
-	kfree(cert->pub->key);
 	kfree(ctx);
 error_no_ctx:
 	x509_free_certificate(cert);
-- 
2.7.4
