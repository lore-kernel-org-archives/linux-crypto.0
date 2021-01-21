Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5679EC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 18:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 220F523136
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 18:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbhAUSZb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 13:25:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728527AbhAUSWu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 13:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611253244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OyOuopIrv8/4vEEbULgoV2l5thLbiLJaFXm8XTuoUpU=;
        b=gca44VZLfifzpbXlle31xkTD6/HwoKzB1Xuu38BUHZ2TgauPzC+NmwOeUe4EJ4Mm76ukAb
        f5SY0E8N1Ac+7WWgM0+1Bojo82h9wWOLHXJsRpH9JSNpje/eEfLPbysDJws8rFCb8evM0E
        +nF34Yi7nApo9PMnwXz/wVbbt+4rRxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-4JTMUH6WP-GnXSxqZovbEg-1; Thu, 21 Jan 2021 13:20:40 -0500
X-MC-Unique: 4JTMUH6WP-GnXSxqZovbEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72A7859;
        Thu, 21 Jan 2021 18:20:39 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F07C5D749;
        Thu, 21 Jan 2021 18:20:36 +0000 (UTC)
Date:   Thu, 21 Jan 2021 13:20:35 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/5] crypto: remove Salsa20 stream cipher algorithm
Message-ID: <20210121182035.GB4662@redhat.com>
References: <20210121130733.1649-1-ardb@kernel.org>
 <20210121130733.1649-6-ardb@kernel.org>
 <YAnCbnnFCQkyBpUA@sol.localdomain>
 <CAMj1kXEycOHSMQu2T1tdQrmapk+g0oQFDiWXDo0J0BKg4QgEuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEycOHSMQu2T1tdQrmapk+g0oQFDiWXDo0J0BKg4QgEuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 21 2021 at  1:09pm -0500,
Ard Biesheuvel <ardb@kernel.org> wrote:

> On Thu, 21 Jan 2021 at 19:05, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Jan 21, 2021 at 02:07:33PM +0100, Ard Biesheuvel wrote:
> > > Salsa20 is not used anywhere in the kernel, is not suitable for disk
> > > encryption, and widely considered to have been superseded by ChaCha20.
> > > So let's remove it.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  Documentation/admin-guide/device-mapper/dm-integrity.rst |    4 +-
> > >  crypto/Kconfig                                           |   12 -
> > >  crypto/Makefile                                          |    1 -
> > >  crypto/salsa20_generic.c                                 |  212 ----
> > >  crypto/tcrypt.c                                          |   11 +-
> > >  crypto/testmgr.c                                         |    6 -
> > >  crypto/testmgr.h                                         | 1162 --------------------
> > >  7 files changed, 3 insertions(+), 1405 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> > > index 4e6f504474ac..d56112e2e354 100644
> > > --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
> > > +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
> > > @@ -143,8 +143,8 @@ recalculate
> > >  journal_crypt:algorithm(:key)        (the key is optional)
> > >       Encrypt the journal using given algorithm to make sure that the
> > >       attacker can't read the journal. You can use a block cipher here
> > > -     (such as "cbc(aes)") or a stream cipher (for example "chacha20",
> > > -     "salsa20" or "ctr(aes)").
> > > +     (such as "cbc(aes)") or a stream cipher (for example "chacha20"
> > > +     or "ctr(aes)").
> >
> > You should check with the dm-integrity maintainers how likely it is that people
> > are using salsa20 with dm-integrity.  It's possible that people are using it,
> > especially since the documentation says that dm-integrity can use a stream
> > cipher and specifically gives salsa20 as an example.
> >
> 
> Good point - cc'ed them now.
> 

No problem here, if others don't find utility in salsa20 then
dm-integrity certainly isn't the hold-out.

Acked-by:  Mike Snitzer <snitzer@redhat.com>

Mike

