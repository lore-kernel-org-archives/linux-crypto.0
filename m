Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E663EC43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 15:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F132077B
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575905596;
	bh=xv8UuW5kDA/p9HUZoET8W9XCTuTQpr0pivWsPRLO79w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DY8t/k5u0hBi2C1F1y2G8QhsMk0KZQ0/SSnI9KHs6aq91J8Mz0XyKD4Y4DQ6di8um
	 w0RWYQm0ezpr2T+V3WYypnYE3IqXDlJogwrgHQvX3+FTQpw1wdULrIMUHO6AxpFWrI
	 zdpBPVhQumoT6b1gaJKejwCV8sMrmVlBpB6Yo7xA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLIPdQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 10:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfLIPdQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 10:33:16 -0500
Received: from localhost (unknown [89.205.132.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7268920692;
        Mon,  9 Dec 2019 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575905595;
        bh=xv8UuW5kDA/p9HUZoET8W9XCTuTQpr0pivWsPRLO79w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xXFiZwDUwjN540ONucZ4zM78TX6Ztxvpi+8utG5Ckm7577MrtEAwRzmU1n4YxJ3+s
         8petGSWeSlrgrDkgL+TIPZtoB2eypNsJbPZRcffsuGD92tETDzCLlYkJCAwNhnIU/O
         YjQ0ZzBKF4m7fYXdDsiJpFI8hqIQQsKqHWLbG0Zw=
Date:   Mon, 9 Dec 2019 16:33:10 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Kim, David" <david.kim@ncipher.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Magee, Tim" <tim.magee@ncipher.com>
Subject: Re: [PATCH] drivers: staging: Add support for nCipher HSM devices
Message-ID: <20191209153310.GD1280846@kroah.com>
References: <1575899815003.20486@ncipher.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1575899815003.20486@ncipher.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 09, 2019 at 01:56:55PM +0000, Kim, David wrote:
> 
> Hi everybody,
> ​
> This patch introduces a driver for nCipher's Solo and Solo XC range of PCIe
> hardware security modules (HSM), which provide key creation/management
> and cryptography services.
> 
> Upstreaming the nCipher driver into the kernel will allow early adopters
> of the latest kernel to upgrade and maintain their working systems when
> using an nCipher PCIe HSM. Further, having this driver in the kernel will be
> more convenient to our users and make a Linux based solution a more
> attractive option for others.​

Odd characters at your line-end here :(

> 
> Regards,
> Dave Kim


No need for the "Hi" and "regards" in a changelog text :)

Most importantly, why is this being submitted for the staging directory?
What is keeping it from being added to the "real" part of the kernel
now?

If you need/want it in drivers/staging/ then you need a TODO file that
lists what needs to be done to it in order to get out of
drivers/staging/

thanks,

greg k-h

> 
> Co-developed-by: Tim Magee <tim.magee@ncipher.com>
> Signed-off-by: Tim Magee <tim.magee@ncipher.com>
> Signed-off-by: David Kim <david.kim@ncipher.com>​

Odd line-end here :(


> 
> 
>  MAINTAINERS                       |    8 +
>  drivers/staging/Kconfig           |    1 +
>  drivers/staging/Makefile          |    1 +
>  drivers/staging/ncipher/Kconfig   |    8 +
>  drivers/staging/ncipher/Makefile  |    7 +
>  drivers/staging/ncipher/fsl.c     |  911 ++++++++++++++++++++++
>  drivers/staging/ncipher/fsl.h     |  117 +++
>  drivers/staging/ncipher/hostif.c  | 1521 +++++++++++++++++++++++++++++++++++++
>  drivers/staging/ncipher/i21555.c  |  553 ++++++++++++++
>  drivers/staging/ncipher/i21555.h  |   68 ++
>  drivers/staging/ncipher/solo.h    |  316 ++++++++
>  include/uapi/linux/nshield_solo.h |  181 +++++
>  12 files changed, 3692 insertions(+)
> 
> 
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 061d59a4a80b..c1125c999b95 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12605,6 +12605,14 @@ L: linux-pci@vger.kernel.org
>  S: Supported
>  F: drivers/pci/controller/vmd.c
> 
> +PCI DRIVER FOR NSHIELD SOLO AND SOLO XC HARDWARE SECURITY MODULES (HSM)
> +M: Tim Magee <tim.magee@ncipher.com>
> +M: David Kim <david.kim@ncipher.com>
> +M: Hamish Cameron <hamish.cameron@ncipher.com>
> +L: linux-crypto@vger.kernel.org
> +S: Supported
> +F: drivers/staging/ncipher/
> +
>  PCI DRIVER FOR MICROSEMI SWITCHTEC
>  M: Kurt Schwemmer <kurt.schwemmer@microsemi.com>
>  M: Logan Gunthorpe <logang@deltatee.com>
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index eaf753b70ec5..0b5498d2415c 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -124,6 +124,7 @@ source "drivers/staging/uwb/Kconfig"
>  source "drivers/staging/exfat/Kconfig"
> 
>  source "drivers/staging/qlge/Kconfig"
> +source "drivers/staging/ncipher/Kconfig"
> 
>  source "drivers/staging/hp/Kconfig"
> 
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index 0a4396c9067b..be9f2e811528 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -55,3 +55,4 @@ obj-$(CONFIG_EXFAT_FS) += exfat/
>  obj-$(CONFIG_QLGE) += qlge/
>  obj-$(CONFIG_NET_VENDOR_HP) += hp/
>  obj-$(CONFIG_WFX) += wfx/
> +obj-$(CONFIG_NCIPHER) += ncipher/
> diff --git a/drivers/staging/ncipher/Kconfig b/drivers/staging/ncipher/Kconfig
> new file mode 100644
> index 000000000000..5b466cd1896a
> --- /dev/null
> +++ b/drivers/staging/ncipher/Kconfig
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Enable support for nCipher's nShield Solo and Solo XC
> +config HSM_NCIPHER_NSHIELD_SOLO
> + tristate "nCipher Solo and Solo XC family of PCIe HSMs"
> + depends on PCI
> + help
> +   Select this as built-in or module if you expect to use
> +   a Hardware Security Module from nCipher's Solo or Solo XC range.
> diff --git a/drivers/staging/ncipher/Makefile b/drivers/staging/ncipher/Makefile
> new file mode 100644
> index 000000000000..b4d5f92addee
> --- /dev/null
> +++ b/drivers/staging/ncipher/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for nCipher nShield HSM drivers
> +#
> +
> +obj-$(CONFIG_HSM_NCIPHER_NSHIELD_SOLO) := nshield_solo.o
> +nshield_solo-y := hostif.o fsl.o i21555.o
> diff --git a/drivers/staging/ncipher/fsl.c b/drivers/staging/ncipher/fsl.c
> new file mode 100644
> index 000000000000..5c4edeef64c0
> --- /dev/null
> +++ b/drivers/staging/ncipher/fsl.c
> @@ -0,0 +1,911 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + *
> + * fsl.c: nCipher PCI HSM FSL command driver
> + * Copyright 2019 nCipher Security Ltd
> + *
> + */
> +
> +#include "solo.h"
> +#include "fsl.h"
> +
> +/**
> + * Resets FSL device.
> + *
> + * Extra device info is initialized the first time created.
> + *
> + * @param ndev common device.
> + * @returns 0 if successful, other value if error.
> + */
> +static int fsl_create(struct nfp_dev *ndev)
> +{
> + /* check for device */
> + if (!ndev) {
> + pr_err("%s: error: no device", __func__);
> + return -ENODEV;
> + }

Patch is totally corrupted and could not be applied even if I wanted to
:(

Can you just use 'git send-email' to send patches out?  web clients do
not work at all (as you saw with your first attempt in html format...)

thanks,

greg k-h
