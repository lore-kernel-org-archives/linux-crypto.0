Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B33C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 07:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiGUHBv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 03:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiGUHBu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 03:01:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC635E31B;
        Thu, 21 Jul 2022 00:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF7661DD3;
        Thu, 21 Jul 2022 07:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91EDC341C0;
        Thu, 21 Jul 2022 07:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658386909;
        bh=MAspyQp3n48KTHYue6ZJclP816GANSXvE+GOJ/o+oNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OgO8+HzAjHYgiL5UtRlc2ogdvHeuubM1hj6c2bcalX009098UEdkSrXM88soDmvKF
         PKTSqGQeZoGxEZ50WLBD3/WEqfTO8+bVL9tRGs/1Doq6dPPxId6nUACgxy0dLjFVXu
         Vz0oX1Y1yZyWl+GHHZIQRyPx012RxtmHnuwJrGaoi0MjOnoHhQIyIc9shieGmdOniY
         mJPd5K3ufXAgBFyPxN8265BfhWlNcQ4AxMH7iLgjc+6x7MzNre3zjaFa/DS1Q8CETg
         AuwPBnW3oYJDfD/YwE/HwbnpirD4NQA7FFJeXMRcHPfFtZ6zMTi49Hk2xkImyJmLYO
         xZENHOLcFPgBw==
Date:   Thu, 21 Jul 2022 00:01:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 3/3] crypto: lib - move crypto_simd_disabled_for_test
 into utils
Message-ID: <Ytj5244/eVaDZ7Bz@sol.localdomain>
References: <20220716062920.210381-1-ebiggers@kernel.org>
 <20220716062920.210381-4-ebiggers@kernel.org>
 <YtMEFyH8WyPS/vJB@zx2c4.com>
 <YtY0T4qASnYOIjIW@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtY0T4qASnYOIjIW@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 18, 2022 at 09:34:23PM -0700, Eric Biggers wrote:
> On Sat, Jul 16, 2022 at 08:32:55PM +0200, Jason A. Donenfeld wrote:
> > Hi Eric,
> > 
> > On Fri, Jul 15, 2022 at 11:29:20PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Move the definition of crypto_simd_disabled_for_test into
> > > lib/crypto/utils.c so that it can be accessed by library code.
> > > 
> > > This is needed when code that is shared between a traditional crypto API
> > > implementation and a library implementation is built-in, but
> > > CRYPTO_ALGAPI=m.  The x86 blake2s previously was an example of this
> > > (https://lore.kernel.org/linux-crypto/20220517033630.1182-1-gaochao49@huawei.com/T/#u).
> > > Although that case was resolved by removing the blake2s shash support,
> > > this problem could easily come back in the future, so let's address it.
> > 
> > I'm not sure I see the reason in general for a utility library rather
> > than doing these piecemeal like the rest of lib functions. Why is crypto
> > special here? But in particular to this patch: nothing is actually using
> > crypto_simd_disabled_for_test in lib/crypto, right? So is this
> > necessary?
> 
> Well, this is what Herbert wanted:
> https://lore.kernel.org/r/YtEgzHuuMts0YBCz@gondor.apana.org.au.  It's
> subjective, but for now I think I prefer this approach too, since the utility
> functions are so small and are widely used.  A whole module is overkill for just
> a few lines of code.
> 
> The commit message answers your second and third questions.
> 

Herbert, any thoughts on this?

Note: I forgot to put a MODULE_LICENSE in the new module, so I'll need to resend
this patchset even if there are no other issues.

- Eric
