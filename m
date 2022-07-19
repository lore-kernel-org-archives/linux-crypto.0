Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266F1C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 03:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiGSDrX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiGSDrV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jul 2022 23:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEE72018B
        for <linux-crypto@vger.kernel.org>; Mon, 18 Jul 2022 20:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96A81B81914
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 03:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F8BC341C6;
        Tue, 19 Jul 2022 03:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202437;
        bh=PtC6fKUZkG8pT1plPerVVE8siIjEm+Hq7rwa9yLpj1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qI75aTHduhSaksc2YIWEZFHJe8HDOdI+0zo+zXYWW5kWzLkJIyvsCMDNjutvSDmaY
         +GGZykhFTvHYdxpW7PvMRGEmgWoIlZUKKSbYVTnrXJ6yTGGD17dDT3IGYVBASN9RBp
         RfUi6ctnChSCODKx0hP9o4/JrHTq2sFxM4Do7L1KBmaXv67VnZqvTk1SpCqT0KcZjd
         JP+yxx6A8uasjEuTGerUXOQEpFOliJ3H3hdr1hAQa5nsX6EkjTZ+MkZnVQf6XbdjSd
         CDwJ0KvMVNDx373yIHkORnQ5rn84wu9pGzGDRFLeBwwwevGXfmeC5RnVsi5Tc2Yr81
         4baH2uTSu10fg==
Date:   Mon, 18 Jul 2022 20:47:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     linux-crypto@vger.kernel.org, luto@kernel.org, tytso@mit.edu,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <YtYpQ1gf23mxIiYH@sol.localdomain>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <d49d35f5-8eaf-d5e8-7443-ac896a946db7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d49d35f5-8eaf-d5e8-7443-ac896a946db7@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 18, 2022 at 04:52:59PM +0800, Guozihua (Scott) wrote:
> On 2022/7/14 15:33, Guozihua (Scott) wrote:
> > Hi Community,
> > 
> > Recently we noticed the removal of flag O_NONBLOCK on /dev/random by
> > commit 30c08efec888 ("random: make /dev/random be almost like
> > /dev/urandom"), it seems that some of the open_source packages e.g.
> > random_get_fd() of util-linux and __getrandom() of glibc. The man page
> > for random() is not updated either.
> 
> Correction: I mean various open source packages are still using O_NONBLOCK
> flag while accessing /dev/random
> > 
> > Would anyone please kindly provide some background knowledge of this
> > flag and it's removal? Thanks!
> > 

This was changed a while ago, in v5.6.  /dev/random no longer recognizes
O_NONBLOCK because it no longer blocks, except before the entropy pool has been
initialized.

(I don't know why O_NONBLOCK stopped being recognized *before* the entropy pool
has been initialized; it's either an oversight, or it was decided it doesn't
matter.  Probably the latter, since I can't think of a real use case for using
O_NONBLOCK on /dev/random.)

The random(4) man page is indeed in need of an update, not just for this reason
but for some other reasons too.

The util-linux code which you mentioned is opening /dev/random with O_NONBLOCK
if opening /dev/urandom fails, which is pretty much pointless.  Perhaps the
author thought that /dev/random with O_NONBLOCK is equivalent to /dev/urandom
(it's not).  The glibc code, if you mean sysdeps/mach/hurd/getrandom.c, is
actually code written for GNU Hurd, not for Linux, so it's not relevant.

- Eric
