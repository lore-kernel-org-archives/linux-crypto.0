Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E824CC38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF34520720
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgEHGF3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 02:05:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40130 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgEHGF2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 02:05:28 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jWw1n-0004wc-5V; Fri, 08 May 2020 15:58:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 May 2020 16:05:10 +1000
Date:   Fri, 8 May 2020 16:05:10 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 0/3] crypto: engine - support for parallel and batch
 requests
Message-ID: <20200508060510.GC24789@gondor.apana.org.au>
References: <1588088945-9067-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588088945-9067-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 28, 2020 at 06:49:02PM +0300, Iuliana Prodan wrote:
> Added support for executing multiple, independent or not, requests
> for crypto engine based on a retry mechanism. If hardware was unable
> to execute a backlog request, enqueue it back in front of crypto-engine
> queue, to keep the order of requests.
> 
> Now do_one_request() returns:
> >= 0: hardware executed the request successfully;
> < 0: this is the old error path. If hardware has support for retry
> mechanism, the backlog request is put back in front of crypto-engine
> queue. For backwards compatibility, if the retry support is not available,
> the crypto-engine will work as before.
> If hardware queue is full (-ENOSPC), requeue request regardless
> of MAY_BACKLOG flag.
> If hardware throws any other error code (like -EIO, -EINVAL,
> -ENOMEM, etc.) only MAY_BACKLOG requests are enqueued back into
> crypto-engine's queue, since the others can be dropped.
> 
> If hardware supports batch requests, crypto-engine can handle this use-case
> through do_batch_requests callback.
> 
> Since, these new features, cannot be supported by all hardware,
> the crypto-engine framework is backward compatible:
> - by using the crypto_engine_alloc_init function, to initialize
> crypto-engine, the new callback is NULL and retry mechanism is
> disabled, so crypto-engine will work as before these changes;
> - to support multiple requests, in parallel, retry_support variable
> must be set on true, in driver. 
> - to support batch requests, do_batch_requests callback must be
> implemented in driver, to execute a batch of requests. The link
> between the requests, is expected to be done in driver, in
> do_one_request(). 
> 
> ---
> Changes since V5:
> - updated, in algapi, the crypto_enqueue_request_head function to
> enqueue requests regardless of backlog flag;
> - requeue request based on the error code returned by do_one_request().
> 
> Changes since V4:
> - added, in algapi a function to add a request in front of queue;
> - added a retry mechanism: if hardware is unable to execute
> a backlog request, enqueue it back in front of crypto-engine
> queue, to keep the order of requests.
> 
> Changes since V3:
> - removed can_enqueue_hardware callback and added a start-stop
> mechanism based on the on the return value of do_one_request().
> 
> Changes since V2:
> - readded cur_req in crypto-engine, to keep, the exact behavior as before
> these changes, if can_enqueue_more is not implemented: send requests
> to hardware, _one-by-one_, on crypto_pump_requests, and complete it,
> on crypto_finalize_request, and so on.
> - do_batch_requests is available only with can_enqueue_more.
> 
> Changes since V1:
> - changed the name of can_enqueue_hardware callback to can_enqueue_more, and
> the argument of this callback to crypto_engine structure (for cases when more
> than ore crypto-engine is used).
> - added a new patch with support for batch requests.
> 
> Changes since V0 (RFC):
> - removed max_no_req and no_req, as the number of request that can be
> processed in parallel;
> - added a new callback, can_enqueue_more, to check whether the hardware
> can process a new request.
> 
> 
> Iuliana Prodan (3):
>   crypto: algapi - create function to add request in front of queue
>   crypto: engine - support for parallel requests based on retry
>     mechanism
>   crypto: engine - support for batch requests
> 
>  crypto/algapi.c         |   8 +++
>  crypto/crypto_engine.c  | 171 +++++++++++++++++++++++++++++++++++++++---------
>  include/crypto/algapi.h |   2 +
>  include/crypto/engine.h |  15 ++++-
>  4 files changed, 164 insertions(+), 32 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
