Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39088 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfARIC6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 03:02:58 -0500
MIME-Version: 1.0
References: <20190117231416.111952141@linutronix.de> <20190117231500.970473486@linutronix.de>
In-Reply-To: <20190117231500.970473486@linutronix.de>
From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date: Fri, 18 Jan 2019 09:02:44 +0100
Message-ID: <CAAUqJDs0TqhgUw6kFGmGoR_RWiqUAgb68zne45J3JLKWAFjThw@mail.gmail.com>
Subject: Re: [patch 2/9] crypto: aegis - Cleanup license mess
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
> added aegis header file has a SPDX license identifier, which is nice, but
> at the same time it has a contradictionary license boiler plate text.
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
> As the other aegis related files are licensed under the GPL v2 or later,
> it's assumed that the boiler plate code is correct, but the SPDX license
> identifier is wrong.
>
> Fix the SPDX identifier and remove the boiler plate as it is redundant.
>
> Fixes: f606a88e5823 ("crypto: aegis - Add generic AEGIS AEAD implementati=
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
>  crypto/aegis.h |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> --- a/crypto/aegis.h
> +++ b/crypto/aegis.h
> @@ -1,14 +1,9 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>  /*
>   * AEGIS common definitions
>   *
>   * Copyright (c) 2018 Ondrej Mosnacek <omosnacek@gmail.com>
>   * Copyright (c) 2018 Red Hat, Inc. All rights reserved.
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
>  #ifndef _CRYPTO_AEGIS_H
>
>
