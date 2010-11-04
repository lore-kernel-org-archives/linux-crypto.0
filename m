From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 1/1] crypto: api.c: adding doxygen comments to api
Date: Thu, 04 Nov 2010 09:53:07 -0700
Message-ID: <4CD2E4F3.4000008@caviumnetworks.com>
References: <1288888362-10599-1-git-send-email-mark.a.allyn@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mark Allyn <mark.a.allyn@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12795 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0KDQxI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 12:53:08 -0400
In-Reply-To: <1288888362-10599-1-git-send-email-mark.a.allyn@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/04/2010 09:32 AM, Mark Allyn wrote:
> Subject: [PATCH 1/1] crypto: api.c: adding doxygen comments to api

Do we really use doxygen in the kernel?  Perhaps a subject line 
containing the string 'kernel-doc' would be more accurate.

Reading kernel-doc-nano-HOWTO.txt will show you the proper format.

> Signed-off-by: Mark A. Allyn<mark.a.allyn@intel.com>
> ---
>   crypto/api.c |   14 ++++++++++++++
>   1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/crypto/api.c b/crypto/api.c
> index 033a714..a11939f 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -193,6 +193,13 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
>   	return alg;
>   }
>
> +/**
> + * This gets the crypto_alg structure for an algorithm
> + * it return struct crypto_alg
> + * @name: name of the algorithm
> + * @type: crypto type (defined at about line 31 of include/linux/crypto.h)

Referencing kernel source file line numbers in documentation seems like 
an excellent way to have the documentation quickly be incorrect.


> + * @mask: mask of allowable crypto types
> + */
>   struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>   {
>   	struct crypto_alg *alg;
> @@ -205,6 +212,13 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
>   }
>   EXPORT_SYMBOL_GPL(crypto_alg_lookup);
>
> +/**
> + * This gets the large value crypto_alg structure for an algorithm
> + * it return struct crypto_alg
> + * @name: name of the algorithm
> + * @type: crypto type (defined at about line 31 of include/linux/crypto.h)
> + * @mask: mask of allowable crypto types
> + */
>   struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
>   {
>   	struct crypto_alg *alg;
