From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5] crypto: xts - Drop use of auxiliary buffer
Date: Fri, 21 Sep 2018 13:44:28 +0800
Message-ID: <20180921054428.zbvsng2gx5x6rf33@gondor.apana.org.au>
References: <20180911074008.2249-1-omosnace@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180911074008.2249-1-omosnace@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 09:40:08AM +0200, Ondrej Mosnacek wrote:
> Since commit acb9b159c784 ("crypto: gf128mul - define gf128mul_x_* in
> gf128mul.h"), the gf128mul_x_*() functions are very fast and therefore
> caching the computed XTS tweaks has only negligible advantage over
> computing them twice.
> 
> In fact, since the current caching implementation limits the size of
> the calls to the child ecb(...) algorithm to PAGE_SIZE (usually 4096 B),
> it is often actually slower than the simple recomputing implementation.
> 
> This patch simplifies the XTS template to recompute the XTS tweaks from
> scratch in the second pass and thus also removes the need to allocate a
> dynamic buffer using kmalloc().
> 
> As discussed at [1], the use of kmalloc causes deadlocks with dm-crypt.
> 
> PERFORMANCE RESULTS
> I measured time to encrypt/decrypt a memory buffer of varying sizes with
> xts(ecb-aes-aesni) using a tool I wrote ([2]) and the results suggest
> that after this patch the performance is either better or comparable for
> both small and large buffers. Note that there is a lot of noise in the
> measurements, but the overall difference is easy to see.
> 
> Old code:
>        ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
>         xts(aes)     256              64             331             328
>         xts(aes)     384              64             332             333
>         xts(aes)     512              64             338             348
>         xts(aes)     256             512             889             920
>         xts(aes)     384             512            1019             993
>         xts(aes)     512             512            1032             990
>         xts(aes)     256            4096            2152            2292
>         xts(aes)     384            4096            2453            2597
>         xts(aes)     512            4096            3041            2641
>         xts(aes)     256           16384            9443            8027
>         xts(aes)     384           16384            8536            8925
>         xts(aes)     512           16384            9232            9417
>         xts(aes)     256           32768           16383           14897
>         xts(aes)     384           32768           17527           16102
>         xts(aes)     512           32768           18483           17322
> 
> New code:
>        ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
>         xts(aes)     256              64             328             324
>         xts(aes)     384              64             324             319
>         xts(aes)     512              64             320             322
>         xts(aes)     256             512             476             473
>         xts(aes)     384             512             509             492
>         xts(aes)     512             512             531             514
>         xts(aes)     256            4096            2132            1829
>         xts(aes)     384            4096            2357            2055
>         xts(aes)     512            4096            2178            2027
>         xts(aes)     256           16384            6920            6983
>         xts(aes)     384           16384            8597            7505
>         xts(aes)     512           16384            7841            8164
>         xts(aes)     256           32768           13468           12307
>         xts(aes)     384           32768           14808           13402
>         xts(aes)     512           32768           15753           14636
> 
> [1] https://lkml.org/lkml/2018/8/23/1315
> [2] https://gitlab.com/omos/linux-crypto-bench
> 
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  crypto/xts.c | 269 +++++++++------------------------------------------
>  1 file changed, 46 insertions(+), 223 deletions(-)
> 
> Changes in v5:
>   - fix dumb mistakes

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
