From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] ansi_cprng: enforce key != seed in fips mode
Date: Fri, 4 Nov 2011 06:51:01 -0400
Message-ID: <20111104105101.GA23232@hmsreliant.think-freely.org>
References: <1320351885-28555-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Stephan Mueller <smueller@atsec.com>,
	Steve Grubb <sgrubb@redhat.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36455 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1KDKvJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Nov 2011 06:51:09 -0400
Content-Disposition: inline
In-Reply-To: <1320351885-28555-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 03, 2011 at 04:24:45PM -0400, Jarod Wilson wrote:
> Apparently, NIST is tightening up its requirements for FIPS validation
> with respect to RNGs. Its always been required that in fips mode, the
> ansi cprng not be fed key and seed material that was identical, but
> they're now interpreting FIPS 140-2, section AS07.09 as requiring that
> the implementation itself must enforce the requirement. Easy fix, we
> just do a memcmp of key and seed in fips_cprng_reset and call it a day.
> 
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Stephan Mueller <smueller@atsec.com>
> CC: Steve Grubb <sgrubb@redhat.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  crypto/ansi_cprng.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
> index ffa0245..a7fdcb4 100644
> --- a/crypto/ansi_cprng.c
> +++ b/crypto/ansi_cprng.c
> @@ -414,10 +414,15 @@ static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
>  static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
>  {
>  	u8 rdata[DEFAULT_BLK_SZ];
> +	u8 *key = seed + DEFAULT_BLK_SZ;
>  	int rc;
>  
>  	struct prng_context *prng = crypto_rng_ctx(tfm);
>  
> +	/* fips strictly requires seed != key */
> +	if (!memcmp(seed, key, DEFAULT_PRNG_KSZ))
> +		return -EINVAL;
> +
>  	rc = cprng_reset(tfm, seed, slen);
>  
>  	if (!rc)
> -- 
> 1.7.1
> 
> 
Thank you Jarod, The idea is fine to me.  Unfortunately, because you're indexing
into the seed to grab the key value, just like cprng_reset does now, you
probably need to add the slen checks that cprng_reset does to make sure theres
enough seed data as well, to avoid dereferencing unallocated memory.  If you fix
that up I'll ack it.

Neil
