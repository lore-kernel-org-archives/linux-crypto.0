Return-Path: <SRS0=21Gj=5M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A2CC43331
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 04:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB57F206DB
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Mar 2020 04:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgC0Eyi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Mar 2020 00:54:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57068 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgC0Eyi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Mar 2020 00:54:38 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jHh0p-0000CC-OZ; Fri, 27 Mar 2020 15:54:32 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2020 15:54:31 +1100
Date:   Fri, 27 Mar 2020 15:54:31 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH v9 0/9] enable CAAM's HWRNG as default
Message-ID: <20200327045431.GC19912@gondor.apana.org.au>
References: <20200319161233.8134-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319161233.8134-1-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 19, 2020 at 09:12:24AM -0700, Andrey Smirnov wrote:
> Everyone:
> 
> This series is a continuation of original [discussion]. I don't know
> if what's in the series is enough to use CAAMs HWRNG system wide, but
> I am hoping that with enough iterations and feedback it will be.
> 
> Changes since [v1]:
> 
>     - Original hw_random replaced with the one using output of TRNG directly
> 
>     - SEC4 DRNG IP block exposed via crypto API
> 
>     - Small fix regarding use of GFP_DMA added to the series
> 
> Chagnes since [v2]:
> 
>     - msleep in polling loop to avoid wasting CPU cycles
> 
>     - caam_trng_read() bails out early if 'wait' is set to 'false'
> 
>     - fixed typo in ZII's name
> 
> Changes since [v3]:
> 
>     - DRNG's .cra_name is now "stdrng"
> 
>     - collected Reviewd-by tag from Lucas
> 
>     - typo fixes in commit messages of the series
> 
> Changes since [v4]:
> 
>     - Dropped "crypto: caam - RNG4 TRNG errata" and "crypto: caam -
>       enable prediction resistance in HRWNG" to limit the scope of the
>       series. Those two patches are not yet ready and can be submitted
>       separately later.
> 
>     - Collected Tested-by from Chris
> 
> Changes since [v5]:
> 
>     - Series is converted back to implementing HWRNG using a job ring
>       as per feedback from Horia.
> 
> Changes since [v6]:
> 
>     - "crypto: caam - drop global context pointer and init_done"
>       changed to use devres group to allow freeing HWRNG resource
>       independently of the parent device lifecycle. Code to deal with
>       circular deallocation dependency is added as well
> 
>     - Removed worker self-scheduling in "crypto: caam - simplify RNG
>       implementation". It didn't bring much value, but meant that
>       simple cleanup with just a call to flush_work() wasn't good
>       enough.
> 
>     - Added a simple function with a FIXME item for MC firmware check in
>       "crypto: caam - enable prediction resistance in HRWNG"
> 
>     - "crypto: caam - limit single JD RNG output to maximum of 16
>       bytes" now shrinks async FIFO size from 32K to 64 bytes, since
>       having a buffer that big doesn't seem to do any good given that
>       througput of TRNG
> 
> Changes since [v7]:
> 
>     - Collected Reviewd-bys from Horia
> 
>     - updated "crypto: caam - simplify RNG implementation" to drop
>       custom type and fix comments
> 
>     - updated "crypto: caam - enable prediction resistance in HRWNG"
>       to integrate code from Andrei Botila
> 
>     - updated "crypto: caam - drop global context pointer and
>       init_done" to use .priv instead of container_of for private data
>       pointer
> 
> Changes since [v8]
> 
>     - Collected more Reviewd-bys from Horia
> 
>     - Pulled "bus: fsl-mc: add api to retrieve mc version" into the set_
> 
>     - Moved RNG quality setting back to "crypto: caam - limit single
>       JD RNG output to maximum of 16 bytes" where it belongs
> 
>     - Fixed comparison and checkpatch warnings in "crypto: caam -
>       enable prediction resistance in HRWNG" per feedback from Horia
> 
> 
> Feedback is welcome!
> 
> Thanks,
> Andrey Smirnov
> 
> [discussion] https://patchwork.kernel.org/patch/9850669/
> [v1] https://lore.kernel.org/lkml/20191029162916.26579-1-andrew.smirnov@gmail.com
> [v2] https://lore.kernel.org/lkml/20191118153843.28136-1-andrew.smirnov@gmail.com
> [v3] https://lore.kernel.org/lkml/20191120165341.32669-1-andrew.smirnov@gmail.com
> [v4] https://lore.kernel.org/lkml/20191121155554.1227-1-andrew.smirnov@gmail.com
> [v5] https://lore.kernel.org/lkml/20191203162357.21942-1-andrew.smirnov@gmail.com
> [v6] https://lore.kernel.org/lkml/20200108154047.12526-1-andrew.smirnov@gmail.com
> [v7] https://lore.kernel.org/lkml/20200127165646.19806-1-andrew.smirnov@gmail.com
> [v8] https://lore.kernel.org/lkml/20200316150047.30828-1-andrew.smirnov@gmail.com
> 
> Andrei Botila (1):
>   bus: fsl-mc: add api to retrieve mc version
> 
> Andrey Smirnov (8):
>   crypto: caam - allocate RNG instantiation descriptor with GFP_DMA
>   crypto: caam - use struct hwrng's .init for initialization
>   crypto: caam - drop global context pointer and init_done
>   crypto: caam - simplify RNG implementation
>   crypto: caam - check if RNG job failed
>   crypto: caam - invalidate entropy register during RNG initialization
>   crypto: caam - enable prediction resistance in HRWNG
>   crypto: caam - limit single JD RNG output to maximum of 16 bytes
> 
>  drivers/bus/fsl-mc/fsl-mc-bus.c |  33 +--
>  drivers/crypto/caam/Kconfig     |   1 +
>  drivers/crypto/caam/caamrng.c   | 405 ++++++++++++--------------------
>  drivers/crypto/caam/ctrl.c      |  88 +++++--
>  drivers/crypto/caam/desc.h      |   2 +
>  drivers/crypto/caam/intern.h    |   7 +-
>  drivers/crypto/caam/jr.c        |  13 +-
>  drivers/crypto/caam/regs.h      |   7 +-
>  include/linux/fsl/mc.h          |  16 ++
>  9 files changed, 276 insertions(+), 296 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
