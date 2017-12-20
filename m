From: Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] [RFT] crypto: aes-generic - turn off -ftree-pre and
 -ftree-sra
Date: Wed, 20 Dec 2017 22:46:48 +0100
Message-ID: <20171220214648.GO2353@tucnak>
References: <20171220205213.1025257-1-arnd@arndb.de>
Reply-To: Jakub Jelinek <jakub@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <james.l.morris@oracle.com>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756348AbdLTVrH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 16:47:07 -0500
Content-Disposition: inline
In-Reply-To: <20171220205213.1025257-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 09:52:05PM +0100, Arnd Bergmann wrote:
> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
> index ca554d57d01e..35f973ba9878 100644
> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -1331,6 +1331,20 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
>  	f_rl(bo, bi, 3, k);	\
>  } while (0)
>  
> +#if __GNUC__ >= 7
> +/*
> + * Newer compilers try to optimize integer arithmetic more aggressively,
> + * which generally improves code quality a lot, but in this specific case
> + * ends up hurting more than it helps, in some configurations drastically
> + * so. This turns off two optimization steps that have been shown to
> + * lead to rather badly optimized code with gcc-7.
> + *
> + * See also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
> + */
> +#pragma GCC optimize("-fno-tree-pre")
> +#pragma GCC optimize("-fno-tree-sra")

So do it only when UBSAN is enabled?  GCC doesn't have a particular
predefined macro for those (only for asan and tsan), but either the kernel
does have something already, or could have something added in the
corresponding Makefile.

	Jakub
