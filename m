Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685A6EB64D8
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jun 2023 22:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjFNWmj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jun 2023 18:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbjFNWmh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jun 2023 18:42:37 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A41BF9
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 15:42:37 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-77a0fd9d2eeso789543739f.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jun 2023 15:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686782556; x=1689374556;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WE73eWAx50Q9c0pRDTsurXPQzo7ErFkWRWSNLKelXl8=;
        b=E3XRTGV8AiMxhMHklREMVoX8tfu4jHY9Wz5qWYxyifnSf4nXtSdmUDTlAJvThYmqlG
         h7cUIpOd9FBtfYUb2VGYwlswK73kszghRWZgTtvuBIUjATT0AvSK+TE2dt4FxG/EZrc2
         T+5ota2UNs3MQ1WfZWQAKgIpsnVkt6LHM3HugLfZIG8gMYyFZ1Uxiq0n1+1J+oC9x4J3
         u/IS/TEpmOY9NSnRx7vt7lazW1Ph4pYPK1AwwUvhVfCjawtvbnyrEDdbWLR2k2X6c5/v
         Fvp0X8Y8fTe5IunlZhk8/baBt3IOTm2GuDI0LDmfidRPyZWGZd3zmAov57YctODGC88F
         dwbA==
X-Gm-Message-State: AC+VfDzrj90Kx7zblLfYmq0cP4o5B8Zg9DVIbBoc5uz5QNVFJrtvHorD
        QHpJdqm1fBCyixQ+KDfkUazQfD1EN+B3IJep2jjTL9y85RtI
X-Google-Smtp-Source: ACHHUZ5d+qMhMNOUFWZyzwX1QZfMj8e4pEaKvgbexuUfTL0QemYLd2k78ajcnQjdBEvahD4oj+jPD0jc4iq5zak1PLa3SgeT60kY
MIME-Version: 1.0
X-Received: by 2002:a5e:880a:0:b0:76c:7d48:d798 with SMTP id
 l10-20020a5e880a000000b0076c7d48d798mr6300645ioj.0.1686782556283; Wed, 14 Jun
 2023 15:42:36 -0700 (PDT)
Date:   Wed, 14 Jun 2023 15:42:36 -0700
In-Reply-To: <1604628.1686754446@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014bf4b05fe1eabfe@google.com>
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

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=12ae3673280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=e79818f5c12416aba9de
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=172d9e8b280000

Note: testing is done by a robot and is best-effort only.
