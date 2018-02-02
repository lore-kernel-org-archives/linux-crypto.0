From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/2] libcrc32c: Add crc32c_impl function
Date: Fri, 2 Feb 2018 18:29:42 +0100
Message-ID: <20180202172942.GU18553@twin.jikos.cz>
References: <1515404705-490-1-git-send-email-nborisov@suse.com>
 <1515404705-490-2-git-send-email-nborisov@suse.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Nikolay Borisov <nborisov@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515404705-490-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Adding linux-crypto@vger.kernel.org to CC

Link to the 2/2 patch https://patchwork.kernel.org/patch/10149203/

On Mon, Jan 08, 2018 at 11:45:04AM +0200, Nikolay Borisov wrote:
> This function returns a string with the currently in-use implementation
> of the crc32c algorithm, i.e crc32c-generic (for unoptimised, generic
> implementation) or crc32c-intel for the sse optimised version. This
> will be used by btrfs.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  include/linux/crc32c.h | 1 +
>  lib/libcrc32c.c        | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/include/linux/crc32c.h b/include/linux/crc32c.h
> index 357ae4611a45..bd21af828ff6 100644
> --- a/include/linux/crc32c.h
> +++ b/include/linux/crc32c.h
> @@ -5,6 +5,7 @@
>  #include <linux/types.h>
>  
>  extern u32 crc32c(u32 crc, const void *address, unsigned int length);
> +extern const char *crc32c_impl(void);
>  
>  /* This macro exists for backwards-compatibility. */
>  #define crc32c_le crc32c
> diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
> index 9f79547d1b97..eaf71e0e04be 100644
> --- a/lib/libcrc32c.c
> +++ b/lib/libcrc32c.c
> @@ -71,6 +71,12 @@ static void __exit libcrc32c_mod_fini(void)
>  	crypto_free_shash(tfm);
>  }
>  
> +const char *crc32c_impl(void)
> +{
> +	return crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
> +}
> +EXPORT_SYMBOL(crc32c_impl);

Crypto maintainers, would it be still possible to squeeze this patch to
4.16? It's quite trivial, but as it is not in a code I maintain I'm not
comfortable to add it to my tree (unless I get an ACK).

The linked patch depends on that change and would let us get rid of some
custom crypto wrappers around crc32c.
