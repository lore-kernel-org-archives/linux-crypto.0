From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: Is the asynchronous hash crypto API asynchronous?
Date: Mon, 9 Jan 2017 14:08:23 +0200
Message-ID: <CAOtvUMfheVHLH6y96+YjScZOYvBJegF6GwuBynR1LEgFt-O4=w@mail.gmail.com>
References: <CAOtvUMd=EHaFq=AtMePzN9fsoMLszZ0ruAu8KaaP=W=8J7nGUg@mail.gmail.com>
 <3639236.s9QSuQoh7d@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35052 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760080AbdAIMIZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 07:08:25 -0500
Received: by mail-io0-f174.google.com with SMTP id j18so31899307ioe.2
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2017 04:08:25 -0800 (PST)
In-Reply-To: <3639236.s9QSuQoh7d@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Stephen,

Before getting to business I wish to offer my thanks for hosting the
kernel crypto documentation on your web site at chronox.de. It has
proven very useful to me :-)

On Mon, Jan 9, 2017 at 12:23 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Am Sonntag, 8. Januar 2017, 15:45:37 CET schrieb Gilad Ben-Yossef:
>
> Hi Gilad,
>
>>         ahash_request_set_callback(req, 0, NULL, NULL);
>
>>
>> Would anyone be kind enough to enlighten me?
>
> The documentation got out of sync with the real world. I will file a patc=
h for
> that shortly.
>
> The ahash API works identically to the async skcipher API for which you f=
ind
> an example in the api-samples.rst. There you see that with the set_callba=
ck, a
> function is registered that is triggered upon completion of the operation=
.
>
> Thus, use the callback example you find for skcipher for your ahash opera=
tion
> and you get an async operation.

Thank you very much for pointing out the skcipher example. It is very helpf=
ul.

However, I suspect there is something a miss here beyond documentation:

There is (quite a lot of) kernel code calling
ahash_request_set_callback() with a NULL callback and consequently not
performing any synchronization in the completion of the hashing
operations.

See for example crypt_iv_essiv_init() in drivers/md/dm-crypt.c
Other similar call sites can be found at block/drbd/drbd_worker.c,
net/ppp/ppp_mppe.c, net/wireless/intersil/orinoco/mic.c,
scsi/iscsi_tcp.c, target/iscsi/iscsi_target_login.c

As far as I could tell the code in crypto/ahash.c does not take any
special consideration of the case where a NULL call back function has
been set and at least one of the underlying ahash algorithm provider
will crash if used like this.

This seems broken to me. I would be very happy to offer to fix the
broken call sites, if you can only confirm my understanding that
indeed cases which register a NULL callback are broken and it is not
just a misunderstanding on my part.

Many thanks,
Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
