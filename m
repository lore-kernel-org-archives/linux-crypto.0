From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/4] crypto: drbg wait for crypto op not signal safe
Date: Thu, 11 May 2017 14:53:43 +0300
Message-ID: <1494503626-15877-3-git-send-email-gilad@benyossef.com>
References: <1494503626-15877-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Eric Biggers <ebiggers3@gmail.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494503626-15877-1-git-send-email-gilad@benyossef.com>
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
 crypto/drbg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index fa749f4..fa9054d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1767,8 +1767,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 			break;
 		case -EINPROGRESS:
 		case -EBUSY:
-			ret = wait_for_completion_interruptible(
-				&drbg->ctr_completion);
+			ret = wait_for_completion(&drbg->ctr_completion);
 			if (!ret && !drbg->ctr_async_err) {
 				reinit_completion(&drbg->ctr_completion);
 				break;
-- 
2.1.4
