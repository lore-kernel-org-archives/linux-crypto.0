Return-Path: <SRS0=WjNG=6M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DC1C83000
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 15:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30CC3205C9
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 15:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgD1PtP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:49:15 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46564 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727860AbgD1PtP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Apr 2020 11:49:15 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 198831A0041;
        Tue, 28 Apr 2020 17:49:13 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id F239E1A002E;
        Tue, 28 Apr 2020 17:49:12 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E774A2030C;
        Tue, 28 Apr 2020 17:49:11 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v6 0/3] crypto: engine - support for parallel and batch requests
Date:   Tue, 28 Apr 2020 18:49:02 +0300
Message-Id: <1588088945-9067-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for executing multiple, independent or not, requests
for crypto engine based on a retry mechanism. If hardware was unable
to execute a backlog request, enqueue it back in front of crypto-engine
queue, to keep the order of requests.

Now do_one_request() returns:
>= 0: hardware executed the request successfully;
< 0: this is the old error path. If hardware has support for retry
mechanism, the backlog request is put back in front of crypto-engine
queue. For backwards compatibility, if the retry support is not available,
the crypto-engine will work as before.
If hardware queue is full (-ENOSPC), requeue request regardless
of MAY_BACKLOG flag.
If hardware throws any other error code (like -EIO, -EINVAL,
-ENOMEM, etc.) only MAY_BACKLOG requests are enqueued back into
crypto-engine's queue, since the others can be dropped.

If hardware supports batch requests, crypto-engine can handle this use-case
through do_batch_requests callback.

Since, these new features, cannot be supported by all hardware,
the crypto-engine framework is backward compatible:
- by using the crypto_engine_alloc_init function, to initialize
crypto-engine, the new callback is NULL and retry mechanism is
disabled, so crypto-engine will work as before these changes;
- to support multiple requests, in parallel, retry_support variable
must be set on true, in driver. 
- to support batch requests, do_batch_requests callback must be
implemented in driver, to execute a batch of requests. The link
between the requests, is expected to be done in driver, in
do_one_request(). 

---
Changes since V5:
- updated, in algapi, the crypto_enqueue_request_head function to
enqueue requests regardless of backlog flag;
- requeue request based on the error code returned by do_one_request().

Changes since V4:
- added, in algapi a function to add a request in front of queue;
- added a retry mechanism: if hardware is unable to execute
a backlog request, enqueue it back in front of crypto-engine
queue, to keep the order of requests.

Changes since V3:
- removed can_enqueue_hardware callback and added a start-stop
mechanism based on the on the return value of do_one_request().

Changes since V2:
- readded cur_req in crypto-engine, to keep, the exact behavior as before
these changes, if can_enqueue_more is not implemented: send requests
to hardware, _one-by-one_, on crypto_pump_requests, and complete it,
on crypto_finalize_request, and so on.
- do_batch_requests is available only with can_enqueue_more.

Changes since V1:
- changed the name of can_enqueue_hardware callback to can_enqueue_more, and
the argument of this callback to crypto_engine structure (for cases when more
than ore crypto-engine is used).
- added a new patch with support for batch requests.

Changes since V0 (RFC):
- removed max_no_req and no_req, as the number of request that can be
processed in parallel;
- added a new callback, can_enqueue_more, to check whether the hardware
can process a new request.


Iuliana Prodan (3):
  crypto: algapi - create function to add request in front of queue
  crypto: engine - support for parallel requests based on retry
    mechanism
  crypto: engine - support for batch requests

 crypto/algapi.c         |   8 +++
 crypto/crypto_engine.c  | 171 +++++++++++++++++++++++++++++++++++++++---------
 include/crypto/algapi.h |   2 +
 include/crypto/engine.h |  15 ++++-
 4 files changed, 164 insertions(+), 32 deletions(-)

-- 
2.1.0

