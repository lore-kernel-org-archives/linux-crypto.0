Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F4EC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 07:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C6082067D
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 07:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbgGaHDb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 03:03:31 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39718 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731375AbgGaHDb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 03:03:31 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k1P4h-0000uq-KY; Fri, 31 Jul 2020 17:03:28 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Jul 2020 17:03:27 +1000
Date:   Fri, 31 Jul 2020 17:03:27 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: algif_skcipher - EBUSY on aio should be an error
Message-ID: <20200731070327.GA17085@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I removed the MAY_BACKLOG flag on the aio path a while ago but
the error check still incorrectly interpreted EBUSY as success.
This may cause the submitter to wait for a request that will never
complete.
    
Fixes: dad419970637 ("crypto: algif_skcipher - Do not set...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a51ba22fef58f..28af2c4773c27 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -123,7 +123,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
 
 		/* AIO operation in progress */
-		if (err == -EINPROGRESS || err == -EBUSY)
+		if (err == -EINPROGRESS)
 			return -EIOCBQUEUED;
 
 		sock_put(sk);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
