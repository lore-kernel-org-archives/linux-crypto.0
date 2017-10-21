From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging: ccree: Fix lines longer than 80 characters
Date: Sat, 21 Oct 2017 10:48:21 +0300
Message-ID: <CAOtvUMfzH86anJJ2JcsVdpX7wzfWh2PYNDUhA0JZ7SP+BfWYpw@mail.gmail.com>
References: <20171010042759.14020-1-stephen@brennan.io> <20171020195754.GA4913@pride.attlocal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephen Brennan <stephen@brennan.io>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:54644 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdJUHsW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Oct 2017 03:48:22 -0400
Received: by mail-oi0-f42.google.com with SMTP id a132so23606402oih.11
        for <linux-crypto@vger.kernel.org>; Sat, 21 Oct 2017 00:48:22 -0700 (PDT)
In-Reply-To: <20171020195754.GA4913@pride.attlocal.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Stephen,

Thank you for your patch! sorry for not responding to your first post.
I seem to have missed that
email completely.

The CryptoCell driver is currently in the staging process for
inclusion in the Linux kernel.
As such, patches such as these are discussed in the staging mailing
list and should include
also the staging tree maintainer.

TIP: if you run the scripts/get_maintainers.pl script on your patch it
will tell you exactly which
list and which people your patch needs to be addressed, so you don't
have to guess.

Also, you are missing a patch description. While it's rather trivial
in this case, it still needs to be written.

TIP: Run the scripts/checkpath.pl on your patch before sending it and
it will let you know what you are missing, if any :-)

Please keep sending patches :-)

Thanks,
Gilad


On Fri, Oct 20, 2017 at 10:57 PM, Stephen Brennan <stephen@brennan.io> wrote:
> Hello,
>
> Just bumping this patch. I know it's only a very trivial change that shuts
> up a checkpatch warning. Please let me know if I can do anything to help.
>
> Thanks,
> Stephen
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
