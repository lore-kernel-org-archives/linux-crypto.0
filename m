Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EE0C47096
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F971613E6
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFCMcg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:32:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60906 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhFCMcg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 08:32:36 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lomUs-000207-Pb; Thu, 03 Jun 2021 20:30:50 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lomUp-0001ev-9c; Thu, 03 Jun 2021 20:30:47 +0800
Date:   Thu, 3 Jun 2021 20:30:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        arno@natisbad.org, bbrezillon@kernel.org, jerinj@marvell.com
Subject: Re: [PATCH 0/4] Add support for Marvell CN10K CPT block
Message-ID: <20210603123047.GF6161@gondor.apana.org.au>
References: <20210525112718.18288-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525112718.18288-1-schalla@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 25, 2021 at 04:57:14PM +0530, Srujana Challa wrote:
> The current CPT driver supports OcteonTX2 silicon variants.
> The same OcteonTX2 Resource Virtualization Unit(RVU) is
> carried forward to the next-gen silicon ie OcteonTX3(CN10K),
> with some changes and feature enhancements.
> 
> This patch series adds support for CN10K silicon.
> 
> Srujana Challa (4):
>   crypto: octeontx2: Add mailbox support for CN10K
>   crypto: octeontx2: add support to map LMTST region for CN10K
>   crypto: octeontx2: add support for CPT operations on CN10K
>   crypto: octeontx2: enable and handle ME interrupts
> 
>  drivers/crypto/marvell/octeontx2/Makefile     |  13 +-
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  93 ++++++++++
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  36 ++++
>  .../marvell/octeontx2/otx2_cpt_common.h       |  23 +++
>  .../marvell/octeontx2/otx2_cpt_hw_types.h     |  16 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c |   9 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  10 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   1 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       | 160 +++++++++++++-----
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  32 +++-
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |   8 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   3 +
>  .../marvell/octeontx2/otx2_cptvf_main.c       |  49 ++++--
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  43 +++++
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  17 +-
>  15 files changed, 438 insertions(+), 75 deletions(-)
>  create mode 100644 drivers/crypto/marvell/octeontx2/cn10k_cpt.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/cn10k_cpt.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
