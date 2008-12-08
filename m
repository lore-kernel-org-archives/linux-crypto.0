From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH v4] crypto: des3_ede: permit weak keys unless REQ_WEAK_KEY set
Date: Mon, 8 Dec 2008 10:41:41 -0500
Message-ID: <200812081041.42296.jarod@redhat.com>
References: <200812041557.49601.jarod@redhat.com> <20081205152427.GA32475@gondor.apana.org.au> <200812051458.10426.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYLHPiT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2008 10:38:19 -0500
In-Reply-To: <200812051458.10426.jarod@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While its a slightly insane to bypass the key1 == key2 ||
key2 == key3 check in triple-des, since it reduces it to the
same strength as des, some folks do need to do this from time
to time for backwards compatibility with des.

My own case is FIPS CAVS test vectors. Many triple-des test
vectors use a single key, replicated 3x. In order to get the
expected results, des3_ede_setkey() needs to only reject weak
keys if the CRYPTO_TFM_REQ_WEAK_KEY flag is set.

Also sets a more appropriate RES flag when a weak key is found.

This time, hopefully without unintended line wrapping...

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/des_generic.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 5d0e458..5bd3ee3 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -868,9 +868,10 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 *flags = &tfm->crt_flags;
 
 	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))))
+		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
+		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY))
 	{
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
 
-- 
Jarod Wilson
jarod@redhat.com
