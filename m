Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73099CA9EA1
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 13:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A2D9222C2
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 13:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410147AbfJRNAY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 09:00:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:44458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410136AbfJRNAY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 09:00:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 56EC6AEF6;
        Fri, 18 Oct 2019 13:00:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BD3FEDA785; Fri, 18 Oct 2019 15:00:36 +0200 (CEST)
Date:   Fri, 18 Oct 2019 15:00:36 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v5 2/2] crypto: add test vectors for blake2b
Message-ID: <20191018130036.GC3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
References: <cover.1571043883.git.dsterba@suse.com>
 <a4e3e9db53b01c4092309a75e5b5d703ed344c5a.1571043883.git.dsterba@suse.com>
 <CAKv+Gu8m+CkrWj6fZi4XtEbpcDTM=d8HNS=9A5piJD8v41B-HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8m+CkrWj6fZi4XtEbpcDTM=d8HNS=9A5piJD8v41B-HQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 12:22:57PM +0200, Ard Biesheuvel wrote:
> On Mon, 14 Oct 2019 at 11:17, David Sterba <dsterba@suse.com> wrote:
> >
> > Test vectors for blake2b with various digest sizes. As the algorithm is
> > the same up to the digest calculation, the key and input data length is
> > distributed in a way that tests all combinanions of the two over the
> > digest sizes.
> >
> > Based on the suggestion from Eric, the following input sizes are tested
> > [0, 1, 7, 15, 64, 247, 256], where blake2b blocksize is 128, so the
> > padded and the non-padded input buffers are tested.
> >
> >           blake2b-160  blake2b-256  blake2b-384  blake2b-512
> >          ---------------------------------------------------
> > len=0   | klen=0       klen=1       klen=32      klen=64
> > len=1   | klen=32      klen=64      klen=0       klen=1
> > len=7   | klen=64      klen=0       klen=1       klen=32
> > len=15  | klen=1       klen=32      klen=64      klen=0
> > len=64  | klen=0       klen=1       klen=32      klen=64
> > len=247 | klen=32      klen=64      klen=0       klen=1
> > len=256 | klen=64      klen=0       klen=1       klen=32
> >
> 
> I don't think your vectors match this table. It looks to me that you
> used the first column for all of them?

You're right, the script that generated each digest picked the key/len
sequence from the beginning and I did not catch that, sorry.

> > +               .plaintext =
> > +                       "\x00\x01\x02\x03\x04\x05\x06\x07"
> > +                       "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> > +                       "\x10\x11\x12\x13\x14\x15\x16\x17"
> > +                       "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f"
> > +                       "\x20\x21\x22\x23\x24\x25\x26\x27"
> > +                       "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
> > +                       "\x30\x31\x32\x33\x34\x35\x36\x37"
> > +                       "\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f",
> 
> Given the number of occurrences of this sequence, I suggest we break
> it out of this data structure, i.e.,
> 
> static const char blake2s_ordered_sequence[256] = {
>   ...
> };
> 
> and use
> 
> .plaintext = blake2s_ordered_sequence
> 
> here, and in all other places where the entire sequence or part of it
> is being used.
> 
> I'm adopting this approach for my Blake2s tests as well - I'll cc you
> on those patches.

That's a great simplification, I'll do the same then.
