Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F14C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 10:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbiGYK2S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 06:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiGYK2M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 06:28:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ADA18352
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 03:28:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C22612FB
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 10:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A49C341D0
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 10:28:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=redhat.com header.i=@redhat.com header.b="BycmvJCR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com; s=20210105;
        t=1658744882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m76z/JnQ2OtbC/b7W4MlrXgJ7vu0wxAYFu8oggyFfDg=;
        b=BycmvJCR+JhWxDqFCUIUMDvHxpUDMND/lxu4d6bsGWNSSZH/Uj3hC68/hlIxCGpXJeluWy
        BBO65nrSGTLaO3uR0NmRVNjhcBdtRsIz/DbtMojc1dHxn+c9KNDTOi43oiYD+FSgwmAwNO
        cOY6jqQ/Hw3+98Y3tKv1AQBhcZk5ua8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 944f94eb (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 10:28:02 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     "Jason A. Donenfeld via Libc-alpha" <libc-alpha@sourceware.org>
Cc:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
Date:   Mon, 25 Jul 2022 12:11:27 +0200
In-Reply-To: <Ytwg8YEJn+76h5g9@zx2c4.com> (Jason A. Donenfeld via Libc-alpha's
        message of "Sat, 23 Jul 2022 18:25:21 +0200")
Message-ID: <87bktdsdrk.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Jason A. Donenfeld via Libc-alpha:

> I really wonder whether this is a good idea, whether this is something
> that glibc wants, and whether it's a design worth committing to in the
> long term.

Do you object to the interface, or the implementation?

The implementation can be improved easily enough at a later date.

> Firstly, for what use cases does this actually help? As of recent
> changes to the Linux kernels -- now backported all the way to 4.9! --
> getrandom() and /dev/urandom are extremely fast and operate over per-cpu
> states locklessly. Sure you avoid a syscall by doing that in userspace,
> but does it really matter? Who exactly benefits from this?

getrandom may be fast for bulk generation.  It's not that great for
generating a few bits here and there.  For example, shuffling a
1,000-element array takes 18 microseconds with arc4random_uniform in
glibc, and 255 microseconds with the na=C3=AFve getrandom-based
implementation (with slightly biased results; measured on an Intel
i9-10900T, Fedora's kernel-5.18.11-100.fc35.x86_64).

> You miss out on this with arc4random, and if that information _is_ to be
> exported to userspace somehow in the future, it would be awfully nice to
> design the userspace interface alongside the kernel one.

What is the kernel interface you are talking about?  From an interface
standpoint, arc4random_buf and getrandom are very similar, with the main
difference is that arc4random_buf cannot report failure (except by
terminating the process).

> Seen from this perspective, going with OpenBSD's older paradigm might be
> rather limiting. Why not work together, between the kernel and libc, to
> see if we can come up with something better, before settling on an
> interface with semantics that are hard to walk back later?

Historically, kernel developers were not interested in solving some of
the hard problems (especially early seeding) that prevent the use of
getrandom during early userspace stages.

> As-is, it's hard to recommend that anybody really use these functions.
> Just keep using getrandom(2), which has mostly favorable semantics.

Some applications still need to run in configurations where getrandom is
not available (either because the kernel is too old, or because it has
been disabled via seccomp).

> Yes, I get it: it's fun to make a random number generator, and so lots
> of projects figure out some way to make yet another one somewhere
> somehow. But the tendency to do so feels like a weird computer tinkerer
> disease rather something that has ever helped the overall ecosystem.

The performance numbers suggest that we benefit from buffering in user
space.  It might not be necessary to implement expansion in userspace.
getrandom (or /dev/urandom) with a moderately-sized buffer could be
sufficient.

But that's an implementation detail, and something we can revisit later.
If we vDSO acceleration for getrandom (maybe using the userspace
thread-specific data donation we discussed for rseq), we might
eventually do way with the buffering in glibc.  Again this is an
implementation detail we can change easily enough.

Thanks,
Florian

