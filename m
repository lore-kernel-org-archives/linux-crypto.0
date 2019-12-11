Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB80C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67ED3214D8
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfLKJbf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:31:35 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:53604 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfLKJbf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 04:31:35 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ieyL9-0008HU-OZ; Wed, 11 Dec 2019 17:31:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ieyL5-0006jO-HF; Wed, 11 Dec 2019 17:31:23 +0800
Date:   Wed, 11 Dec 2019 17:31:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     antoine.tenart@bootlin.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: inside-secure: Use PTR_ERR_OR_ZERO() to
 simplify code
Message-ID: <20191211093123.ppwhycxzdvssgp6a@gondor.apana.org.au>
References: <1574074436-32134-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574074436-32134-1-git-send-email-zhengbin13@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 18, 2019 at 06:53:56PM +0800, zhengbin wrote:
> Fixes coccicheck warning:
> 
> drivers/crypto/inside-secure/safexcel_cipher.c:2534:1-3: WARNING: PTR_ERR_OR_ZERO can be used
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
