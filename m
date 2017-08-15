From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: RE: [PATCH 2/3] crypto: engine - find request type with cra_type
Date: Tue, 15 Aug 2017 07:51:14 +0000
Message-ID: <f2185b14d944433c9737cabc32e3cef9@SFHDAG5NODE3.st.com>
References: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
 <20170814131725.9402-3-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37780 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753232AbdHOHv2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Aug 2017 03:51:28 -0400
In-Reply-To: <20170814131725.9402-3-clabbe.montjoie@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

Since I have just sent a patch to add the support of "aead_request" to crypto engine, I am wondering if your proposed change (checking cra_type instead of crypto_tfm_alg_type) and mine are compatible.
It looks like they are (assuming we export crypto_aead_type): can you confirm?
BR

Fabien.

>-----Original Message-----
>From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
>owner@vger.kernel.org] On Behalf Of Corentin Labbe
>Sent: lundi 14 août 2017 15:17
>To: herbert@gondor.apana.org.au; davem@davemloft.net
>Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Corentin Labbe
><clabbe.montjoie@gmail.com>
>Subject: [PATCH 2/3] crypto: engine - find request type with cra_type
>
>The current method for finding request type is based on crypto_tfm_alg_type.
>
>But in case of skcipher, it is the same than ablkcipher.
>Using cra_type for this work permits to make the distinction between the two.
>
>Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
>---
> crypto/crypto_engine.c | 19 ++++++++-----------
> 1 file changed, 8 insertions(+), 11 deletions(-)
>
>diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c index
>61e7c4e02fd2..74b840749074 100644
>--- a/crypto/crypto_engine.c
>+++ b/crypto/crypto_engine.c
>@@ -38,7 +38,8 @@ static void crypto_pump_requests(struct crypto_engine
>*engine,
> 	struct ablkcipher_request *breq;
> 	unsigned long flags;
> 	bool was_busy = false;
>-	int ret, rtype;
>+	int ret;
>+	const struct crypto_type *cratype;
>
> 	spin_lock_irqsave(&engine->queue_lock, flags);
>
>@@ -94,7 +95,7 @@ static void crypto_pump_requests(struct crypto_engine
>*engine,
>
> 	spin_unlock_irqrestore(&engine->queue_lock, flags);
>
>-	rtype = crypto_tfm_alg_type(engine->cur_req->tfm);
>+	cratype = engine->cur_req->tfm->__crt_alg->cra_type;
> 	/* Until here we get the request need to be encrypted successfully */
> 	if (!was_busy && engine->prepare_crypt_hardware) {
> 		ret = engine->prepare_crypt_hardware(engine);
>@@ -104,8 +105,7 @@ static void crypto_pump_requests(struct crypto_engine
>*engine,
> 		}
> 	}
>
>-	switch (rtype) {
>-	case CRYPTO_ALG_TYPE_AHASH:
>+	if (cratype == &crypto_ahash_type) {
> 		hreq = ahash_request_cast(engine->cur_req);
> 		if (engine->prepare_hash_request) {
> 			ret = engine->prepare_hash_request(engine, hreq); @@
>-122,7 +122,7 @@ static void crypto_pump_requests(struct crypto_engine
>*engine,
> 			goto req_err;
> 		}
> 		return;
>-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
>+	} else if (cratype == &crypto_ablkcipher_type) {
> 		breq = ablkcipher_request_cast(engine->cur_req);
> 		if (engine->prepare_cipher_request) {
> 			ret = engine->prepare_cipher_request(engine, breq);
>@@ -139,21 +139,18 @@ static void crypto_pump_requests(struct
>crypto_engine *engine,
> 			goto req_err;
> 		}
> 		return;
>-	default:
>+	} else {
> 		dev_err(engine->dev, "failed to prepare request of unknown
>type\n");
> 		return;
> 	}
>
> req_err:
>-	switch (rtype) {
>-	case CRYPTO_ALG_TYPE_AHASH:
>+	if (cratype == &crypto_ahash_type) {
> 		hreq = ahash_request_cast(engine->cur_req);
> 		crypto_finalize_hash_request(engine, hreq, ret);
>-		break;
>-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
>+	} else if (cratype == &crypto_ablkcipher_type) {
> 		breq = ablkcipher_request_cast(engine->cur_req);
> 		crypto_finalize_cipher_request(engine, breq, ret);
>-		break;
> 	}
> 	return;
>
>--
>2.13.0
