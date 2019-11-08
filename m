Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AB8C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE794215EA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfKHPLh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 10:11:37 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57724 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbfKHPLg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 10:11:36 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iT5v7-00072y-Ff; Fri, 08 Nov 2019 23:11:29 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iT5v5-000743-RB; Fri, 08 Nov 2019 23:11:27 +0800
Date:   Fri, 8 Nov 2019 23:11:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Colin King <colin.king@canonical.com>
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] crypto: amlogic: ensure error variable err is set
 before returning it
Message-ID: <20191108151127.uysbqg2yt2ovscfa@gondor.apana.org.au>
References: <20191029113230.7050-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029113230.7050-1-colin.king@canonical.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 29, 2019 at 11:32:30AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently when the call to crypto_engine_alloc_init fails the error
> return path returns an uninitialized value in the variable err. Fix
> this by setting err to -ENOMEM.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
