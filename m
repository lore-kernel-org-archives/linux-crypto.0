From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH] crypto: omap-sham - increase cra_proirity to 400
Date: Thu, 30 Jun 2016 10:24:29 +0300
Message-ID: <5774C92D.5040500@ti.com>
References: <1467216696-8014-1-git-send-email-b-liu@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Bin Liu <b-liu@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:51887 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbcF3HYi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jun 2016 03:24:38 -0400
In-Reply-To: <1467216696-8014-1-git-send-email-b-liu@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 29/06/16 19:11, Bin Liu wrote:
> Some software alg has cra_priority as higher as 300, so increase
> omap-sham priority to 400 to ensure it is on top of any software alg.

You could mention the case where this is causing issues, namely the 
arm-neon-sha implementations which currently have priority of 150...300.

-Tero

>
> Signed-off-by: Bin Liu <b-liu@ti.com>
> ---
>   drivers/crypto/omap-sham.c | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 63464e8..aa7be252 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -1328,7 +1328,7 @@ static struct ahash_alg algs_sha1_md5[] = {
>   	.halg.base	= {
>   		.cra_name		= "sha1",
>   		.cra_driver_name	= "omap-sha1",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_KERN_DRIVER_ONLY |
>   						CRYPTO_ALG_ASYNC |
> @@ -1351,7 +1351,7 @@ static struct ahash_alg algs_sha1_md5[] = {
>   	.halg.base	= {
>   		.cra_name		= "md5",
>   		.cra_driver_name	= "omap-md5",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_KERN_DRIVER_ONLY |
>   						CRYPTO_ALG_ASYNC |
> @@ -1375,7 +1375,7 @@ static struct ahash_alg algs_sha1_md5[] = {
>   	.halg.base	= {
>   		.cra_name		= "hmac(sha1)",
>   		.cra_driver_name	= "omap-hmac-sha1",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_KERN_DRIVER_ONLY |
>   						CRYPTO_ALG_ASYNC |
> @@ -1400,7 +1400,7 @@ static struct ahash_alg algs_sha1_md5[] = {
>   	.halg.base	= {
>   		.cra_name		= "hmac(md5)",
>   		.cra_driver_name	= "omap-hmac-md5",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_KERN_DRIVER_ONLY |
>   						CRYPTO_ALG_ASYNC |
> @@ -1428,7 +1428,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
>   	.halg.base	= {
>   		.cra_name		= "sha224",
>   		.cra_driver_name	= "omap-sha224",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_ASYNC |
>   						CRYPTO_ALG_NEED_FALLBACK,
> @@ -1450,7 +1450,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
>   	.halg.base	= {
>   		.cra_name		= "sha256",
>   		.cra_driver_name	= "omap-sha256",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_ASYNC |
>   						CRYPTO_ALG_NEED_FALLBACK,
> @@ -1473,7 +1473,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
>   	.halg.base	= {
>   		.cra_name		= "hmac(sha224)",
>   		.cra_driver_name	= "omap-hmac-sha224",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_ASYNC |
>   						CRYPTO_ALG_NEED_FALLBACK,
> @@ -1497,7 +1497,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
>   	.halg.base	= {
>   		.cra_name		= "hmac(sha256)",
>   		.cra_driver_name	= "omap-hmac-sha256",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_ASYNC |
>   						CRYPTO_ALG_NEED_FALLBACK,
> @@ -1523,7 +1523,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
>   	.halg.base	= {
>   		.cra_name		= "sha384",
>   		.cra_driver_name	= "omap-sha384",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_ASYNC |
>   						CRYPTO_ALG_NEED_FALLBACK,
> @@ -1545,7 +1545,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
>   	.halg.base	= {
>   		.cra_name		= "sha512",
>   		.cra_driver_name	= "omap-sha512",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_ASYNC |
>   						CRYPTO_ALG_NEED_FALLBACK,
> @@ -1568,7 +1568,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
>   	.halg.base	= {
>   		.cra_name		= "hmac(sha384)",
>   		.cra_driver_name	= "omap-hmac-sha384",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_ASYNC |
>   						CRYPTO_ALG_NEED_FALLBACK,
> @@ -1592,7 +1592,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
>   	.halg.base	= {
>   		.cra_name		= "hmac(sha512)",
>   		.cra_driver_name	= "omap-hmac-sha512",
> -		.cra_priority		= 100,
> +		.cra_priority		= 400,
>   		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>   						CRYPTO_ALG_ASYNC |
>   						CRYPTO_ALG_NEED_FALLBACK,
>
