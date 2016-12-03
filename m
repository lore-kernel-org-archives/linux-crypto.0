From: Pan Bian <bianpan201602@163.com>
Subject: [PATCH 1/1] crypto: asymmetric_keys: set error code on failure
Date: Sat,  3 Dec 2016 22:57:04 +0800
Message-ID: <1480777024-7410-1-git-send-email-bianpan201602@163.com>
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
To: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

In function public_key_verify_signature(), returns variable ret on
error paths. When the call to kmalloc() fails, the value of ret is 0,
and it is not set to an errno before returning. This patch fixes the
bug.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188891

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 crypto/asymmetric_keys/public_key.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index fd76b5f..1dc65ba 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -123,8 +123,10 @@ int public_key_verify_signature(const struct public_key *pkey,
 
 	outlen = crypto_akcipher_maxsize(tfm);
 	output = kmalloc(outlen, GFP_KERNEL);
-	if (!output)
+	if (!output) {
+		ret = -ENOMEM;
 		goto error_free_req;
+	}
 
 	sg_init_one(&sig_sg, sig->s, sig->s_size);
 	sg_init_one(&digest_sg, output, outlen);
-- 
1.9.1
