Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F126BC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 14:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC6F2395A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 14:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgLQOCS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 09:02:18 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:58563 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgLQOCR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 09:02:17 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3878ca99
        for <linux-crypto@vger.kernel.org>;
        Thu, 17 Dec 2020 13:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=0aw5hLqJR4v9VhWFOub3GvFpNw0=; b=KJKWdb
        LzN6FZAbjB8oj/u23Spa78T+5S3Ihi1iR5na3l0T9PDYE8BFuOsYp04y8e97tcsN
        kPJQUpd9nr90VRPuKDFCyNkIG1dNOyrTBH+qeGvc28T2Ht5EJ29r20EvxxtkITac
        cQC3TbN/ABWh4EGxre3PzqZVFKnhMzCd5i+pYG0PWtYwp230yXiIqJr2bj0R6xz5
        CNuqLOCYvywklg6J1yONVtjpIte4tOXdsRrsPx98JcxqrnHJO/XxuVCntsM9/2QK
        /Hs+4f34TTckROLhc2eX2UW/RkH9RlM8Xf/KJGEUVTOlIgucuKqnOOFP0H6qqheN
        fw/EhWZrFkrHLLOg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 96102038 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 17 Dec 2020 13:53:50 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id d37so1488481ybi.4
        for <linux-crypto@vger.kernel.org>; Thu, 17 Dec 2020 06:01:35 -0800 (PST)
X-Gm-Message-State: AOAM531o4wNZwb/4btKXEBMbsRZjA6RYQ2FpWz74N4r6GnvZajs0M0dd
        uk125L1Lb1DdZrNcG5GsQ5uEpvt9LBAmlqadNzU=
X-Google-Smtp-Source: ABdhPJz4wQxBSA3ZCgR3XksY5Kd8n7xxVwzeQhw60kUbwdUENg6+9sEbepfMN/wneWWko81mTF+PoDShJBbIVn6MPog=
X-Received: by 2002:a25:4744:: with SMTP id u65mr61913760yba.239.1608213695207;
 Thu, 17 Dec 2020 06:01:35 -0800 (PST)
MIME-Version: 1.0
References: <20201215234708.105527-1-ebiggers@kernel.org> <X9pyfAaw5hQ6ngTI@gmail.com>
 <CAHmME9qj+D8opq6pnoMd4vsOsTYaL9Ntxk0HvskAiPvXFev75A@mail.gmail.com> <X9rWatnoHtF/7gBU@sol.localdomain>
In-Reply-To: <X9rWatnoHtF/7gBU@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 17 Dec 2020 15:01:24 +0100
X-Gmail-Original-Message-ID: <CAHmME9qk=L1g1tMPqwSgfbzCRjp_cnxL9paPOJnRpnx8s9jTAw@mail.gmail.com>
Message-ID: <CAHmME9qk=L1g1tMPqwSgfbzCRjp_cnxL9paPOJnRpnx8s9jTAw@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: add NEON-optimized BLAKE2b
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 4:54 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Dec 16, 2020 at 11:32:44PM +0100, Jason A. Donenfeld wrote:
> > Hi Eric,
> >
> > On Wed, Dec 16, 2020 at 9:48 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > By the way, if people are interested in having my ARM scalar implementation of
> > > BLAKE2s in the kernel too, I can send a patchset for that too.  It just ended up
> > > being slower than BLAKE2b and SHA-1, so it wasn't as good for the use case
> > > mentioned above.  If it were to be added as "blake2s-256-arm", we'd have:
> >
> > I'd certainly be interested in this. Any rough idea how it performs
> > for pretty small messages compared to the generic implementation?
> > 100-140 byte ranges? Is the speedup about the same as for longer
> > messages because this doesn't parallelize across multiple blocks?
> >
>
> It does one block at a time, and there isn't much overhead, so yes the speedup
> on short messages should be about the same as on long messages.
>
> I did a couple quick userspace benchmarks and got (still on Cortex-A7):
>
>         100-byte messages:
>                 BLAKE2s ARM:     28.9 cpb
>                 BLAKE2s generic: 42.4 cpb
>
>         140-byte messages:
>                 BLAKE2s ARM:     29.5 cpb
>                 BLAKE2s generic: 44.0 cpb
>
> The results in the kernel may differ a bit, but probably not by much.

That's certainly a nice improvement though, and I'd very much welcome
the faster implementation.

Jason
