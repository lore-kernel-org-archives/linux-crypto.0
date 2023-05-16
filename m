Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3CCC77B75
	for <linux-crypto@archiver.kernel.org>; Tue, 16 May 2023 05:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjEPFwY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 May 2023 01:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjEPFwX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2023 01:52:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6794740E1;
        Mon, 15 May 2023 22:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 041ED62E86;
        Tue, 16 May 2023 05:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A649C433EF;
        Tue, 16 May 2023 05:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684216341;
        bh=UnnfSoH2Sog9IytTw4FHR+TpDmR01YMPhEE6qSYNrPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qRgroj2v2j30UkZE/IdvIx7y4qOvg4zGQutz4YlyomWWWtOTD+9jg5OLkKW4gBsdz
         8CRaQByqbQQTsxSioc5ywuaDeXO+biQAPqJRokKoz3Lb44gykAM0l6f2N+ktTCpGB/
         u1314ylalzvx9n1XCWv/pTrS9n81y0t/77U9nCIdo1t6zW1RJNP4UVe1S2sX+4U5Sb
         JhrNTsreJV+HSjMwX2wG0++uPNyteN9Qqd+JL76R8EzSD4ko4DPyJbC70qgdFT5Y+R
         hfgcxoERDQ5C5w1mbqD7jzGl+2POjJh4nB+f2lJaMbNk8+SKD+nzL5jw0FhWlJFzdB
         qn2WrrvkGakxg==
Date:   Mon, 15 May 2023 22:52:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     FUJITA Tomonori <tomo@exabit.dev>
Cc:     rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: Re: [PATCH 1/2] rust: add synchronous message digest support
Message-ID: <20230516055219.GC2704@sol.localdomain>
References: <20230515043353.2324288-1-tomo@exabit.dev>
 <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Fujita,

On Mon, May 15, 2023 at 04:34:27AM +0000, FUJITA Tomonori wrote:
> diff --git a/rust/helpers.c b/rust/helpers.c
> index 81e80261d597..03c131b1ca38 100644
> --- a/rust/helpers.c
> +++ b/rust/helpers.c
> @@ -18,6 +18,7 @@
>   * accidentally exposed.
>   */
>  
> +#include <crypto/hash.h>
>  #include <linux/bug.h>
>  #include <linux/build_bug.h>
>  #include <linux/err.h>
> @@ -27,6 +28,29 @@
>  #include <linux/sched/signal.h>
>  #include <linux/wait.h>
>  
> +void rust_helper_crypto_free_shash(struct crypto_shash *tfm)
> +{
> +	crypto_free_shash(tfm);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_crypto_free_shash);

Shouldn't this code be compiled only when the crypto API is available?

> +impl<'a> ShashDesc<'a> {
> +    /// Creates a [`ShashDesc`] object for a request data structure for message digest.
> +    pub fn new(tfm: &'a Shash) -> Result<Self> {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        let size = core::mem::size_of::<bindings::shash_desc>()
> +            + unsafe { bindings::crypto_shash_descsize(tfm.0) } as usize;
> +        let layout = Layout::from_size_align(size, 2)?;
> +        let ptr = unsafe { alloc(layout) } as *mut bindings::shash_desc;
> +        let mut desc = ShashDesc { ptr, tfm, size };
> +        // SAFETY: The `desc.tfm` is non-null and valid for the lifetime of this object.
> +        unsafe { (*desc.ptr).tfm = desc.tfm.0 };
> +        Ok(desc)
> +    }
> +
> +    /// (Re)initializes message digest.
> +    pub fn init(&mut self) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe { bindings::crypto_shash_init(self.ptr) })
> +    }
> +
> +    /// Adds data to message digest for processing.
> +    pub fn update(&mut self, data: &[u8]) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe {
> +            bindings::crypto_shash_update(self.ptr, data.as_ptr(), data.len() as u32)
> +        })
> +    }
> +
> +    /// Calculates message digest.
> +    pub fn finalize(&mut self, output: &mut [u8]) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is valid.
> +        to_result(unsafe { bindings::crypto_shash_final(self.ptr, output.as_mut_ptr()) })
> +    }

This doesn't enforce that init() is called before update() or finalize().  I
think that needs to be checked in the Rust code, since the C code doesn't have
defined behavior in that case.

- Eric
