From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Thu, 24 Jul 2014 08:21:38 -0700
Message-ID: <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu> <20140724151814.GE32421@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Linux API <linux-api@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:47558 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470AbaGXPWA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Jul 2014 11:22:00 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so2048490lab.18
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2014 08:21:58 -0700 (PDT)
In-Reply-To: <20140724151814.GE32421@khazad-dum.debian.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 24, 2014 at 8:18 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Thu, 24 Jul 2014, Theodore Ts'o wrote:
>> ERRORS
>>       EINVAL          An invalid flag was passed to getrandom(2)
>>
>>       EFAULT          buf is outside the accessible address space.
>>
>>       EAGAIN          The requested entropy was not available, and
>>                       getentropy(2) would have blocked if GRND_BLOCK flag
>>                       was set.
>>
>>       EINTR           While blocked waiting for entropy, the call was
>>                       interrupted by a signal handler; see the description
>>                       of how interrupted read(2) calls on "slow" devices
>>                       are handled with and without the SA_RESTART flag
>>                       in the signal(7) man page.
>
> Should we add E<SOMETHING> to be able to deny access to GRND_RANDOM or some
> future extension ?

This might actually be needed sooner rather than later.  There are
programs that use containers and intentionally don't pass /dev/random
through into the container.  I know that Sandstorm does this, and I
wouldn't be surprised if other things (Docker?) do the same thing.

--Andy
