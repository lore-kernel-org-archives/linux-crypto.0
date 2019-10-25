Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC9FCA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C242C21E6F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395548AbfJYP42 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:56:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:51488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388136AbfJYP42 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 11:56:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F529B54C;
        Fri, 25 Oct 2019 15:56:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8756DDA785; Fri, 25 Oct 2019 17:56:38 +0200 (CEST)
Date:   Fri, 25 Oct 2019 17:56:38 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>, linux-crypto@vger.kernel.org,
        ard.biesheuvel@linaro.org
Subject: Re: [PATCH v7 1/2] crypto: add blake2b generic implementation
Message-ID: <20191025155638.GN3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
References: <cover.1571934170.git.dsterba@suse.com>
 <79e47ab2c559c974d950a238e9db909795b4268d.1571934170.git.dsterba@suse.com>
 <20191025051550.GA103313@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025051550.GA103313@sol.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 24, 2019 at 10:15:50PM -0700, Eric Biggers wrote:
> On Thu, Oct 24, 2019 at 06:28:31PM +0200, David Sterba wrote:
> > The patch brings support of several BLAKE2 variants (2b with various
> > digest lengths).  The keyed digest is supported, using tfm->setkey call.
> > The in-tree user will be btrfs (for checksumming), we're going to use
> > the BLAKE2b-256 variant.
> > 
> > The code is reference implementation taken from the official sources and
> > modified in terms of kernel coding style (whitespace, comments, uintXX_t
> > -> uXX types, removed unused prototypes and #ifdefs, removed testing
> > code, changed secure_zero_memory -> memzero_explicit, used own helpers
> > for unaligned reads/writes and rotations).
> > 
> > Further changes removed sanity checks of key length or output size,
> > these values are verified in the crypto API callbacks or hardcoded in
> > shash_alg and not exposed to users.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  crypto/Kconfig           |  17 ++
> >  crypto/Makefile          |   1 +
> >  crypto/blake2b_generic.c | 435 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 453 insertions(+)
> >  create mode 100644 crypto/blake2b_generic.c
> > 
> 
> This looks good enough now, though it would be nice to clean up some more of the
> cruft that isn't actually needed and add a few of the optimizations from the
> BLAKE2s code that is being proposed.  E.g. we could easily save 120 lines with
> the following:

While I see your point, my intention is to avoid changes beyond
formatting and interface adjustments so the kernel code would not
diverge from the reference one. IMHO having this as a separate commit is
a good thing.

Further changes would need another round of review(s) and testing and
then it should be called 'based on reference code and heavily modified',
like the blake2s patch says.

The proposed patch looks good, though I'd rather address that
independently and perhaps also split it to individual changes so it's
clear how the code is transformed.
