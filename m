Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBADCA9EB9
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 18:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84C402173B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 18:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388635AbfJWSLK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 14:11:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:56300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727309AbfJWSLJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 14:11:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD0E6B14B;
        Wed, 23 Oct 2019 18:11:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 404EDDA734; Wed, 23 Oct 2019 20:11:20 +0200 (CEST)
Date:   Wed, 23 Oct 2019 20:11:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 0/2] BLAKE2b generic implementation
Message-ID: <20191023181120.GF3001@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <cover.1571788861.git.dsterba@suse.com>
 <CAKv+Gu_yhm2hL+Sx6ZC3xWLcWuJLn+0erQaK6_NpL-aZo72AbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_yhm2hL+Sx6ZC3xWLcWuJLn+0erQaK6_NpL-aZo72AbA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 23, 2019 at 11:01:25AM +0200, Ard Biesheuvel wrote:
> On Wed, 23 Oct 2019 at 02:12, David Sterba <dsterba@suse.com> wrote:
> > Tested on x86_64 with KASAN and SLUB_DEBUG.
> 
> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org> # arm64 big-endian

Thanks!

> >  crypto/Kconfig           |  17 ++
> >  crypto/Makefile          |   1 +
> >  crypto/blake2b_generic.c | 413 +++++++++++++++++++++++++++++++++++++++
> >  crypto/testmgr.c         |  28 +++
> >  crypto/testmgr.h         | 307 +++++++++++++++++++++++++++++
> >  include/crypto/blake2b.h |  46 +++++
> 
> Final nit: do we need this header file at all? Could we move the
> contents into crypto/blake2b_generic.c? Or is the btrfs code going to
> #include it?

The only interesting part for btrfs would be the definition of
BLAKE2B_256_DIGEST_SIZE instead of hardcoding the number. As the patches
go through separate trees I have to use the hardcoded number anyway.

The header would make sense for the library version of blake2b, similar
to what the wireguard blake2s patches do, but there's no need for that
right now so I guess the header can be folded to .c.
