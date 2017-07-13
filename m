From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] crypto: change hwrng device default permissions to 0444
Date: Thu, 13 Jul 2017 13:59:49 +0530
Message-ID: <CANc+2y40kxtqQ1SOTWm0JJENUMV=rkzZw+AmNBrqLCz-EFYcqg@mail.gmail.com>
References: <1499078279-19135-1-git-send-email-freude@linux.vnet.ibm.com> <20170712101356.GA21862@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, schwidefsky@de.ibm.com,
        Christian.Rund@de.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33699 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdGMI3v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 04:29:51 -0400
Received: by mail-vk0-f51.google.com with SMTP id r126so26102401vkg.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jul 2017 01:29:50 -0700 (PDT)
In-Reply-To: <20170712101356.GA21862@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 12 July 2017 at 15:43, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Hmm, one usage scenario for /dev/hwrng is to feed rngd which then
> feeds into /dev/random.  In that case it may not be desirable to
> allow arbitrary access to hwrgn since it may cause the rate of
> entropy going into /dev/random to go down.
>
> In any case, as you noted userspace can change this anyway so I
> don't see why we need to make this policy change in the kernel.

Looking at the comment in
https://android.googlesource.com/platform/frameworks/base/+/master/services/core/java/com/android/server/EntropyMixer.java#145
I am wondering whether your concern is a problem. I do not know
whether the comment in Android source is valid so please ignore my
ignorance.

Regards,
PrasannaKumar
