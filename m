Return-Path: <SRS0=iH/+=X4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8911C10F14
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 21:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2AC02133F
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 21:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfJCVUr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Oct 2019 17:20:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:40600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727789AbfJCVUr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Oct 2019 17:20:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C7475AB87;
        Thu,  3 Oct 2019 21:20:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 50844DA890; Thu,  3 Oct 2019 23:21:01 +0200 (CEST)
Date:   Thu, 3 Oct 2019 23:21:01 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: BLAKE2 reference implementation
Message-ID: <20191003212101.GV2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
References: <cover.1569849051.git.dsterba@suse.com>
 <8087a8b358b5f97304963a38a17433a416d1382b.1569849051.git.dsterba@suse.com>
 <CAKv+Gu8tEL+5Q6c7TyQvmNjG+HnxfDa01RdE7UTH_YR+VhTpYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8tEL+5Q6c7TyQvmNjG+HnxfDa01RdE7UTH_YR+VhTpYQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

thanks for the review.

On Thu, Oct 03, 2019 at 02:18:55PM +0200, Ard Biesheuvel wrote:
> On Mon, 30 Sep 2019 at 15:12, David Sterba <dsterba@suse.com> wrote:
> > The patch brings support of several BLAKE2 algorithms (2b, 2s, various
> > digest lengths). The in-tree user will be btrfs (for checksumming),
> > we're going to use the BLAKE2b-256 variant. It would be ideal if the
> > patches get merged to 5.5, thats our target to release the support of
> > new hashes.
> 
> So this will be used as an alternative to crc32c, and plugged in at
> runtime depending on the algo described in the fs superblock?

Yes, exactly like that. One checksum for the whole filesystem,
specificed by a number in the superblock item.

> Is it performance critical?

I'd put it that performance is important and blake2 has been selected as
the fastest from the modern hashes (ie. sha3 was rejected for that
reason). We're going to add cryptographically strong hashes (blake2,
sha256) and a fast one (xxhash). So the users should choose what's the
best for their usecase given the trade-offs.

If the question is inspired by the current discussions around wireguard
and library versions, we're fine with using the current API as it's
reasonable for the hash algorithms.

Improvements regarding reduction of the overhead would be welcome but
is not important at the moment.

I'll send v2 with the review comments addressed. Thanks.

d.
