From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH 1/5 v4] add compression algorithm zBeWalgo
Date: Tue, 20 Mar 2018 09:30:12 -0700
Message-ID: <CAOFm3uH1Nw3x6-T1yTMkoX2tpxiwjnerAXDh-WEpyFNROFwAYw@mail.gmail.com>
References: <D7FA4547-4FA6-46EC-99D7-F08ACCD3F13D@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, minchan@kernel.org,
        ngupta@vflare.org,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D7FA4547-4FA6-46EC-99D7-F08ACCD3F13D@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Benjamin,

On Tue, Mar 20, 2018 at 7:04 AM, Benjamin Warnke
<4bwarnke@informatik.uni-hamburg.de> wrote:
> zBeWalgo is a completely new algorithm - Currently it is not published
> somewhere else right now, googleing it would not show up any results. The
> following section describes how the algorithm works.

<snip>

> diff --git a/lib/zbewalgo/zbewalgo.c b/lib/zbewalgo/zbewalgo.c
> new file mode 100644
> index 000000000..ef922bc27
> --- /dev/null
> +++ b/lib/zbewalgo/zbewalgo.c
> @@ -0,0 +1,723 @@
> +/*
> + * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.
> + *

Would you mind using SPDX ids [1] instead of this fine boilerplate
here and throughout your patches?

<snip>

> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("zBeWalgo Compression Algorithm");

Here your MODULE_LICENSE does not match your top level license. See
module.h [2] for a description of values: GPL would mean "GNU Public
License v2 or later" whereas your top level license (best expressed
with SPDX) would mean GPL-2.0 and no other version. To avoid
confusion, you would need to state the same thing in the
MODULE_LICENSE and your SPDX tags.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/license-rules.rst
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/module.h#n175
-- 
Cordially
Philippe Ombredanne
