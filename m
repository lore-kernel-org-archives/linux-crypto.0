Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEBDC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 06:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA0F238D7
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 06:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbhAVGWB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jan 2021 01:22:01 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54122 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbhAVGV7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jan 2021 01:21:59 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l2pod-00021l-Tr; Fri, 22 Jan 2021 17:21:05 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Jan 2021 17:21:03 +1100
Date:   Fri, 22 Jan 2021 17:21:03 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        pathreya@marvell.com, jerinj@marvell.com
Subject: Re: [PATCH v2 0/9] Add Support for Marvell OcteonTX2 CPT engine
Message-ID: <20210122062103.GC1217@gondor.apana.org.au>
References: <20210115135227.20909-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115135227.20909-1-schalla@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 15, 2021 at 07:22:18PM +0530, Srujana Challa wrote:
> This series introduces crypto(CPT) drivers(PF & VF) for Marvell
> OcteonTX2 CN96XX Soc.
> 
> OcteonTX2 SOC's resource virtualization unit (RVU) supports multiple
> physical and virtual functions. Each of the PF/VF's functionality is
> determined by what kind of resources are attached to it. When the CPT
> block is attached to a VF, it can function as a security device.
> 
> The CPT PF driver is responsible for:
> - Forwarding messages to/from VFs from/to admin function(AF),
> - Enabling/disabling VFs,
> - Loading/unloading microcode (creation/deletion of engine groups).
> 
> The CPT VF driver works as a crypto offload device.
> 
> This patch series includes:
> - CPT PF driver patches that include AF<=>PF<=>VF mailbox communication,
> sriov_configure, and firmware load to the acceleration engines.
> - CPT VF driver patches that include VF<=>PF mailbox communication and
> crypto offload support through the kernel cryptographic API.
> 
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.
> 
> Changes since v1:
> * Resolved compilation warning.
> 
> 
> Srujana Challa (9):
>   drivers: crypto: add Marvell OcteonTX2 CPT PF driver
>   crypto: octeontx2: add mailbox communication with AF
>   crypto: octeontx2: enable SR-IOV and mailbox communication with VF
>   crypto: octeontx2: load microcode and create engine groups
>   crypto: octeontx2: add LF framework
>   crypto: octeontx2: add support to get engine capabilities
>   crypto: octeontx2: add virtual function driver support
>   crypto: octeontx2: add support to process the crypto request
>   crypto: octeontx2: register with linux crypto framework
> 
>  drivers/crypto/marvell/Kconfig                |   14 +
>  drivers/crypto/marvell/Makefile               |    1 +
>  drivers/crypto/marvell/octeontx2/Makefile     |   10 +
>  .../marvell/octeontx2/otx2_cpt_common.h       |  137 ++
>  .../marvell/octeontx2/otx2_cpt_hw_types.h     |  464 +++++
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  202 ++
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  197 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  429 ++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  353 ++++
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   61 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |  713 +++++++
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  356 ++++
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      | 1415 +++++++++++++
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |  162 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   29 +
>  .../marvell/octeontx2/otx2_cptvf_algs.c       | 1758 +++++++++++++++++
>  .../marvell/octeontx2/otx2_cptvf_algs.h       |  178 ++
>  .../marvell/octeontx2/otx2_cptvf_main.c       |  410 ++++
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  167 ++
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  541 +++++
>  20 files changed, 7597 insertions(+)
>  create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
