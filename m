From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 4/4] crypto: Documentation: fix none signal safe sample
Date: Thu, 18 May 2017 14:26:46 +0300
Message-ID: <1495106806-2292-5-git-send-email-gilad@benyossef.com>
References: <1495106806-2292-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1495106806-2292-1-git-send-email-gilad@benyossef.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sample code was showing use of wait_for_completion_interruptible()
for waiting for an async. crypto op to finish. However, if a signal
arrived it would free the buffers used even while crypto HW might
still DMA from/into the buffers.

Resolve this by using wait_for_completion() instead.

Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 Documentation/crypto/api-samples.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
index d021fd9..944f08b 100644
--- a/Documentation/crypto/api-samples.rst
+++ b/Documentation/crypto/api-samples.rst
@@ -48,7 +48,7 @@ Code Example For Symmetric Key Cipher Operation
             break;
         case -EINPROGRESS:
         case -EBUSY:
-            rc = wait_for_completion_interruptible(
+            rc = wait_for_completion(
                 &sk->result.completion);
             if (!rc && !sk->result.err) {
                 reinit_completion(&sk->result.completion);
-- 
2.1.4

