From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: scatterwalk_map_and_copy incorrect optimization
Date: Fri, 9 Dec 2016 14:18:01 +0100
Message-ID: <CAHmME9p24bkNPD2CfGMUOHxgOX+OuFO_rVqfhOQdDexwW53ExA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:46288 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932595AbcLINSK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 08:18:10 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

The scatterwalk_map_and_copy function copies ordinary buffers to and
from scatterlists. These buffers can, of course, be on the stack, and
this remains the most popular use of this function -- getting info
between stack buffers and DMA regions. It's mostly used for adding or
checking MACs, in the majority of call sites. Its implementation is
relatively straightforward. It maps the DMA region(s) to a vaddr, and
then just calls vanilla memcpy. Pretty uncontroversial.

However, around ~4.1 an optimization was added to prevent copying when
unnecessary (when the src and dst are the same). The optimization
looks like this:

        if (sg_page(sg) == virt_to_page(buf) &&
           sg->offset == offset_in_page(buf))
               return;

There are two problems with this:

1) If buf points to a large contiguous region, but sg points to
several smaller regions, with the first one of which being smaller
than buf, then this function will not actually copy the latter
fragments to the large contiguous buf. Maybe you don't care about
this, but it is a limitation and a potential source of bugs down the
line.

2) If buf points to the stack, this optimization is totally wrong,
since you shouldn't call virt_to_page on stack addresses.

Since this function is primarily used for copying to and from the
stack, item (2) is especially worrisome. A very quick fix for that
would be to just:

        if (!object_is_on_stack(buf) &&
           sg_page(sg) == virt_to_page(buf) &&
           sg->offset == offset_in_page(buf))
               return;

This doesn't address item (1), however. If you care about fixing item
(1), then maybe a reasonable way would be to just remove the
optimization all together.

I'll submit a patch for the !object_is_on_stack(buf) fix. But maybe
you'd prefer that I submit a patch that removes the whole optimization
entirely. Or something else -- just let me know.

Regards,
Jason
