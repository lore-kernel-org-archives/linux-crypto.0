From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v2] crypto/ecc: Remove stack VLA usage
Date: Fri, 9 Mar 2018 10:31:17 +0200
Message-ID: <470bdece-b9a6-17fa-5dec-f4dfec51ef73@microchip.com>
References: <20180308215702.GA9902@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <kernel-hardening@lists.openwall.com>,
        <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308215702.GA9902@beast>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 03/08/2018 11:57 PM, Kees Cook wrote:
> On the quest to remove all VLAs from the kernel[1], this switches to
> a pair of kmalloc regions instead of using the stack. This also moves
> the get_random_bytes() after all allocations (and drops the needless
> "nbytes" variable).
> 
> [1]https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Kees Cook<keescook@chromium.org>

Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
