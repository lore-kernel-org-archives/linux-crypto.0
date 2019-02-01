Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E925C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF17320870
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfBAGsl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:48:41 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56908 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGsl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:48:41 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpScx-00005k-Mo; Fri, 01 Feb 2019 14:48:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpScw-0005kU-5y; Fri, 01 Feb 2019 14:48:38 +0800
Date:   Fri, 1 Feb 2019 14:48:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [PATCH] crypto: caam - add support for cmac(aes)
Message-ID: <20190201064838.j7ch5rbgvrdq4qbr@gondor.apana.org.au>
References: <20190121132242.22928-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190121132242.22928-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 21, 2019 at 03:22:42PM +0200, Horia Geantă wrote:
> From: Iuliana Prodan <iuliana.prodan@nxp.com>
> 
> Add cmac(aes) keyed hash offloading support.
> 
> Similar to xcbc implementation, driver must make sure there are still
> some bytes buffered when ahash_final() is called. This way HW is able to
> decide whether padding is needed and which key to derive (L -> K1 / K2)
> for the last block.
> 
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/caamhash.c      | 132 ++++++++++++++++++++++++++++++------
>  drivers/crypto/caam/caamhash_desc.c |  30 +++++---
>  drivers/crypto/caam/caamhash_desc.h |  10 ++-
>  3 files changed, 139 insertions(+), 33 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
