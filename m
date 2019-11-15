Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B89BC432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 05:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3432E2072B
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 05:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfKOF30 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 00:29:26 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54458 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfKOF30 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 00:29:26 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iVUAb-0003lE-MP; Fri, 15 Nov 2019 13:29:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iVUAY-0006A4-ML; Fri, 15 Nov 2019 13:29:18 +0800
Date:   Fri, 15 Nov 2019 13:29:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-omap@vger.kernel.org, ard.biesheuvel@kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCHv2 09/22] crypto: add timeout to crypto_wait_req
Message-ID: <20191115052918.htafn2sch3a6aizv@gondor.apana.org.au>
References: <20191105140111.20285-1-t-kristo@ti.com>
 <20191105140111.20285-10-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105140111.20285-10-t-kristo@ti.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 05, 2019 at 04:00:58PM +0200, Tero Kristo wrote:
> Currently crypto_wait_req waits indefinitely for an async crypto request
> to complete. This is bad as it can cause for example the crypto test
> manager to hang without any notification as to why it has happened.
> Instead of waiting indefinitely, add a 1 second timeout to the call,
> and provide a warning print if a timeout happens.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
>  include/linux/crypto.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

As we discussed before this patch is not acceptable because it
would cause a use-after-free.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
