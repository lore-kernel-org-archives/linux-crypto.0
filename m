Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949ABC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 05:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbiA0FVH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:21:07 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60510 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbiA0FVH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 00:21:07 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nCxDE-0008DU-49; Thu, 27 Jan 2022 16:20:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Jan 2022 16:20:48 +1100
Date:   Thu, 27 Jan 2022 16:20:47 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <YfIrr8MagPw9scLr@gondor.apana.org.au>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-4-nhuck@google.com>
 <YfIo1pL69+GRsSzp@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfIo1pL69+GRsSzp@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 26, 2022 at 09:08:38PM -0800, Eric Biggers wrote:
>
> The optional parameters mentioned in the comment above don't appear to be
> implemented.  Also, the syntax described is ambiguous.  I think you meant for
> there to be only one set of square brackets?
> 
> xctr(blockcipher_name) should be xctr_name, since it would have to be a driver /
> implementation name, and those don't necessarily include parentheses like the
> algorithm names do.
> 
> Did you consider not allowing the single block cipher implementation to be
> overridden?  The single block cipher is a minor part compared to xctr.  This
> would simplify the "full" syntax slighty, as then it would be
> "hctr2(xctr_name, polyval_name)" instead of
> "hctr2(blockcipher_name, xctr_name, polyval_name)".
> 
> I suppose it does make sense to take the single block cipher parameter, given
> that it is used.  But you'll need to make sure to make hctr2_create() enforce
> that the same block cipher is used in both parameters.

For the single block cipher parameter, another option is to derive
it from the xctr_name.  That is, once you have the skcipher for
xctr_name, you extract its cra_name, assuming that it must be of
the form xctr(%s) then you just strip away the xctr() and get the
single block cipher name that way.

The purpose of having the parameter explicitly is so that the
instantiatied algorithm is automatically torn down when the
underlying algorithm is replaced with a better version.

This is in general unnecessary if you're simply using the
single block cipher to generate setup material.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
