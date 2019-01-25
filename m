Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F55AC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E542B218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfAYKpo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:45:44 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44386 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYKpo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 05:45:44 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmyzW-0005bm-BU; Fri, 25 Jan 2019 18:45:42 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmyzS-00023z-81; Fri, 25 Jan 2019 18:45:38 +0800
Date:   Fri, 25 Jan 2019 18:45:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srikanth Jampala <jsrikanth@marvell.com>
Subject: Re: [PATCH] crypto: cavium/nitrox - Invoke callback after DMA unmap
Message-ID: <20190125104538.geei73vxp4oeht47@gondor.apana.org.au>
References: <20190114135204.20693-1-rnagadheeraj@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190114135204.20693-1-rnagadheeraj@marvell.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 14, 2019 at 01:52:24PM +0000, Nagadheeraj Rottela wrote:
> In process_response_list() invoke the callback handler after unmapping
> the DMA buffers. It ensures DMA data is synced form device to cpu
> before the client code access the data from callback handler.
> 
> Fixes: c9613335bf4f ("crypto: cavium/nitrox - Added AEAD cipher support")
> Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
