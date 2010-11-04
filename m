From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/1] crypto: api.c: adding doxygen comments to api
Date: Thu, 4 Nov 2010 09:31:20 -0700
Message-ID: <20101104093120.9e411476.rdunlap@xenotime.net>
References: <1288888362-10599-1-git-send-email-mark.a.allyn@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mark Allyn <mark.a.allyn@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:54504 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751241Ab0KDQba (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 12:31:30 -0400
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-crypto@vger.kernel.org>; Thu, 4 Nov 2010 09:31:20 -0700
In-Reply-To: <1288888362-10599-1-git-send-email-mark.a.allyn@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu,  4 Nov 2010 09:32:42 -0700 Mark Allyn wrote:

> Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>

We use kernel-doc notation in kernel sources, not doxygen.

Please see Documentation/kernel-doc-nano-HOWTO.txt for info,
or ask me.

Thanks.

> ---
>  crypto/api.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 033a714..a11939f 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -193,6 +193,13 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
>  	return alg;
>  }
>  
> +/**
> + * This gets the crypto_alg structure for an algorithm
> + * it return struct crypto_alg
> + * @name: name of the algorithm
> + * @type: crypto type (defined at about line 31 of include/linux/crypto.h)
> + * @mask: mask of allowable crypto types
> + */
>  struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> @@ -205,6 +212,13 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>  }
>  EXPORT_SYMBOL_GPL(crypto_alg_lookup);
>  
> +/**
> + * This gets the large value crypto_alg structure for an algorithm
> + * it return struct crypto_alg
> + * @name: name of the algorithm
> + * @type: crypto type (defined at about line 31 of include/linux/crypto.h)
> + * @mask: mask of allowable crypto types
> + */
>  struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
>  {
>  	struct crypto_alg *alg;
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
