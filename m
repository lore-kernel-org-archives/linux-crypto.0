Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AAA5C5479D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 21:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbjAIVZM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 16:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbjAIVYk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 16:24:40 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66EED100
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 13:23:36 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bk16so9618608wrb.11
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2023 13:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3l0v1zJ+Gv6Xgvl36Cev5IcTIXjw7BVlcsvn0fqaZFo=;
        b=kY31CoBzdLSKa6MbgddxjBQXqlBONIV0A1rTVy7NPyxTjlawwTvODaUlHXaidznGdT
         R2by9f81FX0Ft1FEKpcs4blpq1WYCwk2WdGSdJbpJpVukSb0i9WQwGxn8b3tWDC69Gvw
         WjoHVcBdEeX6p/pSBIoqnqKEFJc5BCm7QIIagQwZsE7EQU7Ha+y/b6RZGPwCpzo5uKzw
         18SwubFiLiKzsSJUw6SBmIFuu/TIvR8u0E0iVlVsvY1kISKraanv0/01Ti1BzCwsHNIr
         duraW49tQPtTGhJx2jvB5SmIXhztNrQiE5NXlXL+or9onBQntzqsov4kruyRe7qQSPow
         AYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3l0v1zJ+Gv6Xgvl36Cev5IcTIXjw7BVlcsvn0fqaZFo=;
        b=aNHrQ1tlq4HCZks0525ULxW5+gFoanvSXscXQz7pItwTHVbI1FPcnHAoWTYMxHUx4S
         jl8e/LcrwOAJsWf89nmt6bJBsubKu6sXiw7pnfUNmquEfG9x+h35ijC9QQ1yy2XFMg5Q
         LOSwdedItBSNmZJnY9XQUwPl7N0Ub7m9fsWFhAV2I8INv1WsOEbN2P9O+/gN3vYGpFgB
         BCd5bUkFcUj4hDrxyl5DV512I/hGm03XcSFlKf8w+w0RTyi9zgwqVU1bRoh4X8hjmbof
         7N57SDENCUthTZsisew43Llki7lolth47cSsPCAJc17LK1ev8OUUjHuuLs8eyv/wSSuQ
         0SXg==
X-Gm-Message-State: AFqh2krkfg7PSi5ilcU20V5SrqwCABXWCYVOKACW+4KP3/r0+aWfHS2q
        UJ1PQnZFI8ihGUcL2q0qZzNC7w==
X-Google-Smtp-Source: AMrXdXsyYKqkIZOJlshTIlgq95dDvHV+ynXvWfRt12rHcYt7+dpWw6QG9aa65Umunlzo2VPZB4obuQ==
X-Received: by 2002:a5d:5544:0:b0:26d:2af7:420 with SMTP id g4-20020a5d5544000000b0026d2af70420mr40920177wrw.33.1673299415229;
        Mon, 09 Jan 2023 13:23:35 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id f14-20020adff58e000000b00241fea203b6sm9615911wro.87.2023.01.09.13.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 13:23:34 -0800 (PST)
Message-ID: <043c6dcc-cd25-2061-8162-ee4c04753813@arista.com>
Date:   Mon, 9 Jan 2023 21:23:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 5/5] crypto/Documentation: Add crypto_pool kernel API
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20230103184257.118069-1-dima@arista.com>
 <20230103184257.118069-6-dima@arista.com>
 <20230106180616.4a39dd2a@kernel.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20230106180616.4a39dd2a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/7/23 02:06, Jakub Kicinski wrote:
> Some extra nits here since you need to respin for the build warning
> (include the document in some index / toc tree and adjust the length 
> of the underscores to match the line length).

Thanks again, will correct according to your review notes,

> 
> On Tue,  3 Jan 2023 18:42:57 +0000 Dmitry Safonov wrote:
>> diff --git a/Documentation/crypto/crypto_pool.rst b/Documentation/crypto/crypto_pool.rst
>> new file mode 100644
>> index 000000000000..4b8443171421
>> --- /dev/null
>> +++ b/Documentation/crypto/crypto_pool.rst
>> @@ -0,0 +1,33 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +Per-CPU pool of crypto requests
>> +=============
>> +
>> +Overview
>> +--------
>> +The crypto pool API manages pre-allocated per-CPU pool of crypto requests,
>> +providing ability to use async crypto requests on fast paths, potentially
> 
> .. you *don't* enable async crypto in this series, right?
> 
>> +on atomic contexts. The allocation and initialization of the requests should
> 
> s/on/in/ atomic contexts
> 
>> +be done before their usage as it's slow-path and may sleep.
>> +
>> +Order of operations
>> +-------------------
>> +You are required to allocate a new pool prior using it and manage its lifetime.
> 
> The use of second person is quite uncommon for documentation, but if
> you prefer so be it..

I used Documentation/crypto/crypto_engine.rst as an example :-)
[where "example" was `cp crypto_{engine,pool}.rst && vim crypto_pool.rst`]

> 
>> +You can allocate a per-CPU pool of ahash requests by ``crypto_pool_alloc_ahash()``.
> 
> You don't need to use the backticks around function names and struct
> names. Our doc rendering system recognizes them automatically. 
> 
> `make htmldocs` to see for yourself.

Thanks,
          Dmitry

