From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Tue, 28 Nov 2017 10:59:04 +0100
Message-ID: <CACT4Y+brFOoj25PcGv+d6fy6zcysXOYg3Awat5LQR+CCmFtmxg@mail.gmail.com>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com>
 <1838350.iOjUKSrnbm@tauon.chronox.de> <CACT4Y+ZQfNxO+gTX3QRcMDeQW7ECpeAvv92sf-0=s_8cAD8n0g@mail.gmail.com>
 <1684405.FoYHGhiAJd@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:46473 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbdK1J70 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 04:59:26 -0500
Received: by mail-pf0-f180.google.com with SMTP id q4so18699911pfg.13
        for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2017 01:59:26 -0800 (PST)
In-Reply-To: <1684405.FoYHGhiAJd@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 24, 2017 at 5:31 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Freitag, 24. November 2017, 17:25:55 CET schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>> Eric also pointed me to grep. But I can't say the code is intuitive.
>> I've spent way more time than I expected to just get a list of all
>> algorithms with their types. Say, in some cases algorithm descriptions
>> do not specify their type, it's somehow plumbed somewhere later.
>> Getting the list at runtime allowed me to get relevant ones with
>> proper types.
>
> Hehe, getting the list of ciphers in the script I sent the other day took me a
> long time.
>
> Maybe you leave it for now and come back later for a good grepping code to
> search the sources.


First bugs uncovered by the change started popping up:
https://groups.google.com/forum/#!forum/syzkaller-bugs
More coming!
