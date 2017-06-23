From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Documentation/bindings: crypto: remove the dma-mask property
Date: Fri, 23 Jun 2017 16:56:38 +0200
Message-ID: <CAK8P3a2fa3d6F8rOJLGs0bHivfVOEqxS127PEt4PDohOWFf6bw@mail.gmail.com>
References: <20170623145218.10795-1-antoine.tenart@free-electrons.com>
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
Received: from mail-ot0-f169.google.com ([74.125.82.169]:33029 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdFWO4j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 10:56:39 -0400
Received: by mail-ot0-f169.google.com with SMTP id y47so33199052oty.0
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jun 2017 07:56:39 -0700 (PDT)
In-Reply-To: <20170623145218.10795-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 4:52 PM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:
> The dma-mask property is broken and was removed in the device trees
> having a safexcel-eip197 node and in the safexcel cryptographic
> driver. This patch removes the dma-mask property from the documentation
> as well.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
