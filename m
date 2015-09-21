From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [RFC][PATCH 0/9] use CRYPTO_ALG_TFM_MAY_SHARE cra flag (full
 patchset)
Date: Mon, 21 Sep 2015 22:17:54 +0900
Message-ID: <20150921131754.GA8706@swordfish>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joonsoo Kim <js1304@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33458 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbIUNTE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 09:19:04 -0400
Content-Disposition: inline
In-Reply-To: <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (09/21/15 22:13), Sergey Senozhatsky wrote:
> RFC
> 
> resend reason:
> git (2.6.0-rc2) has crashed and spme patches were not sent out.
> 
> 
> Sorry for the noise.
> 
> ===================

what a day... really sorry.


(release 2.5.3) git has crashed again

[Net::SMTP::SSL] Connection closed at /usr/lib/git-core/git-send-email line 1351.
fatal: 'send-email' appears to be a git command, but we were not
able to execute it. Maybe git-send-email is broken?

hm...

	-ss

> 
> This patch set implements a bit different approach to shared tfm. It
> defines a new CRYPTO_ALG_TFM_MAY_SHARE ->cra_flag which each algorithm
> setups in its `static struct crypto_alg'. Crypto API provides
> crypto_tfm_may_share() function that returns true if the algorithm
> has CRYPTO_ALG_TFM_MAY_SHARE set and, thus, we can supply a shared
> `struct crypto_comp *tfm'.
> 
> Not properly tested yet.
> 
> 
> Sergey Senozhatsky (9):
>   crypto: introduce CRYPTO_ALG_TFM_MAY_SHARE flag
>   crypto/lzo: set CRYPTO_ALG_TFM_MAY_SHARE
>   crypto/lz4: set CRYPTO_ALG_TFM_MAY_SHARE
>   crypto/lz4hc: set CRYPTO_ALG_TFM_MAY_SHARE
>   crypto/842: set CRYPTO_ALG_TFM_MAY_SHARE
>   zram: make stream find and release functions static
>   zram: pass zstrm down to decompression path
>   zram: use crypto API for compression
>   zram: use crypto CRYPTO_ALG_TFM_MAY_SHARE API
> 
>  crypto/842.c                   |   3 +-
>  crypto/lz4.c                   |   3 +-
>  crypto/lz4hc.c                 |   3 +-
>  crypto/lzo.c                   |   3 +-
>  drivers/block/zram/Kconfig     |   8 ++--
>  drivers/block/zram/Makefile    |   4 +-
>  drivers/block/zram/zcomp.c     | 103 +++++++++++++++++++++++++++++++----------
>  drivers/block/zram/zcomp.h     |  42 +++++++----------
>  drivers/block/zram/zcomp_lz4.c |  47 -------------------
>  drivers/block/zram/zcomp_lz4.h |  17 -------
>  drivers/block/zram/zcomp_lzo.c |  47 -------------------
>  drivers/block/zram/zcomp_lzo.h |  17 -------
>  drivers/block/zram/zram_drv.c  |  32 +++++++++----
>  include/linux/crypto.h         |  10 ++++
>  14 files changed, 138 insertions(+), 201 deletions(-)
>  delete mode 100644 drivers/block/zram/zcomp_lz4.c
>  delete mode 100644 drivers/block/zram/zcomp_lz4.h
>  delete mode 100644 drivers/block/zram/zcomp_lzo.c
>  delete mode 100644 drivers/block/zram/zcomp_lzo.h
> 
> -- 
> 2.6.0.rc2.10.gf4d9753
> 
