Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF1FC4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 14:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1B6A60EBB
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 14:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhHPO0a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Aug 2021 10:26:30 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41480 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232234AbhHPO0a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Aug 2021 10:26:30 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17GEPbSw009058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 10:25:38 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9060C15C3DB9; Mon, 16 Aug 2021 10:25:37 -0400 (EDT)
Date:   Mon, 16 Aug 2021 10:25:37 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        John Denker <jsd@av8n.com>, m@ib.tc
Subject: Re: Lockless /dev/random - Performance/Security/Stability improvement
Message-ID: <YRp1YbpFdNG0IJMI@mit.edu>
References: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
 <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
 <CACXcFmmW+tCUf8JS=a=wJEnBY2JojP8VwEGLncYcGLZqiU+5Jw@mail.gmail.com>
 <CACXcFmmosvNMxwjOFZ9SDadqJE11w6Vva+i9AV1zYQxbwoB9sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmmosvNMxwjOFZ9SDadqJE11w6Vva+i9AV1zYQxbwoB9sA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 16, 2021 at 06:59:50PM +0800, Sandy Harris wrote:
> I am by no means convinced that Mike's idea of a lockless driver is a
> good one. Without some locks, if two or more parts of the code write
> to the same data structure, then there's a danger one will overwrite
> the other's contribution & we'll lose entropy.
> 
> However, I cannot see why any data structure should be locked when it
> is only being read. There's no reason to care if others read it as
> well. If someone writes to it, then the result of reading becomes
> indeterminate. In most applications, that would be a very Bad Thing.
> In this contact, though, it is at worst harmless & possibly a Good
> Thing because it would make some attacks harder.
> 
> For example, looking at the 5.8.9 kernel Ubuntu gives me, I find this
> in xtract_buf()
> 
> /* Generate a hash across the pool, 16 words (512 bits) at a time */
>     spin_lock_irqsave(&r->lock, flags);
>     for (i = 0; i < r->poolinfo->poolwords; i += 16)
>         sha1_transform(hash.w, (__u8 *)(r->pool + i), workspace);
> 
>     /*
>      * We mix the hash back into the pool ...
>      */
>     __mix_pool_bytes(r, hash.w, sizeof(hash.w));
>     spin_unlock_irqrestore(&r->lock, flags);
> 
> The lock is held throughout the fairly expensive hash operation & I
> see no reason why it should be.

The reason why this is there is because otherwise, there can be two
processes both trying to extract entry from the pool, and getting the
same result, and returning the identical "randomness" to two different
userspace processes.  Which would be sad....  (unless you are a
nation-state attacker, I suppose :-)

Cheers,

					- Ted
