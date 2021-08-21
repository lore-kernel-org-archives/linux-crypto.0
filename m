Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB413C4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 07:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8B73611C9
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Aug 2021 07:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhHUHu1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Aug 2021 03:50:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53806 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232469AbhHUHu1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Aug 2021 03:50:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mHLlD-0006Dh-DF; Sat, 21 Aug 2021 15:49:47 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mHLl7-0000tf-QD; Sat, 21 Aug 2021 15:49:41 +0800
Date:   Sat, 21 Aug 2021 15:49:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        qat-linux@intel.com, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH v2 0/4] crypto: qat - fixes and cleanups
Message-ID: <20210821074941.GB3392@gondor.apana.org.au>
References: <20210812081816.275405-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812081816.275405-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 12, 2021 at 09:18:12AM +0100, Giovanni Cabiddu wrote:
> This is a rework of a set from Christophe JAILLET that implements a few
> fixes and clean-ups in the QAT drivers with the addition of a related
> patch.
> 
> This set removes the deprecated APIs pci_set_dma_mask() and
> pci_set_consistent_dma_mask(), changes the DMA mask for QAT Gen2
> devices, disables AER if an error occurs in the probe functions and
> fixes a typo in the description of adf_disable_aer()
> 
> Changes from v1:
> - Reworked patch #1 removing `else` related to 32 bits
> - Reworked patch #1 to remove shadow return code
> - Added patch to set DMA mask to 48 bits for QAT Gen2 devices
> 
> Christophe JAILLET (3):
>   crypto: qat - simplify code and axe the use of a deprecated API
>   crypto: qat - disable AER if an error occurs in probe functions
>   crypto: qat - fix a typo in a comment
> 
> Giovanni Cabiddu (1):
>   crypto: qat - set DMA mask to 48 bits for Gen2
> 
>  drivers/crypto/qat/qat_4xxx/adf_drv.c       | 14 ++++----------
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 21 ++++++++-------------
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 15 ++++-----------
>  drivers/crypto/qat/qat_c62x/adf_drv.c       | 21 ++++++++-------------
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 15 ++++-----------
>  drivers/crypto/qat/qat_common/adf_aer.c     |  2 +-
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 21 ++++++++-------------
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 15 ++++-----------
>  8 files changed, 41 insertions(+), 83 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
