Return-Path: <SRS0=Oq1A=OC=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54451 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388768AbeKXExq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Nov 2018 23:53:46 -0500
Date: Fri, 23 Nov 2018 13:07:36 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/11] crypto: crypto_user_stat: misc enhancement
Message-ID: <20181123180736.GA6851@neilslaptop.think-freely.org>
References: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 23, 2018 at 12:02:10PM +0000, Corentin Labbe wrote:
> Hello
> 
> This patchset fixes all reported problem by Eric biggers.
> 
> Regards
> 
> Changes since v3:
> - Added a crypto_stats_init as asked vy Neil Horman
> - Fixed some checkpatch complaints
> 
> Changes since v2:
> - moved all crypto_stats functions from header to algapi.c for using
>   crypto_alg_get/put
> 
> Changes since v1:
> - Better locking of crypto_alg via crypto_alg_get/crypto_alg_put
> - remove all intermediate variables in crypto/crypto_user_stat.c
> - splited all internal stats variables into different structures
> 
> Corentin Labbe (11):
>   crypto: crypto_user_stat: made crypto_user_stat optional
>   crypto: CRYPTO_STATS should depend on CRYPTO_USER
>   crypto: crypto_user_stat: convert all stats from u32 to u64
>   crypto: crypto_user_stat: split user space crypto stat structures
>   crypto: tool: getstat: convert user space example to the new
>     crypto_user_stat uapi
>   crypto: crypto_user_stat: fix use_after_free of struct xxx_request
>   crypto: crypto_user_stat: Fix invalid stat reporting
>   crypto: crypto_user_stat: remove intermediate variable
>   crypto: crypto_user_stat: Split stats in multiple structures
>   crypto: crypto_user_stat: rename err_cnt parameter
>   crypto: crypto_user_stat: Add crypto_stats_init
> 
>  crypto/Kconfig                       |   1 +
>  crypto/Makefile                      |   3 +-
>  crypto/ahash.c                       |  17 +-
>  crypto/algapi.c                      | 300 ++++++++++++++++++++++++++-
>  crypto/crypto_user_stat.c            | 160 +++++---------
>  crypto/rng.c                         |   4 +-
>  include/crypto/acompress.h           |  38 +---
>  include/crypto/aead.h                |  38 +---
>  include/crypto/akcipher.h            |  74 ++-----
>  include/crypto/hash.h                |  32 +--
>  include/crypto/internal/cryptouser.h |  17 ++
>  include/crypto/kpp.h                 |  48 +----
>  include/crypto/rng.h                 |  27 +--
>  include/crypto/skcipher.h            |  36 +---
>  include/linux/crypto.h               | 246 +++++++++++++---------
>  include/uapi/linux/cryptouser.h      | 102 +++++----
>  tools/crypto/getstat.c               |  72 +++----
>  17 files changed, 685 insertions(+), 530 deletions(-)
> 
> -- 
> 2.18.1
> 
> 
Thanks, I think this looks good.

Acked-by: Neil Horman <nhorman@tuxdriver.com>
