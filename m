Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbeK3FWn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Nov 2018 00:22:43 -0500
Date: Thu, 29 Nov 2018 10:16:26 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/11] crypto: crypto_user_stat: misc enhancement
Message-ID: <20181129181625.GA168705@gmail.com>
References: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 29, 2018 at 02:42:15PM +0000, Corentin Labbe wrote:
> Hello
> 
> This patchset fixes all reported problem by Eric biggers.
> 
> Regards
> 
> Changes since v4:
> - Inlined functions when !CRYPTO_STATS
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
>  crypto/algapi.c                      | 247 ++++++++++++++++++++++-
>  crypto/crypto_user_stat.c            | 160 +++++----------
>  crypto/rng.c                         |   4 +-
>  include/crypto/acompress.h           |  38 +---
>  include/crypto/aead.h                |  38 +---
>  include/crypto/akcipher.h            |  74 ++-----
>  include/crypto/hash.h                |  32 +--
>  include/crypto/internal/cryptouser.h |  17 ++
>  include/crypto/kpp.h                 |  48 +----
>  include/crypto/rng.h                 |  27 +--
>  include/crypto/skcipher.h            |  36 +---
>  include/linux/crypto.h               | 290 ++++++++++++++++++---------
>  include/uapi/linux/cryptouser.h      | 102 ++++++----
>  tools/crypto/getstat.c               |  72 +++----
>  17 files changed, 676 insertions(+), 530 deletions(-)
> 
> -- 
> 2.18.1
> 

Thanks Corentin, it looks like this addresses the biggest problems.

(Though I haven't checked everything full detail, like whether every stats value
actually provides something meaningful and correct.  Note also that successful
asynchronous operations are not being counted, but that can be fixed later...)

Herbert, can you send this series to Linus for v4.20 after reviewing it?
We don't want to be stuck with a bad UAPI, and the use-after-free needs to be
fixed anyway too.

- Eric
