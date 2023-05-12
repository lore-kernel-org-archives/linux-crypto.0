Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628A9C77B75
	for <linux-crypto@archiver.kernel.org>; Fri, 12 May 2023 11:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbjELK7v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 May 2023 06:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbjELK7d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2023 06:59:33 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A5011D93
        for <linux-crypto@vger.kernel.org>; Fri, 12 May 2023 03:59:31 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pxQUe-008CAQ-M7; Fri, 12 May 2023 18:59:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 May 2023 18:59:25 +0800
Date:   Fri, 12 May 2023 18:59:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        bbrezillon@kernel.org, arno@natisbad.org
Subject: Re: [PATCH 0/2] crypto: octeontx2: hardware configuration for inline
 IPsec
Message-ID: <ZF4cDZWbDf2cJCDK@gondor.apana.org.au>
References: <20230425140620.2031480-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425140620.2031480-1-schalla@marvell.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 25, 2023 at 07:36:18PM +0530, Srujana Challa wrote:
> On OcteonTX2/OctoenTX3 variants of silicon, Admin function (AF)
> handles resource allocation and configuration for PFs and their VFs.
> PFs request the AF directly, via mailboxes.
> Unlike PFs, VFs cannot send a mailbox request directly. A VF sends
> mailbox messages to its parent PF, with which it shares a
> mailbox region. The PF then forwards these messages to the AF.
> 
> Patch1 adds AF to CPT PF uplink mbox to submit the CPT instructions
> from AF.
> Patch2 adds code to configure inline-IPsec HW resources for
> CPT VFs as CPT VFs cannot send a mailbox request directly to AF.
> 
> Srujana Challa (2):
>   crypto: octeontx2: add support for AF to CPT PF uplink mbox
>   crypto: octeontx2: hardware configuration for inline IPsec
> 
>  .../marvell/octeontx2/otx2_cpt_common.h       |  15 ++
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c  |   3 +
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  34 +--
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  33 ++-
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   7 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |  41 +++
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       | 247 +++++++++++++++++-
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  10 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   1 +
>  .../marvell/octeontx2/otx2_cptvf_main.c       |   8 +-
>  10 files changed, 359 insertions(+), 40 deletions(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
