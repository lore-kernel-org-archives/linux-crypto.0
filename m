Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B098C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 19:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9B1120663
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 19:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfJMTum (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 15:50:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:34674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbfJMTum (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 15:50:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7ABB5B3E7;
        Sun, 13 Oct 2019 19:50:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0F6C9DA7E3; Sun, 13 Oct 2019 21:50:53 +0200 (CEST)
Date:   Sun, 13 Oct 2019 21:50:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>, linux-crypto@vger.kernel.org,
        ard.biesheuvel@linaro.org
Subject: Re: [PATCH v4 0/5] BLAKE2b generic implementation
Message-ID: <20191013195052.GM2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
References: <cover.1570812094.git.dsterba@suse.com>
 <20191011175739.GA235973@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011175739.GA235973@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 10:57:40AM -0700, Eric Biggers wrote:
> The choice of data lengths seems a bit unusual, as they include every length in
> two ranges but nothing in between.  Also, none of the lengths except 0 is a
> multiple of the blake2b block size.  Instead, maybe use something like
> [0, 1, 7, 15, 64, 247, 256]?

Just to clarify, do you mean the block size defined by BLAKE2B_BLOCKBYTES?
That's 128, so that makes 0 and 256 the multiples.

> Also, since the 4 variants share nearly all their code, it seems the tests would
> be just as effective in practice if we cut the test vectors down by 4x by
> distributing the key lengths among each variant.  Like:
> 
>           blake2b-160  blake2b-256  blake2b-384  blake2b-512
>          ---------------------------------------------------
> len=0   | klen=0       klen=1       klen=16      klen=32
> len=1   | klen=16      klen=32      klen=0       klen=1
> len=7   | klen=32      klen=0       klen=1       klen=16
> len=15  | klen=1       klen=16      klen=32      klen=0
> len=64  | klen=0       klen=1       klen=16      klen=32
> len=247 | klen=16      klen=32      klen=0       klen=1
> len=256 | klen=32      klen=0       klen=1       klen=16

That's clever. I assume the 32 key length refers to the default key,
right? That's 64 bytes (BLAKE2B_KEYBYTES), so I'll use that value.

> > Testing performed:
> > 
> > - compiled with SLUB_DEBUG and KASAN, plus crypto selftests
> >   CONFIG_CRYPTO_MANAGER2=y
> >   CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
> >   CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> > - module loaded, no errors reported from the tessuite
> > - (un)intentionally broken test values were detected
> > 
> > The test values were produced by b2sum, compiled from the reference
> > implementation. The generated values were cross-checked by pyblake2
> > based script (ie. not the same sources, built by distro).
> > 
> > The .h portion of testmgr is completely generated, so in case somebody feels
> > like reducing it in size, adding more keys, changing the formatting, it's easy
> > to do.
> 
> > 
> > In case the patches don't make it to the mailinglist, it's in git
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/blake2b-v4
> 
> Can you please rebase this onto cryptodev/master?

Will do.

Thanks for the comments.
