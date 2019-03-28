Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B122DC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 06:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DBE320700
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 06:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfC1GIb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 02:08:31 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:53916 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfC1GIa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 02:08:30 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h9ODE-0003sK-L3; Thu, 28 Mar 2019 14:08:28 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h9ODE-0007oI-HB; Thu, 28 Mar 2019 14:08:28 +0800
Date:   Thu, 28 Mar 2019 14:08:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: caam - fix copy of next buffer for xcbc and cmac
Message-ID: <20190328060828.7hvcu3qbw7woqwyw@gondor.apana.org.au>
References: <1553256750-1125-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553256750-1125-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 22, 2019 at 02:12:30PM +0200, Iuliana Prodan wrote:
> Fix a side effect of adding xcbc support, when the next_buffer is not
> copied.
> The issue occurs, when there is stored from previous state a blocksize
> buffer and received, a less than blocksize, from user. In this case, the
> nents for req->src is 0, and the next_buffer is not copied.
> An example is:
> {
> 	.tap	= { 17, 15, 8 },
> 	.psize	= 40,
> 	.np	= 3,
> 	.ksize	= 16,
> }
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 12b8567f6fa4 ("crypto: caam - add support for xcbc(aes)")
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> ---
>  drivers/crypto/caam/caamhash.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
