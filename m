Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10AD0C43334
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jul 2022 23:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiGXXzu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jul 2022 19:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGXXzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jul 2022 19:55:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8D0D10B
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 16:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED33BB80D8D
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 23:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414CBC3411E;
        Sun, 24 Jul 2022 23:55:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="N8Ke9r/j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658706942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7DaRXub+0gQs2s79YjmSeNTKzOGPtU/OJW1fVzH7s4k=;
        b=N8Ke9r/jgH/E85OcJmpdqQHSutjQxICotlwh8mo61DpKo4Jav4oQWDgsyiXdcLY9inzXGW
        WBTfJIZRUk9t6R+dmXbcYf014CH5o2aOR4FOOQInDbU24JfGPpYwfZRK1nIPMPmvPEc5uV
        4uRQRyq+sOxmhzeOKqMV13D+oQZHadY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b80287cb (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 24 Jul 2022 23:55:42 +0000 (UTC)
Date:   Mon, 25 Jul 2022 01:55:40 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Paul Eggert <eggert@cs.ucla.edu>
Cc:     libc-alpha@sourceware.org, linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
Message-ID: <Yt3b/HOguK9NFgCd@zx2c4.com>
References: <Ytwg8YEJn+76h5g9@zx2c4.com>
 <555f2208-6a04-8c3c-ea52-41ad02b33b0c@cs.ucla.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <555f2208-6a04-8c3c-ea52-41ad02b33b0c@cs.ucla.edu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Paul,

Sorry I missed your reply earlier. I'm not a subscriber so I missed this
as I somehow fell out of the CC.

On Sat, Jul 23, 2022 at 05:18:05PM +0000, Paul Eggert wrote:
> On 7/23/22 09:25, Jason A. Donenfeld via Libc-alpha wrote:
> > it's hard to recommend that anybody really use these functions.
> > Just keep using getrandom(2), which has mostly favorable semantics.
> 
> Yes, that's what I plan to do in GNU projects like Coreutils and Emacs.
> 
> Although I don't recommend arc4random, I suppose it was added for 
> source-code compatibility with the BSDs (I wasn't involved in the decision).

Source code compatibility isn't exactly a bad goal. But according to
Adhemerval you don't plan on this being a secure thing -- hence
mentioning as such in the documentation as he mentioned -- so it seems
like a maybe-okay goal gone bad. But, anyway, if the goal is just basic
source code compatibility, back it with simple calls to getrandom() to
start, and if later there are performance issues (big if!), we can look
into vDSO tricks and such to speed that up. There's no need to add a
whole new huge fraught mechanism for that.

> > is there anyway that glibc can *not*  do this, or has that
> > ship fully sailed
> 
> It hasn't fully sailed since we haven't done a release.

Well that's good. I'd recommend just backing it out until it can be done
in a way that glibc developers feel comfortable calling safe (and others
too, of course, but at the very least you don't want to start out making
something you feel the need to warn about in the documentation).

> That's a bit harsh. Coreutils still has its own random number generator 
> because it needed to be portable to a bunch of platforms and there was 
> no standard. Eventually we'll rip it out but there's no rush. Having 
> written much of that code I can reliably assert that it was not fun.

I'm happy to help with this if you need. I recently cleaned up some
stuff similar sounding in systemd for their uses; random-util.c there
might be of interest.

Jason
