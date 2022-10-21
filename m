Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98328C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 11:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJULiO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 07:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJULiK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 07:38:10 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DA71867BD
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2022 04:38:09 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1olqL8-004dyB-PF; Fri, 21 Oct 2022 19:38:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Oct 2022 19:38:03 +0800
Date:   Fri, 21 Oct 2022 19:38:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     jianchunfu <jianchunfu@cmss.chinamobile.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: talitos - Use the defined variable to clean code
Message-ID: <Y1KEm6Mw9ulxROLA@gondor.apana.org.au>
References: <20221009095254.2406-1-jianchunfu@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009095254.2406-1-jianchunfu@cmss.chinamobile.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 09, 2022 at 05:52:54PM +0800, jianchunfu wrote:
> Use the defined variable "dev" to make the code cleaner.
> 
> Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
> ---
>  drivers/crypto/talitos.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
