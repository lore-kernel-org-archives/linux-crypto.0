Return-Path: <SRS0=45GR=NR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbeKFLEI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Nov 2018 06:04:08 -0500
Date: Mon, 5 Nov 2018 17:41:27 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] crypto: crypto_user_stat: made crypto_user_stat
 optional
Message-ID: <20181106014126.GC28490@gmail.com>
References: <1541422274-40060-1-git-send-email-clabbe@baylibre.com>
 <1541422274-40060-2-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541422274-40060-2-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

On Mon, Nov 05, 2018 at 12:51:10PM +0000, Corentin Labbe wrote:
> Even if CRYPTO_STATS is set to n, some part of CRYPTO_STATS are
> compiled.
> This patch made all part of crypto_user_stat uncompiled in that case.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/Makefile                      |  3 ++-
>  crypto/algapi.c                      |  2 ++
>  include/crypto/internal/cryptouser.h | 17 +++++++++++++++++
>  include/linux/crypto.h               |  2 ++
>  4 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 5c207c76abf7..1e9e5960946a 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -54,7 +54,8 @@ cryptomgr-y := algboss.o testmgr.o
>  
>  obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
>  obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
> -crypto_user-y := crypto_user_base.o crypto_user_stat.o
> +crypto_user-y := crypto_user_base.o
> +crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
>  obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
>  obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
>  obj-$(CONFIG_CRYPTO_VMAC) += vmac.o

Doesn't CONFIG_CRYPTO_STATS also need to depend on CONFIG_CRYPTO_USER?
Currently you can enable it but without CRYPTO_USER the API won't be available.

config CRYPTO_STATS
	bool "Crypto usage statistics for User-space"

should be:

config CRYPTO_STATS
	bool "Crypto usage statistics for User-space"
	depends on CRYPTO_USER

> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 3634ad6fe202..35de61d99cd5 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -515,6 +515,7 @@ struct crypto_alg {
>  	
>  	struct module *cra_module;
>  
> +#ifdef CONFIG_CRYPTO_STATS
>  	union {
>  		atomic_t encrypt_cnt;
>  		atomic_t compress_cnt;
> @@ -552,6 +553,7 @@ struct crypto_alg {
>  		atomic_t compute_shared_secret_cnt;
>  	};
>  	atomic_t sign_cnt;
> +#endif

This is a long ifdef, so use:

#endif /* CONFIG_CRYPTO_STATS */

- Eric
