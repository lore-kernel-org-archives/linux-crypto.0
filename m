From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] tls: Add support for encryption using async offload accelerator
Date: Wed, 31 Jan 2018 08:23:26 +0200
Message-ID: <CAOtvUMeG5_aZ27Pck68mC3BXrxa5X-zwd6ri6iQrAv6WZPpPNg@mail.gmail.com>
References: <20180131103654.9759-1-vakul.garg@nxp.com> <CAOtvUMfXFhZXoYcc5QQTJudK5PvzTCSiXVMWV8D=A+Mq8QNgPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        ilyal@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
To: Vakul Garg <vakul.garg@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:40950 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbeAaGX1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 01:23:27 -0500
Received: by mail-ua0-f176.google.com with SMTP id t6so8728562ual.7
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jan 2018 22:23:27 -0800 (PST)
In-Reply-To: <CAOtvUMfXFhZXoYcc5QQTJudK5PvzTCSiXVMWV8D=A+Mq8QNgPw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 31, 2018 at 8:10 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Hi Vakul,
>
> On Wed, Jan 31, 2018 at 12:36 PM, Vakul Garg <vakul.garg@nxp.com> wrote:
>> Async crypto accelerators (e.g. drivers/crypto/caam) support offloading
>> GCM operation. If they are enabled, crypto_aead_encrypt() return error
>> code -EINPROGRESS. In this case tls_do_encryption() needs to wait on a
>> completion till the time the response for crypto offload request is
>> received.
>>
>
> Thank you for this patch. I think it is actually a bug fix and should
> probably go into stable

On second though in stable we should probably just disable async tfm
allocations.
It's simpler. But this approach is still good for -next


Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
