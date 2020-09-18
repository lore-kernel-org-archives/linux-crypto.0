Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58360C43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 08:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D2C21481
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 08:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgIRIBf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 04:01:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57738 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIRIBf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 04:01:35 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kJBKh-000484-PJ; Fri, 18 Sep 2020 18:01:28 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2020 18:01:27 +1000
Date:   Fri, 18 Sep 2020 18:01:27 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: inside-secure - Fix corruption on not fully
 coherent systems
Message-ID: <20200918080127.GA24222@gondor.apana.org.au>
References: <1599466784-23596-1-git-send-email-pvanleeuwen@rambus.com>
 <20200918065806.GA9698@gondor.apana.org.au>
 <CY4PR0401MB365283BF192613FD82EC0C12C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR0401MB365283BF192613FD82EC0C12C33F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 18, 2020 at 07:42:35AM +0000, Van Leeuwen, Pascal wrote:
>
> Actually, that is what we did as a _quick hack_ initially, but:
> 
> First of all, it's not only about the L1 cacheline size. It's about the worst case cache
> line size in the path all the way from the CPU to the actual memory interface.
> 
> Second, cache line sizes may differ from system to system. So it's not actually
> a constant at all (unless you compile the driver specifically for 1 target system).

Can this alignment exceed ARCH_DMA_MINALIGN? If not then the
macro CRYPTO_MINALIGN should cover it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
