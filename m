From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] s390/crypto: initialize ret to zero to avoid returning
 garbage value
Date: Tue, 6 Sep 2016 09:10:25 +0200
Message-ID: <20160906091025.20726b83@mschwide>
References: <20160905162118.16510-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160905162118.16510-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon,  5 Sep 2016 17:21:18 +0100
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> static analysis with cppcheck detected that ret is not initialized
> and hence garbage is potentially being returned in the case where
> prng_data->ppnows.reseed_counter <= prng_reseed_limit.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  arch/s390/crypto/prng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
> index 79e3a1f..a21fdf4 100644
> --- a/arch/s390/crypto/prng.c
> +++ b/arch/s390/crypto/prng.c
> @@ -412,7 +412,7 @@ static int prng_sha512_reseed(void)
> 
>  static int prng_sha512_generate(u8 *buf, size_t nbytes)
>  {
> -	int ret;
> +	int ret = 0;
> 
>  	/* reseed needed ? */
>  	if (prng_data->ppnows.reseed_counter > prng_reseed_limit) {

This issue has been introduced by git commit 0177db01adf26cf9
"s390/crypto: simplify return code handling" which is only on
the features branch right now. And to set ret=0 does not fix
the problem. The correct fix is to return nbytes.

Still a good catch though.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
