Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5686BC433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A3AA2242A
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgLaS5X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:57:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgLaS5X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A7BB2222D;
        Thu, 31 Dec 2020 18:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609441002;
        bh=m4Z6F5tDzCAGTCgtCpjXf8f+t1/QmaLDe9n5eJDv7Zo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tpeOul22nVU9oRSd3jS2TFOjJggsJXaTM+BaQl2LeVIvp8vtSYIeI3TP2nNJ7KOqy
         nkGW8MjDxCalXnCrLfsYa4a2JGN2aqHitlUft+j+5oKwqbu46atJVGietCuQ0Mf40X
         9CD7hkPt/BpcXSdQL/tWVGnYubibaTeBZliViZhfreZvdzHhrK9oaPTThZlRSml8FP
         bHChCWVClQf58Nn/xCqDlUKE23aysx/YM74ZefQfSEosGiczl0Yzgz7MtwwjaGE/z7
         4HPPtnBNAjgwvblr5HNKnZvEpjjwRXxD5U06VOxuUk2td/oCKfXhJ5qUfYPoR36b/k
         sgFXfvb+14ctw==
Date:   Thu, 31 Dec 2020 10:56:40 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 14/21] crypto: x86 - add some helper macros for ECB and
 CBC modes
Message-ID: <X+4e6CAKgqe0Doo6@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-15-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-15-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:30PM +0100, Ard Biesheuvel wrote:
> The x86 glue helper module has started to show its age:
> - It relies heavily on function pointers to invoke asm helper functions that
>   operate on fixed input sizes that are relatively small. This means the
>   performance is severely impacted by retpolines.
> - It goes to great lengths to amortize the cost of kernel_fpu_begin()/end()
>   over as much work as possible, which is no longer necessary now that FPU
>   save/restore is done lazily, and doing so may cause unbounded scheduling
>   blackouts due to the fact that enabling the FPU in kernel mode disables
>   preemption.
> - The CBC mode decryption helper makes backward strides through the input, in
>   order to avoid a single block size memcpy() between chunks. Consuming the
>   input in this manner is highly likely to defeat any hardware prefetchers,
>   so it is better to go through the data linearly, and perform the extra
>   memcpy() where needed (which is turned into direct loads and stores by the
>   compiler anyway). Note that benchmarks won't show this effect, given that
>   the memory they use is always cache hot.
> 
> GCC does not seem to be smart enough to elide the indirect calls when the
> function pointers are passed as arguments to static inline helper routines
> modeled after the existing ones. So instead, let's create some CPP macros
> that encapsulate the core of the ECB and CBC processing, so we can wire
> them up for existing users of the glue helper module, i.e., Camellia,
> Serpent, Twofish and CAST6.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/ecb_cbc_helpers.h | 71 ++++++++++++++++++++
>  1 file changed, 71 insertions(+)

Acked-by: Eric Biggers <ebiggers@google.com>
