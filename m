From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 2/4] crypto: drbg wait for crypto op not signal safe
Date: Thu, 18 May 2017 14:26:44 +0300
Message-ID: <1495106806-2292-3-git-send-email-gilad@benyossef.com>
References: <1495106806-2292-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495106806-2292-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

drbg_kcapi_sym_ctr() was using wait_for_completion_interruptible() to
wait for completion of async crypto op but if a signal occurs it
may return before DMA ops of HW crypto provider finish, thus
corrupting the output buffer.

Resolve this by using wait_for_completion() instead.

Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: stable@vger.kernel.org
---
 crypto/drbg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index fa749f4..cdb27ac 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1767,9 +1767,8 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 			break;
 		case -EINPROGRESS:
 		case -EBUSY:
-			ret = wait_for_completion_interruptible(
-				&drbg->ctr_completion);
-			if (!ret && !drbg->ctr_async_err) {
+			wait_for_completion(&drbg->ctr_completion);
+			if (!drbg->ctr_async_err) {
 				reinit_completion(&drbg->ctr_completion);
 				break;
 			}
-- 
2.1.4
