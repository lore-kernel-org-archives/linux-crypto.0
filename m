From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: stm32 - Try to fix hash padding
Date: Sat, 7 Oct 2017 12:20:20 +0800
Message-ID: <20171007042020.GG29803@gondor.apana.org.au>
References: <20170912093553.2580986-1-arnd@arndb.de>
 <20170912093553.2580986-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lionel Debieve <lionel.debieve@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170912093553.2580986-2-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 12, 2017 at 11:35:39AM +0200, Arnd Bergmann wrote:
> gcc warns that the length for the extra unaligned data in the hash
> function may be used unaligned. In theory this could happen if
> we pass a zero-length sg_list, or if sg_is_last() was never true:
> 
> In file included from drivers/crypto/stm32/stm32-hash.c:23:
> drivers/crypto/stm32/stm32-hash.c: In function 'stm32_hash_one_request':
> include/uapi/linux/kernel.h:12:49: error: 'ncp' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>  #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> 
> Neither of these can happen in practice, so the warning is harmless.
> 
> However while trying to suppress the warning, I noticed multiple
> problems with that code:
> 
> - On big-endian kernels, we byte-swap the data like we do for
>   register accesses, however this is a data stream and almost
>   certainly needs to use a single writesl() instead of series
>   of writel() to give the correct hash.
> 
> - If the length is not a multiple of four bytes, we skip the
>   last word entirely, since we write the truncated length
>   using stm32_hash_set_nblw().
> 
> - If we change the code to round the length up rather than
>   down, the last bytes contain stale data, so it needs some
>   form of padding.
> 
> This tries to address all four problems, by correctly
> initializing the length to zero, using endian-safe copy
> functions, adding zero-padding and passing the padded length.
> 
> I have done no testing on this patch, so please review
> carefully and if possible test with an unaligned length
> and big-endian kernel builds.
> 
> Fixes: 8a1012d3f2ab ("crypto: stm32 - Support for STM32 HASH module")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
