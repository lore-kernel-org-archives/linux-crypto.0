Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C02C0015E
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jul 2023 23:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjGYXcd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jul 2023 19:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjGYXcc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2023 19:32:32 -0400
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9326C1BD5
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 16:32:30 -0700 (PDT)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-560c7abdbdcso9728624eaf.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2023 16:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690327950; x=1690932750;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NAib9FhsF/p+ZXO7Hu3qYWPzTDSVp9gbYDlcfRv4tfU=;
        b=OTFSOnpx9GqZHGMfbkMUKOs80rVwftbId0pltXr9+7bASvTw9zC4m0r8AYcOxAdglw
         4lFn/6gxrLE/SsI663JwvXlarU343AMHH/uZk9IgCinh+Dl2bFhWmnuZQ8vOyIHMr9+S
         Ffyr18C0FtqZtVbAH496THp0PZEaVL5db//NqEK42lhcV7EkLlY+kbdZxoaZ3ld4uPqd
         XLAWlYlwvaee3xPyVjhCS+klm/Pr0ckZ0jt98es0+8ScHSfH5jIxc/i/tN+p2UXCV7BA
         05FhwBy09GET7X/wWhICaDuH0zoan2Ip0Ouq8BlAZDzk6Yi1De5kuGQs/P2wG3z60Ot9
         49GQ==
X-Gm-Message-State: ABy/qLYx7U+NOhWzSifwf+dJVU56M5Barspj+11FvXVN997pG/tMSY2n
        F9KzWVlrQvWiI3OYLfmta0HrveSCCWdXhY6UViD/nYsRQyaS
X-Google-Smtp-Source: APBJJlFEYk/bqYGyuJAaHAL1JEWuUOwkkcZpbbHJ/FVewEDv5hVdmh7chgIV5DaFhIO4BzQtyA3NJlRpkIZDZVk0K+a5hwacR/az
MIME-Version: 1.0
X-Received: by 2002:a4a:4f8b:0:b0:569:d5ae:eb6e with SMTP id
 c133-20020a4a4f8b000000b00569d5aeeb6emr495681oob.0.1690327949950; Tue, 25 Jul
 2023 16:32:29 -0700 (PDT)
Date:   Tue, 25 Jul 2023 16:32:29 -0700
In-Reply-To: <0000000000000ced8905fecceeba@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000002c74d0601582595@google.com>
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_update
From:   syzbot <syzbot+0bc501b7bf9e1bc09958@syzkaller.appspotmail.com>
To:     alexander.deucher@amd.com, davem@davemloft.net,
        dhowells@redhat.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mario.limonciello@amd.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 30c3d3b70aba2464ee8c91025e91428f92464077
Author: Mario Limonciello <mario.limonciello@amd.com>
Date:   Tue May 30 16:57:59 2023 +0000

    drm/amd: Disallow s0ix without BIOS support again

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122e2c31a80000
start commit:   [unknown] 
git tree:       net-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=0bc501b7bf9e1bc09958
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f71275280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11081055280000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: drm/amd: Disallow s0ix without BIOS support again

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
