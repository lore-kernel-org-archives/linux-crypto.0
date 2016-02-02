From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2 1/3] crypto: sahara - avoid needlessly saving and
 restoring sahara_ctx
Date: Tue, 2 Feb 2016 15:18:47 -0200
Message-ID: <CAOMZO5D-7xEhKyWhL3QDzF23ECLT+Yt=5-mc+ZRfAazZ=QfHEQ@mail.gmail.com>
References: <1452707524-7695-1-git-send-email-festevam@gmail.com>
	<20160125140728.GA8414@gondor.apana.org.au>
	<CAOMZO5BE49yzqpEy3TAGAyY52XR_sq6NtFa6e1fdkDAP9Xt4Ow@mail.gmail.com>
	<20160202144309.GA17909@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37675 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbcBBRSs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Feb 2016 12:18:48 -0500
Received: by mail-ig0-f177.google.com with SMTP id 5so16320473igt.0
        for <linux-crypto@vger.kernel.org>; Tue, 02 Feb 2016 09:18:48 -0800 (PST)
In-Reply-To: <20160202144309.GA17909@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 2, 2016 at 12:43 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Preferably you shouldn't include the mutex in the exported state
> at all.

Ok, so would it be safe to completely remove the mutex like this?

--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -182,7 +182,6 @@ struct sahara_sha_reqctx {
        u8                      buf[SAHARA_MAX_SHA_BLOCK_SIZE];
        u8                      rembuf[SAHARA_MAX_SHA_BLOCK_SIZE];
        u8                      context[SHA256_DIGEST_SIZE + 4];
-       struct mutex            mutex;
        unsigned int            mode;
        unsigned int            digest_size;
        unsigned int            context_size;
@@ -1096,7 +1095,6 @@ static int sahara_sha_enqueue(struct ahash_request *req, i
        if (!req->nbytes && !last)
                return 0;

-       mutex_lock(&rctx->mutex);
        rctx->last = last;

        if (!rctx->active) {
@@ -1109,7 +1107,6 @@ static int sahara_sha_enqueue(struct ahash_request *req, i
        mutex_unlock(&dev->queue_mutex);

        wake_up_process(dev->kthread);
-       mutex_unlock(&rctx->mutex);

        return ret;
 }
@@ -1137,8 +1134,6 @@ static int sahara_sha_init(struct ahash_request *req)
        rctx->context_size = rctx->digest_size + 4;
        rctx->active = 0;

-       mutex_init(&rctx->mutex);
-
        return 0;
 }

Thanks
