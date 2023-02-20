Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E49C636CC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Feb 2023 07:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjBTH2T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Feb 2023 02:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjBTH2S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2023 02:28:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371D183DB
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 23:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC24860C79
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2023 07:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36347C433EF
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2023 07:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676878096;
        bh=LC+TDP3eh3so5jEY4ZoPCULDKb3UFW2G90oxH/hxP2Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A6QlQ3pTtbotmwdL5r0XOaGOhqejkylW31CHKpRb3zuCaXYv3FmoZxh6Pnkma8L1J
         m9WxBqxPRpve5SLyJm/Bhe6FCd4EQoHmPeg7t7wkLwFaA0ZjyYfMXUqfo1YcXzRkCo
         R/pi1HmBmjzVDpUo6BFZo59oFzaYWYwCp1LomCoVhSFg9+ri/R2xN2eRJKv/7GYfA9
         y2BPjnJqGQrBtbSz7mDyJXxnpTjkftKNBnhEoAPqjUld+gzlZez+TPOucRGax/NsPh
         LKXWddJ0SPppsXp6KWG/D+IAsyvoenApy6taixhddQrXVnB5ZZYgwq/31u8Ws1Sdh2
         d2rrqEmPOzKaA==
Received: by mail-lj1-f177.google.com with SMTP id l8so208921ljq.3
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 23:28:16 -0800 (PST)
X-Gm-Message-State: AO0yUKW8usj1E+Sxh8Bohg/61EcdiJMRjauHcLGNpIxlB8SX6EFXb6My
        8odhUdsTZBUoXhab9gxD6P6eXvUSopD855EyXMU=
X-Google-Smtp-Source: AK7set8u7DW+ZZGAvjSWY1oVqWKfQsXsdbDLWmRQXXN/8y9XjKn/eGOMpP//FscR7xI+XKu8dkhUZFB6z9T8mHFb1vk=
X-Received: by 2002:a2e:a4dc:0:b0:293:5359:bf56 with SMTP id
 p28-20020a2ea4dc000000b002935359bf56mr302048ljm.2.1676878094240; Sun, 19 Feb
 2023 23:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20230217144348.1537615-1-ardb@kernel.org> <Y/L6rSGDidhhWq2v@gondor.apana.org.au>
In-Reply-To: <Y/L6rSGDidhhWq2v@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 20 Feb 2023 08:28:05 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com>
Message-ID: <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 20 Feb 2023 at 05:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Feb 17, 2023 at 03:43:48PM +0100, Ard Biesheuvel wrote:
> > Implement AES in CFB mode using the existing, mostly constant-time
> > generic AES library implementation. This will be used by the TPM code
> > to encrypt communications with TPM hardware, which is often a discrete
> > component connected using sniffable wires or traces.
> >
> > While a CFB template does exist, using a skcipher is a major pain for
> > non-performance critical synchronous crypto where the algorithm is known
> > at compile time and the data is in contiguous buffers with valid kernel
> > virtual addresses.
> >
> > Tested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Link: https://lore.kernel.org/all/20230216201410.15010-1-James.Bottomley@HansenPartnership.com/
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > v1 was sent out by James and is archived at the URL above
> >
> > v2:
> > - add test cases and kerneldoc comments
> > - add memzero_explicit() calls to wipe the keystream buffers
> > - add module exports
> > - add James's Tb/Rb
> >
> >  include/crypto/aes.h |   5 +
> >  lib/crypto/Kconfig   |   5 +
> >  lib/crypto/Makefile  |   3 +
> >  lib/crypto/aescfb.c  | 257 ++++++++++++++++++++
> >  4 files changed, 270 insertions(+)
>
> Could we remove the crypto/cfb.c implementation after this work
> is complete?
>

We would still not have any in-tree users of cfb(aes) or any other
cfb(*), so in that sense, yes.

However, skciphers can be called from user space, and we also rely on
this template for the extended testing of the various cfb() hardware
implementations that we have in the tree.

So the answer is no, I suppose. I would like to simplify it a bit,
though - it is a bit more complicated than it needs to be.
