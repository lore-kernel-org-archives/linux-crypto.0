Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B39C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 04:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4FE3206C2
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 04:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392221AbfITEf7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 00:35:59 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51502 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392019AbfITEf7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 00:35:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EDC20205B2;
        Fri, 20 Sep 2019 06:35:57 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DL2If1nkOnUZ; Fri, 20 Sep 2019 06:35:57 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4AD95205A9;
        Fri, 20 Sep 2019 06:35:57 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Sep 2019
 06:35:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E5D903182607;
 Fri, 20 Sep 2019 06:35:56 +0200 (CEST)
Date:   Fri, 20 Sep 2019 06:35:56 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: pcrypt - forbid recursive instantiation
Message-ID: <20190920043556.GP2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If the pcrypt template is used multiple times in an algorithm, then a
deadlock occurs because all pcrypt instances share the same
padata_instance, which completes requests in the order submitted.  That
is, the inner pcrypt request waits for the outer pcrypt request while
the outer request is already waiting for the inner.

Fix this by making pcrypt forbid instantiation if pcrypt appears in the
underlying ->cra_driver_name or if an underlying algorithm needs a
fallback.  This is somewhat of a hack, but it's a simple fix that should
be sufficient to prevent the deadlock.

Reproducer:

	#include <linux/if_alg.h>
	#include <sys/socket.h>
	#include <unistd.h>

	int main()
	{
		struct sockaddr_alg addr = {
			.salg_type = "aead",
			.salg_name = "pcrypt(pcrypt(rfc4106-gcm-aesni))"
		};
		int algfd, reqfd;
		char buf[32] = { 0 };

		algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
		bind(algfd, (void *)&addr, sizeof(addr));
		setsockopt(algfd, SOL_ALG, ALG_SET_KEY, buf, 20);
		reqfd = accept(algfd, 0, 0);
		write(reqfd, buf, 32);
		read(reqfd, buf, 16);
	}

Reported-by: syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com
Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
Cc: <stable@vger.kernel.org> # v2.6.34+
Signed-off-by: Eric Biggers <ebiggers@google.com>
[SK: also require that the underlying algorithm doesn't need a fallback]
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 543792e0ebf0..932a77b61b47 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -198,6 +198,12 @@ static void pcrypt_free(struct aead_instance *inst)
 static int pcrypt_init_instance(struct crypto_instance *inst,
 				struct crypto_alg *alg)
 {
+	/* Recursive pcrypt deadlocks due to the shared padata_instance */
+	if (!strncmp(alg->cra_driver_name, "pcrypt(", 7) ||
+	    strstr(alg->cra_driver_name, "(pcrypt(") ||
+	    strstr(alg->cra_driver_name, ",pcrypt("))
+		return -EINVAL;
+
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "pcrypt(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
@@ -236,7 +242,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	ctx = aead_instance_ctx(inst);
 	crypto_set_aead_spawn(&ctx->spawn, aead_crypto_instance(inst));
 
-	err = crypto_grab_aead(&ctx->spawn, name, 0, 0);
+	err = crypto_grab_aead(&ctx->spawn, name, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (err)
 		goto out_free_inst;
 
-- 
2.17.1

