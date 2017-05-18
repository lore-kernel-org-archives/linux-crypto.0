From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 1/4] crypto: handle EBUSY due to backlog correctly
Date: Thu, 18 May 2017 14:26:43 +0300
Message-ID: <1495106806-2292-2-git-send-email-gilad@benyossef.com>
References: <1495106806-2292-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1495106806-2292-1-git-send-email-gilad@benyossef.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

public_key_verify_signature() was passing the CRYPTO_TFM_REQ_MAY_BACKLOG
flag to akcipher_request_set_callback() but was not handling correctly
the case where a -EBUSY error could be returned from the call to
crypto_akcipher_verify() if backlog was used, possibly casuing
data corruption due to use-after-free of buffers.

Resolve this by handling -EBUSY correctly.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: stable@vger.kernel.org
---
 crypto/asymmetric_keys/public_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index d3a989e..3cd6e12 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -141,7 +141,7 @@ int public_key_verify_signature(const struct public_key *pkey,
 	 * signature and returns that to us.
 	 */
 	ret = crypto_akcipher_verify(req);
-	if (ret == -EINPROGRESS) {
+	if ((ret == -EINPROGRESS) || (ret == -EBUSY)) {
 		wait_for_completion(&compl.completion);
 		ret = compl.err;
 	}
-- 
2.1.4
