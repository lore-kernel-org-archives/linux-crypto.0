Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B6BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 05:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiA0FpH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:45:07 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60514 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbiA0FpH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 00:45:07 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nCxaS-000076-Da; Thu, 27 Jan 2022 16:44:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Jan 2022 16:44:48 +1100
Date:   Thu, 27 Jan 2022 16:44:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <YfIxUPc1KsSMTMLq@gondor.apana.org.au>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-4-nhuck@google.com>
 <YfIo1pL69+GRsSzp@sol.localdomain>
 <YfIrr8MagPw9scLr@gondor.apana.org.au>
 <YfIvSXgnUMoPglCt@sol.localdomain>
 <YfIwQFAqSW68VQ62@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfIwQFAqSW68VQ62@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 04:40:16PM +1100, Herbert Xu wrote:
>
> The question is is it performance-critical? Including it as a
> parameter would be worthwhile if it is.  But if its cost is dwarfed
> by that of the accompanying operations then it might not be worth
> the complexity.

It looks like this is similar to the situation in XTS where I chose
not to make it a full parameter during the skcipher conversion:

commit f1c131b45410a202eb45cc55980a7a9e4e4b4f40
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Nov 22 20:08:19 2016 +0800

    crypto: xts - Convert to skcipher

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
