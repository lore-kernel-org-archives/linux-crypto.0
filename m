From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: Re: [PATCH resend 4.9] hw_random: Don't use a stack buffer in
 add_early_randomness()
Date: Sat, 4 Feb 2017 11:47:38 +0800
Message-ID: <b0545f55-3b3c-35af-c9f6-bc63cf169d2d@huawei.com>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
To: Andy Lutomirski <luto@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:33213 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753413AbdBDDr6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 22:47:58 -0500
In-Reply-To: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Andy,

On 2016/10/18 1:06, Andy Lutomirski wrote:
> hw_random carefully avoids using a stack buffer except in
> add_early_randomness().  This causes a crash in virtio_rng if
> CONFIG_VMAP_STACK=y.
I try to understand this patch, but I do not know why it will cause
a crash in virtio_rng with CONFIG_VMAP_STACK=y?
Could you please give me more info. about it.

Really thanks for that!
Yisheng Xie.

> 
> Reported-by: Matt Mullins <mmullins@mmlx.us>
> Tested-by: Matt Mullins <mmullins@mmlx.us>
> Fixes: d3cc7996473a ("hwrng: fetch randomness only after device init")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
> 
> This fixes a crash in 4.9-rc1.
> 
> resending because I typoed the git send-email command.  I stealthily added
> Matt's Tested-by, too.
> 
>  drivers/char/hw_random/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 9203f2d130c0..340f96e44642 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -84,14 +84,14 @@ static size_t rng_buffer_size(void)
>  
>  static void add_early_randomness(struct hwrng *rng)
>  {
> -	unsigned char bytes[16];
>  	int bytes_read;
> +	size_t size = min_t(size_t, 16, rng_buffer_size());
>  
>  	mutex_lock(&reading_mutex);
> -	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> +	bytes_read = rng_get_data(rng, rng_buffer, size, 1);
>  	mutex_unlock(&reading_mutex);
>  	if (bytes_read > 0)
> -		add_device_randomness(bytes, bytes_read);
> +		add_device_randomness(rng_buffer, bytes_read);
>  }
>  
>  static inline void cleanup_rng(struct kref *kref)
> 
