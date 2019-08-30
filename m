Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70372C3A5A4
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F2A208CB
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 08:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfH3IXn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 04:23:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59634 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfH3IXn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 04:23:43 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i3cBp-0005Z9-Vm; Fri, 30 Aug 2019 18:23:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2019 18:23:20 +1000
Date:   Fri, 30 Aug 2019 18:23:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-crypto@vger.kernel.org, andrew.smirnov@gmail.com,
        christopher.spencer@sea.co.uk, cory.tusar@zii.aero,
        cphealy@gmail.com, l.stach@pengutronix.de, horia.geanta@nxp.com,
        aymen.sghaier@nxp.com, leonard.crestez@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/16] crypto: caam - Add i.MX8MQ support
Message-ID: <20190830082320.GA8729@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820202402.24951-1-andrew.smirnov@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> Everyone:
> 
> Picking up where Chris left off (I chatted with him privately
> beforehead), this series adds support for i.MX8MQ to CAAM driver. Just
> like [v1], this series is i.MX8MQ only.
> 
> Feedback is welcome!
> Thanks,
> Andrey Smirnov
> 
> Changes since [v7]:
> 
>  - Series rebase on latest cryptodev-2.6 (198429631a85)
> 
>  - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"
>    converted to use CTPR and MCFGR to determine CAAM pointer width
>    and renamed to "crypto: caam - select DMA address size at runtime"
> 
>  - Patch adding corresponding DT node added to the series
> 
> Changes since [v6]:
> 
>  - Fixed build problems in "crypto: caam - make CAAM_PTR_SZ dynamic"
> 
>  - Collected Reviewied-by from Horia
> 
>  - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"
>    is changed to check 'caam_ptr_sz' instead of using 'caam_imx'
>    
>  - Incorporated feedback for "crypto: caam - request JR IRQ as the
>    last step" and "crypto: caam - simplfy clock initialization"
> 
> Changes since [v5]:
> 
>  - Hunk replacing sizeof(*jrp->inpring) to SIZEOF_JR_INPENTRY in
>    "crypto: caam - don't hardcode inpentry size", lost in [v5], is
>    back
> 
>  - Collected Tested-by from Iuliana
> 
> Changes since [v4]:
> 
>  - Fixed missing sentinel element in "crypto: caam - simplfy clock
>    initialization"
>    
>  - Squashed all of the devers related patches into a single one and
>    converted IRQ allocation to use devres while at it
> 
>  - Added "crypto: caam - request JR IRQ as the last step" as
>    discussed
> 
> Changes since [v3]:
> 
>  - Patchset changed to select DMA size at runtime in order to enable
>    support for both i.MX8MQ and Layerscape at the same time. I only
>    tested the patches on i.MX6,7 and 8MQ, since I don't have access
>    to any of the Layerscape HW. Any help in that regard would be
>    appareciated.
> 
>  - Bulk clocks and their number are now stored as a part of struct
>    caam_drv_private to simplify allocation and cleanup code (no
>    special context needed)
>    
>  - Renamed 'soc_attr' -> 'imx_soc_match' for clarity
> 
> Changes since [v2]:
> 
>  - Dropped "crypto: caam - do not initialise clocks on the i.MX8" and
>    replaced it with "crypto: caam - simplfy clock initialization" and 
>    "crypto: caam - add clock entry for i.MX8MQ"
> 
> 
> Changes since [v1]
> 
>  - Series reworked to continue using register based interface for
>    queueing RNG initialization job, dropping "crypto: caam - use job
>    ring for RNG instantiation instead of DECO"
> 
>  - Added a patch to share DMA mask selection code
> 
>  - Added missing Signed-off-by for authors of original NXP tree
>    commits that this sereis is based on
> 
> [v7] lore.kernel.org/r/20190812200739.30389-1-andrew.smirnov@gmail.com
> [v6] lore.kernel.org/r/20190717152458.22337-1-andrew.smirnov@gmail.com
> [v5] lore.kernel.org/r/20190715201942.17309-1-andrew.smirnov@gmail.com
> [v4] lore.kernel.org/r/20190703081327.17505-1-andrew.smirnov@gmail.com
> [v3] lore.kernel.org/r/20190617160339.29179-1-andrew.smirnov@gmail.com
> [v2] lore.kernel.org/r/20190607200225.21419-1-andrew.smirnov@gmail.com
> [v1] https://patchwork.kernel.org/cover/10825625/
> 
> Andrey Smirnov (16):
>  crypto: caam - move DMA mask selection into a function
>  crypto: caam - simplfy clock initialization
>  crypto: caam - convert caam_jr_init() to use devres
>  crypto: caam - request JR IRQ as the last step
>  crytpo: caam - make use of iowrite64*_hi_lo in wr_reg64
>  crypto: caam - use ioread64*_hi_lo in rd_reg64
>  crypto: caam - drop 64-bit only wr/rd_reg64()
>  crypto: caam - share definition for MAX_SDLEN
>  crypto: caam - make CAAM_PTR_SZ dynamic
>  crypto: caam - move cpu_to_caam_dma() selection to runtime
>  crypto: caam - drop explicit usage of struct jr_outentry
>  crypto: caam - don't hardcode inpentry size
>  crypto: caam - select DMA address size at runtime
>  crypto: caam - always select job ring via RSR on i.MX8MQ
>  crypto: caam - add clock entry for i.MX8MQ
>  arm64: dts: imx8mq: Add CAAM node
> 
> arch/arm64/boot/dts/freescale/imx8mq.dtsi |  30 +++
> drivers/crypto/caam/caamalg.c             |   2 +-
> drivers/crypto/caam/caamalg_qi2.h         |  27 ---
> drivers/crypto/caam/caamhash.c            |   2 +-
> drivers/crypto/caam/caampkc.c             |   8 +-
> drivers/crypto/caam/caamrng.c             |   2 +-
> drivers/crypto/caam/ctrl.c                | 221 ++++++++++------------
> drivers/crypto/caam/desc_constr.h         |  47 ++++-
> drivers/crypto/caam/error.c               |   3 +
> drivers/crypto/caam/intern.h              |  32 +++-
> drivers/crypto/caam/jr.c                  |  93 +++------
> drivers/crypto/caam/pdb.h                 |  16 +-
> drivers/crypto/caam/pkc_desc.c            |   8 +-
> drivers/crypto/caam/qi.h                  |  26 ---
> drivers/crypto/caam/regs.h                | 140 ++++++++++----
> 15 files changed, 359 insertions(+), 298 deletions(-)

Patches 1-15 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
