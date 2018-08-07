From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 2/9] crypto: cbc: Remove VLA usage
Date: Tue, 7 Aug 2018 17:47:20 +0800
Message-ID: <20180807094720.ljie32lewzlgymm4@gondor.apana.org.au>
References: <20180802225152.19194-1-keescook@chromium.org>
	<20180802225152.19194-3-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Mike Snitzer <snitzer@redhat.com>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Will Deacon <will.deacon@arm.com>, qat-linux@intel.com,
	Matthew Wilcox <mawilcox@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alasdair Kergon <agk@redhat.com>, linux-crypto@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180802225152.19194-3-keescook@chromium.org>
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

On Thu, Aug 02, 2018 at 03:51:45PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> uses the upper bounds on blocksize. Since this is always a cipher
> blocksize, use the existing cipher max blocksize.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/crypto/cbc.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
> index f5b8bfc22e6d..47db0aac2ab9 100644
> --- a/include/crypto/cbc.h
> +++ b/include/crypto/cbc.h
> @@ -113,7 +113,9 @@ static inline int crypto_cbc_decrypt_inplace(
>  	unsigned int bsize = crypto_skcipher_blocksize(tfm);
>  	unsigned int nbytes = walk->nbytes;
>  	u8 *src = walk->src.virt.addr;
> -	u8 last_iv[bsize];
> +	u8 last_iv[MAX_CIPHER_BLOCKSIZE];
> +
> +	BUG_ON(bsize > sizeof(last_iv));

Ugh, please don't add these BUG_ONs.  Add them to the places where
the algorithm is created (if they aren't checking that already).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
