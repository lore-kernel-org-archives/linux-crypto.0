From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 04/11] dm verity fec: Remove VLA usage
Date: Thu, 21 Jun 2018 10:30:54 +0800
Message-ID: <20180621023054.5jx5s3jzap3soe6e@gondor.apana.org.au>
References: <20180620190408.45104-1-keescook@chromium.org>
	<20180620190408.45104-5-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@google.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	qat-linux@intel.com, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Lars Persson <larper@axis.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180620190408.45104-5-keescook@chromium.org>
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

On Wed, Jun 20, 2018 at 12:04:01PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> uses the newly defined max digest size macro. Also adds a sanity-check
> at use-time.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/md/dm-verity-fec.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
> index 684af08d0747..0dfcc52835bc 100644
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -212,12 +212,15 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
>  	struct dm_verity_fec_io *fio = fec_io(io);
>  	u64 block, ileaved;
>  	u8 *bbuf, *rs_block;
> -	u8 want_digest[v->digest_size];
> +	u8 want_digest[AHASH_MAX_DIGESTSIZE];
>  	unsigned n, k;
>  
>  	if (neras)
>  		*neras = 0;
>  
> +	if (WARN_ON(v->digest_size < sizeof(want_digest)))
> +		return -EINVAL;

How about verifying digest_size in the ahash API when algorithms
are registered?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
