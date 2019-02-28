Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7F9C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BCDD2083D
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfB1G2e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:28:34 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39734 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfB1G2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:28:33 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzFBI-0005fJ-50; Thu, 28 Feb 2019 14:28:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzFBG-0001b0-Nu; Thu, 28 Feb 2019 14:28:30 +0800
Date:   Thu, 28 Feb 2019 14:28:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     linux-crypto@vger.kernel.org, dt@chelsio.com
Subject: Re: [PATCH] crypto/chelsio/chcr: Fixed Traffic Stall
Message-ID: <20190228062830.mo64yoyzwc5aev5x@gondor.apana.org.au>
References: <20190218100437.13077-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218100437.13077-1-atul.gupta@chelsio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 18, 2019 at 02:04:37AM -0800, Atul Gupta wrote:
> Fixed Traffic Stall caused by
> - Subcommands except last should have more bit set
> - For esn case subcommand is required for linear skb only
> - Also Optimized is_eth_imm usage
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> ---
>  drivers/crypto/chelsio/chcr_ipsec.c | 33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
