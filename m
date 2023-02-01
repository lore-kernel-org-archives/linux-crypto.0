Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4B9C38142
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 09:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjBAJuO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 04:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjBAJuN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 04:50:13 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC52474EF
        for <linux-crypto@vger.kernel.org>; Wed,  1 Feb 2023 01:50:09 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pN9kl-006Jqb-2X; Wed, 01 Feb 2023 17:50:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Feb 2023 17:50:07 +0800
Date:   Wed, 1 Feb 2023 17:50:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: arm64/aes-ccm - Rewrite skcipher walker loop
Message-ID: <Y9o1zy10V4Yyoi+/@gondor.apana.org.au>
References: <Y9eGyzZ+JAqRQvtm@gondor.apana.org.au>
 <b83ca139-1e8c-60f3-939f-15f727710c36@linux.alibaba.com>
 <Y9opEyTFKXAVjk/D@gondor.apana.org.au>
 <477c73bd-b56e-3c63-1ad6-6a2a08af42af@linux.alibaba.com>
 <Y9ovNyYP03rUBPlq@gondor.apana.org.au>
 <7fdf700c-6747-fa58-ee7a-2cca6397fa05@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fdf700c-6747-fa58-ee7a-2cca6397fa05@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 01, 2023 at 05:43:00PM +0800, Tianjia Zhang wrote:
>
> It seems that only need to fix the loop condition, so if change the
> loop condition of the code just now to
> while (walk.nbytes && walk.nbytes != walk.total), in this way, the
> last chunk cryption is separated out of the loop, which will be clearer
> logically. What is your opinion?

Yes that should work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
