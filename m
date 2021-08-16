Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE91C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 11:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 405C661164
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Aug 2021 11:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbhHPLAl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Aug 2021 07:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbhHPLAf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Aug 2021 07:00:35 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEBDC0613C1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Aug 2021 04:00:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q6so11456712wrv.6
        for <linux-crypto@vger.kernel.org>; Mon, 16 Aug 2021 04:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Gl27ctEl0OvMeLBpmbnTOkT2KQz+Xemn+56DrD+juXI=;
        b=t+ydQo3H4rp2Ylgpm31fOeayrfUe8B7fNtlF8/3E6hKrvdRSSkz2Hgp8IDH67sjOR/
         0zV39bYslRN+robC75uEie3AEk//WqogM+zTK67g92ZiTTLJXf0FVl3DbAPzimJftez+
         xcANMADQguxtAi3T//RyAH/HMN1YtGqTfkFix1YenydoIu0z2gYlMPWReoFuJM1OrwwO
         a3G1wbK4SwX8tWnIwebpi6eki9pHNJz9R38CnPt64vdQKVUi9QzqL5xTsB+zxs5wvmCW
         YFkTstyN8YfTl9xXoXg/PVzdAgM8hN/teaj1oeV4nKsHwvGTQnNlZRD99hejg9JLt2Ml
         B3aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Gl27ctEl0OvMeLBpmbnTOkT2KQz+Xemn+56DrD+juXI=;
        b=V2k70ey3JNv2j3zRAF2Q7Kvr919PoqXebJiEwhBQszvJwK7aCpFXrxeZ2OGRsvz4XF
         3jAUn2rmwaJf5Tn4OW8KV4Hi/+XdQuLLuGv9UxjHJXbUFtgsAqv10BlaRlYBa3FQeJzb
         KGfHaeC9ewitzQkarm76iW4/B7WT/1ng48bk5b+tpEX53d2mAzcJ+0j1ykZ0HxOjVrEO
         lb5iwA50xTtAWo26dy8xQZ3LDMjDSYnrWyzFSKb/JVUTFrwuyNWQrkkZfPutOGMTiZ5L
         sgjN1PJJX1Ku9mzzRaO/bts7+F90BrCw2HtOKX+Vnsd/ApqdAT3treElhqpS1HZ98KP7
         0GYw==
X-Gm-Message-State: AOAM532Xc8mXqd8t7fSCqXD9BRi3XzfLG2jEfuQqdb0THnjA7aZXUvgG
        rZjBeo/fgrI2Qj/UvmnscQmLofV9imKllRP9xjysqRYdBiU=
X-Google-Smtp-Source: ABdhPJxDOT6M37BNiNrj5HsAkkeLc22V55jFHCl9JLIdHAvIWDuX56rldASR74veLZ8R1/6cZiD7+ooK1rBZo0mFOHo=
X-Received: by 2002:a5d:60cd:: with SMTP id x13mr17580192wrt.375.1629111602983;
 Mon, 16 Aug 2021 04:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
 <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com> <CACXcFmmW+tCUf8JS=a=wJEnBY2JojP8VwEGLncYcGLZqiU+5Jw@mail.gmail.com>
In-Reply-To: <CACXcFmmW+tCUf8JS=a=wJEnBY2JojP8VwEGLncYcGLZqiU+5Jw@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Mon, 16 Aug 2021 18:59:50 +0800
Message-ID: <CACXcFmmosvNMxwjOFZ9SDadqJE11w6Vva+i9AV1zYQxbwoB9sA@mail.gmail.com>
Subject: Re: Lockless /dev/random - Performance/Security/Stability improvement
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        John Denker <jsd@av8n.com>, m@ib.tc
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I wrote:

> > The basic ideas here look good to me; I will look at details later.
>
> Looking now, finding some things questionable.
> ...

I'm still looking & finding things that seem worth wondering about, &
asking about here.

I am by no means convinced that Mike's idea of a lockless driver is a
good one. Without some locks, if two or more parts of the code write
to the same data structure, then there's a danger one will overwrite
the other's contribution & we'll lose entropy.

However, I cannot see why any data structure should be locked when it
is only being read. There's no reason to care if others read it as
well. If someone writes to it, then the result of reading becomes
indeterminate. In most applications, that would be a very Bad Thing.
In this contact, though, it is at worst harmless & possibly a Good
Thing because it would make some attacks harder.

For example, looking at the 5.8.9 kernel Ubuntu gives me, I find this
in xtract_buf()

/* Generate a hash across the pool, 16 words (512 bits) at a time */
    spin_lock_irqsave(&r->lock, flags);
    for (i = 0; i < r->poolinfo->poolwords; i += 16)
        sha1_transform(hash.w, (__u8 *)(r->pool + i), workspace);

    /*
     * We mix the hash back into the pool ...
     */
    __mix_pool_bytes(r, hash.w, sizeof(hash.w));
    spin_unlock_irqrestore(&r->lock, flags);

The lock is held throughout the fairly expensive hash operation & I
see no reason why it should be. I'd have:

/* Generate a hash across the pool, 16 words (512 bits) at a time */
    for (i = 0; i < r->poolinfo->poolwords; i += 16)
        sha1_transform(hash.w, (__u8 *)(r->pool + i), workspace);

    /*
     * We mix the hash back into the pool ...
     */
    spin_lock_irqsave(&r->lock, flags);
    __mix_pool_bytes(r, hash.w, sizeof(hash.w));
    spin_unlock_irqrestore(&r->lock, flags);
