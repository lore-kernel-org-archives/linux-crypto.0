From: Matt Mullins <mmullins@mmlx.us>
Subject: Re: [PATCH resend 4.9] hw_random: Don't use a stack buffer in
 add_early_randomness()
Date: Fri, 3 Feb 2017 20:34:16 -0800
Message-ID: <20170204043416.GA7458@hydra.tuxags.com>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
 <b0545f55-3b3c-35af-c9f6-bc63cf169d2d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
To: Yisheng Xie <xieyisheng1@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hydra.tuxags.com ([64.13.172.54]:47593 "EHLO mail.tuxags.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753539AbdBDEm7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 23:42:59 -0500
Content-Disposition: inline
In-Reply-To: <b0545f55-3b3c-35af-c9f6-bc63cf169d2d@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 04, 2017 at 11:47:38AM +0800, Yisheng Xie wrote:
> On 2016/10/18 1:06, Andy Lutomirski wrote:
> > hw_random carefully avoids using a stack buffer except in
> > add_early_randomness().  This causes a crash in virtio_rng if
> > CONFIG_VMAP_STACK=y.
> I try to understand this patch, but I do not know why it will cause
> a crash in virtio_rng with CONFIG_VMAP_STACK=y?
> Could you please give me more info. about it.

My original report was
https://lkml.kernel.org/r/20161016002151.GA18235@hydra.tuxags.com.

The virtio ring APIs use scatterlists to keep track of the buffers, and
scatterlist requires addresses to be in the kernel direct-mapped address range.
This is not the case for vmalloc()ed addresses, such as the original on-stack
"bytes" array when VMAP_STACK=y.
