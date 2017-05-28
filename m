From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v6 4/5] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Sun, 28 May 2017 11:09:43 +0530
Message-ID: <CANc+2y46roki41fd_yURACWeXNzjyBEk_kOwiLEr_D=zFyaWuQ@mail.gmail.com>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com> <20170524141035.21031-5-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, jason@lakedaemon.net,
        andrew@lunn.ch,
        Gregory Clement <gregory.clement@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        oferh@marvell.com, Igal Liberman <igall@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, robin.murphy@arm.com
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:33476 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdE1Fjp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 May 2017 01:39:45 -0400
Received: by mail-ua0-f173.google.com with SMTP id e28so22694950uah.0
        for <linux-crypto@vger.kernel.org>; Sat, 27 May 2017 22:39:44 -0700 (PDT)
In-Reply-To: <20170524141035.21031-5-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antonie,

On 24 May 2017 at 19:40, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:
> Add support for Inside Secure SafeXcel EIP197 cryptographic engine,
> which can be found on Marvell Armada 7k and 8k boards. This driver
> currently implements: ecb(aes), cbc(aes), sha1, sha224, sha256 and
> hmac(sah1) algorithms.
>
> Two firmwares are needed for this engine to work. Their are mostly used
> for more advanced operations than the ones supported (as of now), but we
> still need them to pass the data to the internal cryptographic engine.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

As you have got help from other people for testing, wouldn't it be
nice to add tested-by tag?

Regards,
PrasannaKumar
