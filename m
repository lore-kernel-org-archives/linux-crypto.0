Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C9BC3DA78
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Jan 2023 14:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjAQORz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Jan 2023 09:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjAQORx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2023 09:17:53 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A3B32525
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2023 06:17:52 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so25924177wmb.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2023 06:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dTHyChbO618TW+g0tgT3zi0P3ULK8JiLkstdpFK8mZQ=;
        b=lEDauw0Bb/fxvZJTnThpFfgivtEQ3RY/QrBemDT10fF8F7QGt54GNFNZIyvjlBpXqa
         QoVWAa+ga6bzxooZIE2NU/MuOpTNNsVQf1leqmAfCtjYMUKySyYt5I+KewMyfSj8v0Cx
         LwIgziyXKYbdHP1GDvscs9Qf+GWCM6WBDjx9gEhc2EP6eEkiR0r8Oqla6fbVB2Th5nsI
         OAnSdeimj8lEMYKTiuf0Xc9MwTTVYWwzOWffpkBmFY0mWJ9K/FWqFYk2H2KiFuX2kdEt
         PxKLpW0sR8GFVwIwI7ieDOjt7veajhEhmpTtDS/j4nDRLtwGjxISA//4S3E1a3k/Uqz2
         NfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTHyChbO618TW+g0tgT3zi0P3ULK8JiLkstdpFK8mZQ=;
        b=dojSwe6L/YuUDqwg1zIWukz7W7P2/JYssjU52eTGlmuge9LSgP+8k3T5sig6tlxwzb
         1lsgcXgpoAwc/naXM9kKVYkSofmPqHCK5zTTr+ATaJKIjiWUCtC2S2dQ4e9dY0eCTuRW
         6zaYBJNT4razrSEzcywmACIC6Wa/B1uI2i3bKpfwHzZgArAfifmqeqeQZvjBE2boW/Yc
         0xn8nCdqq1O2D61RJW6Dv1BSQLiu5FHrQXu2Y7Gi9ATyr5G6vlf778QBDznCHlUIwNgI
         liMGzKxL6iNonifnwhKPNi1fR5cYa4XAscFhzEBIV4U5VyXmy7Bl0mV9ekJnSdQwgV7y
         z1/g==
X-Gm-Message-State: AFqh2kojLRP1SCxxJrslJFIeS0pMvDN28U9CQIgwiqWr60iGjrNKJ12a
        78Z6yGtioTKJ9q+fTf3GzgNnQTYXOQmYZg==
X-Google-Smtp-Source: AMrXdXutMAC+jsdRYpfzk/iK7JA4z7t000SJRBSX9kW92VeVEZ3PN0tUG0c3CRYH7q8lu/9lNgoQig==
X-Received: by 2002:a05:600c:4f41:b0:3da:ff08:6c5f with SMTP id m1-20020a05600c4f4100b003daff086c5fmr3093100wmq.40.1673965071448;
        Tue, 17 Jan 2023 06:17:51 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o37-20020a05600c512500b003db09eaddb5sm2395600wms.3.2023.01.17.06.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 06:17:50 -0800 (PST)
Date:   Tue, 17 Jan 2023 17:17:47 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jonathan.Cameron@huawei.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: hisilicon - SEC security accelerator driver
Message-ID: <Y8auC2Ef+nC1FN1T@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Jonathan Cameron,

The patch 915e4e8413da: "crypto: hisilicon - SEC security accelerator
driver" from Jul 23, 2018, leads to the following Smatch static
checker warning:

drivers/crypto/hisilicon/sec/sec_algs.c:389 sec_send_request() warn: sleeping in atomic context
drivers/crypto/hisilicon/sec/sec_algs.c:494 sec_skcipher_alg_callback() warn: sleeping in atomic context
drivers/crypto/hisilicon/sec/sec_algs.c:506 sec_skcipher_alg_callback() warn: sleeping in atomic context
drivers/crypto/hisilicon/sec/sec_algs.c:824 sec_alg_skcipher_crypto() warn: sleeping in atomic context
drivers/crypto/hisilicon/sec/sec_drv.c:864 sec_queue_send() warn: sleeping in atomic context

