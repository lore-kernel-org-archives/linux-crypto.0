From: Jorgen Lundman <lundman@lundman.net>
Subject: Re: Crypto causes panic in scatterwalk_done with large/multiple buffers
Date: Mon, 19 Nov 2012 09:29:22 +0900
Message-ID: <50A97D62.1000604@lundman.net>
References: <50A4AFEE.9030206@lundman.net> <20121117024220.12381ph1ph0fu3q8@www.dalek.fi> <20121117103901.664145ijlv5r29wk@www.dalek.fi> <50A82BD1.4000505@lundman.net> <20121118194033.20427f1141j4ic4c@www.dalek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-crypto@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.lundman.net ([210.157.1.114]:43065 "EHLO mail.lundman.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2KSA30 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2012 19:29:26 -0500
In-Reply-To: <20121118194033.20427f1141j4ic4c@www.dalek.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> 
> From what I now researched, you must not pass vmalloc'd memory to
> sg_set_buf() as it internally uses virt_to_page() to get page of buffer
> address. You most likely need to walk through your vmalloc'd buffer and
> pass all individual pages to scatterlist with sg_set_page().

I was told the same, so I wrote something that called vmalloc_to_page() for
each PAGE_SIZE of the vmalloced memory, with offsets, and created large
scatterlists (well, around ~120 or so).

Made no difference at all, still dies in scatterwalk_done.

Looking at blkcipher (ccm->ctr->blkcipher) and I see it has methods for
_phys(), _virt(), _virt_block(), _fast(), _slow() and _copy(). I was quite
interested in the copy() method, since that is what I am doing at the top.

No idea how I affect those types of use. phys and virt seem to be handled
internally, and virt_block() is what ctr.c uses.

This made me think the vmalloc thing isn't my problem.

Then I copied ccm.c, ctr.c and blkcipher.c to my own module, just so that I
could commend out:


static void Xscatterwalk_pagedone(struct scatter_walk *walk, int out,
                                 unsigned int more)
{

    if (out) {
        struct page *page;

        page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);

#if 0
        /*
         * This call causes panic, so all these sources are just to
         * avoid this call.
         *
         * Once this issue has been fixed, we can remove the entire
         * "sun-ccm(aes)" module.
         *
         */
        if (!PageSlab(page))
            flush_dcache_page(page);
#endif
    }

    if (more) {


And making the two functions, Xscatterwalk_done() and
Xscatterwalk_copychunks(), to call my version instead.

Wouldn't you know, all panics are gone. The misaligned buffer panic, gone.
Reverted back to just passing vmalloc() memory, no problems.

I have been running multi-gig bonnie++ for 24 hours (file system related
crypto). I am trusting that it is working now.

Tested with 3.2.0-0.bpo.3-amd64 and 3.5.0-17-generic.

> This is strange as crypto subsystem's internal test mechanism uses such
> offsetted buffers.
> 

I'm sure it does. I run my tests about 100 times and it usually dies around
~40th.


I appreciate your help,

Lund

-- 
Jorgen Lundman       | <lundman@lundman.net>
Unix Administrator   | +81 (0)3 -5456-2687 ext 1017 (work)
Shibuya-ku, Tokyo    | +81 (0)90-5578-8500          (cell)
Japan                | +81 (0)3 -3375-1767          (home)
