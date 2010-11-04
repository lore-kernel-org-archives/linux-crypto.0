From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/1] crypto: api.c adding kernel-doc comments
Date: Thu, 4 Nov 2010 10:22:19 -0700
Message-ID: <20101104102219.7ec24969.rdunlap@xenotime.net>
References: <1288890442-11208-1-git-send-email-mark.a.allyn@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mark Allyn <mark.a.allyn@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:40698 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750760Ab0KDRWa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 13:22:30 -0400
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-crypto@vger.kernel.org>; Thu, 4 Nov 2010 10:22:20 -0700
In-Reply-To: <1288890442-11208-1-git-send-email-mark.a.allyn@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu,  4 Nov 2010 10:07:22 -0700 Mark Allyn wrote:

> Add comments to crypto_alg_lookup and crypto_larval_lookup
> 
> I am re-submitting this due to errors
> 
> Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
> ---
>  crypto/api.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 033a714..71c389d 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -193,6 +193,15 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
>  	return alg;
>  }
>  
> +/**
> + * crypto_alg_lookup() return crypto_alg structure for an algorithm

needs hyphen between function name and "return".

> + * @name:	text string containing name of algorithm
> + * @type:	crypto type (defined at about line 31 of
> + *		include/linux/crypto.h)
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined at about line 31 of
> + *		include/linux/crypto.h)

drop the line numbers...

> + */
>  struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> @@ -205,6 +214,16 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  }
>  EXPORT_SYMBOL_GPL(crypto_alg_lookup);
>  
> +/**
> + * crypto_alg_larval lookup() return large value (larval) crypto_alg

 * crypto_larval_lookup() - return large value (larval) crypto_alg


> + *	structure for an algorithm
> + * @name:	text string containing name of algorithm
> + * @type:	crypto type (defined at about line 31 of
> + *		include/linux/crypto.h)
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined at about line 31 of
> + *		include/linux/crypto.h)
> + */

drop the line numbers.

>  struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
