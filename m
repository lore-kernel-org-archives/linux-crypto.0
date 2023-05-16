Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600C3C77B7A
	for <linux-crypto@archiver.kernel.org>; Tue, 16 May 2023 08:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjEPIbS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 May 2023 04:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjEPIbR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2023 04:31:17 -0400
X-Greylist: delayed 355 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 May 2023 01:31:15 PDT
Received: from a27-22.smtp-out.us-west-2.amazonses.com (a27-22.smtp-out.us-west-2.amazonses.com [54.240.27.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A5B188;
        Tue, 16 May 2023 01:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684225520;
        h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding;
        bh=GScpAXv+J3eSM6qFgW9uds9TDleKdfcZkU54I1b2MRI=;
        b=Y8G2vfQC3vwxxj6j4GwDb2AvnBwuAhbIXYMXBUinIRvi7RDzmhp6LNLO6fKYRJkD
        lvnoSRy++FdjiK7WmboaZz3KIsmmtHCcFkWQMb6gR81gguLjzvEDRPh3Rd/QWJ3oryD
        vqffG4sn6O0C6WCw4NTLqVMeUx7b/yAZKYsz7Jel9MHxCLB7IJfxZDJt849xpt3O+xR
        lnZQ/Kp9wVfLkhqgV529PZunpOf9qjaZCKZ+CAgvOQ2giF0uxsIHHxzlWOQxzwA068N
        uLfRH4mFBP6AX9AczUeYTIddfcTIgiezZoB6DDAFFiDSN3SO7j6NNOCIhDVZaYkVMpR
        4O6peZXobA==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684225520;
        h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=GScpAXv+J3eSM6qFgW9uds9TDleKdfcZkU54I1b2MRI=;
        b=QF1W1RKbg7VbNHjsIPVKDaZMjOrcbd3oJrHgEXH9XligsGLyX3vbv0MOgV9r9TWa
        vqFQqnM9GxCrLUobdPlSNl58NYltNrjnktWYlOUxHNGb7f63IGABFnRtFC0K1eKwtIU
        OCqiiGYtzeMH8NkHxfFNiqFHaDIC8XK+Ieqt3NAc=
Date:   Tue, 16 May 2023 08:25:19 +0000
Message-ID: <0101018823a9f0f2-a4620a25-6974-4464-a7ed-c997e9579243-000000@us-west-2.amazonses.com>
To:     ebiggers@kernel.org
Cc:     tomo@exabit.dev, rust-for-linux@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        fujita.tomonori@gmail.com
Subject: Re: [PATCH 1/2] rust: add synchronous message digest support
From:   FUJITA Tomonori <tomo@exabit.dev>
In-Reply-To: <20230516055219.GC2704@sol.localdomain>
References: <20230515043353.2324288-1-tomo@exabit.dev>
        <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
        <20230516055219.GC2704@sol.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.us-west-2.j0GTvY5MHQQ5Spu+i4ZGzzYI1gDE7m7iuMEacWMZbe8=:AmazonSES
X-SES-Outgoing: 2023.05.16-54.240.27.22
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Mon, 15 May 2023 22:52:19 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

>> +#include <crypto/hash.h>
>>  #include <linux/bug.h>
>>  #include <linux/build_bug.h>
>>  #include <linux/err.h>
>> @@ -27,6 +28,29 @@
>>  #include <linux/sched/signal.h>
>>  #include <linux/wait.h>
>>  
>> +void rust_helper_crypto_free_shash(struct crypto_shash *tfm)
>> +{
>> +	crypto_free_shash(tfm);
>> +}
>> +EXPORT_SYMBOL_GPL(rust_helper_crypto_free_shash);
> 
> Shouldn't this code be compiled only when the crypto API is available?

Oops, I'll add #ifdef CONFIG_CRYPTO


>> +impl<'a> ShashDesc<'a> {
>> +    /// Creates a [`ShashDesc`] object for a request data structure for message digest.
>> +    pub fn new(tfm: &'a Shash) -> Result<Self> {
>> +        // SAFETY: The type invariant guarantees that the pointer is valid.
>> +        let size = core::mem::size_of::<bindings::shash_desc>()
>> +            + unsafe { bindings::crypto_shash_descsize(tfm.0) } as usize;
>> +        let layout = Layout::from_size_align(size, 2)?;
>> +        let ptr = unsafe { alloc(layout) } as *mut bindings::shash_desc;
>> +        let mut desc = ShashDesc { ptr, tfm, size };
>> +        // SAFETY: The `desc.tfm` is non-null and valid for the lifetime of this object.
>> +        unsafe { (*desc.ptr).tfm = desc.tfm.0 };
>> +        Ok(desc)
>> +    }
>> +
>> +    /// (Re)initializes message digest.
>> +    pub fn init(&mut self) -> Result {
>> +        // SAFETY: The type invariant guarantees that the pointer is valid.
>> +        to_result(unsafe { bindings::crypto_shash_init(self.ptr) })
>> +    }
>> +
>> +    /// Adds data to message digest for processing.
>> +    pub fn update(&mut self, data: &[u8]) -> Result {
>> +        // SAFETY: The type invariant guarantees that the pointer is valid.
>> +        to_result(unsafe {
>> +            bindings::crypto_shash_update(self.ptr, data.as_ptr(), data.len() as u32)
>> +        })
>> +    }
>> +
>> +    /// Calculates message digest.
>> +    pub fn finalize(&mut self, output: &mut [u8]) -> Result {
>> +        // SAFETY: The type invariant guarantees that the pointer is valid.
>> +        to_result(unsafe { bindings::crypto_shash_final(self.ptr, output.as_mut_ptr()) })
>> +    }
> 
> This doesn't enforce that init() is called before update() or finalize().  I
> think that needs to be checked in the Rust code, since the C code doesn't have
> defined behavior in that case.

Surely, Rust side should handle the case.

If the new() function internally calls init() before returning, it
works? The new() returns an initialized ShaDesc object.


Thanks for reviewing!
