Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.46.152]:32215 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727165AbeJQD7o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 23:59:44 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 9A30110E12
        for <linux-crypto@vger.kernel.org>; Tue, 16 Oct 2018 14:44:18 -0500 (CDT)
Subject: Re: [PATCH] crypto: inside-secure: safexcel - fix memory allocation
To: Kees Cook <keescook@chromium.org>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20181008191712.GA12892@embeddedor.com>
 <CAGXu5j+a=81mGFrF5igMXe46mv_PsqzUKCzLWj0oCEMk1PY62g@mail.gmail.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <9fa270bc-502d-5ff5-2acb-88ababcc9262@embeddedor.com>
Date: Tue, 16 Oct 2018 21:44:02 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+a=81mGFrF5igMXe46mv_PsqzUKCzLWj0oCEMk1PY62g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

On 10/9/18 12:20 AM, Kees Cook wrote:
> On Mon, Oct 8, 2018 at 12:17 PM, Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>> The original intention is to allocate space for EIP197_DEFAULT_RING_SIZE
>> *pointers* to struct, so sizeof(priv->ring[i].rdr_req) should be
>> sizeof(*priv->ring[i].rdr_req).
>>
>> Addresses-Coverity-ID: 1473962 ("Sizeof not portable")
>> Fixes: 9744fec95f06 ("crypto: inside-secure - remove request list to improve performance")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 


Friendly ping. Who can take this?

Thanks!
--
Gustavo
