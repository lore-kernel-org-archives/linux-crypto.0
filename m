Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE74C4332B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 03:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBBDC20732
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 03:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCTDvU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 23:51:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33904 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgCTDvU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 23:51:20 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jF8gj-0001XP-OB; Fri, 20 Mar 2020 14:51:14 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Mar 2020 14:51:13 +1100
Date:   Fri, 20 Mar 2020 14:51:13 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        pathreya@marvell.com, schandran@marvell.com, arno@natisbad.org,
        bbrezillon@kernel.org
Subject: Re: [PATCH v2 0/4] Add Support for Marvell OcteonTX Cryptographic
Message-ID: <20200320035113.GF27372@gondor.apana.org.au>
References: <1584100028-21279-1-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584100028-21279-1-git-send-email-schalla@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 13, 2020 at 05:17:04PM +0530, Srujana Challa wrote:
> The following series adds support for Marvell Cryptographic Accelerarion
> Unit (CPT) on OcteonTX CN83XX SoC.
> 
> Changes since v1:
> * Replaced CRYPTO_BLKCIPHER with CRYPTO_SKCIPHER in Kconfig.
> 
> Srujana Challa (4):
>   drivers: crypto: create common Kconfig and Makefile for Marvell
>   drivers: crypto: add support for OCTEON TX CPT engine
>   drivers: crypto: add the Virtual Function driver for CPT
>   crypto: marvell: enable OcteonTX cpt options for build
> 
>  MAINTAINERS                                        |    1 +
>  drivers/crypto/Kconfig                             |   15 +-
>  drivers/crypto/Makefile                            |    2 +-
>  drivers/crypto/marvell/Kconfig                     |   37 +
>  drivers/crypto/marvell/Makefile                    |    7 +-
>  drivers/crypto/marvell/cesa.c                      |  615 -------
>  drivers/crypto/marvell/cesa.h                      |  880 ----------
>  drivers/crypto/marvell/cesa/Makefile               |    3 +
>  drivers/crypto/marvell/cesa/cesa.c                 |  615 +++++++
>  drivers/crypto/marvell/cesa/cesa.h                 |  881 ++++++++++
>  drivers/crypto/marvell/cesa/cipher.c               |  801 +++++++++
>  drivers/crypto/marvell/cesa/hash.c                 | 1448 ++++++++++++++++
>  drivers/crypto/marvell/cesa/tdma.c                 |  352 ++++
>  drivers/crypto/marvell/cipher.c                    |  798 ---------
>  drivers/crypto/marvell/hash.c                      | 1442 ----------------
>  drivers/crypto/marvell/octeontx/Makefile           |    6 +
>  drivers/crypto/marvell/octeontx/otx_cpt_common.h   |   51 +
>  drivers/crypto/marvell/octeontx/otx_cpt_hw_types.h |  824 +++++++++
>  drivers/crypto/marvell/octeontx/otx_cptpf.h        |   34 +
>  drivers/crypto/marvell/octeontx/otx_cptpf_main.c   |  307 ++++
>  drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c   |  253 +++
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  | 1686 +++++++++++++++++++
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h  |  180 ++
>  drivers/crypto/marvell/octeontx/otx_cptvf.h        |  104 ++
>  drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   | 1744 ++++++++++++++++++++
>  drivers/crypto/marvell/octeontx/otx_cptvf_algs.h   |  188 +++
>  drivers/crypto/marvell/octeontx/otx_cptvf_main.c   |  985 +++++++++++
>  drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c   |  247 +++
>  drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c |  612 +++++++
>  drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h |  227 +++
>  drivers/crypto/marvell/tdma.c                      |  350 ----
>  31 files changed, 11592 insertions(+), 4103 deletions(-)
>  create mode 100644 drivers/crypto/marvell/Kconfig
>  delete mode 100644 drivers/crypto/marvell/cesa.c
>  delete mode 100644 drivers/crypto/marvell/cesa.h
>  create mode 100644 drivers/crypto/marvell/cesa/Makefile
>  create mode 100644 drivers/crypto/marvell/cesa/cesa.c
>  create mode 100644 drivers/crypto/marvell/cesa/cesa.h
>  create mode 100644 drivers/crypto/marvell/cesa/cipher.c
>  create mode 100644 drivers/crypto/marvell/cesa/hash.c
>  create mode 100644 drivers/crypto/marvell/cesa/tdma.c
>  delete mode 100644 drivers/crypto/marvell/cipher.c
>  delete mode 100644 drivers/crypto/marvell/hash.c
>  create mode 100644 drivers/crypto/marvell/octeontx/Makefile
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cpt_common.h
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cpt_hw_types.h
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf.h
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf.h
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
>  create mode 100644 drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.h
>  delete mode 100644 drivers/crypto/marvell/tdma.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
