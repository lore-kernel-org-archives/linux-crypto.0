Return-Path: <SRS0=/v7T=NZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39728 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbeKOFNM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Nov 2018 00:13:12 -0500
Subject: Re: [PATCH] HID: add driver for U2F Zero built-in LED and RNG
From: Andrej Shadura <andrew.shadura@collabora.co.uk>
To: =?UTF-8?B?SmnFmcOtIEtvc2luYQ==?= <jikos@kernel.org>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        kernel@collabora.com, Vasily Khoruzhick <anarsoul@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        linux-crypto@vger.kernel.org, Conor Patrick <conorpp@vt.edu>
References: <20181023144654.12906-1-andrew.shadura@collabora.co.uk>
 <d848f97e-a9fc-1562-1963-3b608162106d@collabora.co.uk>
 <nycvar.YFH.7.76.1811121217030.27368@cbobk.fhfr.pm>
 <96148aff-eac8-7e25-dd74-b194b7bae025@collabora.co.uk>
Message-ID: <f68e61ad-4983-fc73-d91c-1d4f293a71cc@collabora.co.uk>
Date: Wed, 14 Nov 2018 11:08:36 -0800
MIME-Version: 1.0
In-Reply-To: <96148aff-eac8-7e25-dd74-b194b7bae025@collabora.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14/11/2018 10:32, Andrej Shadura wrote:
> On 12/11/2018 03:17, Jiri Kosina wrote:
>> On Thu, 1 Nov 2018, Andrej Shadura wrote:
>>
>>> Hi everyone,
>>>
>>> I’ve got a comment from Nick Kossifidis that I probably shouldn’t set
>>> RNG’s quality to 1024. Adding linux-crypto@ to the loop.
>>
>> So, what was this about? Is there any resolution to it? :)
> 
> So far, not really. I talked to Keith Packard regarding a similar
> setting in his ChaosKey driver, and I understand his opinion is that it
> is appropriate there since he’s convinced about the quality of the
> hardware he designed. I’m not sure what exactly I should set it to here.

Just talked to Theodore Ts'o about this, it seems that it doesn’t really
matter that much what to set it to, since this subsystem apparently will
be reworked soon, and setting it to a fair value of 0 will apparently
make it not feed the entropy pool at all, and with a non-zero value only
one device with the highest value will be used. I’m tempted to resubmit
the patch with 0 as the default (as Nick suggested) so that pro users
can toggle it later from the userspace, but it doesn’t have the
opportunity to potentially poison the entropy pool if it’s compromised.

Conor (cc'ed), out of curiosity, could you please post some info on how
the hardware RNG is implemented in U2F Zero?

>>> On 23/10/2018 16:46, Andrej Shadura wrote:
>>>> U2F Zero supports custom commands for blinking the LED and getting data
>>>> from the internal hardware RNG. Expose the blinking function as a LED
>>>> device, and the internal hardware RNG as an HWRNG so that it can be used
>>>> to feed the enthropy pool.
>>>>
>>>> Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
>>>> ---
>>>>  drivers/hid/Kconfig       |  15 ++
>>>>  drivers/hid/Makefile      |   1 +
>>>>  drivers/hid/hid-ids.h     |   1 +
>>>>  drivers/hid/hid-u2fzero.c | 371 ++++++++++++++++++++++++++++++++++++++
>>>>  4 files changed, 388 insertions(+)
>>>>  create mode 100644 drivers/hid/hid-u2fzero.
-- 
Cheers,
  Andrej
