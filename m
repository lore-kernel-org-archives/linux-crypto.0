Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB10C47096
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF2B613F0
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhFCMR3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:17:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60756 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFCMR3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 08:17:29 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lomGF-0001iG-Jo; Thu, 03 Jun 2021 20:15:43 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lomG9-0000aD-PV; Thu, 03 Jun 2021 20:15:37 +0800
Date:   Thu, 3 Jun 2021 20:15:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Marco Chiappero <marco.chiappero@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH 02/10] crypto: qat - remove empty sriov_configure()
Message-ID: <20210603121537.GA2062@gondor.apana.org.au>
References: <20210527191251.6317-1-marco.chiappero@intel.com>
 <20210527191251.6317-3-marco.chiappero@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527191251.6317-3-marco.chiappero@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 27, 2021 at 08:12:43PM +0100, Marco Chiappero wrote:
> Remove the empty implementation of sriov_configure() and set the
> sriov_configure member of the pci_driver structure to NULL.
> This way, if a user tries to enable VFs on a device, when kernel and
> driver are built with CONFIG_PCI_IOV=n, the kernel reports an error
> message saying that the driver does not support SRIOV configuration via
> sysfs.
> 
> Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
> Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/qat/qat_4xxx/adf_drv.c          | 2 ++
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c         | 2 ++
>  drivers/crypto/qat/qat_c62x/adf_drv.c          | 2 ++
>  drivers/crypto/qat/qat_common/adf_common_drv.h | 5 -----
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c      | 2 ++
>  5 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
> index a8805c815d16..b77290d3da10 100644
> --- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
> +++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
> @@ -309,7 +309,9 @@ static struct pci_driver adf_driver = {
>  	.name = ADF_4XXX_DEVICE_NAME,
>  	.probe = adf_probe,
>  	.remove = adf_remove,
> +#ifdef CONFIG_PCI_IOV
>  	.sriov_configure = adf_sriov_configure,
> +#endif

How about #defining adf_sriov_configure to NULL?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
