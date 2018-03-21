From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH 1/5 v4] add compression algorithm zBeWalgo
Date: Wed, 21 Mar 2018 13:57:30 -0700
Message-ID: <CAOFm3uEpDh1jp1+ODzR=TFH0uq08LL2qjqrMLOe+_jE+4Sw_og@mail.gmail.com>
References: <D7FA4547-4FA6-46EC-99D7-F08ACCD3F13D@informatik.uni-hamburg.de>
 <CAOFm3uH1Nw3x6-T1yTMkoX2tpxiwjnerAXDh-WEpyFNROFwAYw@mail.gmail.com> <F4F10894-B101-4E46-A39D-7F09DEF2207D@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, minchan@kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F4F10894-B101-4E46-A39D-7F09DEF2207D@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Benjamin,

On Wed, Mar 21, 2018 at 12:32 AM, Benjamin Warnke
<4bwarnke@informatik.uni-hamburg.de> wrote:
> Ok, I will use
>
> /* SPDX-License-Identifier: GPL-2.0 */
> /*
>  * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
> ...
>
> at the top of my files instead of that boilerplate text. And
>
> MODULE_LICENSE("GPL");
>
> at the bottom of the module-files.

<snip>
>
> I used the file "crypto/lz4.c" - since it is a compression algorithm too - as an example of how to format the licensing text.
> Unfortunately there is the same 'error'.
> I fixed this error in all of my files in all patches.

Actually to be consistent if you want to use GPL-2-0 (and not "or
later") you should use:

1. at the top, for a c. file:
// SPDX-License-Identifier: GPL-2.0

or for a .h file:
/* SPDX-License-Identifier: GPL-2.0 */

The doc explains it all. Including the comment style (a topic that has
been discussed also on list quite bit: Linus had the final word there)

2. and in your MODULE_LICENSE macro:

MODULE_LICENSE("GPL v2");

.... because a MODULE_LICENSE("GPL"); would mean GPL-2.0+ (e.g. or any
later version) and this would not match your top level license tag.

I know this may seem confusing, but there is little hope we can change
the MODULE_LICENSE tags that are used by many external module loaders.
Comments in module.h explain it all.

-- 
Cordially
Philippe Ombredanne
