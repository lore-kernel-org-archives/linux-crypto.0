From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Read in crypto_aead_free_instance
Date: Wed, 20 Dec 2017 10:50:10 +0100
Message-ID: <CACT4Y+Y5SdeqYv9fUyr83k8C-FmpcmFtCRRO_r9_TbvqpNyH7Q@mail.gmail.com>
References: <001a11c14bc887c2c60560c0cdda@google.com> <2720015.COYl3plZzm@positron.chronox.de>
 <CACT4Y+Zgm=g2Tnne-p2J1sXEhfa2BVZsLXox3sxzq_NW4MBKmQ@mail.gmail.com> <7081028.ZNJKGTzsya@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot
        <bot+e5e6fab2d4dc3d9877ac240fed364027bb960ad0@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:34154 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbdLTJub (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 04:50:31 -0500
Received: by mail-pl0-f46.google.com with SMTP id d21so8700409pll.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 01:50:31 -0800 (PST)
In-Reply-To: <7081028.ZNJKGTzsya@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 10:29 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 20. Dezember 2017, 10:19:43 CET schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>> >
>> > This issue vanishes after applying the patch "[PATCH v2] crypto: AF_ALG -
>> > limit mask and type".
>>
>> Hi Stephan,
>>
>> syzbot does not understand arbitrary English prose, it only understands
> this:
>> > Once a fix for this bug is merged into any tree, reply to this email with:
>> > #syz fix: exact-commit-title
>>
>> Let's tell it about the fix:
>>
>> #syz fix: crypto: AF_ALG - limit mask and type
>
> I have seen that this is the approach, but the fix is not yet in the tree. I
> just want to let folks know that there is a patch.

Ah, ok, sorry. It's just difficult to tell when there is a reason to
not provide the tag right now, or when people are don't know about
them or ignore.
If the patch is merged with this title, then there is nothing else to
do. If it's merged under a different title, a new "#syz fix:" tag will
override the old one.
