Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:45045 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfARIAf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 03:00:35 -0500
MIME-Version: 1.0
References: <20190117231416.111952141@linutronix.de> <20190117231501.068505479@linutronix.de>
In-Reply-To: <20190117231501.068505479@linutronix.de>
From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date: Fri, 18 Jan 2019 09:00:20 +0100
Message-ID: <CAAUqJDs6VoE-pTQ9Sk0eTV1+Z+20WFh3hxQTkNAxePkVZDgtpg@mail.gmail.com>
Subject: Re: [patch 3/9] crypto: morus - Cleanup license mess
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

pi 18. 1. 2019 o 0:15 Thomas Gleixner <tglx@linutronix.de> nap=C3=ADsal(a):
> Precise and non-ambiguous license information is important. The recently
> added morus header files have a SPDX license identifier, which is nice, b=
ut
> at the same time they have a contradictionary license boiler plate text.
>
>   SPDX-License-Identifier: GPL-2.0
>
> versus
>
>   * This program is free software; you can redistribute it and/or modify =
it
>   * under the terms of the GNU General Public License as published by the=
 Free
>   * Software Foundation; either version 2 of the License, or (at your opt=
ion)
>   * any later version
>
> Oh well.
>
> As the other morus related files are licensed under the GPL v2 or later,
> it's assumed that the boiler plate code is correct, but the SPDX license
> identifier is wrong.
>
> Fix the SPDX identifier and remove the boiler plate as it is redundant.

Thanks, I must have copy-pasted the bits from somewhere and didn't
notice the discrepancy...

>
> Fixes: 56e8e57fc3a7 ("crypto: morus - Add common SIMD glue code for MORUS=
")
> Fixes: 396be41f16fd ("crypto: morus - Add generic MORUS AEAD implementati=
ons")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ondrej Mosnacek <omosnacek@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org

Acked-by: Ondrej Mosnacek <omosnacek@gmail.com>
(feel free to keep the ack also if you decide to switch to the "GPL-2.0+" f=
orm)

> ---
>
> P.S.: This patch is part of a larger cleanup, but independent of other
>       patches and is intended to be picked up by the maintainer directly.
>
> ---
> ---
>  include/crypto/morus1280_glue.h |    7 +------
>  include/crypto/morus640_glue.h  |    7 +------
>  include/crypto/morus_common.h   |    7 +------
>  3 files changed, 3 insertions(+), 18 deletions(-)
>
> --- a/include/crypto/morus1280_glue.h
> +++ b/include/crypto/morus1280_glue.h
> @@ -1,15 +1,10 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>  /*
>   * The MORUS-1280 Authenticated-Encryption Algorithm
>   *   Common glue skeleton -- header file
>   *
>   * Copyright (c) 2016-2018 Ondrej Mosnacek <omosnacek@gmail.com>
>   * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify =
it
> - * under the terms of the GNU General Public License as published by the=
 Free
> - * Software Foundation; either version 2 of the License, or (at your opt=
ion)
> - * any later version.
>   */
>
>  #ifndef _CRYPTO_MORUS1280_GLUE_H
> --- a/include/crypto/morus640_glue.h
> +++ b/include/crypto/morus640_glue.h
> @@ -1,15 +1,10 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>  /*
>   * The MORUS-640 Authenticated-Encryption Algorithm
>   *   Common glue skeleton -- header file
>   *
>   * Copyright (c) 2016-2018 Ondrej Mosnacek <omosnacek@gmail.com>
>   * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify =
it
> - * under the terms of the GNU General Public License as published by the=
 Free
> - * Software Foundation; either version 2 of the License, or (at your opt=
ion)
> - * any later version.
>   */
>
>  #ifndef _CRYPTO_MORUS640_GLUE_H
> --- a/include/crypto/morus_common.h
> +++ b/include/crypto/morus_common.h
> @@ -1,15 +1,10 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>  /*
>   * The MORUS Authenticated-Encryption Algorithm
>   *   Common definitions
>   *
>   * Copyright (c) 2016-2018 Ondrej Mosnacek <omosnacek@gmail.com>
>   * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
> - *
> - * This program is free software; you can redistribute it and/or modify =
it
> - * under the terms of the GNU General Public License as published by the=
 Free
> - * Software Foundation; either version 2 of the License, or (at your opt=
ion)
> - * any later version.
>   */
>
>  #ifndef _CRYPTO_MORUS_COMMON_H
>
>
