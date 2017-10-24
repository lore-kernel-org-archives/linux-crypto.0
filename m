From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging: ccree: Fix lines longer than 80 characters
Date: Tue, 24 Oct 2017 11:54:05 +0300
Message-ID: <CAOtvUMcr6s700AjVkohV4V+QqsNqgCsLraTbowYpndNmoa63Ww@mail.gmail.com>
References: <20171010042759.14020-1-stephen@brennan.io> <20171020195754.GA4913@pride.attlocal.net>
 <CAOtvUMfzH86anJJ2JcsVdpX7wzfWh2PYNDUhA0JZ7SP+BfWYpw@mail.gmail.com> <20171023150006.GA8840@pride.attlocal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephen Brennan <stephen@brennan.io>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:52825 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdJXIyG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2017 04:54:06 -0400
Received: by mail-oi0-f42.google.com with SMTP id c202so35510667oih.9
        for <linux-crypto@vger.kernel.org>; Tue, 24 Oct 2017 01:54:06 -0700 (PDT)
In-Reply-To: <20171023150006.GA8840@pride.attlocal.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 23, 2017 at 6:00 PM, Stephen Brennan <stephen@brennan.io> wrote:
> Hi Gilad,
>
> Thanks for the quick reply, I really appreciate your taking time to help a
> newbie get started. I've made the appropriate changes and re-submitted.

It is completely my pleasure. Thanks,
>
>> TIP: if you run the scripts/get_maintainers.pl script on your patch it
>> will tell you exactly which
>> list and which people your patch needs to be addressed, so you don't
>> have to guess.
>
> When I ran this tool, it listed out quite a few mailing lists, including
> linux-kernel@vger.kernel.org. Is it correct to simply address your patch to
> the whole list output by the script? I omitted linux-kernel on my
> resubmission, simply to avoid contributing to the heavy volume of that
> list, given how trivial this patch is.
>

Strange as it may sound, it is the protocol. If you think you cringe
when sending
a trivial patch there wait till you send the 20th revision of a patch
that get_maintainer
says needs to be cross posted to half a dozen mailing lists... :-)

Posting to lkml is more than just informative. There are actually
automated tool that
will pick your patch and run it through a bunch of static analysers
tools and try to compile
it and sometime boot on a dozen different archs.

Besides, lkml is a fire host as it is... :-)

Gilad


> Thanks again!
> Stephen
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
