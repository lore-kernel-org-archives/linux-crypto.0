From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] Add Ingenic JZ4780 hardware RNG driver
Date: Fri, 19 Aug 2016 18:39:00 +0530
Message-ID: <CANc+2y4-sVNbs9=uuESoWY8Db3i_GkxQ=hrAEF8oWFGBm6fiKw@mail.gmail.com>
References: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com> <CAH8yC8ny62Vf63cjtL8bUgGoRr-0BVGvqazs20S4JreJq+OBcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34953 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753665AbcHSNJC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2016 09:09:02 -0400
In-Reply-To: <CAH8yC8ny62Vf63cjtL8bUgGoRr-0BVGvqazs20S4JreJq+OBcg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> __ARM_FEATURE_UNALIGNED (cf.,
> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0774f/chr1383660321827.html)
> . MIPSEL does not define such a macro.
>
>     # MIPS ci20 creator with GCC 4.6
>     $ gcc -march=native -dM -E - </dev/null | grep -i align
>     #define __BIGGEST_ALIGNMENT__ 8
>
> If the MIPS CPU does not tolerate unaligned data access, then the
> following could SIGBUS:
>
>> +       u32 *data = buf;
>> +       *data = jz4780_rng_readl(jz4780_rng, REG_RNG_DATA);
>
> If GCC emits code that uses the MIPS unaligned load and store
> instructions, then there's probably going to be a performance penalty.
>
> Regardless of what the CPU tolerates, I believe unaligned data access
> is undefined behavior in C/C++. I believe you should memcpy the value
> into the buffer.

I am not sure whether this is required. 'buf' is part of a structure
so I guess it is properly aligned by padding. Not sure though, will
look about this.
