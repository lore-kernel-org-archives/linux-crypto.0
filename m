Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21752C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD0C92360D
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbgLQWek (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 17:34:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732113AbgLQWek (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 17:34:40 -0500
Date:   Thu, 17 Dec 2020 14:33:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608244439;
        bh=5M7rj1meNyW9IwwIxUZlzTnOJb4jcvakJ8gveMSjQQA=;
        h=From:To:Subject:References:In-Reply-To:From;
        b=t+uD4tVZRFXWawZeOpgFW5v+YEhufgYEgYc4cktCu0Yd4H+mu4D2vv7oC6opmtGQs
         TxfNXYoC7rtZ9ObjZQwJoXUZ1Shj6bVs69ucJgDT5x+YaIcZjcgmULcoeuVqVEWF8z
         f1bptHF4qjKAICZK+kNT8k6z1qXD/y1izdBn6bYMbbxMbERF3MZkYZT0pacLaRnWrD
         IvrF4QKSHyVNWtaOHQB1wsb3GVWT0z+rRLxNGo1BsbM2l9k/nO0YPg+MfS82r6vAnQ
         nyOHaub2pWXPAZiKfe9Cu9rHXSWHrhUA2kGYPuDFHLvnn0VGoxaP76F2Yv5Cunq7wZ
         uFmlzQ21ufPMg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     dsterba@suse.cz, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH 3/5] crypto: blake2b - export helpers for optimized
 implementations
Message-ID: <X9vc1dhBb3vC6PBS@sol.localdomain>
References: <20201215234708.105527-1-ebiggers@kernel.org>
 <20201215234708.105527-4-ebiggers@kernel.org>
 <20201217171540.GU6430@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217171540.GU6430@suse.cz>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 06:15:40PM +0100, David Sterba wrote:
> On Tue, Dec 15, 2020 at 03:47:06PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > In preparation for adding architecture-specific implementations of
> > BLAKE2b, create a header <crypto/blake2b.h> that contains common
> > constants, structs, and helper functions for BLAKE2b.
> > 
> > Furthermore, export the BLAKE2b generic setkey(), init(), update(), and
> > final() functions, and add functions __crypto_blake2b_update() and
> > __crypto_blake2b_final() which take a pointer to a
> > blake2b_compress_blocks_t function.
> > 
> > This way, optimized implementations of BLAKE2b only have to provide an
> > implementation of blake2b_compress_blocks_t.  (This is modeled on how
> > the nhpoly1305 implementations work.  Also, the prototype of
> > blake2b_compress_blocks_t is meant to be similar to that of
> > blake2s_compress_arch().)
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

I ended up making some changes to this patch in v2, to keep things consistent
with what I decided to do for BLAKE2s, so I didn't add your Reviewed-by to this
patch.  If you could review the new version too that would be great -- thanks!

- Eric
