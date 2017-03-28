From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] crypto: ccp - Mark driver as little-endian only
Date: Tue, 28 Mar 2017 16:59:58 +0200
Message-ID: <CAK8P3a1TH9Lb5_HjTappqXr1X3S03b4M9TLPERa3BZqFeRKnTg@mail.gmail.com>
References: <20170328095814.3734615-1-arnd@arndb.de> <20170328095814.3734615-2-arnd@arndb.de>
 <f5780ea9-3479-22df-30a6-c03f40803c0d@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:36773 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752532AbdC1PAq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 11:00:46 -0400
In-Reply-To: <f5780ea9-3479-22df-30a6-c03f40803c0d@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 28, 2017 at 4:08 PM, Gary R Hook <ghook@amd.com> wrote:

>> In fact, the use of bit fields in hardware defined data structures is
>> not portable to start with, so until all these bit fields get replaced
>> by something else, the driver cannot work on big-endian machines, and
>> I'm adding an annotation here to prevent it from being selected.
>
>
> This is a driver that talks to hardware, a device which, AFAIK, has no
> plan to be implemented in a big endian flavor. I clearly need to be more
> diligent in building with various checkers enabled. I'd prefer my fix
> over your suggested refusal to compile, if that's okay.

It's hard to predict the future. If this device ever makes it into an
ARM based chip, the chances are relatively high that someone
will eventually run a big-endian kernel on it. As long as it's guaranteed
to be x86-only, the risk of anyone running into the bug is close to
zero, but we normally still try to write device drivers in portable C
code to prevent it from getting copied incorrectly into another driver.

>> The CCPv3 code seems to not suffer from this problem, only v5 uses
>> bitfields.
>
>
> Yes, I took a different approach when I wrote the code. IMO (arguably)
> more readable. Same result: words full of hardware-dependent bit patterns.
>
> Please help me understand what I could do better.

The rule for portable drivers is that you must not use bitfields in structures
that can be accessed by the hardware. I think you can do this in a more
readable way by removing the CCP5_CMD_* macros etc completely
and just accessing the members of the structure as __le32 words.
The main advantage for readability here is that you can grep for the
struct members and see where they are used without following the
macros. If it helps, you can also encapsulate the generation of the
word inside of an inline function, like:

static inline __le32 ccp5_cmd_dw0(bool soc, bool ioc, bool init, bool
eom, u32 engine)
{
        u32 dw0 = (soc  ? CCP5_WORD0_SOC  : 0)  |
                  (ioc  ? CCP5_WORD0_IOC  : 0)  |
                  (init ? CCP5_WORD0_INIT : 0)  |
                  (eom  ? CCP5_WORD0_EOM  : 0)  |
                CCP5_WORD0_ENGINE(engine);

        return __cpu_to_le32(dw0);
}

...
desc->dw0 = ccp5_cmd_dw0(op->soc, 0, op->init, op->oem, op->engine);

       Arnd
