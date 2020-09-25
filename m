Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F813C4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F102087D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgIYIQo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:16:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53370 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbgIYIQo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:16:44 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLiu8-0007Mc-Qc; Fri, 25 Sep 2020 18:16:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 18:16:32 +1000
Date:   Fri, 25 Sep 2020 18:16:32 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v7 00/17] crypto: allwinner: add xRNG and hashes
Message-ID: <20200925081632.GP6381@gondor.apana.org.au>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 18, 2020 at 07:22:58AM +0000, Corentin Labbe wrote:
> Hello
> 
> The main goal of this serie is to add support for TRNG, PRNG and hashes
> to the sun8i-ss/sun8i-ce driver.
> The whole serie is tested with CRYPTO_EXTRA_TESTS enabled and loading
> tcrypt.
> The PRNG and TRNG are tested with rngtest.
> Both LE and BE kernel are tested.
> 
> This serie was tested on:
> - sun50i-a64-pine64
> - sun8i-a83t-bananapi-m3
> - sun8i-r40-bananapi-m2-ultra
> - sun50i-h5-libretech-all-h3-cc
> - sun8i-h3-orangepi-pc
> 
> Regards
> 
> Change since v1:
> - removed _crypto_rng_cast patch
> 
> Change since v2:
> - cleaned unused variables from sun8i-ce-prng
> - added some missing memzero_explicit
> 
> Change since v3:
> - rebased on latest next
> - removed useless cpu_to_le32() in sun8i-ss
> - added 2 last patches
> - add handle endianness of t_common_ctl patch
> 
> Change since v4:
> - added a style issue patch
> 
> Changes since v5:
> - handle failure pattern of pm_runtime_get_sync
> - Add missing linux/dma-mapping.h
> 
> Changes since v6:
> - fix sparse error in sun8i-ce-cipher.c
> 
> Corentin Labbe (17):
>   crypto: sun8i-ss: Add SS_START define
>   crypto: sun8i-ss: Add support for the PRNG
>   crypto: sun8i-ss: support hash algorithms
>   crypto: sun8i-ss: fix a trivial typo
>   crypto: sun8i-ss: Add more comment on some structures
>   crypto: sun8i-ss: better debug printing
>   crypto: sun8i-ce: handle endianness of t_common_ctl
>   crypto: sun8i-ce: move iv data to request context
>   crypto: sun8i-ce: split into prepare/run/unprepare
>   crypto: sun8i-ce: handle different error registers
>   crypto: sun8i-ce: rename has_t_dlen_in_bytes to cipher_t_dlen_in_bytes
>   crypto: sun8i-ce: support hash algorithms
>   crypto: sun8i-ce: Add stat_bytes debugfs
>   crypto: sun8i-ce: Add support for the PRNG
>   crypto: sun8i-ce: Add support for the TRNG
>   crypto: sun8i-ce: fix comparison of integer expressions of different
>     signedness
>   crypto: sun8i-ss: fix comparison of integer expressions of different
>     signedness
> 
>  drivers/crypto/allwinner/Kconfig              |  43 ++
>  drivers/crypto/allwinner/sun8i-ce/Makefile    |   3 +
>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 116 +++--
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 381 ++++++++++++++-
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 413 ++++++++++++++++
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 164 +++++++
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 127 +++++
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 139 +++++-
>  drivers/crypto/allwinner/sun8i-ss/Makefile    |   2 +
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 205 +++++++-
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 444 ++++++++++++++++++
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 173 +++++++
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  89 +++-
>  13 files changed, 2240 insertions(+), 59 deletions(-)
>  create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
>  create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
>  create mode 100644 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c
>  create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
>  create mode 100644 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
