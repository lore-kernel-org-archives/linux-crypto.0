From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v3 0/8] hwrng: amd: rework of the amd hwrng driver
Date: Sat, 27 Aug 2016 14:49:58 +0000
Message-ID: <20160827144958.GL10637@io.lakedaemon.net>
References: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Corentin,

On Fri, Aug 26, 2016 at 01:11:28PM +0200, LABBE Corentin wrote:
> Changes since v2:
>  - split the latest patch in 4
> Changes since v1:
>  - Keep the hwrng name as "amd"
> 
> LABBE Corentin (8):
>   hwrng: amd: Fix style problem with blank line
>   hwrng: amd: use the BIT macro
>   hwrng: amd: Be consitent with the driver name
>   hwrng: amd: Remove asm/io.h
>   hwrng: amd: release_region must be called after hwrng_unregister
>   hwrng: amd: Replace global variable with private struct
>   hwrng: amd: Access hardware via ioread32/iowrite32
>   hwrng: amd: Convert to new hwrng read() API
> 
>  drivers/char/hw_random/amd-rng.c | 150 +++++++++++++++++++++++++--------------
>  1 file changed, 96 insertions(+), 54 deletions(-)

Once you've fixed up the casting in #6, you can add my

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

to the series.

thx,

Jason.
