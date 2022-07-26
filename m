Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F21C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 10:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiGZK0N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 06:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiGZK0M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 06:26:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74D4221
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 03:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C19BB8122F
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 10:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E60C341C0;
        Tue, 26 Jul 2022 10:26:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bLfiYKw6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658831166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XsE0nz7DV+yVLaXm6kfzuk9277kz+h0KY+YmIq37ZeE=;
        b=bLfiYKw628JbNbTcemH0VhU33ZjaPgGKpvhDRkCyfbWadP1Tf6ibnF2LdV/9nYFJfRtWoz
        2F/btr+YhcICMmaXC79ShHm/or7DdpD1GZwHI2wDaEBkAvqkZIvrTRPXGQFSCqd4sM3sqV
        6FdlJgVQtAW8EPGLyEeKmLf4SO/5iFI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8fcbf43a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 10:26:06 +0000 (UTC)
Date:   Tue, 26 Jul 2022 12:26:04 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt/BPMG46VTs+SCn@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <Yt8uVciDQzRbyDds@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yt8uVciDQzRbyDds@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Mon, Jul 25, 2022 at 04:59:17PM -0700, Eric Biggers wrote:
> This looks good to me.
> 
> There are still a few bits that need to be removed/updated.  With a quick grep,
> I found:
> 
> sysdeps/generic/tls-internal-struct.h:  struct arc4random_state_t *rand_state;
> 
> sysdeps/unix/sysv/linux/tls-internal.h:/* Reset the arc4random TCB state on fork.  *
> 
> NEWS: ... The functions use a pseudo-random number generator along with
> NEWS: entropy from the kernel.
> 
> 
> Also, the documentation in manual/math.texi should say that the randomness is
> cryptographically secure.

Thanks for the notes. I'll clean that all up in v3.

Jason
