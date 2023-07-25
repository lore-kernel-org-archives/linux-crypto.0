Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECCEC0015E
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jul 2023 16:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjGYQC2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jul 2023 12:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjGYQC1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2023 12:02:27 -0400
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761E1E4D
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 09:02:25 -0700 (PDT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3a5ab2d2a31so5177009b6e.2
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 09:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690300945; x=1690905745;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OYrN+166SJjRTzPRLQqH1H2WZ+LKvtSBI3v/6mM3uCU=;
        b=gy6outcREKp0tguZN/cjKpIQ5nQwc9INIFJ2OqkkhSkz77Z0QejYTNs4VqVOJrPBdw
         /xkyT+JjnQcONA8RXNMXbkOIsJUCLigHeaumDbXKhQwX5qHZq3HIlhauJJIQ4+obndSr
         FBupC15nZ66scKC1mkYr2r86x8uEs02bhLZruExiBPCjM8AR6sC+UQ4J/DkERlZ0FzQc
         X4SxXWcUbFoHma9ZpTVBPy3+AmmRkILb5/uMbK0gKRN5fWWrU6C1qAZe9x2qRxgcdjnE
         lzNltgYzmSuY2AZgIxrxjo8IEwsU0UG9UDs1x/IdfKatRi+ZYYz2Iv2smBfT70sNtQKc
         It2g==
X-Gm-Message-State: ABy/qLZ0+fwTg1c2t0syHR26eluP8o6tftuqrHo5qSQabCAmujcI2YGy
        C7MAts5ewg3+W064KJJ7ofAlEean9H4zj66N0r40UfM2ADxA
X-Google-Smtp-Source: APBJJlGXkX52G4eXyHWloF4CzCkRRIJE2m4tcBzyC92qEloDbaeV+IlGYdkjXcsjD5bzKsqPKNjZ3k70G1Mkz2BGwHGW0DFNLB8H
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2025:b0:399:e5c2:f7d3 with SMTP id
 q37-20020a056808202500b00399e5c2f7d3mr27685378oiw.7.1690300944879; Tue, 25
 Jul 2023 09:02:24 -0700 (PDT)
Date:   Tue, 25 Jul 2023 09:02:24 -0700
In-Reply-To: <104261.1690298950@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000621765060151db5e@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in cryptd_hash_export
From:   syzbot <syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com

Tested on:

commit:         b6d972f6 crypto: af_alg/hash: Fix recvmsg() after send..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=11736cbea80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2cdac84c489b934f
dashboard link: https://syzkaller.appspot.com/bug?extid=e79818f5c12416aba9de
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
