Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0EDC10F03
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7D01217D7
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfDYHu7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:50:59 -0400
Received: from [5.180.42.13] ([5.180.42.13]:52378 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfDYHu6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 03:50:58 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hJZ9f-0002Iv-FP; Thu, 25 Apr 2019 15:50:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hJZ9b-00026F-9D; Thu, 25 Apr 2019 15:50:47 +0800
Date:   Thu, 25 Apr 2019 15:50:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, maxime.ripard@bootlin.com, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 0/4] crypto: sun4i-ss: Fix problem reported by
 CONFIG_CRYPTO_EXTRA_TESTS
Message-ID: <20190425075047.2jhb222vkkf25qr4@gondor.apana.org.au>
References: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 18, 2019 at 10:17:31AM +0200, Corentin Labbe wrote:
> Hello
> 
> Loading sun4i-ss with CONFIG_CRYPTO_EXTRA_TESTS, lead to hung tasks.
> This patchset fix the two deadlock (one in hash, one in cipher) found.
> This patchset fix also some invalid IV handling found while debugging
> thoses issues.
> 
> Regards
> 
> Corentin Labbe (4):
>   crypto: sun4i-ss: Handle better absence/presence of IV
>   crypto: sun4i-ss: remove ivsize from ECB
>   crypto: sun4i-ss: Fix invalid calculation of hash end
>   crypto: sun4i-ss: fallback when length is not multiple of blocksize
> 
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 67 ++++++++++++++++++-----
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 19 ++++---
>  drivers/crypto/sunxi-ss/sun4i-ss-hash.c   |  5 +-
>  drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +
>  4 files changed, 71 insertions(+), 22 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
