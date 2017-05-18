From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 3/4] crypto: gcm wait for crypto op not signal safe
Date: Thu, 18 May 2017 16:29:25 +0300
Message-ID: <1495114167-3073-4-git-send-email-gilad@benyossef.com>
References: <1495114167-3073-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495114167-3073-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

crypto_gcm_setkey() was using wait_for_completion_interruptible() to
wait for completion of async crypto op but if a signal occurs it
may return before DMA ops of HW crypto provider finish, thus
corrupting the data buffer that is kfree'ed in this case.

Resolve this by using wait_for_completion() instead.

Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: stable@vger.kernel.org
---
 crypto/gcm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index b7ad808..3841b5e 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -152,10 +152,8 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 
 	err = crypto_skcipher_encrypt(&data->req);
 	if (err == -EINPROGRESS || err == -EBUSY) {
-		err = wait_for_completion_interruptible(
-			&data->result.completion);
-		if (!err)
-			err = data->result.err;
+		wait_for_completion(&data->result.completion);
+		err = data->result.err;
 	}
 
 	if (err)
-- 
2.1.4
