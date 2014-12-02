From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 07/17] crypto: ansi_cprng - Shrink rand_read_pos & flags
Date: Tue, 2 Dec 2014 09:59:11 -0500
Message-ID: <20141202145911.GF3388@hmsreliant.think-freely.org>
References: <20141202083314.17647.qmail@ns.horizon.com>
 <20141202084313.18411.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42157 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbaLBO7Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 09:59:16 -0500
Content-Disposition: inline
In-Reply-To: <20141202084313.18411.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2014 at 03:43:13AM -0500, George Spelvin wrote:
> rand_read_pos is never more than 16, while there's only 1 flag
> bit allocated, so we can shrink the context a little.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>  crypto/ansi_cprng.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> They're also reordered to avoid alignment holes.
> 
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index 93ed00f6..f40f54cd 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -51,9 +51,9 @@ struct prng_context {
>  	unsigned char rand_data[DEFAULT_BLK_SZ];
>  	unsigned char DT[DEFAULT_BLK_SZ];
>  	unsigned char V[DEFAULT_BLK_SZ];
> -	u32 rand_read_pos;	/* Offset into rand_data[] */
> +	unsigned char rand_read_pos;	/* Offset into rand_data[] */
u8 please.  Also, not sure if this helps much, as I think the padding will just
get you back to word alignment on each of these.

> +	unsigned char flags;
>  	struct crypto_cipher *tfm;
> -	u32 flags;
>  };
>  
>  static int dbg;
> -- 
> 2.1.3
> 
> 
