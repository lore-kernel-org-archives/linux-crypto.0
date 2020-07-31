Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85EEC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 07:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5BA1207F5
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 07:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731544AbgGaHDx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 03:03:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39722 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731367AbgGaHDw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 03:03:52 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k1P54-0000vh-6E; Fri, 31 Jul 2020 17:03:51 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Jul 2020 17:03:50 +1000
Date:   Fri, 31 Jul 2020 17:03:50 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: algif_aead - Do not set MAY_BACKLOG on the async path
Message-ID: <20200731070350.GB17085@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The async path cannot use MAY_BACKLOG because it is not meant to
block, which is what MAY_BACKLOG does.  On the other hand, both
the sync and async paths can make use of MAY_SLEEP.
    
Fixes: 83094e5e9e49 ("crypto: af_alg - add async support to...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index d48d2156e6210..d733c8b74bee3 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -78,7 +78,7 @@ static int crypto_aead_copy_sgl(struct crypto_sync_skcipher *null_tfm,
 	SYNC_SKCIPHER_REQUEST_ON_STACK(skreq, null_tfm);
 
 	skcipher_request_set_sync_tfm(skreq, null_tfm);
-	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	skcipher_request_set_callback(skreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(skreq, src, dst, len, NULL);
 
@@ -291,19 +291,20 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		areq->outlen = outlen;
 
 		aead_request_set_callback(&areq->cra_u.aead_req,
-					  CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  CRYPTO_TFM_REQ_MAY_SLEEP,
 					  af_alg_async_cb, areq);
 		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
 				 crypto_aead_decrypt(&areq->cra_u.aead_req);
 
 		/* AIO operation in progress */
-		if (err == -EINPROGRESS || err == -EBUSY)
+		if (err == -EINPROGRESS)
 			return -EIOCBQUEUED;
 
 		sock_put(sk);
 	} else {
 		/* Synchronous operation */
 		aead_request_set_callback(&areq->cra_u.aead_req,
+					  CRYPTO_TFM_REQ_MAY_SLEEP |
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  crypto_req_done, &ctx->wait);
 		err = crypto_wait_req(ctx->enc ?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
