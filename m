Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F68EC04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD1820879
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfEWGug (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 02:50:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47750 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWGug (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 02:50:36 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hThYf-0001lG-N7; Thu, 23 May 2019 14:50:33 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hThYb-0006A4-RX; Thu, 23 May 2019 14:50:29 +0800
Date:   Thu, 23 May 2019 14:50:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH v2 0/7] crypto: caam - IOMMU support
Message-ID: <20190523065029.lk2m6pohdderwakn@gondor.apana.org.au>
References: <20190503141743.27129-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190503141743.27129-1-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 03, 2019 at 05:17:36PM +0300, Horia Geantă wrote:
> This patch set adds support in caam drivers (caam/jr, caam/qi, caam/qi2)
> for the crypto engine to work behind an IOMMU.
> 
> v2:
> Fixed compilation warnings (unused variables) in patch 3/7.
> 
> v1:
> 
> The changes consist in:
> 
> 1. Deferred probing support
> -caam/jr - top level drivers are converted to "libraries"; this also fixes
> the issue reported previously by Marcin:
> https://patchwork.kernel.org/cover/10558409/
> -caam/qi - use the newly added QBMan functions (*) to decide whether to defer
> caam controller probing or not
> 
> 2. Fixing spurios memory accesses, that lead to IOMMU access faults
> -crypto engine prefetches S/G table entries in chunks of 4 (64 bytes),
> and driver has to make sure memory is allocated and mapped
> -crypto engine tries to prefetch S/G table entries when input / output
> is marked as scattered, even though length is zero
> 
> 3. Getting rid of platform device created by caam/qi
> There are inherent problems with platform device being created dynamically
> (and not relying on the existence of a DT node).
> 
> 4. Update phys -> virt address translation in case IOMMU is present
> iova -> phys -> virt
> 
> 5. Fix the device used for key buffers DMA mapping
> Key buffers are incorrectly DMA mapped using a job ring device, since they
> are accessed eventually by the QI - this creating an ICID / stream ID
> mismatch at IOMMU level.
> 
> Tests were performed on:
> -LS1046A - caam/jr and caam/qi - job ring and queue interface
> -LS1088A - caam/jr and caam/qi2 - job ring and dpsec interface
> 
> There are some dependencies (see below).
> While not everything is in place, I would like at least to patches 1-6/7
> being reviewed & merged.
> 
> i. Patch 7/7 (crypto: caam - defer probing until QMan is available) depends
> on commit 1c8f39946c03 ("soc: fsl: qbman_portals: add APIs to retrieve the probing status")
> from Leo's tree: git://git.kernel.org/pub/scm/linux/kernel/git/leo/linux.git
> and should not be merged.
> 
> ii. U-boot updates for LS1088A (needed for caam/jr ICID programming)
> [U-Boot,1/2] armv8: fsl-layerscape: add missing sec jr base address defines
> https://patchwork.ozlabs.org/patch/1059256/
> [U-Boot,2/2] armv8: ls1088a: add icid setup for platform devices
> https://patchwork.ozlabs.org/patch/1059259/
> 
> Horia Geantă (7):
>   crypto: caam - avoid S/G table fetching for AEAD zero-length output
>   crypto: caam - fix S/G table passing page boundary
>   crypto: caam - convert top level drivers to libraries
>   crypto: caam/qi - don't allocate an extra platform device
>   crypto: caam/qi - fix address translations with IOMMU enabled
>   crypto: caam/qi - DMA map keys using proper device
>   crypto: caam - defer probing until QMan is available
> 
>  drivers/crypto/caam/Kconfig       |  46 ++++-------
>  drivers/crypto/caam/Makefile      |  18 ++---
>  drivers/crypto/caam/caamalg.c     |  74 ++++++++----------
>  drivers/crypto/caam/caamalg_qi.c  | 124 +++++++++++++++---------------
>  drivers/crypto/caam/caamalg_qi2.c |  72 +++++++++++++----
>  drivers/crypto/caam/caamhash.c    |  81 ++++++-------------
>  drivers/crypto/caam/caampkc.c     |  57 +++-----------
>  drivers/crypto/caam/caamrng.c     |  54 ++-----------
>  drivers/crypto/caam/ctrl.c        | 124 ++++++++++++++++++------------
>  drivers/crypto/caam/desc_constr.h |  11 +++
>  drivers/crypto/caam/intern.h      | 102 ++++++++++++++++++++++--
>  drivers/crypto/caam/jr.c          |  43 +++++++++++
>  drivers/crypto/caam/qi.c          |  52 ++++++-------
>  13 files changed, 465 insertions(+), 393 deletions(-)

Patches 1-6 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
