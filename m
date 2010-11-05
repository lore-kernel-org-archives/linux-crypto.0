From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/1] crypto: api.c: doc on crypto_alg_lookup,
 crypto_larval_lookup, and crypto_alg_mod_lookup
Date: Fri, 5 Nov 2010 11:28:15 -0700
Message-ID: <20101105112815.25cd3949.randy.dunlap@oracle.com>
References: <1288980346-15961-1-git-send-email-mark.a.allyn@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mark Allyn <mark.a.allyn@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288980346-15961-1-git-send-email-mark.a.allyn@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri,  5 Nov 2010 11:05:46 -0700 Mark Allyn wrote:

> Resubmit due to errors on patch submitted 11/4/2010
> 
> Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Mark.


> ---
>  crypto/api.c |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 033a714..d8a7c35 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -193,6 +193,14 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
>  	return alg;
>  }
>  
> +/**
> + * crypto_alg_lookup() - get the crypto_alg structure for an algorithm
> + * @name:	text string containing name of algorithm
> + * @type:	crypto type defined in include/linux/crypto.h
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined in include/linux/crypto.h)
> + * @returns:	pointer to crypto_alg structure
> + */
>  struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> @@ -205,6 +213,15 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  }
>  EXPORT_SYMBOL_GPL(crypto_alg_lookup);
>  
> +/**
> + * crypto_larval_lookup() - gets large value (larval) crypto_alg
> + *	structure for an algorithm
> + * @name:	text string containing name of algorithm
> + * @type:	crypto type defined in include/linux/crypto.h
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined in include/linux/crypto.h)
> + * @returns:	pointer to crypto_alg structure
> + */
>  struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> @@ -247,6 +264,14 @@ int crypto_probing_notify(unsigned long val, void *v)
>  }
>  EXPORT_SYMBOL_GPL(crypto_probing_notify);
>  
> +/**
> + * crypto_alg_mod_lookup() - gets the algorithm module
> + * @name:	text string containing name of algorithm
> + * @type:	crypto type defined in include/linux/crypto.h
> + * @mask:	mask of allowable crypto types (use or'd list
> + *		of types as defined in include/linux/crypto.h)
> + * @returns:	pointer to crypto_alg structure
> + */
>  struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
