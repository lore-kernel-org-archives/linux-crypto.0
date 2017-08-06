From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH V2] staging: ccree: Fix format/argument mismatches
Date: Sun, 6 Aug 2017 09:03:42 +0300
Message-ID: <CAOtvUMf-3N912YBj+64BGCAo3gFVJDjcVvDsE-oXR1su8RbQVw@mail.gmail.com>
References: <201708031730.VcP8Q0DJ%fengguang.wu@intel.com> <1501768199.31625.17.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35944 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbdHFGDo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Aug 2017 02:03:44 -0400
Received: by mail-yw0-f194.google.com with SMTP id n83so3226207ywn.3
        for <linux-crypto@vger.kernel.org>; Sat, 05 Aug 2017 23:03:43 -0700 (PDT)
In-Reply-To: <1501768199.31625.17.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 3, 2017 at 4:49 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2017-08-03 at 17:09 +0800, kbuild test robot wrote:
>> Hi Joe,
>>
>> [auto build test WARNING on staging/staging-testing]
>> [also build test WARNING on next-20170803]
>> [cannot apply to v4.13-rc3]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> Pretty odd that m32r has ioread32 as _readl and so unsigned long
> Seems silly to have to cast it.

Yes, that does seem silly.

>
> Gilad, is this actually a supported platform for ccree?

Yes, since CryptoCell can be baked into any silicon that can be made
to talk AMBA, even though
I don't know of a specific platform that carries both M32R cores and CryptoCell.

That doesn't seem like a unique problem to ccree though, do other
drivers do this cast?
In that case, maybe we need to add a printk format like for dma addresses.

I wanted to add the M32R kernel mailing list but it seems the arch has
been orphaned and the web site
is a  a maze of twisty little 404s, all alike. Is that thing still alive?


Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
