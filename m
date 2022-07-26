Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F1CC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238572AbiGZLGh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiGZLGh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:06:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 941FF2F00E
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658833595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DlwwH6JhaE6dOJB4zz8d3PCKM7SP103SiMtUfD5qxKo=;
        b=NTMhhs0OyQ1HdFK3ldgkkJV+9fLYA1LMxtOKzbXhenZKP8VA4FrEjths140AwMkrraEqkI
        W3I0b/RLwXkIJq0ed4VQc53rlsVhg/mvND6RYVZoa6rmWAz0cvTn+nW7MVFb81hhAbPOr4
        wcUnrZ4DNVOKJyAatWaCgsQgDDPto+8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-aLGBITHRNXKWI2wEyPYLVQ-1; Tue, 26 Jul 2022 07:06:34 -0400
X-MC-Unique: aLGBITHRNXKWI2wEyPYLVQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 019B23C22880;
        Tue, 26 Jul 2022 11:06:34 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.193.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A296401473;
        Tue, 26 Jul 2022 11:06:32 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Mark Harris <mark.hsj@gmail.com>, libc-alpha@sourceware.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
References: <20220725225728.824128-1-Jason@zx2c4.com>
        <20220725232810.843433-1-Jason@zx2c4.com>
        <CAMdZqKH=9mDhoW_gpL-pUEQAGuN=orc1doudyAuHdoPc7O53RQ@mail.gmail.com>
        <Yt/EySjdJjYW/EcB@zx2c4.com>
Date:   Tue, 26 Jul 2022 13:06:31 +0200
In-Reply-To: <Yt/EySjdJjYW/EcB@zx2c4.com> (Jason A. Donenfeld's message of
        "Tue, 26 Jul 2022 12:41:13 +0200")
Message-ID: <87bktci154.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Jason A. Donenfeld:

> Not in current kernels, where it always returns at least PAGE_SIZE bytes
> before checking for pending signals. In older kernels, if there was a
> signal pending at the top, it would do no work and return -ERESTARTSYS,
> which I believe should then get restarted by glibc's syscaller?

glibc does not handle ERESTARTSYS, it's a kernel-internal error code
that's not exported in UAPI headers and must not leak to userspace
(except perhaps via ptrace).  I believe restarts are handled in the
kernel signal code, by tweaking the program counter.  Looking at that,
ERESTARTSYS gets translated to EINTR for !SA_RESTART system calls:

        /* Are we from a system call? */
        if (syscall_get_nr(current, regs) != -1) {
                /* If so, check system call restarting.. */
                switch (syscall_get_error(current, regs)) {
                case -ERESTART_RESTARTBLOCK:
                case -ERESTARTNOHAND:
                        regs->ax = -EINTR;
                        break;

                case -ERESTARTSYS:
                        if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
                                regs->ax = -EINTR;
                                break;
                        }
                        fallthrough;
                case -ERESTARTNOINTR:
                        regs->ax = regs->orig_ax;
                        regs->ip -= 2;
                        break;
                }
        }

(arch/x86/kernel/signal.c)

Thanks,
Florian

