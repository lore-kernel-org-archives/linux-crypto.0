Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45930C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jan 2022 21:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiANV5O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiANV5O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jan 2022 16:57:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAC6C061574
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jan 2022 13:57:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 894DCB825F5
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jan 2022 21:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD95C36AE9;
        Fri, 14 Jan 2022 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642197431;
        bh=yEo0mmMULFRXxQI8RUkCALnbTQ5TKNz4Ym4YOjTA2dQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E7ANNwnqgb28CgGtd9O8RjaAAPLYuf+cTx1h6M79QVUYUCz9BdA2COQVkEZTEDdJq
         +WoyqEliwMS1HBrIL4DKVK6laZeRs5oKhRthq8niAEDmvQ+xFlvQcEOPQXogdLvel6
         pEESfgWBbGyFR6jWQWgrmCfRiEFPMFyXbs9behp3F3upxczuQ9D0wH9uTQ4cMndu4b
         oxmcG+LTLETxZl+cdW4YMntw+TEvPmfF1RMQgTjhqec6h0xReDUffiW3YV1p+UBIox
         G3+BHEPuRUQDblv3PYUpDpK5ksPcIlztuT4LhGPbV6NRJPU+iUNDqIZB1vogeJuVZL
         S5ArxRovOEJvw==
Date:   Fri, 14 Jan 2022 13:57:09 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: testmgr - Move crypto_simd_disabled_for_test
 out
Message-ID: <YeHxta9jqIoQ4pIo@sol.localdomain>
References: <Yd0jA4VOjysrdOu7@gondor.apana.org.au>
 <Yd36HsgI+ya6P7RF@gmail.com>
 <Yd4nmLgFr8XTxCo6@gondor.apana.org.au>
 <YeEa3qCB7b4QzBH9@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeEa3qCB7b4QzBH9@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 14, 2022 at 05:40:30PM +1100, Herbert Xu wrote:
> On Wed, Jan 12, 2022 at 11:58:00AM +1100, Herbert Xu wrote:
> > On Tue, Jan 11, 2022 at 01:43:58PM -0800, Eric Biggers wrote:
> > >
> > > Maybe CRYPTO_MANAGER_EXTRA_TESTS should select CRYPTO_SIMD?
> > 
> > You're right.  I was focusing only on the module dependencies
> > but neglected to change the Kconfig dependencies.
> > 
> > I'll fix this in the next version.
> 
> ---8<---
> As testmgr is part of cryptomgr which was designed to be unloadable
> as a module, it shouldn't export any symbols for other crypto
> modules to use as that would prevent it from being unloaded.  All
> its functionality is meant to be accessed through notifiers.
> 
> The symbol crypto_simd_disabled_for_test was added to testmgr
> which caused it to be pinned as a module if its users were also
> loaded.  This patch moves it out of testmgr and into crypto/algapi.c
> so cryptomgr can again be unloaded and replaced on demand.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
