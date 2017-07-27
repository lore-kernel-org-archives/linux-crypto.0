From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 1/3] staging: ccree: Replace kzalloc with devm_kzalloc
Date: Thu, 27 Jul 2017 17:26:18 +0300
Message-ID: <CAOtvUMeypygShtn4+nXCsepUrsDhBmZmqXMp60D116P8+2WT4A@mail.gmail.com>
References: <20170717123306.GF24503@kroah.com> <1500375526-12973-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        karthik@techveda.org
To: sunil.m@techveda.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35716 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdG0O0U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jul 2017 10:26:20 -0400
Received: by mail-io0-f193.google.com with SMTP id f1so13239920ioj.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jul 2017 07:26:20 -0700 (PDT)
In-Reply-To: <1500375526-12973-1-git-send-email-sunil.m@techveda.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 1:58 PM,  <sunil.m@techveda.org> wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
>
> It is recommended to use managed function devm_kzalloc, which
> simplifies driver cleanup paths and driver code.
> This patch does the following:
> (a) replace kzalloc with devm_kzalloc.
> (b) drop kfree(), because memory allocated with devm_kzalloc() is
> automatically freed on driver detach, otherwise it leads to a double
> free.
> (c) remove unnecessary blank lines.
>
> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
> ---
> Changes for v2:
>
> - Changes done as suggested by Greg-KH.
> - Rebased on top of next-20170718.
> ---
> Note:
>
> - Patch was tested and built(ARCH=arm) on next-20170718.
>   No build issues reported, however it was not tested on
>   real hardware.

I verified the patch set on CrytoCell HW and it's fine.

Unfortunately, my coding style fixes patch set made two of these to
fail to apply.
Following up is a rebased patch. There are no changes except resolving
conflicts.


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
