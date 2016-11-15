From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: sha*-mb Fix total_len for correct hash when
 larger than 512MB
Date: Tue, 15 Nov 2016 08:50:12 -0800
Message-ID: <1479228612.5138.14.camel@linux.intel.com>
References: <1479165104-24356-1-git-send-email-greg.b.tucker@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: megha.dey@linux.intel.com, xiaodong.liu@intel.com
To: Greg Tucker <greg.b.tucker@intel.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34665 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932525AbcKOQuN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2016 11:50:13 -0500
In-Reply-To: <1479165104-24356-1-git-send-email-greg.b.tucker@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2016-11-14 at 16:11 -0700, Greg Tucker wrote:
> Current multi-buffer hash implementations have a restriction on the total
> length of a hash job to 512MB. Hashing larger buffers will result in an
> incorrect hash. This extends the limit to 2^62 - 1.
> 
> Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>

> ---
>  arch/x86/crypto/sha1-mb/sha1_mb.c         | 2 +-
>  arch/x86/crypto/sha1-mb/sha1_mb_ctx.h     | 2 +-
>  arch/x86/crypto/sha256-mb/sha256_mb.c     | 2 +-
>  arch/x86/crypto/sha256-mb/sha256_mb_ctx.h | 2 +-
>  arch/x86/crypto/sha512-mb/sha512_mb.c     | 2 +-
>  arch/x86/crypto/sha512-mb/sha512_mb_ctx.h | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/crypto/sha1-mb/sha1_mb.c b/arch/x86/crypto/sha1-mb/sha1_mb.c
> index 9e5b671..acf9fdf 100644
> --- a/arch/x86/crypto/sha1-mb/sha1_mb.c
> +++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
> @@ -114,7 +114,7 @@ static inline void sha1_init_digest(uint32_t *digest)
>  }
>  
>  static inline uint32_t sha1_pad(uint8_t padblock[SHA1_BLOCK_SIZE * 2],
> -			 uint32_t total_len)
> +			 uint64_t total_len)
>  {
>  	uint32_t i = total_len & (SHA1_BLOCK_SIZE - 1);
>  
> diff --git a/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h b/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
> index 98a35bc..13590cc 100644
> --- a/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
> +++ b/arch/x86/crypto/sha1-mb/sha1_mb_ctx.h
> @@ -125,7 +125,7 @@ struct sha1_hash_ctx {
>  	/* error flag */
>  	int error;
>  
> -	uint32_t	total_length;
> +	uint64_t	total_length;
>  	const void	*incoming_buffer;
>  	uint32_t	incoming_buffer_length;
>  	uint8_t		partial_block_buffer[SHA1_BLOCK_SIZE * 2];
> diff --git a/arch/x86/crypto/sha256-mb/sha256_mb.c b/arch/x86/crypto/sha256-mb/sha256_mb.c
> index 6f97fb3..7926a22 100644
> --- a/arch/x86/crypto/sha256-mb/sha256_mb.c
> +++ b/arch/x86/crypto/sha256-mb/sha256_mb.c
> @@ -115,7 +115,7 @@ inline void sha256_init_digest(uint32_t *digest)
>  }
>  
>  inline uint32_t sha256_pad(uint8_t padblock[SHA256_BLOCK_SIZE * 2],
> -			 uint32_t total_len)
> +			 uint64_t total_len)
>  {
>  	uint32_t i = total_len & (SHA256_BLOCK_SIZE - 1);
>  
> diff --git a/arch/x86/crypto/sha256-mb/sha256_mb_ctx.h b/arch/x86/crypto/sha256-mb/sha256_mb_ctx.h
> index edd252b..aabb303 100644
> --- a/arch/x86/crypto/sha256-mb/sha256_mb_ctx.h
> +++ b/arch/x86/crypto/sha256-mb/sha256_mb_ctx.h
> @@ -125,7 +125,7 @@ struct sha256_hash_ctx {
>  	/* error flag */
>  	int error;
>  
> -	uint32_t	total_length;
> +	uint64_t	total_length;
>  	const void	*incoming_buffer;
>  	uint32_t	incoming_buffer_length;
>  	uint8_t		partial_block_buffer[SHA256_BLOCK_SIZE * 2];
> diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sha512-mb/sha512_mb.c
> index d210174..9c1bb6d 100644
> --- a/arch/x86/crypto/sha512-mb/sha512_mb.c
> +++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
> @@ -117,7 +117,7 @@ inline void sha512_init_digest(uint64_t *digest)
>  }
>  
>  inline uint32_t sha512_pad(uint8_t padblock[SHA512_BLOCK_SIZE * 2],
> -			 uint32_t total_len)
> +			 uint64_t total_len)
>  {
>  	uint32_t i = total_len & (SHA512_BLOCK_SIZE - 1);
>  
> diff --git a/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h b/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
> index 9d4b2c8..e4653f5 100644
> --- a/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
> +++ b/arch/x86/crypto/sha512-mb/sha512_mb_ctx.h
> @@ -119,7 +119,7 @@ struct sha512_hash_ctx {
>  	/* error flag */
>  	int error;
>  
> -	uint32_t        total_length;
> +	uint64_t        total_length;
>  	const void      *incoming_buffer;
>  	uint32_t        incoming_buffer_length;
>  	uint8_t         partial_block_buffer[SHA512_BLOCK_SIZE * 2];
