Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E694BC54FCB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 11:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C552084D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 11:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgDWLrJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 07:47:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37446 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbgDWLrJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 07:47:09 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jRaJU-0001c8-A7; Thu, 23 Apr 2020 21:46:41 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Apr 2020 21:46:40 +1000
Date:   Thu, 23 Apr 2020 21:46:40 +1000
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
Subject: Re: [PATCH v5 2/3] crypto: engine - support for parallel requests
 based on retry mechanism
Message-ID: <20200423114640.GA14399@gondor.apana.org.au>
References: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
 <1586982375-18710-3-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586982375-18710-3-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 15, 2020 at 11:26:14PM +0300, Iuliana Prodan wrote:
> Added support for executing multiple requests, in parallel,
> for crypto engine based on a retry mechanism.
> If hardware was unable to execute a backlog request, enqueue it
> back in front of crypto-engine queue, to keep the order
> of requests.
> 
> A new variable is added, retry_support (this is to keep the
> backward compatibility of crypto-engine) , which keeps track
> whether the hardware has support for retry mechanism and,
> also, if can run multiple requests.
> 
> If do_one_request() returns:
> >= 0: hardware executed the request successfully;
> < 0: this is the old error path. If hardware has support for retry
> mechanism, the request is put back in front of crypto-engine queue.
> For backwards compatibility, if the retry support is not available,
> the crypto-engine will work as before.
> Only MAY_BACKLOG requests are enqueued back into
> crypto-engine's queue, since the others can be dropped.

This looks a lot nicer!

However, I do have one little issue with the error case.  I think
we should not lump all errors together.  For queueing errors, we
should requeue regardless of MAY_BACKLOG.  After all, we don't
want to have random packet loss just becayse the queue was full.

For other errors (e.g., a kmalloc error), we should requeue the
MAY_BACKLOG requests and drop everythin else.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
