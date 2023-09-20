Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D72CCE79AE
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 05:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjITFYJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 01:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbjITFXu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 01:23:50 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32571997
        for <linux-crypto@vger.kernel.org>; Tue, 19 Sep 2023 22:22:49 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qipfg-00GD68-Lp; Wed, 20 Sep 2023 13:22:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Sep 2023 13:22:47 +0800
Date:   Wed, 20 Sep 2023 13:22:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Adam Guerin <adam.guerin@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] enable dc chaining service
Message-ID: <ZQqBp/UqjpiDoSfw@gondor.apana.org.au>
References: <20230914141413.466155-1-adam.guerin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914141413.466155-1-adam.guerin@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 14, 2023 at 03:14:11PM +0100, Adam Guerin wrote:
> This set adds a new configuration option for QAT GEN4 devices allowing the
> device to now be configured for chained compression operations in userspace.
> Refactoring data structures relating to device configuration to avoid
> duplication.
> 
> Adam Guerin (1):
>   crypto: qat - enable dc chaining service
> 
> Giovanni Cabiddu (1):
>   crypto: qat - consolidate services structure
> 
>  Documentation/ABI/testing/sysfs-driver-qat    |  2 +
>  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 56 ++++++++++---------
>  drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   | 34 ++---------
>  .../crypto/intel/qat/qat_common/adf_admin.c   | 39 +++++++++++--
>  .../intel/qat/qat_common/adf_cfg_services.h   | 34 +++++++++++
>  .../intel/qat/qat_common/adf_cfg_strings.h    |  1 +
>  .../crypto/intel/qat/qat_common/adf_sysfs.c   | 17 +-----
>  .../qat/qat_common/icp_qat_fw_init_admin.h    |  1 +
>  8 files changed, 113 insertions(+), 71 deletions(-)
>  create mode 100644 drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
> 
> 
> base-commit: ed12943d6c00be183e876059089792b94f9d3790
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
