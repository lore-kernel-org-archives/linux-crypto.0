Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-lj1-f171.google.com ([209.85.208.171]:38891 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbfARICT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 03:02:19 -0500
MIME-Version: 1.0
References: <20190117231416.111952141@linutronix.de> <20190117231501.254152158@linutronix.de>
In-Reply-To: <20190117231501.254152158@linutronix.de>
From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date: Fri, 18 Jan 2019 09:02:06 +0100
Message-ID: <CAAUqJDufgoZMhPia5M6cc+V5tijX+huzncnd3LSp=DVhXy80Nw@mail.gmail.com>
Subject: Re: [patch 5/9] crypto: morus - Convert to SPDX license identifiers
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
> The license boiler plate text is not ideal for machine parsing. The kerne=
l
> uses SPDX license identifiers for that purpose, which replace the boiler
> plate text.
>
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
>  crypto/morus1280.c |    6 +-----
>  crypto/morus640.c  |    6 +-----
>  2 files changed, 2 insertions(+), 10 deletions(-)
>
> --- a/crypto/morus1280.c
> +++ b/crypto/morus1280.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * The MORUS-1280 Authenticated-Encryption Algorithm
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
>  #include <asm/unaligned.h>
> --- a/crypto/morus640.c
> +++ b/crypto/morus640.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * The MORUS-640 Authenticated-Encryption Algorithm
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
>  #include <asm/unaligned.h>
>
>
