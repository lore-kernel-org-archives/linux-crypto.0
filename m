From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: Re: [PATCH 1/5 v4] add compression algorithm zBeWalgo
Date: Wed, 21 Mar 2018 08:32:46 +0100
Message-ID: <F4F10894-B101-4E46-A39D-7F09DEF2207D@informatik.uni-hamburg.de>
References: <D7FA4547-4FA6-46EC-99D7-F08ACCD3F13D@informatik.uni-hamburg.de>
 <CAOFm3uH1Nw3x6-T1yTMkoX2tpxiwjnerAXDh-WEpyFNROFwAYw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, minchan@kernel.org,
        ngupta@vflare.org,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Philippe Ombredanne <pombredanne@nexb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOFm3uH1Nw3x6-T1yTMkoX2tpxiwjnerAXDh-WEpyFNROFwAYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Philippe,


> Am 20.03.2018 um 17:30 schrieb Philippe Ombredanne <pombredanne@nexb.com>:
> 
> Hi Benjamin,
> 
> On Tue, Mar 20, 2018 at 7:04 AM, Benjamin Warnke
> <4bwarnke@informatik.uni-hamburg.de> wrote:
>> zBeWalgo is a completely new algorithm - Currently it is not published
>> somewhere else right now, googleing it would not show up any results. The
>> following section describes how the algorithm works.
> 
> <snip>
> 
>> diff --git a/lib/zbewalgo/zbewalgo.c b/lib/zbewalgo/zbewalgo.c
>> new file mode 100644
>> index 000000000..ef922bc27
>> --- /dev/null
>> +++ b/lib/zbewalgo/zbewalgo.c
>> @@ -0,0 +1,723 @@
>> +/*
>> + * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program.
>> + *
> 
> Would you mind using SPDX ids [1] instead of this fine boilerplate
> here and throughout your patches?

Ok, I will use 

/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
...

at the top of my files instead of that boilerplate text. And

MODULE_LICENSE("GPL");

at the bottom of the module-files.


> <snip>
> 
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("zBeWalgo Compression Algorithm");
> 
> Here your MODULE_LICENSE does not match your top level license. See
> module.h [2] for a description of values: GPL would mean "GNU Public
> License v2 or later" whereas your top level license (best expressed
> with SPDX) would mean GPL-2.0 and no other version. To avoid
> confusion, you would need to state the same thing in the
> MODULE_LICENSE and your SPDX tags.

I used the file "crypto/lz4.c" - since it is a compression algorithm too - as an example of how to format the licensing text.
Unfortunately there is the same 'error'.
I fixed this error in all of my files in all patches.

Cordially
Benjamin Warnke
