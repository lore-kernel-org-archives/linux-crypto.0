Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6272EC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 05:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbiA0Fkg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:40:36 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60512 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbiA0Fkg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 00:40:36 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nCxW5-00005x-1B; Thu, 27 Jan 2022 16:40:18 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Jan 2022 16:40:16 +1100
Date:   Thu, 27 Jan 2022 16:40:16 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <YfIwQFAqSW68VQ62@gondor.apana.org.au>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-4-nhuck@google.com>
 <YfIo1pL69+GRsSzp@sol.localdomain>
 <YfIrr8MagPw9scLr@gondor.apana.org.au>
 <YfIvSXgnUMoPglCt@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfIvSXgnUMoPglCt@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 26, 2022 at 09:36:09PM -0800, Eric Biggers wrote:
>
> Well, the single block cipher isn't used just in ->setkey(), but also in
> ->encrypt() and ->decrypt() (not for the bulk of the data, but for 1 block).
> So allowing its implementation to be specified might make sense.

The question is is it performance-critical? Including it as a
parameter would be worthwhile if it is.  But if its cost is dwarfed
by that of the accompanying operations then it might not be worth
the complexity.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
