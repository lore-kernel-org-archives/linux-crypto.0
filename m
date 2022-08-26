Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FB5ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 04:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiHZExE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 00:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiHZExE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 00:53:04 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433FECE469;
        Thu, 25 Aug 2022 21:53:03 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oRRKw-00FJ0j-2d; Fri, 26 Aug 2022 14:52:55 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Aug 2022 12:52:54 +0800
Date:   Fri, 26 Aug 2022 12:52:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Jason A . Donenfeld " <Jason@zx2c4.com>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 2/3] crypto: lib - move __crypto_xor into utils
Message-ID: <YwhRpUcbqs1GGGU6@gondor.apana.org.au>
References: <20220725183636.97326-1-ebiggers@kernel.org>
 <20220725183636.97326-3-ebiggers@kernel.org>
 <YwhPtnL6yVG0K2Lo@sol.localdomain>
 <YwhQIRVc60u4B9Bs@gondor.apana.org.au>
 <YwhQmcgPpe2fpx86@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwhQmcgPpe2fpx86@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 25, 2022 at 09:48:25PM -0700, Eric Biggers wrote:
>
> The one I'm commenting on (patch 2 of 3).  But patch 1 is needed as a
> prerequisite.

Oh so it's just dropping the select? Can you please send me a
separate patch for the crypto tree with a Fixes header? I'll
deal with the merge conflict.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
