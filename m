Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EDDC433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Nov 2022 01:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiKTBE6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Nov 2022 20:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiKTBE5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Nov 2022 20:04:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F0DB6B34;
        Sat, 19 Nov 2022 17:04:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9663EB8085E;
        Sun, 20 Nov 2022 01:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C67EC433D6;
        Sun, 20 Nov 2022 01:04:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QlCx2dJr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668906291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PwCgR4GrIDa93Xj810+SeDsgFfSgAHtSL3WBPnVichA=;
        b=QlCx2dJrMPKdb8FOUiyeKgxCV8ijGOybdybyPkdf3VdyyapD+FmDwtoVG1S1GfYKre1Y6q
        0GMjrNNxDHhDtKQLfzg03rZciD5A/GO+u0aALfbvi92PKrsR8+KBdAbQ2cVIdv801iJXGr
        gUISb3oVtbe8F64xf5oNH7mo24Bgm0M=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 08b48af9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 20 Nov 2022 01:04:51 +0000 (UTC)
Date:   Sun, 20 Nov 2022 02:04:49 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v5 2/3] random: introduce generic vDSO getrandom()
 implementation
Message-ID: <Y3l9MXCO02/rOpFx@zx2c4.com>
References: <20221119120929.2963813-1-Jason@zx2c4.com>
 <20221119120929.2963813-3-Jason@zx2c4.com>
 <Y3liVEdYByF2gZZU@sol.localdomain>
 <Y3l6ocn1dTN0+1GK@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3l6ocn1dTN0+1GK@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 20, 2022 at 01:53:53AM +0100, Jason A. Donenfeld wrote:
> I'm not quite sure what the best approach here is. One idea would be to
> just note that libcs should wait until vgetrandom() has returned
> everywhere before forking, using its atfork functionality. 

To elaborate on this idea a bit, the way this looks is:

  rwlock_t l;
  pid_t fork(void)
  {
    pid_t pid;
    write_lock(&l);
    pid = syscall_fork();
    write_unlock(&l);
    return pid;
  }
  ssize_t getrandom(...)
  {
    ssize_t ret;
    ...
    if (!read_try_lock(&l))
    	return syscall_getrandom(...);
    ret = vdso_getrandom(...);
    read_unlock(&l);
    return ret;
  }

So maybe that doesn't seem that bad, especially considering libc already
has the kind of infrastructure in place to do that somewhat easily.
Maybe there's a priority locking thing to get right here -- the writer
should immediately starve out all future readers, so it's not unbound --
but that seems par for the course.

Jason
