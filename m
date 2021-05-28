Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B26C47087
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 07:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6FD61378
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 07:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhE1H0u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 03:26:50 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50194 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234347AbhE1H0q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 03:26:46 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lmWrj-0003Y5-VJ; Fri, 28 May 2021 15:25:07 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lmWrj-0001wd-ER; Fri, 28 May 2021 15:25:07 +0800
Date:   Fri, 28 May 2021 15:25:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] crypto: Fix spelling mistakes in header files
Message-ID: <20210528072507.GC7392@gondor.apana.org.au>
References: <20210517110234.7416-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517110234.7416-1-thunder.leizhen@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 17, 2021 at 07:02:34PM +0800, Zhen Lei wrote:
> Fix some spelling mistakes in comments:
> cipherntext ==> ciphertext
> syncronise ==> synchronise
> feeded ==> fed
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  include/crypto/aead.h   | 2 +-
>  include/crypto/engine.h | 2 +-
>  include/crypto/hash.h   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