drivers/crypto/hisilicon/sec/sec_algs.c
    421 static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
    422                                       struct crypto_async_request *req_base)
    423 {
    424         struct skcipher_request *skreq = container_of(req_base,
    425                                                       struct skcipher_request,
    426                                                       base);
    427         struct sec_request *sec_req = skcipher_request_ctx(skreq);
    428         struct sec_request *backlog_req;
    429         struct sec_request_el *sec_req_el, *nextrequest;
    430         struct sec_alg_tfm_ctx *ctx = sec_req->tfm_ctx;
    431         struct crypto_skcipher *atfm = crypto_skcipher_reqtfm(skreq);
    432         struct device *dev = ctx->queue->dev_info->dev;
    433         int icv_or_skey_en, ret;
    434         bool done;
    435 
    436         sec_req_el = list_first_entry(&sec_req->elements, struct sec_request_el,
    437                                       head);
    438         icv_or_skey_en = (sec_resp->w0 & SEC_BD_W0_ICV_OR_SKEY_EN_M) >>
    439                 SEC_BD_W0_ICV_OR_SKEY_EN_S;
    440         if (sec_resp->w1 & SEC_BD_W1_BD_INVALID || icv_or_skey_en == 3) {
    441                 dev_err(dev, "Got an invalid answer %lu %d\n",
    442                         sec_resp->w1 & SEC_BD_W1_BD_INVALID,
    443                         icv_or_skey_en);
    444                 sec_req->err = -EINVAL;
    445                 /*
    446                  * We need to muddle on to avoid getting stuck with elements
    447                  * on the queue. Error will be reported so requester so
    448                  * it should be able to handle appropriately.
    449                  */
    450         }
    451 
    452         spin_lock_bh(&ctx->queue->queuelock);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Holding a spinlock.

    453         /* Put the IV in place for chained cases */
    454         switch (ctx->cipher_alg) {
    455         case SEC_C_AES_CBC_128:
    456         case SEC_C_AES_CBC_192:
    457         case SEC_C_AES_CBC_256:
    458                 if (sec_req_el->req.w0 & SEC_BD_W0_DE)
    459                         sg_pcopy_to_buffer(sec_req_el->sgl_out,
    460                                            sg_nents(sec_req_el->sgl_out),
    461                                            skreq->iv,
    462                                            crypto_skcipher_ivsize(atfm),
    463                                            sec_req_el->el_length -
    464                                            crypto_skcipher_ivsize(atfm));
    465                 else
    466                         sg_pcopy_to_buffer(sec_req_el->sgl_in,
    467                                            sg_nents(sec_req_el->sgl_in),
    468                                            skreq->iv,
    469                                            crypto_skcipher_ivsize(atfm),
    470                                            sec_req_el->el_length -
    471                                            crypto_skcipher_ivsize(atfm));
    472                 /* No need to sync to the device as coherent DMA */
    473                 break;
    474         case SEC_C_AES_CTR_128:
    475         case SEC_C_AES_CTR_192:
    476         case SEC_C_AES_CTR_256:
    477                 crypto_inc(skreq->iv, 16);
    478                 break;
    479         default:
    480                 /* Do not update */
    481                 break;
    482         }
    483 
    484         if (ctx->queue->havesoftqueue &&
    485             !kfifo_is_empty(&ctx->queue->softqueue) &&
    486             sec_queue_empty(ctx->queue)) {
    487                 ret = kfifo_get(&ctx->queue->softqueue, &nextrequest);
    488                 if (ret <= 0)
    489                         dev_err(dev,
    490                                 "Error getting next element from kfifo %d\n",
    491                                 ret);
    492                 else
    493                         /* We know there is space so this cannot fail */
--> 494                         sec_queue_send(ctx->queue, &nextrequest->req,
                                ^^^^^^^^^^^^^^^

Sleeping function.

    495                                        nextrequest->sec_req);
    496         } else if (!list_empty(&ctx->backlog)) {
    497                 /* Need to verify there is room first */
    498                 backlog_req = list_first_entry(&ctx->backlog,
    499                                                typeof(*backlog_req),
    500                                                backlog_head);
    501                 if (sec_queue_can_enqueue(ctx->queue,
    502                     backlog_req->num_elements) ||
    503                     (ctx->queue->havesoftqueue &&
    504                      kfifo_avail(&ctx->queue->softqueue) >
    505                      backlog_req->num_elements)) {
    506                         sec_send_request(backlog_req, ctx->queue);
                                ^^^^^^^^^^^^^^^^
Also sleeps.

    507                         backlog_req->req_base->complete(backlog_req->req_base,
    508                                                         -EINPROGRESS);
    509                         list_del(&backlog_req->backlog_head);
    510                 }
    511         }
    512         spin_unlock_bh(&ctx->queue->queuelock);

regards,
dan carpenter
