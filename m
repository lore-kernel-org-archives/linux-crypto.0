From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v8 5/9] dm: Remove VLA usage from hashes
Date: Thu, 13 Sep 2018 13:54:39 -0400
Message-ID: <20180913175439.GA5414@redhat.com>
References: <20180807211843.47586-1-keescook@chromium.org>
 <20180807211843.47586-6-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        qat-linux@intel.com, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807211843.47586-6-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 07 2018 at  5:18pm -0400,
Kees Cook <keescook@chromium.org> wrote:

> In the quest to remove all stack VLA usage from the kernel[1], this uses
> the new HASH_MAX_DIGESTSIZE from the crypto layer to allocate the upper
> bounds on stack usage.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/md/dm-integrity.c  | 23 +++++++++++++++++------
>  drivers/md/dm-verity-fec.c |  5 ++++-
>  2 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 86438b2f10dd..884edd7cf1d0 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -521,7 +521,12 @@ static void section_mac(struct dm_integrity_c *ic, unsigned section, __u8 result
>  		}
>  		memset(result + size, 0, JOURNAL_MAC_SIZE - size);
>  	} else {
> -		__u8 digest[size];
> +		__u8 digest[HASH_MAX_DIGESTSIZE];
> +
> +		if (WARN_ON(size > sizeof(digest))) {
> +			dm_integrity_io_error(ic, "digest_size", -EINVAL);
> +			goto err;
> +		}
>  		r = crypto_shash_final(desc, digest);
>  		if (unlikely(r)) {
>  			dm_integrity_io_error(ic, "crypto_shash_final", r);
> @@ -1244,7 +1249,7 @@ static void integrity_metadata(struct work_struct *w)
>  		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
>  		char *checksums;
>  		unsigned extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
> -		char checksums_onstack[ic->tag_size + extra_space];
> +		char checksums_onstack[HASH_MAX_DIGESTSIZE];
>  		unsigned sectors_to_process = dio->range.n_sectors;
>  		sector_t sector = dio->range.logical_sector;
>  
> @@ -1253,8 +1258,14 @@ static void integrity_metadata(struct work_struct *w)
>  
>  		checksums = kmalloc((PAGE_SIZE >> SECTOR_SHIFT >> ic->sb->log2_sectors_per_block) * ic->tag_size + extra_space,
>  				    GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
> -		if (!checksums)
> +		if (!checksums) {
>  			checksums = checksums_onstack;
> +			if (WARN_ON(extra_space &&
> +				    digest_size > sizeof(checksums_onstack))) {
> +				r = -EINVAL;
> +				goto error;
> +			}
> +		}
>  
>  		__bio_for_each_segment(bv, bio, iter, dio->orig_bi_iter) {
>  			unsigned pos;

Given the length of the kmalloc() just prior to this new WARN_ON() line
I'm not seeing why you've elected to split the WARN_ON across multiple
lines.

But that style nit aside:

Acked-by: Mike Snitzer <snitzer@redhat.com>
