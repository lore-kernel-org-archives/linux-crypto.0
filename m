Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F200C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BF192067C
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLTHFX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:05:23 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58690 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfLTHFX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 02:05:23 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iiCLg-0008Qq-1S; Fri, 20 Dec 2019 15:05:20 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iiCLd-0007pI-LO; Fri, 20 Dec 2019 15:05:17 +0800
Date:   Fri, 20 Dec 2019 15:05:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 resend] crypto: picoxcell: adjust the position of
 tasklet_init and fix missed tasklet_kill
Message-ID: <20191220070517.xmo26ffufq7wjebb@gondor.apana.org.au>
References: <20191209162144.14877-1-hslester96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209162144.14877-1-hslester96@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 10, 2019 at 12:21:44AM +0800, Chuhong Yuan wrote:
> Since tasklet is needed to be initialized before registering IRQ
> handler, adjust the position of tasklet_init to fix the wrong order.
> 
> Besides, to fix the missed tasklet_kill, this patch adds a helper
> function and uses devm_add_action to kill the tasklet automatically.
> 
> Fixes: ce92136843cb ("crypto: picoxcell - add support for the picoxcell crypto engines")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
> Changes in v4:
>   - Use devm_add_action instead of devm_add_action_or_reset.
> 
>  drivers/crypto/picoxcell_crypto.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
