Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB85C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 15:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59FA623731
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 15:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgLGPyF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 10:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGPyF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 10:54:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBE4C061749;
        Mon,  7 Dec 2020 07:53:25 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607356403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iOkZ3W3L6bSlN1APqwo5nIbtEaSMrjF8AC1jOpzqAYQ=;
        b=DLUeAs6z7ruzwD1nO9N5q2h9ySs502k7C/NjLDlKP3QPiqtaYKGnGduBhA7hvz0PJ/mCXG
        /2yd7g6u1OAOE0+FtCgqBlqlH1ojAFEfpgvstJxlVYP/7OxX37BW70nEjPzRCz8grX+K7v
        36tsLhxo3zsPPC8aywkLsI78RRXtzEePzzF4IiKLq8z4c/OKCygD/IJbbZ066VSKyZnNSR
        hpX0rm1sa9NIWtTQwVC/Pslf4VYwZ8ZV2cXSzsDoLXiKt/Y79GOIpiP8AgsVhAKqnRc0ZV
        uJAda+nTdqOrHefeDqI3BGj7/UnWjNqtm7DTVvnvBz4OVdo+65nfWW2ofi0KLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607356403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iOkZ3W3L6bSlN1APqwo5nIbtEaSMrjF8AC1jOpzqAYQ=;
        b=3FfR88oQdeCnzCNAmXtEP9jaR90FX/aW6kJwge0mwQRORSYJTbOJ71GDDVCZP1z0L3bM8h
        vC889D2QR6hiMBBg==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201207121820.GB8458@Red>
References: <20201203173846.GA16207@Red> <87r1o6bh1u.fsf@nanos.tec.linutronix.de> <20201204132631.GA25321@Red> <874kl1bod0.fsf@nanos.tec.linutronix.de> <20201204192753.GA19782@Red> <87wnxx9tle.fsf@nanos.tec.linutronix.de> <20201205184334.GA8034@Red> <87mtys8268.fsf@nanos.tec.linutronix.de> <20201206214053.GA8458@Red> <87ft4i79oq.fsf@nanos.tec.linutronix.de> <20201207121820.GB8458@Red>
Date:   Mon, 07 Dec 2020 16:53:23 +0100
Message-ID: <87o8j562a4.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 07 2020 at 13:18, Corentin Labbe wrote:
> On Mon, Dec 07, 2020 at 01:15:49AM +0100, Thomas Gleixner wrote:

> So if I understand correctly, basicly I cannot have two atomic kmap at
> the same time since it made unmapping them in the right order complex.

You can, but the ordering has to be correct and with sg_miter that's
probably hard to get right.

> I am not sure to have well understood your hint, but could you give me

So the point is:

   sg_miter_next(&mi);  map 1 -> vaddr1
   sg_miter_next(&mo);  map 2 -> vaddr2

   do {
      ...
      if (cond) {
         sg_miter_next(&mi)
           sg_miter_stop()
             unmap(vaddr1);      unmaps map2   -> FAIL
             if (next_page)
                map();           maps map2 -> vaddr2 -> FAIL
      }

The only way how that could have ever worked is when the conditional
sg_miter_next(&mi) did not try to map a new page, i.e. end of data.

The ARM kunmap_atomic() had:

#ifdef CONFIG_DEBUG_HIGHMEM
		BUG_ON(vaddr != __fix_to_virt(idx));
		set_fixmap_pte(idx, __pte(0));
#else

which means the warning and clearing the PTE only happens when debugging
is enabled. That made your code "work" by chance because the unmap
leaves map2 intact which means the vaddr2 mapping stays valid, so the
access to it further down still worked.

   sg_miter_next(&mi);  map 1 -> vaddr1
   sg_miter_next(&mo);  map 2 -> vaddr2

   do {
      ...
      if (cond) {
         sg_miter_next(&mi)
           sg_miter_stop()
             unmap(vaddr1);      idx 2 ---> 1
                                 but mapping still valid for vaddr2
      }

   *vaddr2 = x;                  works by chance

But that also would cause trouble in the following case:

   sg_miter_next(&mi);  map 1 -> vaddr1
   sg_miter_next(&mo);  map 2 -> vaddr2

   do {
      ...
      if (cond) {
         sg_miter_next(&mi)
           sg_miter_stop()
             unmap(vaddr1);      idx 2 ---> 1
                                 but mapping still valid for vaddr2
      }

interrupt
   kmap_atomic(some_other_page)
     idx 1 -> 2                 map some_otherpage to vaddr2
   kunmap_atomic(vaddr2)        idx 2 --->  1
                                mapping still valid for vaddr2,
                                but now points to some_other_page
end of interrupt

      *vaddr2 = x;              <-- accesses some_other_page  -> FAIL

This is the worst one because it's random data corruption and extremly
hard to debug.

I made the warning and the pte clearing in the new code unconditional
just to catch any issues upfront which it did.

   sg_miter_next(&mi);  map 1 -> vaddr1
   sg_miter_next(&mo);  map 2 -> vaddr2

   do {
      ...
      if (cond) {
         sg_miter_next(&mi)
           sg_miter_stop()
             unmap(vaddr1);      unmaps map2   -> FAIL
             clear map2          invalidates vaddr2
      }

      *vaddr2 = x;              <-- accesses the unmapped vaddr2 -> CRASH
 
> what you think about the following patch which fix (at least) the
> crash.  Instead of holding SGmiter (and so two kmap), I use only one
> at a time.

That looks fine at least vs. the sg_miter/kmap_atomic usage.

Thanks,

        tglx
