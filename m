Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED25C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8908F2075C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 11:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfBVLzI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:55:08 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:54788 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfBVLzI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 06:55:08 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gx9Pm-0000Uc-L8; Fri, 22 Feb 2019 19:54:50 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gx9PZ-00078l-4h; Fri, 22 Feb 2019 19:54:37 +0800
Date:   Fri, 22 Feb 2019 19:54:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ofir Drag <ofir.drang@arm.com>, stable@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree: add missing inline qualifier
Message-ID: <20190222115437.3ivxsrqfazy6e3gb@gondor.apana.org.au>
References: <20190211142758.16718-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211142758.16718-1-gilad@benyossef.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 11, 2019 at 04:27:58PM +0200, Gilad Ben-Yossef wrote:
> Commit 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
> was missing a "inline" qualifier for stub function used when CONFIG_PM
> is not set causing a build warning.
> 
> Fixes: 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
> Cc: stable@kernel.org # v4.20
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/crypto/ccree/cc_pm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
