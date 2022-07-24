Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF8AC43334
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jul 2022 21:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiGXV5W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jul 2022 17:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXV5V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jul 2022 17:57:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C242BE014
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 14:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81680B80D87
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 21:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8AEC3411E;
        Sun, 24 Jul 2022 21:57:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oyCoF+sx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658699835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iaGgJrv5lEqWDP853ScdMsLIfOIvOKHIKPti4xT91C0=;
        b=oyCoF+sxkAWTS9fZdP2fIjdQb6cF9OVpXvwDbMdDZtyFeAVlcffoxwEq4W0/Yc1IEMowUo
        hOm9LjtPr6vs1ANyqwyI8Oh+t8cRRNBPG2pRvPv2iA20YaK7az8HWNyy5taubBHYP9mxvA
        boBW41F2rU16y74NzPLp7gcBnQGyrB8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 60677a68 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 24 Jul 2022 21:57:14 +0000 (UTC)
Date:   Sun, 24 Jul 2022 23:57:10 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <Yt3ANkrB9vwp0co6@zx2c4.com>
References: <YtwgTySJyky0OcgG@zx2c4.com>
 <Ytwg8YEJn+76h5g9@zx2c4.com>
 <CAPBLoAdtEcpJg7sZQ7+z7HeCQzAs7Am7ep9GBFuBGxUeC3NyEw@mail.gmail.com>
 <Ytx9WW4Z90lx8MQt@zx2c4.com>
 <CAPBLoAc+PozfZ4TJ_j-LANLw4gHbVzkpm+Wzu5QTWdumaut_xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPBLoAc+PozfZ4TJ_j-LANLw4gHbVzkpm+Wzu5QTWdumaut_xQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Cristian,

On Sun, Jul 24, 2022 at 12:23:43PM -0400, Cristian Rodríguez wrote:
> On Sat, Jul 23, 2022 at 6:59 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> 
> > Doesn't getrandom() already basically have this quality?
> 
> In current kernels. yes. problems with old kernels remain..

Can you outline specifically which kernels you think those are and what
the problems you think there are? And how arc4random as currently
implemented does away with those problems?

I kind of suspect you don't have something specific in mind...

> The syscall
> overhead being too high for some use cases is still a remaining
> problem,

Really? Do you have any numbers? I would be very surprised to hear that
this is affecting things that intend to use arc4random as a substitute.
Could you give me specifics on this? Again, this sounds made up in the
absence of something real, widespread, and particular.

> if that was overcomed it could be used literally for everything,
> including simulations and other stuff.

You mentioned simulations, but actually simulations are one thing where
you want repeatable randomness -- something insecure with a seed that
gives a good distribution and is extremely fast, so that you can repeat
your simulation with the same data need-be. For this there are various
LFSRs and such that work fine and are well explored. But that's not what
getrandom() is, nor arc4random().

More generally speaking, there are well-defined RNGs that are for
simulations and take seeds, and there are well-defined RNGs that are
sufficient for crypto, and then there's a massive valley of ill-defined
junk in between that people keep shooting themselves in the foot with.

The fact that you won't even call arc4random cryptographically secure
(according to Adhemerval's comment) indicates to me that something has
gone wrong here.

So, please, I urge you to put the breaks on this a little bit. Come up
with numbers. Let's lay out the interfaces and properties we want. And
then we'll see what we can draw up together.

But now I'm just repeating myself. See my earlier reply here:
https://lore.kernel.org/linux-crypto/Ytx8GKSZfRt+ZrEO@zx2c4.com/

Jason
