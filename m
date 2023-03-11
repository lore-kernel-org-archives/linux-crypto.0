Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E8CC74A44
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 08:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjCKIze (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 03:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCKIzd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 03:55:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE885FA5E
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 00:55:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D42609EB
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D6AC4339B
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678524928;
        bh=d5rUCaLed0EKz0UtAvVS4tFCICnmJMFxqhLHvxeiLbY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RgBup6rs4va8txKaIqE23bpTiPudVoCXLNkqff770DAabsz33+7ZA5nkCIj15MrwR
         XA7s5kAGNTF26n2BlMfGt0389QToOjdqDShl7y4c7WGN+EMLxwEKWG+XvVoYIc1ZC9
         GhKO6Kk5zsvruvsFjggzYkkUXV/edG/LrHPHdfxD0Yo+A5PxknrjrBzfxlyJbjMVBR
         Cv3bvKduRMq8x1+hwYM2FYmPE80/H94TatRtpiF98bEzbLEDlZDPN+QVpwsAYtsMGx
         OFgytUvwMHWWXK2OgYh8GWVniN9GFbm7h2colbRBBNHbx5Gvk9y8KqGB3WIk6XfQet
         lnWoIRwqCzXfg==
Received: by mail-lf1-f52.google.com with SMTP id n2so9638974lfb.12
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 00:55:28 -0800 (PST)
X-Gm-Message-State: AO0yUKVpfYxW7jqrnN+B3cRizo6HiF2K9CNQCOxMFyYmAbYUOINMmR1e
        OjwpvIGFNPzLHDUAtOE3Blo32GR+1lrXSA7qH/g=
X-Google-Smtp-Source: AK7set8mfzPxBmPkZxv6nPIiyMPxE5lPAABQHRgDwwLqrT1rQIyLtlUgr6PnAQLhah8JEOZWxM1PyvqQ3M2Ppxr3Uho=
X-Received: by 2002:ac2:5de1:0:b0:4dd:af74:fe17 with SMTP id
 z1-20020ac25de1000000b004ddaf74fe17mr8766020lfq.7.1678524926968; Sat, 11 Mar
 2023 00:55:26 -0800 (PST)
MIME-Version: 1.0
References: <20230217144348.1537615-1-ardb@kernel.org> <Y/L6rSGDidhhWq2v@gondor.apana.org.au>
 <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com>
 <ZAsDT00Jgs2p6luL@gondor.apana.org.au> <CAMj1kXHhF7CyeGV2QHu6MRVQNKo1EHFkshewOfptEOdJ5znJDA@mail.gmail.com>
 <ZAw2eHDQELdiVXcZ@gondor.apana.org.au> <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
 <ZAw5Ffv7X2mNmbG8@gondor.apana.org.au> <CAMj1kXEr8W1NP0Xcny7ed1xb7ofb7Y6R57TPNe6=jAASDzHzKw@mail.gmail.com>
 <ZAxAK2rlOsQjlgB9@gondor.apana.org.au>
In-Reply-To: <ZAxAK2rlOsQjlgB9@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 11 Mar 2023 09:55:15 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG_27v0YXoO_8Avjcz=YtYhCfX_6pcXowk0fy5cYR6gVw@mail.gmail.com>
Message-ID: <CAMj1kXG_27v0YXoO_8Avjcz=YtYhCfX_6pcXowk0fy5cYR6gVw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 11 Mar 2023 at 09:47, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Mar 11, 2023 at 09:42:06AM +0100, Ard Biesheuvel wrote:
> >
> > Every call to crypto_skcipher_set_reqsize(), no?
>
> We'd only convert the software implementations.  But you're right
> there does seem to be a few users such as aria that demand a large
> amount of temp space.  I'd be tempted to just leave them on skcipher.
>
> In other cases such as ctr we can easily put the IV on the stack.
>

But why can't we make skcipher just a hybrid?

- make the scatterlist members in skcipher_request unions with virtual
src and dst alternatives
- add an API that assigns those alternative members and checks that
the tfm is not ALG_ASYNC
- make the existing skcipher_en/decrypt() implementations check the
request type, and hand off to a 'sync' alternative that allocates the
request ctx on the stack, and make the accessor return the stack
version instead of the heap version
- update skcipher_walk_xxx() to return the virtually addressable dst
and src if the sync request type is encountered.

That way, the skcipher implementations can remain as they are, and the
callers can just put a struct skcipher_request on the stack (without
the padding and ctx overhead) and call the new interface with virtual
addresses.

That way, all the SYNC_SKCIPHER hacks can go, and we don't need yet
another algo type.


That way, the implementations can remain the same,
