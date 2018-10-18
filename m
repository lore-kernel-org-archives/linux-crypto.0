Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.48.38]:33997 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727357AbeJROnp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 10:43:45 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id C6077400DB261
        for <linux-crypto@vger.kernel.org>; Thu, 18 Oct 2018 01:24:06 -0500 (CDT)
Subject: Re: [PATCH] crypto: inside-secure: safexcel - fix memory allocation
To: Kees Cook <keescook@chromium.org>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20181008191712.GA12892@embeddedor.com>
 <CAGXu5j+a=81mGFrF5igMXe46mv_PsqzUKCzLWj0oCEMk1PY62g@mail.gmail.com>
 <9fa270bc-502d-5ff5-2acb-88ababcc9262@embeddedor.com>
 <20181017061741.qr23stkwqf36fet6@gondor.apana.org.au>
 <20181017072034.GD28572@kwain>
 <0529a397-f104-5f3a-663e-7ef2d883dcb2@embeddedor.com>
 <CAGXu5jKL07_ofMpTbaH2E=JnWEF8Y=36T+sQ5m-aRke5H=3twA@mail.gmail.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <0077259b-11bb-107c-97ea-ad739e1d2e86@embeddedor.com>
Date: Thu, 18 Oct 2018 08:24:02 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKL07_ofMpTbaH2E=JnWEF8Y=36T+sQ5m-aRke5H=3twA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 10/17/18 8:23 PM, Kees Cook wrote:

>>
>> If so, could you take this patch?
> 
> Since this has no functional exposure (the sizes are the same), let's
> just wait until after the merge window to get this into crypto-next.
> 

Okay. I agree.

Thanks!
--
Gustavo
