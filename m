From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH v3] crypto: des3_ede: permit weak keys unless REQ_WEAK_KEY
 set
Date: Sat, 06 Dec 2008 00:39:38 -0500
Message-ID: <493A101A.1080500@redhat.com>
References: <200812041557.49601.jarod@redhat.com> <493942D9.6030807@redhat.com> <20081205152427.GA32475@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48402 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYLFFos (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Dec 2008 00:44:48 -0500
In-Reply-To: <20081205152427.GA32475@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jarod Wilson wrote:
> While its a slightly insane to bypass the key1 == key2 ||
> key2 == key3 check in triple-des, since it reduces it to the
> same strength as des, some folks do need to do this from time
> to time for backwards compatibility with des.
>
> My own case is FIPS CAVS test vectors. Many triple-des test
> vectors use a single key, replicated 3x. In order to get the
> expected results, des3_ede_setkey() needs to honor the weak
> key flag.

v2: make CRYPTO_TFM_REQ_WEAK_KEY flag usage consistent w/rest
of crypto subsystem, per comments from Herbert in Red Hat
bugzilla #474394.

v3: set more appropriate RES flag, also per Herbert.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
  crypto/des_generic.c |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 5d0e458..5bd3ee3 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -868,9 +868,10 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const 
u8 *key,
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

