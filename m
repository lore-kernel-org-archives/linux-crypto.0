Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F6FCE79AD
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 05:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbjITFXz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 01:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjITFXe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 01:23:34 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDC8170A
        for <linux-crypto@vger.kernel.org>; Tue, 19 Sep 2023 22:22:40 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qipfW-00GD5w-Sh; Wed, 20 Sep 2023 13:22:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Sep 2023 13:22:37 +0800
Date:   Wed, 20 Sep 2023 13:22:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/5] crypto: qat - state change fixes
Message-ID: <ZQqBnSWxblA1ib/s@gondor.apana.org.au>
References: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 14, 2023 at 10:55:44AM +0100, Giovanni Cabiddu wrote:
> This set combines a set of fixes in the QAT driver related to the core
> state machines and the change in state that can be triggered through
> sysfs.
> 
> Here is a summary of the changes:
> * Patch #1 resolves a bug that prevents resources to be freed up.
> * Patch #2 is a simple cleanup.
> * Patch #3 fix the behaviour of the command `up` triggered through a
>   write to  /sys/bus/pci/devices/<BDF>/qat/state.
> * Patches #4 and #5 fix a corner case in the un-registration of
>   algorithms in the state machines.
> 
> Giovanni Cabiddu (5):
>   crypto: qat - fix state machines cleanup paths
>   crypto: qat - do not shadow error code
>   crypto: qat - ignore subsequent state up commands
>   crypto: qat - fix unregistration of crypto algorithms
>   crypto: qat - fix unregistration of compression algorithms
> 
>  .../intel/qat/qat_common/adf_common_drv.h       |  2 ++
>  drivers/crypto/intel/qat/qat_common/adf_init.c  | 17 ++++++++---------
>  drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 15 ++++++++++++---
>  3 files changed, 22 insertions(+), 12 deletions(-)
> 
> 
> base-commit: be369945f2f612c40f771fe265db1ca658cdc0d1
> -- 
> 2.41.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
