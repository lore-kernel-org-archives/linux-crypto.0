Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D802C43334
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jul 2022 07:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237351AbiGHH6i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jul 2022 03:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbiGHH6h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jul 2022 03:58:37 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321751260E
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2022 00:58:35 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o9isQ-00Frpi-NT; Fri, 08 Jul 2022 17:58:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Jul 2022 15:58:14 +0800
Date:   Fri, 8 Jul 2022 15:58:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v2 0/4] crypto: qat - enable configuration for 4xxx
Message-ID: <YsfjlnxTcNDJCETk@gondor.apana.org.au>
References: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 27, 2022 at 09:36:48AM +0100, Giovanni Cabiddu wrote:
> qat_4xxx devices can be configured to allow either crypto or compression
> operations. By default, devices are configured statically according
> to following rule:
> - odd numbered devices assigned to compression services
> - even numbered devices assigned to crypto services
> 
> This set exposes two attributes in sysfs that allow to report and change
> the state and the configuration of a QAT 4xxx device.
> The first, /sys/bus/pci/devices/<BDF>/qat/state, allows to bring a
> device down in order to change the configuration, and bring it up again.
> The second, /sys/bus/pci/devices/<BDF>/qat/cfg_services, allows to
> inspect the current configuration of a device (i.e. crypto or
> compression) and change it.
> 
>     # cat /sys/bus/pci/devices/<BDF>/qat/state
>     up
>     # cat /sys/bus/pci/devices/<BDF>/qat/cfg_services
>     sym;asym
>     # echo down > /sys/bus/pci/devices/<BDF>/qat/state
>     # echo dc > /sys/bus/pci/devices/<BDF>/qat/cfg_services
>     # echo up > /sys/bus/pci/devices/<BDF>/qat/state
>     # cat /sys/bus/pci/devices/<BDF>/qat/state
>     dc
> 
> Changes from v1:
>  - Updated target kernel version in documentation (from 5.19 to 5.20).
>  - Fixed commit message in patch #1 and updated documentation in patch
>    #4 after review from Vladis Dronov.
> 
> Giovanni Cabiddu (4):
>   crypto: qat - expose device state through sysfs for 4xxx
>   crypto: qat - change behaviour of adf_cfg_add_key_value_param()
>   crypto: qat - relocate and rename adf_sriov_prepare_restart()
>   crypto: qat - expose device config through sysfs for 4xxx
> 
>  Documentation/ABI/testing/sysfs-driver-qat    |  61 ++++++
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   1 +
>  .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |   1 +
>  drivers/crypto/qat/qat_4xxx/adf_drv.c         |   6 +-
>  drivers/crypto/qat/qat_common/Makefile        |   1 +
>  .../crypto/qat/qat_common/adf_accel_devices.h |   1 +
>  drivers/crypto/qat/qat_common/adf_cfg.c       |  41 +++-
>  .../crypto/qat/qat_common/adf_common_drv.h    |   3 +
>  drivers/crypto/qat/qat_common/adf_init.c      |  26 +++
>  drivers/crypto/qat/qat_common/adf_sriov.c     |  28 +--
>  drivers/crypto/qat/qat_common/adf_sysfs.c     | 191 ++++++++++++++++++
>  11 files changed, 331 insertions(+), 29 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-qat
>  create mode 100644 drivers/crypto/qat/qat_common/adf_sysfs.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
