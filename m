Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E623BC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 12:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiGZMI7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 08:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238492AbiGZMI6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 08:08:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845662B638
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 05:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 194D4B8128D
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 12:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F81EC341C0;
        Tue, 26 Jul 2022 12:08:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QJ7YXSrQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658837330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=blNfI594UxSlxvAxiYvdsJihan3p1zYkKcGwtk+en5U=;
        b=QJ7YXSrQgROElrxosVkugA1yXXsMOGwkqKxoaUdZfALECs5IJ6EAsN14ge/f3IZAFwbbem
        kd9u94KZzyVzUkzSmjExsGJAxuOtTdjTXLlXb3ZhVkl2P+7/3675gqy3OAD0SDaz4fUt4w
        bXZ9LCSTXlA/17qWetq89jHXox1HQB0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3ad2ae25 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 12:08:50 +0000 (UTC)
Date:   Tue, 26 Jul 2022 14:08:48 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt/ZUBdK5hiVyKfB@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <9c576e6b-77c9-88c5-50a3-a43665ea5e93@linaro.org>
 <Yt/V78eyHIG/kms3@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yt/V78eyHIG/kms3@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey again,

On Tue, Jul 26, 2022 at 01:54:23PM +0200, Jason A. Donenfeld wrote:
> > As Florian said we will need a non cancellable poll here.  Since you are setting
> > the timeout as undefined, I think it would be simple to just add a non cancellable
> > wrapper as:
> > 
> >   int __ppoll_noncancel_notimeout (struct pollfd *fds, nfds_t nfds)
> >   {
> >   #ifndef __NR_ppoll_time64
> >   # define __NR_ppoll_time64 __NR_ppoll
> >   #endif
> >      return INLINE_SYSCALL_CALL (__NR_ppoll_time64, fds, nfds, NULL, NULL, 0);
> >   }
> > 
> > So we don't need to handle the timeout for 64-bit time_t wrappers.
> 
> Oh that sounds like a good solution to the time64 situation. I'll do
> that for v4... BUT, I already implemented possibly the wrong solution
> for v3. Could you take a look at what I did there and confirm that it's
> wrong? If so, then I'll do exactly what you suggested here.

Actually, forget my v3. What you're suggesting is also better because
it's ppoll, not poll, as poll isn't on all platforms. So I'll do things
exactly as you've described for v4.

Jason
