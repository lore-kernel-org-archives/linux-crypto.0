Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFC5C00140
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 18:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiGZSg6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbiGZSg4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 14:36:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEFA32EFD
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 11:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7DCC2CE1A92
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 18:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1792AC433D6;
        Tue, 26 Jul 2022 18:36:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="f7jDlF7X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658860608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KBtVCb+gs9V9oJDCZh/m2Gv64lXqzBv+HHF42prGwN8=;
        b=f7jDlF7X5qjCbmjWAT0o4y1rAr0xR9hp82YFF/nFc/1+8t3ZhkbAehcm7kbQsoyZY0T1Hf
        MJQHKAOn9V5F7HeZ7HRrVHR8HjTEhbsOCrrpkMMXuFhaCdvUTQTpHijr79MjbaUqirEkQ3
        2JI+GTk2kSYKIc1fumPHC2Jv0J1CSyQ=
X-Spam: yes
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d9be2f07 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 18:36:47 +0000 (UTC)
Date:   Tue, 26 Jul 2022 20:36:45 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Mark Harris <mark.hsj@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4] arc4random: simplify design for better safety
Message-ID: <YuA0PcpBdWU5MS9s@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220726133049.1145913-1-Jason@zx2c4.com>
 <45ef8ca0-12ca-4853-98a0-9f52dfca8c57@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45ef8ca0-12ca-4853-98a0-9f52dfca8c57@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Adhemerval,

On Tue, Jul 26, 2022 at 01:20:11PM -0300, Adhemerval Zanella Netto wrote:
> > +	{
> > +	  atomic_store_relaxed (&have_getrandom, false);
> 
> I still think there is no much gain in this optimization, the syscall will
> most likely be present and it is one less static data.  Also, we avoid to
> use __ASSUME_GETRANDOM on generic code (all __ASSUME usage within
> sysdeps and/or nptl).

Oh! *That's* what you were talking about before. Sorry I didn't catch
your meaning the first time through.

Okay so you're alright having +1 syscall overhead on old systems, so
that new systems can have a byte less of static data. I don't hold any
opinions either way there and will defer to your expertise, so I'll get
rid of this part on v5.

> > +    __ppoll_infinity_nocancel;
> >      __sigtimedwait;
> >      # functions used by nscd
> >      __netlink_assert_response;
> 
> There is no need to export on GLIBC_PRIVATE, since it is not currently usage
> libc.so.  Just define is a hidden (attribute_hidden).
> Use attribute_hidden here and remove it from sysdeps/unix/sysv/linux/Versions.
>> Maybe just add an inline wrapper on sysdeps/unix/sysv/linux/not-cancel.h, 
> as for __getrandom_nocancel:
> It avoids a lot of boilerplate code to add the internal symbol.

Okay I'll skip all the symbol stuff and just do the static inline like
getrandom has. Thanks for the suggestion; that's a lot simpler.

> Also update the hurd sysdeps/mach/hurd/not-cancel.h with a wrapper to 
> __poll (since it does not really support pthread cancellation).

Ack.

Thanks for the comments. v5 coming up shortly.

Jason
