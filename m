Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11420C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 13:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE0D020881
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 13:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfAYNtP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 08:49:15 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44878 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfAYNtP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 08:49:15 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gn1r6-0003qQ-Oa; Fri, 25 Jan 2019 21:49:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gn1qw-0003KD-5t; Fri, 25 Jan 2019 21:49:02 +0800
Date:   Fri, 25 Jan 2019 21:49:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Roland Hieber <rhi@pengutronix.de>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org,
        Roland Hieber <r.hieber@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de
Subject: Re: [PATCH 2/2] crypto: caam - fix DMA mapping of stack memory
Message-ID: <20190125134902.yp7kjja6aecce6vm@gondor.apana.org.au>
References: <20190122152651.1150-1-rhi@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190122152651.1150-1-rhi@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 22, 2019 at 04:26:51PM +0100, Roland Hieber wrote:
>
> The cause is that the struct ahash_request *req is created as a
> stack-local variable up in the stack (presumably somewhere in the IMA
> implementation), then passed down into the CAAM driver, which tries to
> dma_single_map the req->result (indirectly via map_seq_out_ptr_result)
> in order to make that buffer available for the CAAM to store the result
> of the following hash operation.

Then IMA needs to be fixed.  Asynchronous crypto requests must be
allocated with kmalloc so this is an API violation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
