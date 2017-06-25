From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 2/7] staging: ccree: register setkey for none hash macs
Date: Sun, 25 Jun 2017 09:28:29 +0300
Message-ID: <CAOtvUMfdwzyf3wo7YTzxc9N1tYPw4nES=9e7twvpXcGbFHpQUA@mail.gmail.com>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
 <1498138623-6126-3-git-send-email-gilad@benyossef.com> <20170623162919.GA24336@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:34477 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdFYG2a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Jun 2017 02:28:30 -0400
Received: by mail-yb0-f177.google.com with SMTP id e201so21948030ybb.1
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2017 23:28:30 -0700 (PDT)
In-Reply-To: <20170623162919.GA24336@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 23, 2017 at 7:29 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 22, 2017 at 04:36:56PM +0300, Gilad Ben-Yossef wrote:
>> Fix a bug where the transformation init code did
>> not register a setkey method for none hash based MACs.
>
> "none hash based MACs"?  Is that the correct language, I don't
> understand it, sorry, can you expand on it a bit in your v3 series?

My apologies. English is not my mother tongue. This should have been
"non-hash based MACs".

>
>> Fixes commit 50cfbbb7e627 ("staging: ccree: add ahash support").
>
> This line should be written as:
> Fixes: 50cfbbb7e627 ("staging: ccree: add ahash support").
>

I'll fix both.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
