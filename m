From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [Part2 PATCH v9 12/38] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Wed, 6 Dec 2017 22:10:27 +0100
Message-ID: <CAOFm3uE06YTvfwe5P0uq3Pgc4PwzQmTh=dvVUuV5WxPjAf2Sdw@mail.gmail.com>
References: <20171205010438.5773-1-brijesh.singh@amd.com> <20171205010438.5773-13-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, bp@alien8.de, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36219 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbdLFVLJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 16:11:09 -0500
Received: by mail-wr0-f194.google.com with SMTP id v105so5338699wrc.3
        for <linux-crypto@vger.kernel.org>; Wed, 06 Dec 2017 13:11:09 -0800 (PST)
In-Reply-To: <20171205010438.5773-13-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 5, 2017 at 2:04 AM, Brijesh Singh <brijesh.singh@amd.com> wrote=
:
> The Platform Security Processor (PSP) is part of the AMD Secure
> Processor (AMD-SP) functionality. The PSP is a dedicated processor
> that provides support for key management commands in Secure Encrypted
> Virtualization (SEV) mode, along with software-based Trusted Execution
> Environment (TEE) to enable third-party trusted applications.
>
> Note that the key management functionality provided by the SEV firmware
> can be used outside of the kvm-amd driver hence it doesn't need to
> depend on CONFIG_KVM_AMD.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Improvements-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Reviewed-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/crypto/ccp/Kconfig   |  11 +++++
>  drivers/crypto/ccp/Makefile  |   1 +
>  drivers/crypto/ccp/psp-dev.c | 105 +++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/crypto/ccp/psp-dev.h |  59 ++++++++++++++++++++++++
>  drivers/crypto/ccp/sp-dev.c  |  26 +++++++++++
>  drivers/crypto/ccp/sp-dev.h  |  24 +++++++++-
>  drivers/crypto/ccp/sp-pci.c  |  52 +++++++++++++++++++++
>  7 files changed, 277 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/ccp/psp-dev.c
>  create mode 100644 drivers/crypto/ccp/psp-dev.h
>
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 9c84f9838931..b9dfae47aefd 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -33,3 +33,14 @@ config CRYPTO_DEV_CCP_CRYPTO
>           Support for using the cryptographic API with the AMD Cryptograp=
hic
>           Coprocessor. This module supports offload of SHA and AES algori=
thms.
>           If you choose 'M' here, this module will be called ccp_crypto.
> +
> +config CRYPTO_DEV_SP_PSP
> +       bool "Platform Security Processor (PSP) device"
> +       default y
> +       depends on CRYPTO_DEV_CCP_DD && X86_64
> +       help
> +        Provide support for the AMD Platform Security Processor (PSP).
> +        The PSP is a dedicated processor that provides support for key
> +        management commands in Secure Encrypted Virtualization (SEV) mod=
e,
> +        along with software-based Trusted Execution Environment (TEE) to
> +        enable third-party trusted applications.
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index c4ce726b931e..51d1c0cf66c7 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -8,6 +8,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) +=3D ccp-dev.o \
>             ccp-dmaengine.o \
>             ccp-debugfs.o
>  ccp-$(CONFIG_PCI) +=3D sp-pci.o
> +ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) +=3D psp-dev.o
>
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) +=3D ccp-crypto.o
>  ccp-crypto-objs :=3D ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> new file mode 100644
> index 000000000000..b5789f878560
> --- /dev/null
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -0,0 +1,105 @@
> +/*
> + * AMD Platform Security Processor (PSP) interface
> + *
> + * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */

Dear Brijesh,

Have you considered using the new SPDX license ids instead?

This would come out this way:
> +// SDPX-License-Identifier: GPL-2.0
> +/*
> + * AMD Platform Security Processor (PSP) interface
> + *
> + * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + */

It is much cleaner and simpler, right?

For the C++ comment style and first line placement, please see Thomas
(tlgx) doc patches and Linus posts explaining his rationale of why he
wants it this way.
It would be awesome if this could be applied to all AMD contributions btw!

--=20
Cordially
Philippe Ombredanne
