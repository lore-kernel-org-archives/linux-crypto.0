From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: Re: [PATCH resend 4.9] hw_random: Don't use a stack buffer in
 add_early_randomness()
Date: Sat, 4 Feb 2017 18:32:46 +0800
Message-ID: <8b98b1e0-2161-6c58-573c-613940e0f31e@huawei.com>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
 <b0545f55-3b3c-35af-c9f6-bc63cf169d2d@huawei.com>
 <20170204043416.GA7458@hydra.tuxags.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Jens Axboe" <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170204043416.GA7458@hydra.tuxags.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

hi, Matt,
Thanks for your reply.

On 2017/2/4 12:34, Matt Mullins wrote:
> On Sat, Feb 04, 2017 at 11:47:38AM +0800, Yisheng Xie wrote:
>> On 2016/10/18 1:06, Andy Lutomirski wrote:
>>> hw_random carefully avoids using a stack buffer except in
>>> add_early_randomness().  This causes a crash in virtio_rng if
>>> CONFIG_VMAP_STACK=y.
>> I try to understand this patch, but I do not know why it will cause
>> a crash in virtio_rng with CONFIG_VMAP_STACK=y?
>> Could you please give me more info. about it.
> 
> My original report was
> https://lkml.kernel.org/r/20161016002151.GA18235@hydra.tuxags.com.
> 
> The virtio ring APIs use scatterlists to keep track of the buffers, and
> scatterlist requires addresses to be in the kernel direct-mapped address range.
> This is not the case for vmalloc()ed addresses, such as the original on-stack
> "bytes" array when VMAP_STACK=y.
> 
I see, and will check the logic to get more detail about it.

Thanks.
Yisheng Xie
