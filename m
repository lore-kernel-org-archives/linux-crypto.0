From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 5/6] crypto: aesni-intel - Add bulk request support
Date: Thu, 12 Jan 2017 19:19:33 -0800
Message-ID: <20170113031933.GA4956@zzz>
References: <cover.1484215956.git.omosnacek@gmail.com>
 <c32a28630157c619ac2a7c851be586e72f193c68.1484215956.git.omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33513 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdAMDTg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 22:19:36 -0500
Received: by mail-pf0-f196.google.com with SMTP id 127so6153801pfg.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 19:19:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <c32a28630157c619ac2a7c851be586e72f193c68.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 01:59:57PM +0100, Ondrej Mosnacek wrote:
> This patch implements bulk request handling in the AES-NI crypto drivers.
> The major advantage of this is that with bulk requests, the kernel_fpu_*
> functions (which are usually quite slow) are now called only once for the whole
> request.
> 

Hi Ondrej,

To what extent does the performance benefit of this patchset result from just
the reduced numbers of calls to kernel_fpu_begin() and kernel_fpu_end()?

If it's most of the benefit, would it make any sense to optimize
kernel_fpu_begin() and kernel_fpu_end() instead?

And if there are other examples besides kernel_fpu_begin/kernel_fpu_end where
the bulk API would provide a significant performance boost, can you mention
them?

Interestingly, the arm64 equivalent to kernel_fpu_begin()
(kernel_neon_begin_partial() in arch/arm64/kernel/fpsimd.c) appears to have an
optimization where the SIMD registers aren't saved if they were already saved.
I wonder why something similar isn't done on x86.

Eric
