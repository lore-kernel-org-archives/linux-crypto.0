From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Getting the ccree driver out of staging
Date: Wed, 10 Jan 2018 08:54:55 +0200
Message-ID: <CAOtvUMdo_ZJ-M-=apA1a=70KyVBX2J0pEVc+Uc9i=rYWCie6Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Ofir Drang <Ofir.Drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:44966 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753304AbeAJGy5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 01:54:57 -0500
Received: by mail-oi0-f51.google.com with SMTP id g128so429006oib.11
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jan 2018 22:54:56 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi folks,

With the enormous help of people in the to and CCed lists I've gotten
the ccree driver to a point I believe it is ready to graduate out of
the staging tree:

- The code base has been reduced by something by 30% and is *much*
more  readable and manageable.
- The very few checkpatch warnings are all false positives (one due to
dt bindings going through the crypto tree, the others due to harmless
macro argument reuse)
and the few sparse output are equally benign.
- The driver follows the crypto API expected behavior as much as I can tell.
- Fixed all the bugs I could fine as a result of tcrypt tests.
- It works :-)

There are obviously more things todo, but I believe they are out of
scope for staging.

So, if you see something that still needs work, kindly let me know.
Alternatively, will you accept a patch moving it to drivers/crypto/?

Many thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
