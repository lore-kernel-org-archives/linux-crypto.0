From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: inside-secure - do not parse the dma mask from dt
Date: Fri, 23 Jun 2017 16:29:58 +0200
Message-ID: <CAK8P3a2U58VE6nn1fA79W+Vx7Y2fTn5-fLS6h4TQ5Qw_8ZcRtg@mail.gmail.com>
References: <20170623140525.360-1-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        oferh@marvell.com, igall@marvell.com, nadavh@marvell.com,
        linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33564 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752006AbdFWO37 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 10:29:59 -0400
Received: by mail-ot0-f195.google.com with SMTP id q16so5008345otb.0
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2017 07:29:59 -0700 (PDT)
In-Reply-To: <20170623140525.360-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 4:05 PM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:
> Remove the dma mask parsing from dt as this should not be encoded into
> the engine device tree node. Keep the fallback value for now, which
> should work for the boards already supported upstream.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> ---
>
> Hi Herbert,
>
> As pointed our by Arnd (ic Cc) parsing the dma mask from the dt node of
> the engine is broken. This property will be removed from the device
> trees having an inside-secure safexcel engine node. While the
> inside-secure won't fail because of this (as it will fallback to a
> 64 bits mask), the code handling the dma-mask property is dead. This
> patch removes it.

Do we also need a patch to update the DT binding?

       Arnd
