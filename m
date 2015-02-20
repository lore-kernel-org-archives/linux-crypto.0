From: sri sowj <srisowj4linux@gmail.com>
Subject: Re: Intermediate Hash states
Date: Fri, 20 Feb 2015 14:00:51 +0530
Message-ID: <CAHTT9VLnhGqYz6vWzEfFCxw0L1=u1g-pa3B=8uLu0Pj=MQJthQ@mail.gmail.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9E0366@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Markus Stockhausen <stockhausen@collogia.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:37843 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbbBTIaw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 03:30:52 -0500
Received: by mail-oi0-f52.google.com with SMTP id u20so1460700oif.11
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 00:30:51 -0800 (PST)
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9E0366@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Markus,

Thanks for the information provided .

 But I am still not really sure how does crypto driver keeps track of
the context (intermediate Hash) ,when another application/thread sends
a request ? I think export/import methods are used to export this
intermediate hash to upper layers ,then to import the same when
Needed.

Please can you provide some inputs on the same may be with some open
source references if possible.

BR,
& Srisowj

On Thu, Feb 19, 2015 at 10:20 PM, Markus Stockhausen
<stockhausen@collogia.de> wrote:
> If I understand it correctly each requestor gets its own (multiple)
> contexts. So no need to worry. It will use a different area to store
> intermediate values.
>
> Markus
>
> Am 19.02.2015 17:18 schrieb sri sowj <srisowj4linux@gmail.com>:
>
> Hi ,
>
> I am trying to understand Hashing Algorithms implementation in linux kernel
> .
>
> I am really not sure on how to deal with following scenario.
>
> assume when App1 is in middle of
> execution(crypto_ahash_init/update/update...) ,App2 sends a request
> may be from another cpu in multi-core system to underlying crypto
> driver .
> Then essentially input1 has to save its  state(intermediate Hash) and
> serves App2 request.
>
> App1 ---------> Linux kernel crypto driver
>
>        crypto_ahash_init(input1);
>         crypto_ahash_update(input1);
>        ..................
>        ..................
>         crypto_ahash_update(input1); // multple Hash requests
>        ..................
>        ..................
>     crypto_ahash_final()
>
>
>
> App2 ---------> Linux kernel crypto driver
>
>         crypto_ahash_init(input2);
>         crypto_ahash_update(input2);
>
>
> Here in this scenario how to track,save and restore the Hash state for App1
> ?
>
> BR,
> Srisowj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
