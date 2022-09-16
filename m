Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A967C54EE9
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 09:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiIPJlU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 05:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiIPJlS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 05:41:18 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C035A6C52
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 02:41:17 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oZ7qR-005FNV-9l; Fri, 16 Sep 2022 19:41:12 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Sep 2022 17:41:11 +0800
Date:   Fri, 16 Sep 2022 17:41:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: Re: [PATCH 8/9] crypto: qat - expose deflate through acomp api for
 QAT GEN2
Message-ID: <YyREt8XK7ei0Owq4@gondor.apana.org.au>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
 <20220818180120.63452-9-giovanni.cabiddu@intel.com>
 <YwigYBNM7O/J6gO1@gondor.apana.org.au>
 <YwjW2x/uT9ST8+8i@gcabiddu-mobl1.ger.corp.intel.com>
 <Yw3TpwuF7a46SZDI@gondor.apana.org.au>
 <YyMj9yKMSTC4Iw0s@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyMj9yKMSTC4Iw0s@gcabiddu-mobl1.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 15, 2022 at 02:09:11PM +0100, Giovanni Cabiddu wrote:
>
> > Here's a suggestion.  Start with whatever value you want (e.g.,
> > src * 2), attempt the decompression, if it fails because the
> > space is to small, then double it and retry the operation.
>
> I prototyped the solution you proposed and it introduces complexity,
> still doesn't fully solve the problem and it is not performant. See
> below*.

I don't understand how it can be worse than your existing patch.

I'm suggesting that you start with your current estimate, and only
fallback to allocating a bigger buffer in case that overflows.  So
it should be exactly the same as your current patch as the fallback
path would only activate in cases where your patch would have failed
anyway.

> We propose instead to match the destination buffer size used in scomp
> for the NULL pointer use case, i.e. 128KB:
> https://elixir.bootlin.com/linux/v6.0-rc5/source/include/crypto/internal/scompress.h#L13
> Since the are no users of acomp with this use-case in the kernel, we
> believe this will be sufficient.

Once we start imposing arbitrary limits in the driver, then users
will forever be burdened with this.  So that's why I want to avoid
adding such limits.

The whole point of having this feature in the acomp API is to avoid
having users such as ipcomp preallocate huge buffers for the unlikely
case of an exceptionally large decompressed result.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
