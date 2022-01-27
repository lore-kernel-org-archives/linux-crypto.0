Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FECFC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 00:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiA0AgK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 19:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiA0AgK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 19:36:10 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E80FC06161C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 16:36:10 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id o12so2030695eju.13
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 16:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X0Usarwu6KVRkGvtR6V1/OIm5/VM3r1k//rGHvbz25Y=;
        b=R5Qj0O+sETCdnxm9hPW2uISZBZlRVg37XJ3qtcaQVwhe/6CcL/1aRcasnfVO+p6deZ
         Jh/jInMG9hsw/Bl9ythl1icc9Q4Qg70+Xw4LUsuq/NFieC5tqp1ICcaVpu47fiJZWAPU
         qc/z0f4nyIiHnKe0uaEQgn9A6U+zvJLcP9F1gI/ttLspnJkhahqHDAJyZj1H5UxvFOLX
         bZw+v0kUK2/qffMrKOJx++RmGI/CpMyv7TOB6B2MVpMu9JikmIPDte/7p3z704gZDjAM
         /htQVoh1xDfu1MkYLgl2/UusDIy4oOc2EYACbp5Z6Av0j0FOuZJMtp94SJD17CLcLT7n
         4rpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X0Usarwu6KVRkGvtR6V1/OIm5/VM3r1k//rGHvbz25Y=;
        b=dz2zt7IJ8+OrnNgDxzM6Q+Dn7Q7xnxd2dC1XCltRcYih9QkYjy58LDGIcgToaOvTzT
         KiiFV6mxYwyqfd8kOrfazyt2t7siNEqmcFtP+5gIB+KwitVXZd/deXJsh9m6i/Tn6o2U
         Tg0ZE6Ymgt9S+yv3e5T5GC5iJgXaGTnIsVaN1ZnDQ728cBdl+YnFHMEMb7IusAkuamZk
         pGAkxzXfzYGE1+gYzZmQhOIa4bhoZkOZTyQm3u8dOuH+sSZuW5CTXUckdTZsVpOqdlqq
         OjWuh7NT2JhLhXgRZ/qXNfk3feyTq2Cve+Z03dt+t4wNFinHG44Iwq4DCD5YL29n8T0p
         9ZBw==
X-Gm-Message-State: AOAM531fS4RLTnXzYovHJBbjN+86dTHmtZrYhdcbHaZ4FPrPen7ISJ0L
        /QLBFUG3CBxcdq+IEMMIjZfGRrIDtnAFci8orxnadxexFaU=
X-Google-Smtp-Source: ABdhPJwQg1iJFohWR4PJndZBqiTXGBQPwpRdMrjPWQDgb9e0afm80x+zObQcU97WfshMPc7Q82bN/SIzpu4IBmHxIds=
X-Received: by 2002:a17:907:1c19:: with SMTP id nc25mr1090294ejc.354.1643243768550;
 Wed, 26 Jan 2022 16:36:08 -0800 (PST)
MIME-Version: 1.0
References: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
 <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
 <CACXcFmmW+tCUf8JS=a=wJEnBY2JojP8VwEGLncYcGLZqiU+5Jw@mail.gmail.com>
 <CACXcFmmosvNMxwjOFZ9SDadqJE11w6Vva+i9AV1zYQxbwoB9sA@mail.gmail.com> <YRp1YbpFdNG0IJMI@mit.edu>
In-Reply-To: <YRp1YbpFdNG0IJMI@mit.edu>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 27 Jan 2022 08:35:54 +0800
Message-ID: <CACXcFmmSBZ3zzpPOCtQ7Sp7y3cAcwi54kZP894PGR8DzHny_UQ@mail.gmail.com>
Subject: Re: Lockless /dev/random - Performance/Security/Stability improvement
To:     "Theodore Ts'o" <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        John Denker <jsd@av8n.com>, m@ib.tc
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 16, 2021 at 10:25 PM Theodore Ts'o <tytso@mit.edu> wrote:

> On Mon, Aug 16, 2021 at 06:59:50PM +0800, Sandy Harris wrote:

> > I am by no means convinced that Mike's idea of a lockless driver is a
> > good one. Without some locks, if two or more parts of the code write
> > to the same data structure, then there's a danger one will overwrite
> > the other's contribution & we'll lose entropy.
> >
> > However, I cannot see why any data structure should be locked when it
> > is only being read. There's no reason to care if others read it as
> > well. If someone writes to it, then the result of reading becomes
> > indeterminate. In most applications, that would be a very Bad Thing.
> > In this contact, though, it is at worst harmless & possibly a Good
> > Thing because it would make some attacks harder.
> >
> > For example, looking at the 5.8.9 kernel Ubuntu gives me, I find this
> > in xtract_buf()
> >
> > /* Generate a hash across the pool, 16 words (512 bits) at a time */
> >     spin_lock_irqsave(&r->lock, flags);
> >     for (i = 0; i < r->poolinfo->poolwords; i += 16)
> >         sha1_transform(hash.w, (__u8 *)(r->pool + i), workspace);
> >
> >     /*
> >      * We mix the hash back into the pool ...
> >      */
> >     __mix_pool_bytes(r, hash.w, sizeof(hash.w));
> >     spin_unlock_irqrestore(&r->lock, flags);
> >
> > The lock is held throughout the fairly expensive hash operation & I
> > see no reason why it should be.
>
> The reason why this is there is because otherwise, there can be two
> processes both trying to extract entry from the pool, and getting the
> same result, and returning the identical "randomness" to two different
> userspace processes.  Which would be sad....  (unless you are a
> nation-state attacker, I suppose :-)

So lock the chacha context, the data structure it writes, instead.
Since the write back to the pool is inside that lock, two threads
extracting entropy will get different results. Call mix_pool_bytes()
instead of __mix_pool_bytes() and it will do the necessary
locking when the input pool is written.

I think this deals with Mike's main objection:

" It is highly unusual that /dev/random is allowed to degrade the
" performance of all other subsystems - and even bring the
" system to a halt when it runs dry.

At any rate, it reduces the chance of other code that
writes to the input pool being blocked by random(4).
