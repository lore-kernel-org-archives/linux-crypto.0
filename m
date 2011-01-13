From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: RSA verification in the kernel
Date: Thu, 13 Jan 2011 12:30:36 +0200
Message-ID: <4D2ED44C.4040100@nokia.com>
References: <4D2EA764.4070109@nokia.com> <AANLkTi=O3Kn3u8-4P0MaFfzWBRY4P4bfE6a3n+xHt+EQ@mail.gmail.com> <4D2ED304.10306@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: ext Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:39309 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab1AMKch (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Jan 2011 05:32:37 -0500
In-Reply-To: <4D2ED304.10306@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

License of that library is such
--------------------------------------------------
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.

----------------------------------------------------


I wonder if such code can be integrated to Linux kernel..
It needs to be GPL..
Can this "F..G" license be converted to GPL...?

- Dmitry

On 13/01/11 12:25, Dmitry Kasatkin wrote:
> Hi,
>
> Indeed. Forgot about it. I even have that repo on my computer: newapi
> branch.
>
> Thanks,
>
> Dmitry
>
> On 13/01/11 10:08, ext Nikos Mavrogiannopoulos wrote:
>> On Thu, Jan 13, 2011 at 8:19 AM, Dmitry Kasatkin
>> <dmitry.kasatkin@nokia.com> wrote:
>>> Hi,
>>> Does anybody know if there is a GPL implementation of RSA verification
>>> for the Linux kernel?
>>> I know DigSig, but is anything recent available?
>> In NCR [http://home.gna.org/cryptodev-linux/ncr.html] I've added RSA and DSA
>> using the public domain libtommath/libtomcrypt. You could use them. The internal
>> API for RSA is the libtomcrypt one.
>>
>> regards,
>> Nikos
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
