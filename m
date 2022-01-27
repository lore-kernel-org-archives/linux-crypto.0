Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E77C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 05:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiA0FgO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiA0FgO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 00:36:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19264C06161C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 21:36:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDB84B8210C
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 05:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573B7C340E4;
        Thu, 27 Jan 2022 05:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643261771;
        bh=SZ9CNXgBetCvzyn6zAdS1K6n9xh2YpDlNEWCHN4BVQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mxddQNlAmsonNyPQGryjHNceG/5khC2uhJtR4D+WVovU+wHdCx0NvJLRhDbwbJNHE
         i1V/HjJmL5UUmRpSyUJGHhLNT6pT8O0sPkiqhGTVzbBvRFxipNXqpMFEX5g5u4VItC
         WjzVxfcv3XNfDcESBlz1xqHvJSsDD0J3tKNCaX5XKR+IqsGkxnfc+kE1CN8F4r0HvW
         8+q1icvCs/RbnRTzlFxX5BaVvTf2pmSu+7d5l9WX3R1QAN+xlmRkNL0mzU7c9YOWEK
         IBG5lQWgXPSzcA79xR7qlzbB1xCIf35TaU94Z4GVQKAqlZTyGW5Rzr3Rq4l7kE5tF/
         FqbN0kIaMSJow==
Date:   Wed, 26 Jan 2022 21:36:09 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <YfIvSXgnUMoPglCt@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-4-nhuck@google.com>
 <YfIo1pL69+GRsSzp@sol.localdomain>
 <YfIrr8MagPw9scLr@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfIrr8MagPw9scLr@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 04:20:47PM +1100, Herbert Xu wrote:
> On Wed, Jan 26, 2022 at 09:08:38PM -0800, Eric Biggers wrote:
> >
> > The optional parameters mentioned in the comment above don't appear to be
> > implemented.  Also, the syntax described is ambiguous.  I think you meant for
> > there to be only one set of square brackets?
> > 
> > xctr(blockcipher_name) should be xctr_name, since it would have to be a driver /
> > implementation name, and those don't necessarily include parentheses like the
> > algorithm names do.
> > 
> > Did you consider not allowing the single block cipher implementation to be
> > overridden?  The single block cipher is a minor part compared to xctr.  This
> > would simplify the "full" syntax slighty, as then it would be
> > "hctr2(xctr_name, polyval_name)" instead of
> > "hctr2(blockcipher_name, xctr_name, polyval_name)".
> > 
> > I suppose it does make sense to take the single block cipher parameter, given
> > that it is used.  But you'll need to make sure to make hctr2_create() enforce
> > that the same block cipher is used in both parameters.
> 
> For the single block cipher parameter, another option is to derive
> it from the xctr_name.  That is, once you have the skcipher for
> xctr_name, you extract its cra_name, assuming that it must be of
> the form xctr(%s) then you just strip away the xctr() and get the
> single block cipher name that way.

That's what I had in mind with "hctr2(xctr_name, polyval_name)".

> 
> The purpose of having the parameter explicitly is so that the
> instantiatied algorithm is automatically torn down when the
> underlying algorithm is replaced with a better version.
> 
> This is in general unnecessary if you're simply using the
> single block cipher to generate setup material.
> 

Well, the single block cipher isn't used just in ->setkey(), but also in
->encrypt() and ->decrypt() (not for the bulk of the data, but for 1 block).
So allowing its implementation to be specified might make sense.

Alternatively the single block cipher could be emulated with xctr which the
template already has, similar to how the cts template only uses cbc, but I think
that would be pretty messy here.

- Eric
