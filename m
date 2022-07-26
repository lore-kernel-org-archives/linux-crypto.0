Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A4EC04A68
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 19:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiGZTZA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGZTY7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 15:24:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB13433E37
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 12:24:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EC5BB819F8
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 19:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7C5C433C1;
        Tue, 26 Jul 2022 19:24:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UDOR6iW/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658863494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jmjPfT0r6vu/FucPDkswmv6UGlwXkW38xyJjWM5UoHA=;
        b=UDOR6iW/nG4L3e4hSXtLKDKcHA3MktUDMPfhe6QsAE3ApR8povBxEtkulUV9KYyBTfCTEg
        q3rSVp/KSu/1yh40jIAbffuLYiJXFAaOCDTnkjpRlWNWyUnfLUHN6Q0j17PfRzH76iPqtM
        loZorsjzsBIeQrRic5WDp0yVGjJ8ryA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d920f036 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 26 Jul 2022 19:24:54 +0000 (UTC)
Date:   Tue, 26 Jul 2022 21:24:52 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Mark Harris <mark.hsj@gmail.com>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <YuA/hJ5oG4Whzzy+@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <CAMdZqKH=9mDhoW_gpL-pUEQAGuN=orc1doudyAuHdoPc7O53RQ@mail.gmail.com>
 <Yt/EySjdJjYW/EcB@zx2c4.com>
 <CAMdZqKGzhajnb5ejypnPFanJ2E=4Pk_96x8FAAShttvnrRenfQ@mail.gmail.com>
 <YuA1q74gwHCWWOR2@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YuA1q74gwHCWWOR2@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 26, 2022 at 08:42:51PM +0200, Jason A. Donenfeld wrote:
> Hi Mark,
> 
> On Tue, Jul 26, 2022 at 09:51:03AM -0700, Mark Harris wrote:
> > > Thanks. It looks like INTERNAL_SYSCALL_CALL just returns the errno as-is
> > > as a return value, right? I'll adjust the code to account for that.
> > 
> > Yes INTERNAL_SYSCALL_CALL just returns the negated errno value that it
> > gets from the Linux kernel, but only on Linux does
> > __getrandom_nocancel use that.  The Hurd and generic implementations
> > set errno on error.  Previously the only call to this function did not
> > care about the specific error value so it didn't matter.  Since you
> > are now using the error value in generic code, __getrandom_nocancel
> > should be changed on Linux to set errno like most other _nocancel
> > calls, and then it should go back to checking errno here.
> > 
> > And as Adhemerval mentioned, you only added a Linux implementation of
> > __ppoll_infinity_nocancel, but are calling it from generic code.
> 
> Okay, I'll switch this to use INLINE_SYSCALL_CALL, so that it sets
> errno, and then will use the normal TEMP_FAILURE_RETRY macro for EINTR.
> 
> > Also, by the way your patches cc'd directly to me get quarantined
> > because DKIM signature verification failed.  The non-patch messages
> > pass DKIM and are fine.
> 
> That sure is odd. The emails are all going through the MTA. rspamd bug?
> OpenSMTPD bug? Hmm...

It's because LICENSE has a ^L in it, which I guess doesn't go over well
with OpenSMPTD or rspamd or kernel.org's smtp server or some combination
thereof...

I just posted v5, by the way, in case it's in your spam folder.

Jason
