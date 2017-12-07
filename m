From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [Part2 PATCH v9 12/38] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Thu, 7 Dec 2017 22:20:49 +0100
Message-ID: <CAOFm3uGqTZa9forFDFWdnGOx9z2OwEh0=jzL5U11=STqgPkxkA@mail.gmail.com>
References: <20171205010438.5773-1-brijesh.singh@amd.com> <20171205010438.5773-13-brijesh.singh@amd.com>
 <CAOFm3uE06YTvfwe5P0uq3Pgc4PwzQmTh=dvVUuV5WxPjAf2Sdw@mail.gmail.com> <d90c011a-82b2-2599-6988-02d1497b028e@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, bp@alien8.de, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39611 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdLGVVb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 16:21:31 -0500
Received: by mail-wr0-f194.google.com with SMTP id a41so8922837wra.6
        for <linux-crypto@vger.kernel.org>; Thu, 07 Dec 2017 13:21:30 -0800 (PST)
In-Reply-To: <d90c011a-82b2-2599-6988-02d1497b028e@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 7, 2017 at 9:21 PM, Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 12/06/2017 03:10 PM, Philippe Ombredanne wrote:>> diff --git
> a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>>>
>>> new file mode 100644
>>> index 000000000000..b5789f878560
>>> --- /dev/null
>>> +++ b/drivers/crypto/ccp/psp-dev.c
>>> @@ -0,0 +1,105 @@
>>> +/*
>>> + * AMD Platform Security Processor (PSP) interface
>>> + *
>>> + * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
>>> + *
>>> + * Author: Brijesh Singh <brijesh.singh@amd.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>
>>
>> Dear Brijesh,
>>
>> Have you considered using the new SPDX license ids instead?
>>
>> This would come out this way:
>>>
>>> +// SDPX-License-Identifier: GPL-2.0
>>> +/*
>>> + * AMD Platform Security Processor (PSP) interface
>>> + *
>>> + * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
>>> + *
>>> + * Author: Brijesh Singh <brijesh.singh@amd.com>
>>> + */
>>
>>
>> It is much cleaner and simpler, right?
>>
>> For the C++ comment style and first line placement, please see Thomas
>> (tlgx) doc patches and Linus posts explaining his rationale of why he
>> wants it this way.
>> It would be awesome if this could be applied to all AMD contributions btw!
>>
>
> Hi Philippe,
>
> I was not aware of SPDX identifier, If v10 is needed for SEV series then I
> will certainly update the patches to use SPDX license identifier. thanks


Brijesh, that's very kind of you!

-- 
Cordially
Philippe Ombredanne
