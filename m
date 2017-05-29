From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 01/12] staging: ccree: correct coding style violations
Date: Mon, 29 May 2017 20:11:05 +0300
Message-ID: <CAOtvUMeU=c=_H3tb0iu7967-z_yL5EM3Y+8ZmgXjMwg3S7jhzA@mail.gmail.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
 <1495982440-10047-2-git-send-email-gilad@benyossef.com> <20170529143728.GA12428@kroah.com>
 <1496077030.18529.1.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35064 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdE2RLG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 13:11:06 -0400
Received: by mail-yw0-f196.google.com with SMTP id p144so4698594ywp.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 May 2017 10:11:06 -0700 (PDT)
In-Reply-To: <1496077030.18529.1.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 29, 2017 at 7:57 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2017-05-29 at 16:37 +0200, Greg Kroah-Hartman wrote:
>> On Sun, May 28, 2017 at 05:40:26PM +0300, Gilad Ben-Yossef wrote:
>> > cc_crypto_ctx.h had multiple coding style violations reported by
>> > checkpatch. Fix them all.
>>
>> Sorry, no.  You need to do only one-thing-per-patch, and "fix all coding
>> style issues is not "one thing".  I wouldn't take this kind of patch
>> from anyone else, so why should I take it from you?  :)
>
> Because he's the named MAINTAINER of the subsystem
> and you are acting as an upstream conduit.
>

LOL. Thank you Joe, but I have opted to upstream via staging to get the guidance
and review of Greg and other developers kind enough to offer it, and I'd be a
fool not to listen to them.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
