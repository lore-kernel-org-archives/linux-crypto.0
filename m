Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523EEC61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 08:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBPIJK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 03:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBPIJJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 03:09:09 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC542366B
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 00:09:06 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSZK9-00BtTd-Ta; Thu, 16 Feb 2023 16:09:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 16:09:01 +0800
Date:   Thu, 16 Feb 2023 16:09:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 4/10] crypto: hash - Count error stats differently
Message-ID: <Y+3knSW48uF2vmfV@gondor.apana.org.au>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2L-00BVkw-GI@formenos.hmeau.com>
 <Y+3GIaoMR+2mzAmi@sol.localdomain>
 <Y+3G8H5zWGd8cbqT@gondor.apana.org.au>
 <Y+3JwjG4nMjfFhHg@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+3JwjG4nMjfFhHg@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 10:14:26PM -0800, Eric Biggers wrote:
>
> This is the backtrace.  kconfig is attached.

Thanks for the info.  My test tree wasn't clean so I didn't
actually test the whole thing properly.  The issue is the extra
!statesize test that I added to shash and obviously it's wrong
for crypto_null.

I'll back that change out.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
