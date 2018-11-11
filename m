Return-Path: <SRS0=7Tml=NW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:53667 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbeKKVPH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Nov 2018 16:15:07 -0500
Message-ID: <7e4e2c4ee692f4dff7ce7fb447e4990429b6b9b8.camel@v3.sk>
Subject: Re: [PATCH 03/17] hw_random: bcm2835-rng: Switch to SPDX identifier
From: Lubomir Rintel <lkundrak@v3.sk>
To: Stefan Wahren <stefan.wahren@i2se.com>,
        Eric Anholt <eric@anholt.net>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-rpi-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Date: Sun, 11 Nov 2018 12:26:43 +0100
In-Reply-To: <1541861476-6778-1-git-send-email-stefan.wahren@i2se.com>
References: <1541861476-6778-1-git-send-email-stefan.wahren@i2se.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2018-11-10 at 15:51 +0100, Stefan Wahren wrote:
> Adopt the SPDX license identifier headers to ease license compliance
> management. While we are at this fix the comment style, too.
> 
> Cc: Lubomir Rintel <lkundrak@v3.sk>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/hw_random/bcm2835-rng.c
> b/drivers/char/hw_random/bcm2835-rng.c
> index 6767d96..256b0b1 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -1,10 +1,7 @@
> -/**
> +// SPDX-License-Identifier: GPL-2.0
> +/*
>   * Copyright (c) 2010-2012 Broadcom. All rights reserved.
>   * Copyright (c) 2013 Lubomir Rintel
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> ("GPL")
> - * version 2, as published by the Free Software Foundation.
>   */
>  
>  #include <linux/hw_random.h>

Acked-by: Lubomir Rintel <lkundrak@v3.sk>
