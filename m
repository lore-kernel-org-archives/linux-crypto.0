Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5A8C2D0C5
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DC66214D8
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 09:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfLKJjA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 04:39:00 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54414 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfLKJi7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 04:38:59 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ieySN-00008V-7g; Wed, 11 Dec 2019 17:38:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ieySL-0005dj-0a; Wed, 11 Dec 2019 17:38:53 +0800
Date:   Wed, 11 Dec 2019 17:38:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] crypto: ccree: fixes
Message-ID: <20191211093852.h47k5gk3lnclgmip@gondor.apana.org.au>
References: <20191127084909.14472-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127084909.14472-1-gilad@benyossef.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 27, 2019 at 10:49:04AM +0200, Gilad Ben-Yossef wrote:
> Assorted fixes for the ccree driver
> 
> Gilad Ben-Yossef (2):
>   crypto: ccree: remove useless define
>   crypto: ccree: fix backlog memory leak
> 
> Hadar Gat (2):
>   crypto: ccree: fix typos in comments
>   crypto: ccree: fix typos in error msgs
> 
>  drivers/crypto/ccree/cc_driver.c      |  8 ++++----
>  drivers/crypto/ccree/cc_driver.h      |  1 -
>  drivers/crypto/ccree/cc_fips.c        |  2 +-
>  drivers/crypto/ccree/cc_hash.c        |  2 --
>  drivers/crypto/ccree/cc_pm.c          |  2 +-
>  drivers/crypto/ccree/cc_request_mgr.c | 13 +++++++------
>  6 files changed, 13 insertions(+), 15 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
