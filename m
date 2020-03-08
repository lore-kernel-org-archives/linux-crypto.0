Return-Path: <SRS0=hwJD=4Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D205C10DCE
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 22:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F071D206D5
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 22:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCHWvr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Mar 2020 18:51:47 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57534 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgCHWvr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Mar 2020 18:51:47 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9D90E1A1658;
        Sun,  8 Mar 2020 23:51:44 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 90C7A1A1657;
        Sun,  8 Mar 2020 23:51:44 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E4135204CC;
        Sun,  8 Mar 2020 23:51:43 +0100 (CET)
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
Subject: [PATCH v4 0/2] crypto: engine - support for parallel and batch requests
Date:   Mon,  9 Mar 2020 00:51:31 +0200
Message-Id: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for executing multiple, independent or not, requests
for crypto engine. This is based on the return value of
do_one_request(), which is expected to be:
> 0: if hardware still has space in its queue. A driver can implement
do_one_request() to return the number of free entries in
hardware queue;
0: if the request was accepted, by hardware, with success, but the
hardware doesn't support multiple requests or there is no space
left in the hardware queue.
This is to keep the backward compatibility of crypto-engine.
< 0: error.

If hardware supports batch requests, crypto-engine can handle this use-case
through do_batch_requests callback.

Since, these new features, cannot be supported by all hardware,
the crypto-engine framework is backward compatible:
- by using the crypto_engine_alloc_init function, to initialize
crypto-engine, the new callback is NULL and, if do_one_request()
returns 0, crypto-engine will work as before these changes;
- to support multiple requests, in parallel, do_one_request()
needs to be updated to return > 0. 
On crypto_pump_requests(), if do_one_request() returns > 0,
a new request is send to hardware, until there is no space
and do_one_request() returns 0.
- to support batch requests, do_batch_requests callback must be
implemented in driver, to execute a batch of requests. The link
between the requests, is expected to be done in driver, in
do_one_request(). 

---
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

Iuliana Prodan (2):
  crypto: engine - support for parallel requests
  crypto: engine - support for batch requests

 crypto/crypto_engine.c  | 150 ++++++++++++++++++++++++++++++++++++------------
 include/crypto/engine.h |  15 +++--
 2 files changed, 124 insertions(+), 41 deletions(-)

-- 
2.1.0

