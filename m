Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C5CC64EC4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 11:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCJLbm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCJLbj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 06:31:39 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760D0EABAE
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 03:31:37 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paayB-002Y90-UX; Fri, 10 Mar 2023 19:31:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 19:31:31 +0800
Date:   Fri, 10 Mar 2023 19:31:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shashank Gupta <shashank.gupta@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/5] crypto: qat - fix concurrency related issues
Message-ID: <ZAsVE24KVKyoYhJ2@gondor.apana.org.au>
References: <20230227205545.5796-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230227205545.5796-1-shashank.gupta@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 27, 2023 at 03:55:40PM -0500, Shashank Gupta wrote:
> This set fixes issues related to using unprotected QAT device state    
> machine functions that might cause concurrency issues at the time of state  
> transition.
> 
> The first patch fixes the QAT 4XXX device's unexpected behaviour that
> might occur if the user changes the device state or configuration via
> sysfs while the driver performing device bring-up. The sequence is changed
> in the probe function now the sysfs attribute is created after the device
> initialization.
> 
> The second patch fixes the concurrency issue in the sysfs `state` 
> attribute if multiple processes change the state of the qat device in 
> parallel. The change introduces the protected wrapper function 
> adf_dev_up() and adf_dev_down() that protects the transition of the device
> state. These are used in adf_sysfs.c instead of low-level state machine 
> functions.
> 
> The third patch replaces the use of unsafe low-level device state machine 
> function with its protected wrapper functions.
> 
> The forth patch refactor device restart logic by moving it into 
> adf_dev_restart() which uses safe adf_dev_up() and adf_dev_down().
> 
> The fifth patch define state machine functions static as they are unsafe
> to use for state transition now performed by safe adf_dev_up() and 
> adf_dev_down().
> 
> Shashank Gupta (5):
>   crypto: qat - delay sysfs initialization
>   crypto: qat - fix concurrency issue when device state changes
>   crypto: qat - replace state machine calls
>   crypto: qat - refactor device restart logic
>   crypto: qat - make state machine functions static
> 
>  drivers/crypto/qat/qat_4xxx/adf_drv.c             | 21 ++---
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c            | 17 +---
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c          | 13 +--
>  drivers/crypto/qat/qat_c62x/adf_drv.c             | 17 +---
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c           | 13 +--
>  drivers/crypto/qat/qat_common/adf_accel_devices.h |  1 +
>  drivers/crypto/qat/qat_common/adf_aer.c           |  4 +-
>  drivers/crypto/qat/qat_common/adf_common_drv.h    |  8 +-
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c       | 27 +++----
>  drivers/crypto/qat/qat_common/adf_dev_mgr.c       |  2 +
>  drivers/crypto/qat/qat_common/adf_init.c          | 96 ++++++++++++++++++++---
>  drivers/crypto/qat/qat_common/adf_sriov.c         | 10 +--
>  drivers/crypto/qat/qat_common/adf_sysfs.c         | 23 +-----
>  drivers/crypto/qat/qat_common/adf_vf_isr.c        |  3 +-
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c         | 17 +---
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c       | 13 +--
>  16 files changed, 132 insertions(+), 153 deletions(-)
> 
> -- 
> 2.16.4

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
