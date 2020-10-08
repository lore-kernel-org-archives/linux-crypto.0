Return-Path: <SRS0=kcel=DP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0869EC433E7
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 05:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEDCD2087D
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Oct 2020 05:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgJHFnv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Oct 2020 01:43:51 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41200 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgJHFnv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Oct 2020 01:43:51 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kQOiP-0006Rz-LX; Thu, 08 Oct 2020 16:43:46 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2020 16:43:46 +1100
Date:   Thu, 8 Oct 2020 16:43:46 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH] crypto: qat - fix function parameters descriptions
Message-ID: <20201008054345.GA9733@gondor.apana.org.au>
References: <20200930221747.553707-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930221747.553707-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 30, 2020 at 11:17:47PM +0100, Giovanni Cabiddu wrote:
> Fix description of function parameters. This is to fix the following
> warnings when compiling the driver with W=1:
> 
>     drivers/crypto/qat/qat_common/adf_sriov.c:133: warning: Function parameter or member 'numvfs' not described in 'adf_sriov_configure'
>     drivers/crypto/qat/qat_common/adf_dev_mgr.c:296: warning: Function parameter or member 'pci_dev' not described in 'adf_devmgr_pci_to_accel_dev'
>     drivers/crypto/qat/qat_common/adf_dev_mgr.c:296: warning: Excess function parameter 'accel_dev' description in 'adf_devmgr_pci_to_accel_dev'
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_dev_mgr.c | 2 +-
>  drivers/crypto/qat/qat_common/adf_sriov.c   | 6 +++++-
>  2 files changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
