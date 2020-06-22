Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DB9C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 13:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B2092070E
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 13:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgFVNd2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:33:28 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43638 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgFVNd2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 09:33:28 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jnMZg-0000Iu-Gy; Mon, 22 Jun 2020 23:33:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 22 Jun 2020 23:33:24 +1000
Date:   Mon, 22 Jun 2020 23:33:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sachin Sant <sachinp@linux.vnet.ibm.com>
Cc:     linux-crypto@vger.kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [next-20200621] LTP tests af_alg02/05 failure on POWER9 PowerVM
 LPAR
Message-ID: <20200622133324.GA4025@gondor.apana.org.au>
References: <DF21C7B5-3824-4A6E-B59C-78B67E247383@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DF21C7B5-3824-4A6E-B59C-78B67E247383@linux.vnet.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 22, 2020 at 05:55:29PM +0530, Sachin Sant wrote:
> With recent next(next-20200621) af_alg02/05 tests fail while running on POWER9
> PowerVM LPAR.
> 
> Results from  5.8.0-rc1-next-20200622
> # ./af_alg02
> tst_test.c:1096: INFO: Timeout per run is 0h 00m 20s
> af_alg02.c:52: BROK: Timed out while reading from request socket.
> #
> 
> 5.8.0-rc1-next-20200618 was good. The test case ran fine.
> 
> Root cause analysis point to following commit:
> 
> commit f3c802a1f30013f8f723b62d7fa49eb9e991da23
>     crypto: algif_aead - Only wake up when ctx->more is zero
> 
> Reverting this commit allows the test to PASS.

Yes that commit does change the behaviour if you don't terminate
your AEAD request by clearing the MSG_MORE flag.  AEAD does not
support chaining so each request must be sent in full before it
can be processed through recvmsg(2).  Setting the MSG_MORE flag
indicates that your request has not been sent in full.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
