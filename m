Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3521C00140
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 18:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiGZSm7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiGZSm6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 14:42:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BB42E9D0
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 11:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98782B8113E
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 18:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E7DC433D6;
        Tue, 26 Jul 2022 18:42:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nVStWzR/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658860973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QjNGaVyW+WZioi5dMlm7fD9E+/yt0ObUAyCW9EClMvY=;
        b=nVStWzR/szdBM3zLyEvZaceI5u8p6S9/kpHAAxjqcrElgD/GqrjxViIqE6V/EOmxip/R8n
        2CsuflPP3CpGmAjWQf0rDfNxvsuexo10E49qyPL0Jo2zXzmQZ5y82JFeYlwaWw7rDvn+et
        dPwCyVOZdiLqRvrQ7tqZessijcg6xeg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 92f27bfa (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 18:42:53 +0000 (UTC)
Date:   Tue, 26 Jul 2022 20:42:51 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Mark Harris <mark.hsj@gmail.com>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <YuA1q74gwHCWWOR2@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <CAMdZqKH=9mDhoW_gpL-pUEQAGuN=orc1doudyAuHdoPc7O53RQ@mail.gmail.com>
 <Yt/EySjdJjYW/EcB@zx2c4.com>
 <CAMdZqKGzhajnb5ejypnPFanJ2E=4Pk_96x8FAAShttvnrRenfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMdZqKGzhajnb5ejypnPFanJ2E=4Pk_96x8FAAShttvnrRenfQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mark,

On Tue, Jul 26, 2022 at 09:51:03AM -0700, Mark Harris wrote:
> > Thanks. It looks like INTERNAL_SYSCALL_CALL just returns the errno as-is
> > as a return value, right? I'll adjust the code to account for that.
> 
> Yes INTERNAL_SYSCALL_CALL just returns the negated errno value that it
> gets from the Linux kernel, but only on Linux does
> __getrandom_nocancel use that.  The Hurd and generic implementations
> set errno on error.  Previously the only call to this function did not
> care about the specific error value so it didn't matter.  Since you
> are now using the error value in generic code, __getrandom_nocancel
> should be changed on Linux to set errno like most other _nocancel
> calls, and then it should go back to checking errno here.
> 
> And as Adhemerval mentioned, you only added a Linux implementation of
> __ppoll_infinity_nocancel, but are calling it from generic code.

Okay, I'll switch this to use INLINE_SYSCALL_CALL, so that it sets
errno, and then will use the normal TEMP_FAILURE_RETRY macro for EINTR.

> Also, by the way your patches cc'd directly to me get quarantined
> because DKIM signature verification failed.  The non-patch messages
> pass DKIM and are fine.

That sure is odd. The emails are all going through the MTA. rspamd bug?
OpenSMTPD bug? Hmm...

Jason
